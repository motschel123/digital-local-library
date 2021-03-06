import 'package:digital_local_library/models/appbar_model.dart';
import 'package:digital_local_library/models/books_database_model.dart';
import 'package:digital_local_library/models/chats_overview_model.dart';
import 'package:digital_local_library/screens/chats/chats_overview_screen.dart';
import 'package:digital_local_library/screens/landing_screen.dart';
import 'package:digital_local_library/screens/sign_in/sign_in_screen.dart';
import 'package:digital_local_library/screens/upload_book_screen.dart';
import 'package:digital_local_library/sign_in/auth.dart';
import 'package:digital_local_library/sign_in/auth_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:digital_local_library/consts/Consts.dart';
import 'package:scoped_model/scoped_model.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final Auth auth = Auth();

  @override
  Widget build(BuildContext context) {
    return AuthProvider(
      auth: auth,
      child: ScopedModel<AppBarModel>(
        model: AppBarModel(),
        child: ScopedModel<BooksDatabaseModel>(
          model: BooksDatabaseModel(),
          child: ScopedModel<ChatsOverviewModel>(
            model: ChatsOverviewModel(
              currentUser: auth.currentUser(),
            ),
            child: MaterialApp(
              title: Consts.HOMESCREEN_TITLE,
              theme: ThemeData(
                brightness: Brightness.light,
                primaryColor: Colors.red[400],
                accentColor: Colors.greenAccent,
              ),
              routes: {
                '/home': (context) => LandingScreen(),
                '/home/chats': (context) => ChatsOverviewScreen(),
                '/home/sign_in': (context) => SignInScreen(),
                '/home/upload': (context) =>
                    UploadBookScreen(modelContext: context)
              },
              initialRoute: '/home',
            ),
          ),
        ),
      ),
    );
  }
}
