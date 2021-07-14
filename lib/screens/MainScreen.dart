import 'package:flutter/material.dart';
import '../screens/HomePage.dart';
import '../screens/MyCoursePage.dart';
import '../screens/MyAccount.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_icons/flutter_icons.dart';
class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  List<Widget> _widgetOptions = <Widget>[
    HomePage(),
    MyCoursePage(),
    MyAccountPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              FontAwesome.home,
              color: Colors.lightBlue,
            ),
            label: 'Home',
            activeIcon: Icon(
              FontAwesome.home,
              color: Colors.redAccent,
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              FontAwesome5.play_circle,
              color: Colors.lightBlue,
            ),
            label: ('My Course'),
            activeIcon: Icon(
              FontAwesome5.play_circle,
              color: Colors.redAccent,
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              EvilIcons.user,
              color: Colors.lightBlue,
              size: 36,
            ),
            label: ('My Account'),
            activeIcon: Icon(
              EvilIcons.user,
              color: Colors.redAccent,
              size: 36,
            ),
          ),
        ],
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
    );
  }
}
