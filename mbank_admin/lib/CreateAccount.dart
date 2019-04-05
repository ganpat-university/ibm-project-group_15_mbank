import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';
import 'package:encrypt/encrypt.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:mbank_admin/DashboardPage.dart';
import 'dart:math';

class AddingData extends StatefulWidget{
  AddingData({Key key}) : super(key: key);

  @override
  _AddingData createState() => new _AddingData();

}

class _AddingData extends State<AddingData> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  bool _autovalidate =false;
  TextEditingController name= new TextEditingController();
  TextEditingController phone= new TextEditingController();
  TextEditingController balance= new TextEditingController();

  List _lan = ["Aburoad","Ahmedabad","Banglore","Mumbai"];
  List<DropdownMenuItem<String>> _dropDownMenuItems;
  String _currentlan;
  String lan;

  List _type = ["Current","Saving"];
  List<DropdownMenuItem<String>> _dropDownMenuItems2;
  String _currentlan2;
  String lan2;

  List<DropdownMenuItem<String>> getDropDownMenuItems() {
    List<DropdownMenuItem<String>> items = new List();
    for (String language in _lan) {
      items.add(new DropdownMenuItem(
          value: language,
          child: new Text(language)
      ));
    }
    return items;
  }
  List<DropdownMenuItem<String>> getDropDownMenuItems2() {
    List<DropdownMenuItem<String>> items = new List();
    for (String language in _type) {
      items.add(new DropdownMenuItem(
          value: language,
          child: new Text(language)
      ));
    }
    return items;
  }
