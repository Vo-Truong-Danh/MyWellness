import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_wellness/src/screens/authentication/LoginPage.dart';

import '../authentication/Auth.dart';

class Account_Setting extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _Account_Setting();
  }
}

class _Account_Setting extends State<Account_Setting> {
    final user = FirebaseAuth.instance.currentUser;

  logOut() async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => Auth()),
          (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Flutter Setting And Accout',
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.w700),
          ),
          SizedBox(height: 20),
          Text(
            'Họ Tên: ${user?.displayName}',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
          ),
          Text(
            'Email: ${user?.email}',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
          ),
          SizedBox(height: 50),
          ElevatedButton(
            style: TextButton.styleFrom(
              maximumSize: Size(200, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              backgroundColor: Color(0xFF30C9B7),
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              logOut();
            },
            child: Center(
              child: Text('Đăng Xuất', style: TextStyle(fontSize: 17)),
            ),
          ),
        ],
      ),
    );
  }
}
