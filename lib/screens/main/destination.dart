import 'package:flutter/material.dart';

class Destination {
  final String title;
  final IconData icon;
  final MaterialColor color;

  const Destination({this.title, this.icon, this.color});
}

class DestinationView {
  final Destination destination;
  final Widget body;

  const DestinationView({this.destination, this.body});
}