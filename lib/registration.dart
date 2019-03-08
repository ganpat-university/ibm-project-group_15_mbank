import 'package:flutter/material.dart';
import 'package:mbank/globals.dart';
import 'package:flutter/services.dart';
import 'package:mbank/controller/registrationClass.dart';

class Registration extends StatefulWidget{
  Registration({Key key}) : super(key: key);

  @override
  _RegistrationPage createState() => new _RegistrationPage();

}

class _RegistrationPage extends State<Registration> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  TextEditingController username= new TextEditingController();
  TextEditingController email= new TextEditingController();
  TextEditingController password= new TextEditingController();



  void cancel(){
    Navigator.pop(context);
  }


  @override
  Widget build(BuildContext context) {
   return new Scaffold(
        key: _scaffoldKey,
        backgroundColor: Color(0xFF424242),
        body: SingleChildScrollView(
            child: new ConstrainedBox(
              constraints: BoxConstraints(maxHeight: 672),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,

                  children: <Widget>[

                    Container(
                      padding: EdgeInsets.fromLTRB(0, 20,0, 0),

                      child: new Row(
                        children: <Widget>[
                          Expanded(
                              child: Text("Register",textAlign: TextAlign.center,style:TextStyle(fontSize: 34,color: Colors.white,fontFamily:'mukta'),)
                          )
                        ],),),
                   Container(

                        child:  new Container(
                        padding: EdgeInsets.only(top: 30),
                            width: 280,
                              color: Colors.transparent,
                              child: new Container(
                                  decoration:  new BoxDecoration(

                                          color: Colors.white, borderRadius: new BorderRadius.all(Radius.circular(25.0)
                                            )),
                                child:Form(key: _formKey,
                                    autovalidate: true,
                                    child: Column(
                                      children: <Widget>[


                                        Container(
                                            padding: EdgeInsets.only(top: 10),
                                            width: 200,

                                            child: TextFormField(
                                            controller: email,
                                              //cursorColor: Color(0xFFA86E52),
                                              validator: (val) => val.length<10 ? 'Email should be correct' : null,
                                              keyboardType: TextInputType.emailAddress,
                                              decoration: new InputDecoration(
                                                  focusedBorder: new OutlineInputBorder(
                                                    borderSide: new BorderSide(color: Color(0xFFA86E52)),
                                                    borderRadius: const BorderRadius.all(const Radius.circular(15.0),),
                                                  ),
                                                  border: new OutlineInputBorder(
                                                    borderSide: new BorderSide(
                                                        color: Color.fromRGBO(
                                                            246, 242, 199, 1.0)),
                                                    borderRadius: const BorderRadius
                                                        .all(
                                                      const Radius.circular(15.0),),
                                                  ),
                                                  filled: true,
                                                  hintStyle: new TextStyle(
                                                      color: Colors.white),
                                                  hintText: "Email",
                                                  fillColor: Color(0xFF757575)),
                                            )
                                        ),
                                        Container(
                                            padding: EdgeInsets.only(top: 10),
                                            width: 200,
                                            child: TextFormField(
                                              controller: username,
                                              validator: (val) => val.isEmpty ? 'Username is required' : null,
                                              //cursorColor: Color(0xFFA86E52),
                                              decoration: new InputDecoration(
                                                  focusedBorder: new OutlineInputBorder(
                                                    borderSide: new BorderSide(color: Color(0xFFA86E52)),
                                                    borderRadius: const BorderRadius.all(const Radius.circular(15.0),),
                                                  ),
                                                  border: new OutlineInputBorder(borderSide: new BorderSide(color: Color.fromRGBO(246, 242, 199, 1.0)),
                                                    borderRadius: const BorderRadius.all(const Radius.circular(15.0),),),
                                                  filled: true,
                                                  hintStyle: new TextStyle(color: Colors.white),
                                                  hintText: "Username",
                                                  fillColor: Color(0xFF757575)),
                                            )
                                        ),

                                        Container(
                                            padding: EdgeInsets.only(top: 10),
                                            width: 200,
                                            child: TextFormField(
                                              controller: password,
                                              obscureText: true,
                                              validator: (val) => val.isEmpty ? 'Password is required' : null,
                                              //cursorColor: Color(0xFFA86E52),
                                              decoration: new InputDecoration(
                                                  focusedBorder: new OutlineInputBorder(
                                                    borderSide: new BorderSide(color: Color(0xFFA86E52)),
                                                    borderRadius: const BorderRadius.all(const Radius.circular(15.0),),
                                                  ),
                                                  border: new OutlineInputBorder(borderSide: new BorderSide(color: Color.fromRGBO(246, 242, 199, 1.0)),
                                                    borderRadius: const BorderRadius.all(const Radius.circular(15.0),),),
                                                  filled: true,
                                                  hintStyle: new TextStyle(color: Colors.white),
                                                  hintText: "Password",
                                                  fillColor: Color(0xFF757575)),
                                            )
                                        ),

                                        Container(
                                            padding: EdgeInsets.only(top: 10),
                                            width: 200,
                                            child: TextFormField(
                                              obscureText: true,
                                              validator: (val) => val.isEmpty ? 'Password is required' : null,
                                              //cursorColor: Color(0xFFA86E52),
                                              decoration: new InputDecoration(
                                                  focusedBorder: new OutlineInputBorder(
                                                    borderSide: new BorderSide(color: Color(0xFFA86E52)),
                                                    borderRadius: const BorderRadius.all(const Radius.circular(15.0),),
                                                  ),
                                                  border: new OutlineInputBorder(borderSide: new BorderSide(color: Colors.black),
                                                    borderRadius: const BorderRadius.all(const Radius.circular(15.0),),),
                                                  filled: true,
                                                  hintStyle: new TextStyle(color: Colors.white),
                                                  hintText: "Confirm Password",
                                                  fillColor: Color(0xFF757575)),
                                            )
                                        ),


                                        Container(
                                          width: 150,
                                          height: 70,
                                          padding: EdgeInsets.only(top: 20),
                                            margin: EdgeInsets.only(bottom: 20),
                                          child: RaisedButton(onPressed: registerPage,
                                              elevation: 0.0,
                                              color: Color(0xFF424242),
                                              textColor: Colors.white,

                                              child: new Text("Register",style: TextStyle(fontSize: 18)),
                                              shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(15.0))
                                          ),)

                                      ],


                                    ))))),
                  ]),


            )));



  }

  void login() {}

  void registerPage() async{
    final FormState form = _formKey.currentState;
    var nav = context;
    if(form.validate()){
      form.save();
      Register obj = new Register(username.text, email.text, password.text, phoneDetail, accountDetail, nav);
      obj.reg();
    }
    else{
      showDialog(context: nav,builder: (BuildContext context){
        return AlertDialog(
          title: Text("Error"),
          content: Text("Please check the details"),
          actions: <Widget>[
            FlatButton(
              child:  Text("Close"),
              onPressed: (){Navigator.of(context).pop();},
            )
          ],
        );
      });
    }
  }

  void helpPage() {}



}
