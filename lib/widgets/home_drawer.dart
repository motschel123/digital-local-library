import 'package:flutter/material.dart';

class HomeDrawer extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomeDrawerState();
}

class _HomeDrawerState extends State<HomeDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: <Color>[
                Theme.of(context).primaryColor,
                Theme.of(context).primaryColor.withOpacity(0.6)
              ]),
            ),
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
            onPressed: () {},
          ),
          Container(
            child: MaterialButton(
              onPressed: null,
              child: Text("Sign out"),
            ),
          ),
        ],
      ),
    );
  }
}
