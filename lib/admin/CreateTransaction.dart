import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';
import 'package:encrypt/encrypt.dart';
import 'package:firebase_database/firebase_database.dart';

class AddingData extends StatefulWidget{
  AddingData({Key key}) : super(key: key);

  @override
  _AddingData createState() => new _AddingData();

}

class _AddingData extends State<AddingData> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();


  TextEditingController phone= new TextEditingController();
  TextEditingController account= new TextEditingController();


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
                              child: Text("Account Details Adding",textAlign: TextAlign.center,style:TextStyle(fontSize: 34,color: Colors.white,fontFamily:'mukta'),)
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
                                            padding: EdgeInsets.only(top: 20),
                                            width: 200,
                                            child: TextFormField(
                                              controller: account,
                                              keyboardType: TextInputType.number,
                                              // cursorColor: Color(0xFFA86E52),
                                              validator: (val) => val.isEmpty ? 'Account no is required' : null,
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
                                                  hintText: "Account Number",
                                                  fillColor: Color(0xFF757575)),
                                            )
                                        ),

                                        Container(
                                            padding: EdgeInsets.only(top: 10),
                                            width: 200,
                                            child: TextFormField(
                                              controller: phone,
                                              //cursorColor: Color(0xFFA86E52),
                                              validator: (val) => val.length<10 ? 'Phone number should be correct' : null,
                                              keyboardType: TextInputType.phone,
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
                                                  hintText: "Phone Number",
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

                                              child: new Text("ADD",style: TextStyle(fontSize: 14)),
                                              shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(15.0))
                                          ),)

                                      ],


                                    ))))),
                  ]),


            )));



  }

  void login() {}

  void registerPage() {
    var uuid = new Uuid();

    //final key = 'my32lengthsupersecretnooneknowsl';
    final key = 'private!!!!!!!!!';
    final iv = '8bytesiv';

    final encrypter =new Encrypter(new Salsa20(key, iv));


    final encryptedPhone = encrypter.encrypt(phone.text);
    final encryptedAccount = encrypter.encrypt(account.text);

    DatabaseReference db = FirebaseDatabase.instance.reference();
    db.child("account_details").child(uuid.v1()).set({
      'Phone_no': encryptedPhone,
      'Account_no': encryptedAccount,
    });




  }

  void helpPage() {}



}
