import 'package:flutter/material.dart';

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
            // TODO: add upload
            scaffoldKey.currentState.showSnackBar(SnackBar(content: Text('Uploading your book!')));
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
