import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';





class AccountScreen extends StatelessWidget{

  AccountScreen({@required this.loggedInUser,});

  static String id = 'account_screen';
  final FirebaseUser loggedInUser;


  @override
  Widget build(BuildContext context) {


    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only( bottom: 50, ),
                height: 100.0,
                child: Image.asset('images/logo.png'),
              ),
              SizedBox(
                height: 15,
              ),
              Container(
                child: Text(
                  'Your logged in account is ${loggedInUser.email}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                color: Colors.grey[100],
              ),
            ]),
      ),
    );
  }
  }




