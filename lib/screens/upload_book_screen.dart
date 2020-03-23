import 'package:barcode_scan/barcode_scan.dart';
import 'package:digital_local_library/consts/Consts.dart';
import 'package:digital_local_library/data/book.dart';
import 'package:digital_local_library/models/books_database_model.dart';
import 'package:digital_local_library/sign_in/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class UploadBookScreen extends StatefulWidget {
  final BuildContext modelContext;

  UploadBookScreen({@required this.modelContext});

  @override
  State<StatefulWidget> createState() => UploadBookScreenState();
}

class UploadBookScreenState extends State<UploadBookScreen> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final TextEditingController isbnController = TextEditingController();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController authorController = TextEditingController();
  final TextEditingController imageLinkController = TextEditingController();

  bool fetchingData = false;

  @override
  initState() {
    super.initState();
    isbnController.addListener(() {
      final text = isbnController.text;
      isbnController.value = isbnController.value.copyWith(
        text: text.replaceAll(RegExp(r'[^0-9]'), ""),
      );
    });
  }

  @override
  void dispose() {
    isbnController.dispose();
    titleController.dispose();
    authorController.dispose();
    imageLinkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(Consts.UPLOADBOOKSCREEN_TITLE),
      ),
      body: _buildBody(),
      floatingActionButton: _buildUploadFAB(context),
    );
  }

  Widget _buildBody() {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Align(
              alignment: Alignment.topLeft,
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                height: 140.0,
                child: imageLinkController.text == ""
                    ? null
                    : Image(
                        image: NetworkImage(imageLinkController.text),
                      ),
              ),
            ),
            Expanded(
              child: Column(
                children: <Widget>[
                  _buildTitleFormField(),
                  _buildAuthorFormField(),
                  _buildIsbnFormField(),
                  _buildImageLinkFormField(),
                  _buildScanIsbnButton()
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTitleFormField() {
    return TextFormField(
      //enabled: formEnabled,
      controller: titleController,
      decoration: InputDecoration(
        hintText: "Enter title",
        prefixText: "Title",
      ),
      textAlign: TextAlign.right,
      validator: (value) {
        if (value.isEmpty) {
          return 'Please enter the title!';
        }
        return null;
      },
    );
  }

  Widget _buildAuthorFormField() {
    return TextFormField(
      controller: authorController,
      decoration: InputDecoration(
        hintText: "Enter author",
        prefixText: "Author",
      ),
      textAlign: TextAlign.right,
      validator: (value) {
        if (value.isEmpty) {
          return 'Please enter the author!';
        }
        return null;
      },
    );
  }

  Widget _buildIsbnFormField() {
    return TextFormField(
      controller: isbnController,
      decoration: InputDecoration(
        hintText: "Enter isbn",
        prefixText: "ISBN",
      ),
      textAlign: TextAlign.right,
      validator: (String value) {
        if (!Book.checkIsbn(value)) {
          return "Enter a valid ISBN!";
        }
        return null;
      },
    );
  }

  Widget _buildImageLinkFormField() {
    return TextFormField(
      controller: imageLinkController,
      decoration: InputDecoration(
        hintText: "Enter thumbnail image link",
        prefixText: "Thumbnail",
      ),
      textAlign: TextAlign.right,
      validator: (String value) {
        if (value.isEmpty) {
          return "Enter a valid image link";
        }
        return null;
      },
    );
  }

  Widget _buildScanIsbnButton() {
    return Center(
      child: fetchingData
          ? Padding(
              padding: EdgeInsets.all(5.0), child: CircularProgressIndicator())
          : RaisedButton(
              child: Text("Scan your book!"),
              onPressed: () async {
                String isbn = "";
                setState(() {
                  fetchingData = true;
                });
                try {
                  isbn = await BarcodeScanner.scan();
                } catch (e) {
                  print(e);
                  _scaffoldKey.currentState.showSnackBar(
                    const SnackBar(
                      content: const Text("Couldn't get Isbn"),
                    ),
                  );
                  setState(() {
                    fetchingData = false;
                  });
                  return;
                }
                try {
                  await BookBase.getByIsbn(isbn).then((BookBase bookBase) {
                    setState(() {
                      isbnController.text = bookBase.isbn;
                      titleController.text = bookBase.title;
                      authorController.text = bookBase.author;
                      imageLinkController.text = bookBase.imagePath;
                      _formKey.currentState.validate();
                      fetchingData = false;
                    });
                  });
                } on Exception catch (e) {
                  setState(() {
                    fetchingData = false;
                    _scaffoldKey.currentState.showSnackBar(
                      SnackBar(
                        backgroundColor: Colors.red[800],
                        content: Text(e.toString()),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  });
                }
              }),
    );
  }

  Widget _buildUploadFAB(BuildContext context) {
    return FloatingActionButton(
      child: Icon(
        Icons.file_upload,
        color: Colors.white,
      ),
      onPressed: fetchingData
          ? null
          : () async {
              setState(() {
                fetchingData = true;
              });
              if (await _uploadBook()) {
                Navigator.of(context).pop(true);
              } else {
                _scaffoldKey.currentState.showSnackBar(
                  SnackBar(content: Text("Something went wrong")),
                );
              }
              setState(() {
                fetchingData = false;
              });
            },
    );
  }

  Future<bool> _uploadBook() async {
    FormState formState = _formKey.currentState;
    if (formState.validate()) {
      // Close keyboard
      FocusScope.of(_scaffoldKey.currentContext).requestFocus(FocusNode());

      // Give visual feedback to the user
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(content: Text('Uploading your Book...')),
      );
      // create book to upload
      Book uploadBook = new Book(
        isbn: isbnController.text,
        title: titleController.text,
        author: authorController.text,
        imagePath: imageLinkController.text,
        uid: (await AuthProvider.of(context).currentUser()).uid,
      );
      _scaffoldKey.currentState.hideCurrentSnackBar();
      setState(() {
        fetchingData = true;
      });
      return await ScopedModel.of<BooksDatabaseModel>(widget.modelContext)
          .uploadBook(
        book: uploadBook,
      );
    }
    return false;
  }
}
