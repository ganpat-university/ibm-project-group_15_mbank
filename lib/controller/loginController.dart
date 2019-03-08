import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mbank/dashboard.dart';

class Log{

  var email;
  var password;
  var nav;

  Log( var email,var password,var nav)
  {
    this.email = email;
    this.password=password;
    this.nav=nav;
  }

  void log() async {
    try{

      FirebaseUser user = await FirebaseAuth.instance.currentUser();
      await user.reload();
      user = await FirebaseAuth.instance.currentUser();
      bool flag = user.isEmailVerified;

      if(flag)
      {
        FirebaseUser user=await FirebaseAuth.instance.currentUser();
        await FirebaseAuth.instance.signInWithEmailAndPassword(email: email.text, password: password.text);
        Navigator.push(nav, MaterialPageRoute(builder: (context) => dashboard(user: user)));
      }
      else
      {
        showDialog(context: nav,builder: (BuildContext context)
        {
          return AlertDialog(
            title: new Text("Verify mail"),
            content: new Text("Please verify your mail before log in"),
            actions: <Widget>[
              new FlatButton(
                child: new Text("Close"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
        );

      }}catch(e){
      print(e.message);
    }
  }
}