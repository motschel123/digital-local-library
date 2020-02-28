import 'package:barcode_scan/barcode_scan.dart';
import 'package:digital_local_library/models/appbar_model.dart';
import 'package:digital_local_library/models/books_database_model.dart';
import 'package:digital_local_library/screens/upload_book_screen.dart';
import 'package:digital_local_library/widgets/books_feed.dart';
import 'package:digital_local_library/data/book.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class HomeScreen extends StatelessWidget {
    final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

    final BooksDatabaseModel books;
    final AppBarModel searchBar;

    HomeScreen ({Key key, this.books, this.searchBar}) : super(key: key);

    Widget _createAppBar () {
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

    Widget _createDrawer () {
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

    Widget _createBookFeed () {
        return Center(
            child: ScopedModelDescendant<AppBarModel>(
                rebuildOnChange: true,
                builder: (BuildContext context, Widget child, AppBarModel model) {
                    return new BooksFeed(model.searchText);
                },
            ),
        );
    }

    Widget _createFloatingActionButton ({@required BuildContext context}) {
        return FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () async {
                Book _bookInfo;

                try {
                    String _isbn = await BarcodeScanner.scan();
                    _bookInfo = await Book.getByIsbn(_isbn);
                } on Exception {
                    throw Exception('Unable to get ISBN or fetch book information');
                }

                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => UploadBookScreen(book: _bookInfo)),
                );
            },
        );
    }

    @override
    Widget build (BuildContext context) {
        return ScopedModel<AppBarModel>(
            model: searchBar,
            child: ScopedModel<BooksDatabaseModel>(
                model: books,
                child: Scaffold(
                    key: _scaffoldKey,
                    appBar: _createAppBar(),
                    drawer: _createDrawer(),
                    body: _createBookFeed(),
                    floatingActionButton: _createFloatingActionButton(context: context),
                ),
            ),
        );
    }
}
