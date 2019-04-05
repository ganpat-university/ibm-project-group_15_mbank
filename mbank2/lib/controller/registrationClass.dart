import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:mbank2/login.dart';
import 'package:encrypt/encrypt.dart';
import 'package:mbank2/globals.dart';


class Register{

  var username;
  var password;
  var email;
  var phonenum;
  var account;
  var nav;

  Register(var username,var email,var password,var phonenum,var account,var nav) {
    this.username = username;
    this.password=password;
    this.account=account;
    this.phonenum=phonenum;
    this.email=email;
    this.nav=nav;
  }

  void reg() async {

    final key = 'private!!!!!!!!!';
    final iv = '8bytesiv';

    final encrypter =new Encrypter(new Salsa20(key, iv));

    FirebaseUser user;

    try
    {

      user = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email.trim(), password: password.trim())
          .then((FirebaseUser user) {user.sendEmailVerification();});


    }
    catch (e)
    {
      print(e.message);
    }
    finally
    {
      user=await FirebaseAuth.instance.currentUser();
      DatabaseReference db = FirebaseDatabase.instance.reference();
      if (user != null)
      {
        final uid = user.uid;
        await db.child("registered_data").child(uid).set({
          'Username': encrypter.encrypt(username),
          'Password': encrypter.encrypt(password),
          'Phone_no': encrypter.encrypt(phonenum),
          'Email_id': encrypter.encrypt(email),
          'Account_no': encrypter.encrypt(account),
          'uid': uid
        });

        await db.child('account_details').child(keyUpdate).update(
            {"netBanking":true});


        Navigator.pushReplacement(nav, MaterialPageRoute(builder: (context) => new Login()));

      }else
      {
        print("null");
      }
    }
  }
}