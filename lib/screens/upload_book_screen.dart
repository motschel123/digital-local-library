import 'package:digital_local_library/consts/Consts.dart';
import 'package:digital_local_library/data/book.dart';
import 'package:digital_local_library/models/books_database_model.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class UploadBookScreen extends StatefulWidget {
  final Book book;

  UploadBookScreen({@required this.book});

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

  @override
  void initState() {
    isbnController.text = widget.book.isbn;
    titleController.text = widget.book.title;
    authorController.text = widget.book.author;
    imageLinkController.text = widget.book.imagePath;

    super.initState();
  }



  bool formEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(Consts.UPLOADBOOKSCREEN_TITLE),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: <Widget>[
              Container(
                margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                height: 120.0,
                child: Image(
                  image: NetworkImage(widget.book.imagePath),
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
                      autofocus: true,
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
        onPressed: !formEnabled
            ? null
            : () async {
                FormState formState = _formKey.currentState;
                if (formState.validate()) {
                  FocusScope.of(_scaffoldKey.currentContext)
                      .requestFocus(FocusNode());

                  _scaffoldKey.currentState.showSnackBar(
                    SnackBar(content: Text('Uploading your Book...')),
                  );
                  setState(() {
                    formEnabled = false;
                  });
                  Book uploadBook = new Book(
                      isbn: isbnController.text,
                      title: titleController.text,
                      author: authorController.text,
                      imagePath: imageLinkController.text);
                  ScopedModel.of<BooksDatabaseModel>(context)
                      .uploadBook(book: uploadBook)
                      .then((uploaded) {
                    if (uploaded) {
                      Navigator.of(context).pop();
                    } else {
                      _scaffoldKey.currentState.showSnackBar(
                        SnackBar(content: Text('Something went wrong...')),
                      );
                      setState(() {
                        formEnabled = true;
                      });
                    }
                  });
                }
              },
      ),
    );
  }
}
