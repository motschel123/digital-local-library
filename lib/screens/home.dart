import 'package:digital_local_libary/consts/strings.dart';
import 'package:digital_local_libary/widgets/books_feed.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final TextEditingController _filter = new TextEditingController();
  final dio = new Dio();

  List books = new List(); // books we get from API
  List filteredBooks = new List(); // books filtered by search text

  Widget _appBarTitle = new Text(Strings.MAIN_TITLE);
  String _searchText = "";
  Icon _searchIcon = new Icon(Icons.search);
  

  HomeScreenState() {
    _filter.addListener(() {
      if (_filter.text.isEmpty) {
        setState(() {
          _searchText = "";
          filteredBooks = books;
        });
      } else {
        setState(() {
          _searchText = _filter.text;
        });
      }
    });
  }

  Widget _createAppBar() {
    return AppBar(
      title: _appBarTitle,
      leading: new IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {
            _scaffoldKey.currentState.openDrawer();
          }),
      actions: <Widget>[
        IconButton(
            icon: _searchIcon,
            onPressed: () {
              setState(() {
                if (this._searchIcon.icon == Icons.search) {
                  this._searchIcon = new Icon(Icons.close);
                  this._appBarTitle = new TextField(
                    controller: _filter,
                    decoration: new InputDecoration(
                      prefixIcon: new Icon(Icons.search),
                      hintText: 'Search a Book...',
                    ),
                  );
                } else {
                  this._searchIcon = new Icon(Icons.search);
                  this._appBarTitle = new Text(Strings.MAIN_TITLE);
                  filteredBooks = books;
                  _filter.clear();
                }
              });
            })
      ],
    );
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

  void _getBooks() {
    // TODO: get books
    setState(() {
      books = ["Das Cafe am Rande der Welt", "Kaffee und Zigaretten"];
      filteredBooks = books;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: _createAppBar(),
        drawer: _createDrawer(),
        body: _createBookFeed(),
        floatingActionButton: _createFloatingActionButton());
  }
}
