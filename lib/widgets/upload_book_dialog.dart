import 'package:digital_local_library/consts/Consts.dart';
import 'package:digital_local_library/data/book.dart';
import 'package:digital_local_library/models/books_database_model.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class UploadBookDialog extends AlertDialog {
  final String isbnCode;
  final GlobalKey<ScaffoldState> scaffoldKey;

  UploadBookDialog({@required this.isbnCode, @required this.scaffoldKey});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("ISBN: $isbnCode"),
      content: Text("Is this the right code?"),
      actions: <Widget>[
        FlatButton(
            child: Text("Yes"),
            onPressed: () {
              BooksDatabaseModel model = ScopedModel.of<BooksDatabaseModel>(scaffoldKey.currentContext);
              model.uploadBook(book: Book(isbn: isbnCode, title: null, author: null, imagePath: null)).then((bool success) {
                if (success) {
                  scaffoldKey.currentState
                      .showSnackBar(Consts.SNACKBAR_UPLOAD_SUCCESSFUL);
                } else {
                  scaffoldKey.currentState
                      .showSnackBar(Consts.SNACKBAR_UPLOAD_FAILED);
                }
              });
              Navigator.of(context).pop();
            },
          ),
        FlatButton(
          child: Text("No"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
