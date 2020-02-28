import 'package:digital_local_library/consts/Consts.dart';
import 'package:digital_local_library/data/book.dart';
import 'package:flutter/material.dart';

class UploadBookScreen extends StatefulWidget {
    final Book book;

    UploadBookScreen ({@required this.book});

    @override
    State<StatefulWidget> createState () => UploadBookScreenState();
}

class UploadBookScreenState extends State<UploadBookScreen> {
    final _formKey = GlobalKey<FormState>();

    @override
    Widget build (BuildContext context) {
        return Scaffold(
            appBar: AppBar(
                title: Text(Consts.UPLOADBOOKSCREEN_TITLE),
            ),
            body: Form(
                key: _formKey,
                child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                        children: <Widget>[
                            TextFormField(
                                decoration: InputDecoration(hintText: "Enter title"),
                                initialValue: widget.book.title,
                                autofocus: true,
                                validator: (value) {
                                    if (value.isEmpty) {
                                        return 'Please enter the title!';
                                    }
                                    return null;
                                },
                            ),
                            TextFormField(
                                decoration: InputDecoration(hintText: "Enter author"),
                                initialValue: widget.book.author,
                                validator: (value) {
                                    if (value.isEmpty) {
                                        return 'Please enter the author!';
                                    }
                                    return null;
                                },
                            ),
                            TextFormField(
                                decoration: InputDecoration(hintText: "Enter isbn"),
                                initialValue: widget.book.isbn,
                                validator: (String value) {
                                    if (Book.checkIsbn(value)) {
                                        return null;
                                    }
                                    return "Enter a valid ISBN!";
                                },
                            ),
                            TextFormField(
                                decoration: InputDecoration(hintText: "Enter thumbnail image link"),
                                initialValue: widget.book.imagePath,
                                validator: (String value) {
                                    if (value.isEmpty) {
                                        return null;
                                    }
                                    return "Enter a valid image link";
                                },
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
                    if (_formKey.currentState.validate()) {
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
}