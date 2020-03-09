import 'package:digital_local_library/models/appbar_model.dart';
import 'package:digital_local_library/models/books_database_model.dart';
import 'package:digital_local_library/screens/upload_book_screen.dart';
import 'package:digital_local_library/widgets/books_feed.dart';
import 'package:digital_local_library/widgets/home_drawer.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class HomeScreen extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  final BooksDatabaseModel booksModel = BooksDatabaseModel();
  final AppBarModel searchBarModel = AppBarModel();

  HomeScreen({Key key}) : super(key: key);

  Widget _createAppBar() {
    return AppBar(
      title: ScopedModelDescendant<AppBarModel>(
        builder: (context, child, model) {
          return model.appBarTitle;
        },
      ),
      leading: new IconButton(
        icon: Icon(Icons.menu),
        onPressed: () {
          _scaffoldKey.currentState.openDrawer();
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

  Widget _createBookFeed() {
    return Center(
      child: ScopedModelDescendant<AppBarModel>(
        rebuildOnChange: true,
        builder: (BuildContext context, Widget child, AppBarModel model) {
          return new BooksFeed(searchText: model.searchText);
        },
      ),
    );
  }

  Widget _createFloatingActionButton({@required BuildContext context}) {
    return FloatingActionButton(
      child: Icon(
        Icons.add,
        color: Colors.white,
      ),
      onPressed: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) =>
                UploadBookScreen(booksModel: booksModel),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<AppBarModel>(
      model: searchBarModel,
      child: ScopedModel<BooksDatabaseModel>(
        model: booksModel,
        child: Scaffold(
          key: _scaffoldKey,
          appBar: _createAppBar(),
          drawer: HomeDrawer(),
          body: _createBookFeed(),
          floatingActionButton: _createFloatingActionButton(context: context),
        ),
      ),
    );
  }
}
