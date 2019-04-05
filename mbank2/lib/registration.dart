import 'package:flutter/material.dart';
import 'package:mbank2/globals.dart';
import 'package:flutter/services.dart';
import 'package:mbank2/controller/registrationClass.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:encrypt/encrypt.dart';

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
 bool autoValid = false;

  String dialogText;
  void cancel(){
    Navigator.pop(context);
  }


  @override
  Widget build(BuildContext context) {
   return new Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.black,
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
                              child: Text("Register",textAlign: TextAlign.center,style:TextStyle(fontSize: 30,color: Colors.redAccent,fontFamily:'mukta'),)
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
                                    autovalidate: autoValid,
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
                                              color: Colors.red,
                                              textColor: Colors.white,

                                              child: new Text("Register",style: TextStyle(fontSize: 18)),
                                              shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(15.0))
                                          ),)

                                      ],


                                    ))))),
                  ]),


            )));



  }

  void onDismiss(){
    Navigator.pop(context);
  }

  Dialog createDialog(bool loadingbar,bool button) {
    return  Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0),
      ),
      //this right here
      child: Container(
        height: 250.0,
        width: 350.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
                alignment: Alignment.center,
                padding: EdgeInsets.only(left: 25, right: 25, top: 25,),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(dialogText,style: TextStyle(fontSize: 18),),

                    Padding(padding: EdgeInsets.only(top: 20),),

                    loadingbar?Center(child: CircularProgressIndicator(),):Container(),

                    Padding(padding: EdgeInsets.only(bottom: 20),),
                    Row(
                      children: <Widget>[
                        Expanded(
                            child:Container(
                              height:1,
                              margin: EdgeInsets.only(left: 15,right:15),
                              color: Colors.black,
                            ))
                      ],
                    ),
                    Padding(padding: EdgeInsets.only(bottom: 20),),
                    button?RaisedButton(onPressed: onDismiss,
                        elevation: 0.0,
                        color: Colors.redAccent,
                        textColor: Colors.white,
                        child: new Text("Dismiss",style: TextStyle(fontSize: 12)),
                        shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(15.0))
                    ):Container()
                  ],
                )
            ),
          ],
        ),
      ),
    );
  }


  Future<void> checkingForInfo() async {

    final key = 'private!!!!!!!!!';
    final iv = '8bytesiv';
    final encrypter =new Encrypter(new Salsa20(key, iv));
    DatabaseReference db = FirebaseDatabase.instance.reference();

    await db.child('account_details').once().then((DataSnapshot snapshot){
      var keys = snapshot.value.keys;
      var data = snapshot.value;
      print(keys);
      for (var key in keys){
        var x = encrypter.decrypt(data[key]['Account_no']);
        if(x == accountDetail ){
          keyUpdate =key ;
        }
      }});
  }


  void registerPage() async{
    final FormState form = _formKey.currentState;
    var nav = context;
    if(form.validate()){
      print("fsdfjdsfjkhdskfhdskfhdksfhkdsfhdsfhdksfhkdsfhkdshfkdshfkdsfhkdsfhksdf");
      dialogText = "Registration is in process. Please wait.....";
      showDialog(context: context, builder: (BuildContext context) => createDialog(true,false));

      await checkingForInfo();
      form.save();
      Register obj = new Register(username.text, email.text, password.text, phoneDetail, accountDetail, nav);

      Future.delayed(Duration(seconds: 3),(){
        obj.reg();
      });



    }
    else{
      autoValid=true;

      dialogText = "Please enter the correct details";
      showDialog(context: context, builder: (BuildContext context) => createDialog(false,true));

    }
  }
  void showMessage(String message, [MaterialColor color = Colors.red]) {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(backgroundColor: color, content: new Text(message)));
  }


}
