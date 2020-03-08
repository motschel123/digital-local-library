import 'package:barcode_scan/barcode_scan.dart';
import 'package:digital_local_library/consts/Consts.dart';
import 'package:digital_local_library/data/book.dart';
import 'package:digital_local_library/models/books_database_model.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class UploadBookScreen extends StatefulWidget {
  final BooksDatabaseModel booksModel;

  UploadBookScreen({
    @required this.booksModel,
  });

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
      body: fetchingData
          ? Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        margin: EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 16.0),
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
                          TextFormField(
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
                          ),
                          TextFormField(
                            //enabled: formEnabled,
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
                          ),
                          TextFormField(
                            //enabled: formEnabled,
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
                          ),
                          TextFormField(
                            //enabled: formEnabled,
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
                          ),
                          Center(
                              child: RaisedButton(
                                  child: Text("Scan your book!"),
                                  onPressed: () async {
                                    String isbn = "";
                                    setState(() {
                                      fetchingData = true;
                                    });
                                    isbn = await BarcodeScanner.scan()
                                        .catchError((error) {
                                      _scaffoldKey.currentState.showSnackBar(
                                        const SnackBar(
                                          content: const Text("g"),
                                        ),
                                      );
                                      return;
                                    });
                                    await Book.getByIsbn(isbn)
                                        .then((Book book) {
                                      setState(() {
                                        isbnController.text = book.isbn;
                                        titleController.text = book.title;
                                        authorController.text = book.author;
                                        imageLinkController.text =
                                            book.imagePath;
                                        fetchingData = false;
                                      });
                                    }).catchError((error) {
                                      _scaffoldKey.currentState.showSnackBar(
                                        const SnackBar(
                                          content:
                                              const Text("Couldn't find book"),
                                        ),
                                      );
                                    });
                                  }))
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.file_upload,
          color: Colors.white,
        ),
        onPressed: () async {
          FormState formState = _formKey.currentState;
          if (formState.validate()) {
            // Close keyboard
            FocusScope.of(_scaffoldKey.currentContext)
                .requestFocus(FocusNode());

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
            );
            _scaffoldKey.currentState.hideCurrentSnackBar();
            widget.booksModel.uploadBook(book: uploadBook).then((uploaded) {
              if (uploaded) {
                Navigator.of(context).pop();
              } else {
                _scaffoldKey.currentState.showSnackBar(
                  SnackBar(content: Text("Something went wrong")),
                );
              }
            });
          }
        },
      ),
    );
  }
}
