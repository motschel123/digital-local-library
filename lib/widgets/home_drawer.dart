import 'package:digital_local_library/sign_in/auth_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
                child: StreamBuilder<FirebaseUser>(
                  stream: AuthProvider.of(context).currentUser().asStream(),
                  builder: (BuildContext context,
                      AsyncSnapshot<FirebaseUser> snapshot) {
                    String userName = snapshot.hasData
                        ? snapshot.data.isAnonymous
                            ? "Anonymous user"
                            : snapshot.data.displayName
                        : "";
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
              child: StreamBuilder<FirebaseUser>(
                  stream: AuthProvider.of(context).currentUser().asStream(),
                  builder: (context, AsyncSnapshot<FirebaseUser> snapshot) {
                    if (snapshot.hasData) {
                      return snapshot.data.isAnonymous
                          ? MaterialButton(
                              onPressed: () {
                                Navigator.pop(context);
                                Navigator.pushNamed(context, '/forced_sign_in');
                              },
                              child: Text("Sign in"),
                            )
                          : MaterialButton(
                              onPressed: () {
                                Navigator.pop(context);
                                AuthProvider.of(context).signOut();
                              },
                              child: Text("Sign out"),
                            );
                    }
                    return CircularProgressIndicator();
                  })),
        ],
      ),
    );
  }
}
