import 'package:digital_local_library/consts/Consts.dart';
import 'package:flutter/material.dart';

class UploadBookScreen extends StatefulWidget {
  final String isbn;

  UploadBookScreen({@required this.isbn});

  @override
  State<StatefulWidget> createState() => UploadBookScreenState();
}

class UploadBookScreenState extends State<UploadBookScreen>{
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Consts.UPLOADBOOKSCREEN_TITLE),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(hintText: "Enter title"),
              autofocus: true,
              validator: (value) {
                if(value.isEmpty) {
                  return 'Please enter the title!';
                }
                return null;
              },
            ),
            TextFormField(
              decoration: InputDecoration(hintText: "Enter author"),
              validator: (value) {
                if(value.isEmpty) {
                  return 'Please enter the author!';
                }
                return null;
              },
            ),
            TextFormField(
              decoration: InputDecoration(hintText: "Enter isbn"),
              initialValue: widget.isbn,
              validator: (String value) {
                if(_checkIsbn(value)) {
                  return null;
                }
                return "Enter a valid Isbn!";
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if(_formKey.currentState.validate()) {
            Scaffold
              .of(context)
              .showSnackBar(SnackBar(content: Text('Uploading your Book...')));
            await Future.delayed(const Duration(seconds: 2));
            Navigator.of(context).pop();
          }
        },
      )
    );
  }

  static bool _checkIsbn(String isbn) {
    isbn = isbn.replaceAll("-", "").replaceAll(" ", "");
    if (isbn.length == 13) {
      return _check13isbn(isbn);
    } else if (isbn.length == 10) {
      return _check10isbn(isbn);
    }
    return false;
  }

  static bool _check13isbn(String isbn) {
    int checkDigit = int.parse(isbn[isbn.length - 1]);
    isbn = isbn.substring(0, isbn.length - 1);
    List<String> chars = isbn.split("");

    int sum = 0;
    int swapper = 1;
    for (String char in chars) {
      sum = sum + int.parse(char) * swapper;
      swapper = swapper == 1 ? 3 : 1;
    }
    int mod = sum % 10;
    if (mod == 0) {
      return true;
    }
    if (10 - mod == checkDigit) {
      return true;
    }
    return false;
  }

  static bool _check10isbn(String isbn) {
    List<String> chars = isbn.split("").reversed.toList();

    int sum = 0;
    for (int i = 0; i < 10; i++) {
      sum = sum + int.parse(chars[i]) * (i + 1);
    }
    print(sum);
    int mod = sum % 21;
    if (mod == 0) {
      return true;
    }
    return false;
  }
}