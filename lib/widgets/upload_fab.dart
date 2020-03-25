import 'package:flutter/material.dart';

class UploadFAB extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      child: Icon(
        Icons.add,
        color: Colors.white,
      ),
      onPressed: () {
        Navigator.pushNamed(context, '/home/upload');
      },
    );
  }
}