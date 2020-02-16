import 'package:digital_local_libary/consts/strings.dart';
import 'package:digital_local_libary/screens/search.dart';
import 'package:digital_local_libary/widgets/books_feed.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new HomePageState();
}

class HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  String title = Strings.MAIN_TITLE;
  List<String> bookImagePaths;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(title),
      
        leading: new IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              _scaffoldKey.currentState.openDrawer();
            }),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.search), 
          onPressed: () {
            Navigator.push(context,
            MaterialPageRoute(builder: (context)  => SearchScreen()));
          })],
      ),
      drawer: homeDrawer,
      body: Center(
        child: new BooksFeed(),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {},
      ),
    );
  }

  Drawer homeDrawer = Drawer(
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
        RaisedButton(
          child: Text("Friends"),
          onPressed: () {}
        ),
      ],
    ),
  );
}
