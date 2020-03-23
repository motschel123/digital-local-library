import 'package:digital_local_library/sign_in/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SignInEmailScreen extends StatefulWidget {
  @override
  _SignInEmailScreenState createState() => _SignInEmailScreenState();
}

class _SignInEmailScreenState extends State<SignInEmailScreen> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController _emailCtr;
  TextEditingController _passwordCtr;
  TextEditingController _usernameCtr;

  @override
  void initState() {
    super.initState();

    _emailCtr = TextEditingController();
    _passwordCtr = TextEditingController();
    _usernameCtr = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _buildSignInForm(),
            Padding(
              padding: EdgeInsets.all(15),
              child: MaterialButton(
                child: Text("Sign in"),
                onPressed: () async {
                  if (_formKey.currentState.validate()) {
                    try {
                      await AuthProvider.of(context).signInWithEmailAndPassword(
                          _emailCtr.text, _passwordCtr.text);
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
                      _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("${e.message}")));
                    } catch (e) {
                      _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("An error Occured")));
                    }
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSignInForm() {
    return Form(
      key: _formKey,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: <Widget>[
            _emailFormField(),
            _passwordFormField(),
            _usernameFormField(),
          ],
        ),
      ),
    );
  }

  TextFormField _emailFormField() {
    return TextFormField(
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

  TextFormField _usernameFormField() {
    return TextFormField(
      controller: _usernameCtr,
      decoration: InputDecoration(
        hintText: "Enter your name",
        prefixText: "Name",
      ),
      obscureText: true,
      textAlign: TextAlign.right,
      validator: (value) {
        if (!_validUsername(value)) {
          return 'Enter your name';
        }
        return null;
      },
    );
  }

  bool _validEmail(String email) {
    RegExp _emailRegExp = new RegExp(
        r"^((([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+(\.([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+)*)|((\x22)((((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(([\x01-\x08\x0b\x0c\x0e-\x1f\x7f]|\x21|[\x23-\x5b]|[\x5d-\x7e]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(\\([\x01-\x09\x0b\x0c\x0d-\x7f]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF]))))*(((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(\x22)))@((([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.)+(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))$");

    if (_emailRegExp.hasMatch(email) &&
        _emailRegExp.allMatches(email).length == 1) {
      return true;
    } else {
      return false;
    }
  }

  bool _validPassword(String pass) {
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
