// lib/src/app.dart
import 'package:flutter/material.dart';

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MainApp();
  }
}

class MainApp extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Health Data",
            style: TextStyle(fontWeight: FontWeight.w900, fontSize: 29),
          ),
        ),
        body: 
        Center(
          child: Text("Hello Github"),
        ),
      ),
    );
  }
}
