import 'package:digital_local_libary/models/appbar_model.dart';
import 'package:digital_local_libary/models/books_model.dart';
import 'package:digital_local_libary/widgets/books_feed.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class HomeScreen extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  final BooksModel books;
  final AppBarModel searchBar;

  HomeScreen({Key key, this.books, this.searchBar}) : super(key: key);

  Widget _createAppBar() {
    return ScopedModelDescendant<AppBarModel>(builder: (context, child, model) {
      return AppBar(
        title: model.appBarTitle,
        leading: new IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              _scaffoldKey.currentState.openDrawer();
            }),
        actions: <Widget>[IconButton(icon: model.searchIcon, onPressed: () {})],
      );
    });
  }

  Widget _createDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text(
              'Drawer Home',
              style: TextStyle(
                color: Colors.black,
                fontSize: 24,
              ),
            ),
          ),
          RaisedButton(child: Text("Friends"), onPressed: () {}),
        ],
      ),
    );
  }

  Widget _createBookFeed() {
    return Center(child: new BooksFeed());
  }

  Widget _createFloatingActionButton() {
    return FloatingActionButton(
      child: Icon(Icons.add),
      onPressed: () {},
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<AppBarModel>(
      model: searchBar,
      child: ScopedModel<BooksModel>(
        model: books,
        child: Scaffold(
          key: _scaffoldKey,
          appBar: _createAppBar(),
          drawer: _createDrawer(),
          body: _createBookFeed(),
          floatingActionButton: _createFloatingActionButton(),
        ),
      ),
    );
  }
}
