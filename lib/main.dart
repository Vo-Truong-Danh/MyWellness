import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:my_wellness/src/app.dart';
import 'package:my_wellness/src/screens/authentication/auth.dart';
// import 'package:my_wellness/src/app.dart'; // Tạm thời bỏ import này

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
      ),
      debugShowCheckedModeBanner: false,
      home: Auth(),
    ),
  );
}
