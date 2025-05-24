import 'package:flutter/material.dart';
import 'package:my_wellness/src/app.dart';

void main() {
  runApp(
    MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
      ),
      debugShowCheckedModeBanner: false,
      home: MyApp(),
    ),
  );
}
