import 'package:camera/camera.dart';
import 'package:digital_local_libary/models/appbar_model.dart';
import 'package:digital_local_libary/models/books_model.dart';
import 'package:digital_local_libary/screens/scan_book.dart';
import 'package:digital_local_libary/widgets/books_feed.dart';
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
      onPressed: () async {
        // Ensure that plugin services are initialized so that `availableCameras()`
        // can be called before `runApp()`
        WidgetsFlutterBinding.ensureInitialized();
        // Obtain a list of the available cameras on the device.
        final cameras = await availableCameras();

        // Get a specific camera from the list of available cameras.
        final firstCamera = cameras.first;

        Navigator.push(
          context, 
          MaterialPageRoute(builder: (context) => ScanBookScreen(camera: firstCamera)));
      },
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
          floatingActionButton: _createFloatingActionButton(context: context),
        ),
      ),
    );
  }
}
