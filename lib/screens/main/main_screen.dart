import 'package:digital_local_library/screens/main/views/saved.dart';
import 'package:flutter/material.dart';
import 'package:digital_local_library/screens/main/destination.dart';
import 'package:digital_local_library/screens/main/views/library.dart';
import 'package:digital_local_library/screens/main/views/profile.dart';
import 'package:digital_local_library/screens/main/views/settings.dart';

const List<Destination> allDestinations = <Destination>[
  Destination(title: 'All books', icon: Icons.library_books, color: Colors.teal),
  Destination(title: 'Saved books', icon: Icons.favorite, color: Colors.lightGreen),
  Destination(title: 'Profile', icon: Icons.person, color: Colors.red),
  Destination(title: 'Settings', icon: Icons.settings, color: Colors.yellow),
];

List<Widget> allDestinationViews = [
  new LibraryView(),
  new SavedBooksView(),
  new ProfileView(),
  new SettingsView(),
];

class MainScreen extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainScreen> with TickerProviderStateMixin<MainScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: false,
        child: IndexedStack(
          index: _currentIndex,
          children: allDestinationViews,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: allDestinations.map((Destination destination) {
          return BottomNavigationBarItem(
            icon: Icon(destination.icon),
            backgroundColor: destination.color,
            title: Text(destination.title),
          );
        }).toList(),
      ),
    );
  }
}
