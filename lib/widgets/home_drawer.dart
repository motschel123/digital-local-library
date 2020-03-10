import 'package:digital_local_library/sign_in/auth_provider.dart';
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
            child: StreamBuilder(
              stream: AuthProvider.of(context).currentUserName().asStream(),
              builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                String userName = snapshot.hasData ? snapshot.data : "";
                return Center(
                  child: Column(
                    children: <Widget>[
                      Text(
                        '$userName',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 24,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          RaisedButton(
            child: Text("Friends"),
            onPressed: () {},
          ),
          Container(
            child: MaterialButton(
              onPressed: () => AuthProvider.of(context).signOut(),
              child: Text("Sign out"),
            ),
          ),
        ],
      ),
    );
  }
}
