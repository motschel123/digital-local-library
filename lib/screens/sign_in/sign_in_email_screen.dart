import 'dart:developer';

import 'package:digital_local_library/data/user.dart';
import 'package:digital_local_library/sign_in/auth.dart';
import 'package:digital_local_library/sign_in/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum ScreenState { sign_in, sign_up }

class SignInEmailScreen extends StatefulWidget {
  @override
  _SignInEmailScreenState createState() => _SignInEmailScreenState();
}

class _SignInEmailScreenState extends State<SignInEmailScreen> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController _emailCtr;
  TextEditingController _passwordCtr;
  TextEditingController _repeatPasswordCtr;

  ScreenState currentState = ScreenState.sign_in;

  @override
  void initState() {
    _emailCtr = TextEditingController();
    _emailCtr.addListener(() {
      final String text = _emailCtr.text;
      if (text.contains(' ')) {
        _emailCtr.value = _emailCtr.value.copyWith(
          selection: TextSelection.fromPosition(TextPosition(offset: text.indexOf(' '))),
          text: text.replaceAll(' ', ''),
          composing: TextRange.empty,
        );
      }
    });
    _passwordCtr = TextEditingController();
    _repeatPasswordCtr = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    _emailCtr.dispose();
    _passwordCtr.dispose();
    _repeatPasswordCtr.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _buildForm(),
            currentState == ScreenState.sign_in
                ? _buildSignInButton()
                : Container(),
            _buildSignUpButton(),
            currentState == ScreenState.sign_up
                ? _buildSignInButton()
                : Container(),
          ],
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: <Widget>[
            _emailFormField(),
            _passwordFormField(),
            currentState == ScreenState.sign_up
                ? _repeatPasswordFormField()
                : Container(),
          ],
        ),
      ),
    );
  }

  TextFormField _emailFormField() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      controller: _emailCtr,
      decoration: InputDecoration(
        hintText: "Enter your email",
        prefixText: "Email",
      ),
      textAlign: TextAlign.right,
      validator: (value) {
        if (!_validEmail(value)) {
          return 'Please enter a valid email!';
        }
        return null;
      },
    );
  }

  TextFormField _passwordFormField() {
    return TextFormField(
      controller: _passwordCtr,
      decoration: InputDecoration(
        hintText: "Enter a password",
        prefixText: "Password",
      ),
      obscureText: true,
      textAlign: TextAlign.right,
      validator: (value) {
        if (!_validPassword(value)) {
          return 'At least 8 chars long';
        }
        return null;
      },
    );
  }

  TextFormField _repeatPasswordFormField() {
    return TextFormField(
      controller: _repeatPasswordCtr,
      decoration: InputDecoration(
        hintText: "Repeat your password",
        prefixText: "Reapeat Password",
      ),
      obscureText: true,
      textAlign: TextAlign.right,
      validator: (value) {
        if (value != _passwordCtr.text) {
          return 'Passwords don\'t match';
        }
        return null;
      },
    );
  }

  Widget _buildSignInButton() {
    return Padding(
      padding: EdgeInsets.all(15),
      child: MaterialButton(
        child: Text("Sign in"),
        onPressed: () {
          _signIn();
        },
      ),
    );
  }

  Widget _buildSignUpButton() {
    return Padding(
      padding: EdgeInsets.all(15),
      child: MaterialButton(
          child: Text("Sign up"),
          onPressed: () {
            _signUp();
          }),
    );
  }

  void _signIn() async {
    if (currentState == ScreenState.sign_up) {
      setState(() {
        currentState = ScreenState.sign_in;
      });
      return;
    }
    if (_formKey.currentState.validate()) {
      try {
        await AuthProvider.of(context)
            .signInWithEmailAndPassword(_emailCtr.text, _passwordCtr.text);
        Navigator.popUntil(context, ModalRoute.withName('/home'));
      } on PlatformException catch (e) {
        String error = e.code;
        switch (error) {
          case "ERROR_INVALID_EMAIL":
            break;
          case "ERROR_WRONG_PASSWORD":
            break;
          case "ERROR_USER_NOT_FOUND":
            break;
          case "ERROR_TOO_MANY_REQUESTS":
            break;
          case "ERROR_OPERATION_NOT_ALLOWED":
            break;
          default:
        }
        _scaffoldKey.currentState
            .showSnackBar(SnackBar(content: Text("${e.message}")));
      } catch (e) {
        _scaffoldKey.currentState
            .showSnackBar(SnackBar(content: Text("An error Occured")));
      }
    }
  }

  void _signUp() async {
    if (currentState == ScreenState.sign_in) {
      setState(() {
        currentState = ScreenState.sign_up;
      });
      return;
    }
    if (_formKey.currentState.validate()) {
      try {
        await AuthProvider.of(context)
            .createUserWithEmailAndPassword(_emailCtr.text, _passwordCtr.text);
        Navigator.popUntil(context, ModalRoute.withName("/home"));
      } on AuthException catch (e) {
        _scaffoldKey.currentState
            .showSnackBar(SnackBar(content: Text("${e.message}")));
      } catch (e) {
        log(e);
        _scaffoldKey.currentState
            .showSnackBar(SnackBar(content: Text("Something went wrong")));
      }
    }
  }

  bool _validEmail(String email) {
    RegExp _emailRegExp = new RegExp(
        r"^((([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+(\.([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+)*)|((\x22)((((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(([\x01-\x08\x0b\x0c\x0e-\x1f\x7f]|\x21|[\x23-\x5b]|[\x5d-\x7e]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(\\([\x01-\x09\x0b\x0c\x0d-\x7f]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF]))))*(((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(\x22)))@((([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.)+(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))$");

    if (_emailRegExp.hasMatch(email.trimRight()) &&
        _emailRegExp.allMatches(email).length == 1) {
      return true;
    } else {
      return false;
    }
  }

  bool _validPassword(String pass) {
    return true;
    if (pass == null || pass.isEmpty) return false;
    if (pass.length < 8) {
      return false;
    } else {
      return true;
    }
  }

  bool _validUsername(String name) {
    if (name == null || name.isEmpty) return false;
    return true;
  }
}
