import 'package:flutter/material.dart';
import 'package:digital_local_library/sign_in/auth.dart';

export 'package:digital_local_library/sign_in/auth.dart';


class AuthProvider extends InheritedWidget {
  final BaseAuth auth;

  AuthProvider({
    Key key,
    Widget child,
    this.auth,
  }) : super(
          key: key,
          child: child,
        );

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return true;
  }

  static BaseAuth of(BuildContext context) => 
    (context.dependOnInheritedWidgetOfExactType<AuthProvider>()).auth;
}