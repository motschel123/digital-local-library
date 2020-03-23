import 'package:digital_local_library/models/appbar_model.dart';
import 'package:digital_local_library/widgets/book_feed.dart';
import 'package:digital_local_library/widgets/home_drawer.dart';
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

  Widget _createFloatingActionButton({@required BuildContext context}) {
    return FloatingActionButton(
      child: Icon(
        Icons.add,
        color: Colors.white,
      ),
      onPressed: () {
        Navigator.pushNamed(context, '/upload');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _createAppBar(),
      drawer: HomeDrawer(),
      body: BookFeed(),
      floatingActionButton: _createFloatingActionButton(context: context),
    );
  }
}
