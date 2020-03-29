import 'package:digital_local_library/sign_in/auth.dart';
import 'package:digital_local_library/sign_in/auth_provider.dart';
import 'package:flutter/material.dart';

enum Screen { ProfileScreen }

class HomeDrawer extends StatefulWidget {
  final Screen currentScreen;

  HomeDrawer({this.currentScreen});

  @override
  State<StatefulWidget> createState() => _HomeDrawerState();
}

class _HomeDrawerState extends State<HomeDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: <Color>[
                    Theme.of(context).primaryColor,
                    Theme.of(context).primaryColor.withOpacity(0.6)
                  ]),
                ),
                child: StreamBuilder<User>(
                  stream: AuthProvider.of(context).currentUser().asStream(),
                  builder:
                      (BuildContext context, AsyncSnapshot<User> snapshot) {
                    String userName =
                        snapshot.hasData ? snapshot.data.displayName : "Anonymous user";
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
                child: Text("Profile"),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/profile');
                },
              ),
            ],
          ),
          Align(
              alignment: Alignment.bottomCenter,
              child: StreamBuilder<User>(
                  stream: AuthProvider.of(context).currentUser().asStream(),
                  builder: (context, AsyncSnapshot<User> snapshot) {
                    return snapshot.hasData
                        ? MaterialButton(
                            onPressed: () {
                              Navigator.pop(context);
                              AuthProvider.of(context).signOut();
                            },
                            child: Text("Sign out"),
                          )
                        : MaterialButton(
                            onPressed: () {
                              Navigator.pop(context);
                              Navigator.pushNamed(context, '/sign_in');
                            },
                            child: Text("Sign in"),
                          );
                  })),
        ],
      ),
    );
  }
}
