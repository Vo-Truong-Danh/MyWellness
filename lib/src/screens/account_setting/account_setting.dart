import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_wellness/src/screens/authentication/LoginPage.dart';
import 'package:my_wellness/src/widget/AboutUS.dart';

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
    return SingleChildScrollView(
      child: Container(
        color: Color(0xFF30C9B7),
        height: 1000,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 50,
                  left: 40,
                  right: 40,
                  bottom: 50,
                ),
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Column(
                        spacing: 15,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Elon Musk',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Row(
                            spacing: 10,
                            children: [
                              Icon(Icons.email_outlined, color: Colors.white),
                              Text(
                                'EmailTmp@gmail.com',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            spacing: 10,
                            children: [
                              Icon(Icons.phone, color: Colors.white),
                              Text(
                                '09274758582',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: 
                        Image.asset('assets/images/brlogin.gif')
                    ),
                  ],
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(30),
                  topLeft: Radius.circular(30),
                ),
              ),
              width: double.infinity,
              height: 780,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      bottom: 5,
                      right: 5,
                      left: 10,
                      top: 15,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: Colors.black, width: 1),
                        ),
                      ),
                      child: Column(
                        children: [
                          OutlinedButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext dialogContext) {
                                  return const AboutAppDialog();
                                },
                                barrierDismissible: true,
                              );
                            },
                            style: TextButton.styleFrom(
                              side: BorderSide(width: 0, color: Colors.white),
                            ),
                            child: Row(
                              children: [
                                SizedBox(width: 10),
                                Icon(Icons.info_outline, size: 26),
                                SizedBox(width: 20),
                                Text(
                                  'About Us',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 5),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      bottom: 25,
                      right: 5,
                      left: 10,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: Colors.black, width: 1),
                        ),
                      ),
                      child: Column(
                        children: [
                          OutlinedButton(
                            onPressed: () {
                              logOut();
                            },
                            style: TextButton.styleFrom(
                              side: BorderSide(width: 0, color: Colors.white),
                            ),
                            child: Row(
                              children: [
                                SizedBox(width: 10),
                                Icon(Icons.logout, size: 26),
                                SizedBox(width: 20),
                                Text('Log out', style: TextStyle(fontSize: 16)),
                              ],
                            ),
                          ),
                          SizedBox(height: 5),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
