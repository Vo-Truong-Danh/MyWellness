// lib/src/app.dart
import 'package:flutter/material.dart';
import 'package:my_wellness/src/screens/home/homepage.dart';
import 'package:my_wellness/src/screens/chart/chart.dart';
import 'package:my_wellness/src/screens/account_setting/account_setting.dart';

class MyApp extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return MainApp();
  }
}

class MainApp extends State<MyApp> {

  int _index = 0;

  @override
  static List<Widget> _option = <Widget>[
    HomePage(),
    Chart(),
    Account_Setting(),
  ];

  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(

        body: IndexedStack(index: _index, children: _option),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.grid_view_rounded),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart_sharp),
              label: 'Statistics',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.manage_accounts),
              label: 'Account',
            ),
          ],
          currentIndex: _index,
          onTap: (value) {
            setState(() {
              _index = value;
            });
          },
          selectedItemColor: Color(0xFF30C9B7),
          unselectedItemColor: Colors.grey,
        ),
      ),
    );
  }
}
