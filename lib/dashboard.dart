import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mbank/registration.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
//import 'package:jellow_senior/Pages/dashboard.dart';
import 'package:mbank/controller/loginController.dart';

class dashboard extends StatefulWidget{
  FirebaseUser user;
  dashboard({Key key,this.user}) : super(key: key,);

  @override
  _dashboard createState() => new _dashboard();
}

class _dashboard extends State<dashboard>{


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        backgroundColor: Color(0xFF424242),
        body: Text("You are here")
    );

  }


}