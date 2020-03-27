import 'package:digital_local_library/sign_in/auth.dart';
import 'package:digital_local_library/sign_in/auth_provider.dart';
import 'package:flutter/material.dart';

class ProfileView extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: ListView(
        children: <Widget>[
          Align(
            child: CircleAvatar(
              backgroundImage: AssetImage('assets/default/avatar.jpg'),
              maxRadius: 100.0,
            ),
          ),
          StreamBuilder(
            stream: AuthProvider.of(context).currentUser().asStream(),
            builder: (context, AsyncSnapshot<User> snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data.isAnonymous) {
                  return Text("Anonymous");
                }
                return Text("${snapshot.data.displayName}");
              }
              return Text("Loading");
            },
          ),
        ],
      ),
    );
  }
}
