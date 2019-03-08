import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mbank/login.dart';
import 'package:mbank/registration.dart';
import 'package:mbank/admin/Adding_data.dart';
import 'package:mbank/scanningPage.dart';
void main() {


    runApp(new MyApp());

}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          backgroundColor:  Color(0xFF01579B),
          highlightColor:Colors.white,
          hintColor:  Colors.white,
          textTheme: new TextTheme(
              display1: TextStyle(color: Color(0xFFA86E52))
          )

      ),
      home: Login(),
      routes: <String, WidgetBuilder> {
        '/registration': (BuildContext context) => new Registration(),
        '/login' : (BuildContext context) => new Login(),
      },

    );
  }
}