@override
  void initState() {
    // TODO: implement initState
  _dropDownMenuItems = getDropDownMenuItems();
  _dropDownMenuItems2 = getDropDownMenuItems2();




    super.initState();
  }


  void cancel(){
    Navigator.pop(context);
  }
  @override
  void dispose() {
    // TODO: implement dispose
    phone.clear();
    balance.clear();

    super.dispose();
  }

  void showMessage(String message, MaterialColor color ) {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(backgroundColor: color, content: new Text(message)));
  }
  @override
  Widget build(BuildContext context) {





    return new Scaffold(
        key: _scaffoldKey,
        appBar:AppBar(
          title: Text("Create mBank account",style: TextStyle(color: Colors.white),),
          backgroundColor: Color(0xFFbf2b46),
          elevation: 0.0,
          actions: <Widget>[
          ],
        ),
        backgroundColor: Colors.black,
        body: SingleChildScrollView(

              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,

                  children: <Widget>[

                    Container(
                      padding: EdgeInsets.fromLTRB(0, 20,0, 0),

                      child: new Row(
                        children: <Widget>[
                          Expanded(
                              child: Text("",textAlign: TextAlign.center,style:TextStyle(fontSize: 22,color: Colors.redAccent,fontFamily:'mukta'),)
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
                                    autovalidate: _autovalidate,
                                    child: Column(
                                      children: <Widget>[

                                        Container(
                                            padding: EdgeInsets.only(top: 20),
                                            width: 200,
                                            child: TextFormField(
                                              controller: name,
                                              // cursorColor: Color(0xFFA86E52),
                                              validator: (val) => val.isEmpty ? 'Name is required' : null,
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
                                                  hintText: "Full Name",
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
                                            margin: EdgeInsets.only(top: 20),
                                            padding: EdgeInsets.only(left: 10),
                                            width: 200,
                                            decoration:  new BoxDecoration(
                                                color: Color(0xFF757575),
                                                border: Border.all(color:Color.fromRGBO(246,242,199, 1.0),),
                                                borderRadius: BorderRadius.all(Radius.circular(15.0))
                                            ),
                                            child: DropdownButton(
                                              value: _currentlan,
                                              items: _dropDownMenuItems,
                                              onChanged: changedDropDownItem,
                                              hint: Text("Select Branch"),
                                              style: TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.normal),
                                              isExpanded: true,
                                              elevation: 12,
                                              iconSize: 42,
                                            )
                                        ),

                                        Container(
                                            margin: EdgeInsets.only(top: 20),
                                            padding: EdgeInsets.only(left: 10),
                                            width: 200,
                                            decoration:  new BoxDecoration(
                                                color: Color(0xFF757575),
                                                border: Border.all(color:Color.fromRGBO(246,242,199, 1.0),),
                                                borderRadius: BorderRadius.all(Radius.circular(15.0))
                                            ),
                                            child: DropdownButton(
                                              value: _currentlan2,
                                              items: _dropDownMenuItems2,
                                              onChanged: changedDropDownItem2,
                                              hint: Text("Select A/C type"),
                                              style: TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.normal),
                                              isExpanded: true,
                                              elevation: 12,
                                              iconSize: 42,
                                            )
                                        ),



                                        Container(
                                            padding: EdgeInsets.only(top: 10),
                                            width: 200,
                                            child: TextFormField(
                                              controller: balance,
                                              //cursorColor: Color(0xFFA86E52),
                                              validator: (val) => val.length==0? 'Enter Balance' : null,
                                              keyboardType: TextInputType.number,
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
                                                  hintText: "Initial Balance",
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
                                              color:Color(0xFFbf2b46),
                                              textColor: Colors.white,

                                              child: new Text("ADD",style: TextStyle(fontSize: 14)),
                                              shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(15.0))
                                          ),)

                                      ],


                                    ))))),
                  ]),


            ));



  }

  void changedDropDownItem(String selectedCity) {
    setState(() {
      _currentlan = selectedCity;
      lan=_currentlan;

    });
  }

  void changedDropDownItem2(String selectedCity) {
    setState(() {
      _currentlan2 = selectedCity;
      lan2=_currentlan2;

    });
  }
  Dialog createLoadinDialog() {
    return  Dialog(
        backgroundColor: Colors.white30,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0),
        ),
        //this right here
        child: Container(
            height: 100.0,
            width: 100,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[

                Center(
                  child: CircularProgressIndicator(),
                )
              ],
            ))

    );
  }

  void registerPage() async {
    var uuid = new Uuid();
    final FormState form = _formKey.currentState;
    //final key = 'my32lengthsupersecretnooneknowsl';
    final key = 'private!!!!!!!!!';
    final iv = '8bytesiv';

    final encrypter =new Encrypter(new Salsa20(key, iv));


    showDialog(context: context, builder: (BuildContext context) => createLoadinDialog());

    var rng = new Random();
    String account ="";
   for(int i=0;i<10;i++){
     account+=rng.nextInt(10).toString();
   }
      print(account);
    final encryptedname = encrypter.encrypt(name.text);
    final encryptedPhone = encrypter.encrypt(phone.text);
    final encryptedAccount = encrypter.encrypt(account);
    final encryptedBalance = encrypter.encrypt(balance.text);
    final encryptedType = encrypter.encrypt(lan2);
    final encryptedbranch = encrypter.encrypt(lan);

    if(form.validate()){
      DatabaseReference db = FirebaseDatabase.instance.reference();
      await db.child("account_details").child(uuid.v1()).set({
        'Name':encryptedname,
        'Phone_no': encryptedPhone,
        'Account_no': encryptedAccount,
        'Balance': encryptedBalance,
        'Branch':encryptedbranch,
        'Type':encryptedType,
        'netBanking':false
      });
      Navigator.pop(context);
      showDialog(context: context, builder: (BuildContext context) => createDialog(account));


    }else{
      showMessage('Data entered is not correct',Colors.red);
    }





  }

  Dialog createDialog(String account) {
    return  Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0),
      ),
      //this right here
      child: Container(
        height: 300.0,
        width: 400.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

            Container(
                alignment: Alignment.center,
                padding: EdgeInsets.only(left: 25, right: 25, top: 15,),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("Information",style: TextStyle(fontSize: 28,)),
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


                    Text("Mr/Miss "+name.text+" your account is created at "+lan+" branch. Your account number is "+account,style: TextStyle(fontSize: 18),),
                  ],
                )
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[

                Container(
                  width: 150,
                  height: 70,
                  padding: EdgeInsets.only(top: 20),
                  margin: EdgeInsets.only(bottom: 20),
                  child: RaisedButton(onPressed: onYesPressed,
                    elevation: 0.0,
                    textColor: Colors.white,
                    color:Color(0xFFbf2b46), shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(15.0)),
                    child: new Text("Dismiss", style: TextStyle(fontSize: 18)),
                  ),),


              ],)
          ],
        ),
      ),
    );
  }


  void onYesPressed(){Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) =>dashboard()),
  );}
}
