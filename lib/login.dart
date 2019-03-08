import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mbank/admin/Adding_data.dart';
import 'package:mbank/scanningPage.dart';
import 'package:mbank/controller/loginController.dart';

class Login extends StatefulWidget{
  FirebaseUser user;
  Login({Key key,this.user}) : super(key: key,);

  @override
  _LoginState createState() => new _LoginState();
}

class _LoginState extends State<Login>{

  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();


  TextEditingController username = new TextEditingController();
  TextEditingController password = new TextEditingController();
  String us ;

  @override
  Widget build(BuildContext context) {

    void registrationFun(){
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Scanning()),
      );

    }

    void showMessage(String message, [MaterialColor color = Colors.red]) {
      _scaffoldKey.currentState.showSnackBar(new SnackBar(backgroundColor: color, content: new Text(message)));
    }

    void login(){
      final FormState form = _formKey.currentState;
      var nav=context;

      if(form.validate()) {
        form.save();
        Log obj=new Log(username, password, nav);
        obj.log();
      }
      else{
        showMessage('Data is not valid');
      }


    }



    return new Scaffold(
        key: _scaffoldKey,
        backgroundColor: Color(0xFF424242),
        body: SingleChildScrollView(
            child:new ConstrainedBox(constraints: BoxConstraints(maxHeight: 672 )
              ,child:Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[

                    Container(

                      child: new Row(
                        children: <Widget>[
                          Expanded(
                              child: Text("Mobile Banking",textAlign: TextAlign.center,style:TextStyle(fontSize: 34,color: Colors.white,fontFamily:'mukta'),)
                          )
                        ],),),

                    Container(
                      padding: EdgeInsets.fromLTRB(0, 10,0, 0),
                      child: new Row(
                        children: <Widget>[
                          Expanded(
                            child: new Text("Login to Continue to mBank",textAlign: TextAlign.center,style:TextStyle(color:Colors.white70,fontSize: 16)),
                          )
                        ],),),

                    Container(

                        child:  new Container(
                            padding: EdgeInsets.only(top: 30),
                            width: 300,
                            color: Colors.transparent,
                            child: new Container(
                                decoration:  new BoxDecoration(

                                    color: Colors.white, borderRadius: new BorderRadius.all(Radius.circular(25.0)
                                )),
                                child: Form(
                                    key: _formKey,
                                    autovalidate:true,
                                    child: Column(
                                      children: <Widget>[

                                        Container(
                                            padding: EdgeInsets.only(top: 20),
                                            width: 200,
                                            child:TextFormField(
                                              controller: username,
                                              //cursorColor: Color(0xFFA86E52),
                                              validator: (val) => val.isEmpty ? 'Username is required' : null,
                                              decoration: new InputDecoration(
                                                  focusedBorder: new OutlineInputBorder(
                                                    borderSide: new BorderSide(color: Colors.black),
                                                    borderRadius: const BorderRadius.all(const Radius.circular(15.0),),
                                                  ),
                                                  border: new OutlineInputBorder(
                                                    borderSide: new BorderSide(color: Color.fromRGBO(246,242,199, 1.0)),
                                                    borderRadius: const BorderRadius.all(const Radius.circular(15.0),),
                                                  ),
                                                  filled: true,
                                                  hintStyle: new TextStyle(color: Colors.white),
                                                  hintText: "User Name",
                                                  fillColor: Color(0xFF757575)


                                              ),
                                            )
                                        ),

                                        Container(
                                            padding: EdgeInsets.only(top: 20),
                                            width: 200,
                                            child:TextFormField(
                                              controller: password,
                                              //cursorColor: Color(0xFFA86E52),
                                              validator: (val) => val.isEmpty ? 'Password is required' : null,
                                              decoration: new InputDecoration(
                                                  focusedBorder: new OutlineInputBorder(
                                                    borderSide: new BorderSide(color:Colors.black),
                                                    borderRadius: const BorderRadius.all(const Radius.circular(15.0),),
                                                  ),
                                                  border: new OutlineInputBorder(
                                                    borderSide: new BorderSide(color: Color.fromRGBO(246,242,199, 1.0)),
                                                    borderRadius: const BorderRadius.all(const Radius.circular(15.0),),
                                                  ),
                                                  filled: true,
                                                  hintStyle: new TextStyle(color: Colors.white),
                                                  hintText: "Password",
                                                  fillColor: Color(0xFF757575)),

                                            )
                                        ),

                                        Container(
                                          width: 150,
                                          height: 70,
                                          padding: EdgeInsets.only(top: 20),
                                          margin: EdgeInsets.only(bottom: 20),
                                          child: RaisedButton(onPressed: login,
                                              elevation: 0.0,
                                              textColor: Colors.white,
                                              child: new Text("Login",style: TextStyle(fontSize: 18)),
                                              shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(15.0))
                                          ),)
                                      ],))))),

                    Container(
                      padding: const EdgeInsets.only(bottom: 100,left: 20,top: 20,right: 20),
                      width: 300,
                      child: Row(
                          children: <Widget>[
                            new GestureDetector(
                                child: new Text("Register",style: TextStyle(color: Colors.white70,fontSize: 18,fontWeight: FontWeight.bold),),
                                onTap: registrationFun
                            ),
                            Expanded(
                                child:GestureDetector(
                                  child: new Text("Need Help?",textAlign: TextAlign.end,style: TextStyle(color: Colors.white70,fontSize: 18,fontWeight: FontWeight.bold),),
                                  onTap: helpPage,
                                )),

                          ]),
                    ),


                  ]),


            )));

  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    username.dispose();
    password.dispose();
  }


  void helpPage(){

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) =>AddingData()),
    );
  }
}