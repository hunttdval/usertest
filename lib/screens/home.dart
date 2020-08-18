import 'package:flutter/material.dart';
import 'package:login_phone_number/screens/home_view.dart';
import 'package:login_phone_number/services/authservice.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  final List _children = [
    HomeView(),
    ExploreView(),
    ProfileView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          leading: Icon(Icons.more_vert),
          actions: [
            FlatButton.icon(
              icon: Icon(Icons.exit_to_app),
              label: Text('SignOut'),
              onPressed: () {
                AuthService().signOut();
              },
            ),
          ],
        ),
        body: _children[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
            onTap: onTabTapped,
            currentIndex: _currentIndex,
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                title: Text(
                  'Home',
                  style: TextStyle(fontSize: 17),
                ),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.explore),
                title: Text(
                  'Explore',
                  style: TextStyle(fontSize: 17),
                ),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.account_circle),
                title: Text(
                  'Profile',
                  style: TextStyle(fontSize: 17),
                ),
              ),
            ]));
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
