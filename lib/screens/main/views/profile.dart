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
        ],
      ),
    );
  }
}
