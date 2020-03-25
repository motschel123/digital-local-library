import 'package:digital_local_library/models/appbar_model.dart';
import 'package:digital_local_library/widgets/book_feed.dart';
import 'package:digital_local_library/widgets/upload_fab.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class LibraryView extends StatelessWidget {

  LibraryView({Key key}) : super(key: key);

  Widget _createAppBar() {
    return AppBar(
      title: ScopedModelDescendant<AppBarModel>(
        builder: (context, child, model) {
          return model.appBarTitle;
        },
      ),
      actions: <Widget>[
        ScopedModelDescendant<AppBarModel>(builder: (context, child, model) {
          return IconButton(
              icon: model.searchIcon,
              onPressed: () {
                model.searchPressed();
              });
        }),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _createAppBar(),
      body: BookFeed(),
      floatingActionButton: UploadFAB(),
    );
  }
}
