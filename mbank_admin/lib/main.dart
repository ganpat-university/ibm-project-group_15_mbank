import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mbank_admin/DashboardPage.dart';
import 'package:mbank_admin/Controllers/Firebase_sms.dart';
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
      home:dashboard(),
      //home: MyHomePage(),
      //home: CreateTransaction(),
      routes: <String, WidgetBuilder> {

      },

    );
  }
}

