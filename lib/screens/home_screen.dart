import 'package:barcode_scan/barcode_scan.dart';
import 'package:digital_local_library/models/appbar_model.dart';
import 'package:digital_local_library/models/books_model.dart';
import 'package:digital_local_library/widgets/books_feed.dart';
import 'package:digital_local_library/widgets/upload_book_dialog.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class HomeScreen extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  final BooksModel books;
  final AppBarModel searchBar;

  HomeScreen({Key key, this.books, this.searchBar}) : super(key: key);

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
    return Center(
      child: ScopedModelDescendant<AppBarModel>(
        rebuildOnChange: true,
        builder: (BuildContext context, Widget child, AppBarModel model) {
          return new BooksFeed(model.searchText);
        },
      ),
    );
  }

  Widget _createFloatingActionButton({@required BuildContext context}) {
    return FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          _scanISBN().then((String isbn) {
            // TODO: handle ISBN code
            showDialog(
              context: context,
              builder: (_) => UploadBookDialog(isbnCode: isbn, scaffoldKey: _scaffoldKey),
              	barrierDismissible: false,  
            );
          }).catchError((error) {
            print(error);
            Scaffold.of(context).showSnackBar(SnackBar(content: Text('Something went wrong...')));
          });
        });
  }

  Future<String> _scanISBN() async {
    try {
      return await BarcodeScanner.scan();
    } on Exception {
      throw Exception();
    }
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
          floatingActionButton: _createFloatingActionButton(context: context),
        ),
      ),
    );
  }
}
