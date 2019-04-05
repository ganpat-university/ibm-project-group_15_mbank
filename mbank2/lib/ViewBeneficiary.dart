import 'package:flutter/material.dart';
import 'package:mbank2/controller/BeneficiaryClass.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mbank2/controller/CustomerClass.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:encrypt/encrypt.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mbank2/globals.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import 'package:mbank2/ViewBeneficiary.dart';


class ViewBeneficiary extends StatefulWidget{
  FirebaseUser user;
  ViewBeneficiary({Key key,this.user}) : super(key: key,);

  @override
  _ViewBeneficiary createState() => new _ViewBeneficiary();
}

class _ViewBeneficiary extends State<ViewBeneficiary>{

List<Beneficiary> data=[];
String keyUpdateLocal;
int indexDelete;
  @override
  void initState() {
    super.initState();
    collectinDataForTransaction();

  }


  var formatter = new DateFormat.yMd();
  var formatter2 = new DateFormat("h:mm a");

 TextEditingController account = new TextEditingController();
 TextEditingController name = new TextEditingController();
 TextEditingController limit = new TextEditingController();

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
      if(x == account.text){
        keyUpdateLocal =key ;
      }
    }});
 }

  void addData() async{
    var uuid = new Uuid();
    final key = 'private!!!!!!!!!';
    final iv = '8bytesiv';

    String uid = uuid.v1();
    final encrypter =new Encrypter(new Salsa20(key, iv));

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String accountNo = prefs.getString('account');

    showDialog(context: context, builder: (BuildContext context) => createLoadinDialog());

    await checkingForInfo();
    Future.delayed(Duration(seconds: 5), );

    if(keyUpdateLocal!=null) {

      DatabaseReference db = FirebaseDatabase.instance.reference();

      await db.child("Beneficiary_details").child(accountNo).child(uid).set({
        "Uid": encrypter.encrypt(uid),
        "Name": encrypter.encrypt(name.text),
        "Account_no":encrypter.encrypt(account.text),
        "Limit":encrypter.encrypt(limit.text)
      });
      Navigator.pop(context);
      Navigator.pop(context);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ViewBeneficiary()));
    }

    else{
      Navigator.pop(context);
      showDialog(context: context, builder: (BuildContext context) => createDialogError());

    }
  }

  void add_beneficiary(){
   showDialog(context: context, builder: (BuildContext context) => createDialog());
 }

  Dialog createDialog() {
  return  Dialog(
    backgroundColor: Colors.white,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0),
    ),
    //this right here
    child: SingleChildScrollView(child:
    Container(
      height: 400.0,
      width: 350.0,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[

          Padding(padding: EdgeInsets.only(top: 20),),
          Container(
            child: Text("Add Beneficiary",style: TextStyle(fontSize: 20),),
          ),


          Row(
            children: <Widget>[
              Expanded(
                  child:Container(
                    height:1,
                    margin: EdgeInsets.only(top: 5,left: 15,right:15),
                    color: Color(0xFF1ea3d8),
                  ))
            ],
          ),
          Container(
              alignment: Alignment.center,
              padding: EdgeInsets.only(left: 25, right: 25, top: 25,),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[

                  Container(
                    child: TextFormField(

                  controller: name,
                  //cursorColor: Color(0xFFA86E52),

                  validator: (val) => val.isEmpty ? 'Name is required' : null,
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
                      hintText: "Account holder name",
                      fillColor: Color(0xFF757575)
                  ),
                  )),

                  Padding(padding: EdgeInsets.only(top: 10),),
                  Container(
                      child: TextFormField(
                        controller: account,
                        keyboardType: TextInputType.number,
                        //cursorColor: Color(0xFFA86E52),
                        validator: (val) => val.isEmpty ? 'Account is required' : null,
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
                            hintText: "Account number",
                            fillColor: Color(0xFF757575)
                        ),
                      )),

                  Padding(padding: EdgeInsets.only(top: 10),),
                  Container(
                      child: TextFormField(
                        controller: limit,
                        keyboardType: TextInputType.number,
                        //cursorColor: Color(0xFFA86E52),
                        validator: (val) => val.isEmpty ? 'Limit is required' : null,
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
                            hintText: "Limit",
                            fillColor: Color(0xFF757575)
                        ),
                      )),


                  Padding(padding: EdgeInsets.only(bottom: 20),),

                  Row(
                    children: <Widget>[

                      Container(
                        width: 105,
                        height: 45,
                        child: RaisedButton(onPressed: addData,
                            elevation: 0.0,
                            color: Color(0xFFbf2b46),
                            textColor: Colors.white,
                            child: new Text("Add",style: TextStyle(fontSize: 12)),
                            shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(15.0))
                        ),
                      ),

                      Padding(padding: EdgeInsets.only(left: 20),),

                      Container(
                        width: 105,
                        height: 45,
                        child:RaisedButton(onPressed: (){ Navigator.pop(context);},
                            elevation: 0.0,
                            color:  Color(0xFFbf2b46),
                            textColor: Colors.white,
                            child: new Text("Dismiss",style: TextStyle(fontSize: 12)),
                            shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(15.0))
                        ),
                      )


                    ],
                  )


                ],
              )
          ),
        ],
      ),
    ),
  )
  );
}

  @override
  Widget build(BuildContext context) {
    //data.sort((a, b) => a.time.compareTo(b.time));
    return new Scaffold(
        backgroundColor: Colors.white,

        appBar: AppBar(
          title: Text("Add/Manage Beneficiary",style: TextStyle(color: Colors.white),),
          backgroundColor: Color(0xFFbf2b46),
          elevation: 3.0,
          actions: <Widget>[
          ],
        ),

        floatingActionButton: FloatingActionButton(
          onPressed: add_beneficiary,
          tooltip: 'Add',
          backgroundColor:  Color(0xFFbf2b46),

          child: Icon(Icons.add,),
        ),


        body:
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 8,top: 8),
            ),

            Expanded(

              child: new ListView.builder(
                itemCount: data.length,
                physics: BouncingScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: ( context, int index) {
                  return Card(
                    color: Colors.white,
                    elevation: 4.0,
                    child:Row(
                      children: <Widget>[

                        Container( alignment: Alignment.centerLeft,
                          child:   Column(

                            children: <Widget>[
                              Padding(padding: EdgeInsets.only(top: 8),),
                              Row(
                                children: <Widget>[

                                  Padding(padding: EdgeInsets.only(left: 8),),
                                  Text("Name : "+data[index].name,style: TextStyle(fontSize: 16),textAlign: TextAlign.start,),
                                ],
                              ),

                              Padding(padding: EdgeInsets.only(top: 4),),
                              Row(
                                children: <Widget>[Padding(padding: EdgeInsets.only(left: 8),),
                                Text("Account no : "+data[index].account_no,style: TextStyle(fontSize: 16),textAlign: TextAlign.start),
                                ],
                              ),

                              Padding(padding: EdgeInsets.only(top: 4),),
                              Row(
                                children: <Widget>[Padding(padding: EdgeInsets.only(left: 8),),
                                Text("Limit : "+data[index].limit,style: TextStyle(fontSize: 16),textAlign: TextAlign.start),
                                ],
                              ),
                              Padding(padding: EdgeInsets.only(bottom: 8),),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Container(
                            child:Text("")
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(right: 8.0),
                          alignment: Alignment.centerRight,
                          child:GestureDetector(
                            onTap: (){
                           indexDelete = index;
                           showDialog(context: context, builder: (BuildContext context) => createDeleteDialog());
                            },
                            child:  Image.asset("assests/remove.png",color: Colors.red,width: 30,height: 30,),
                          )
                        )
                         ]
                    ) );
                }
                ,),
            )


          ],

        )
    );
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

Dialog createDialogError() {
  return  Dialog(
      backgroundColor: Colors.white,
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
                child: Text("Account Details does not exists",style: TextStyle(fontSize: 18),),
              ),
              Center(
                child: RaisedButton(
                  child: Text("Dismiss"),
                    color: Colors.redAccent,
                    textColor: Colors.white,
                    onPressed: (){Navigator.pop(context);}

                ),
              )

            ],
          ))

  );
}

Dialog createDialogSuccess() {
  return  Dialog(
      backgroundColor: Colors.white,
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
                child: Text("Successfully Deleted",style: TextStyle(fontSize: 22),),
              ),
              Center(
                child: RaisedButton(
                    child: Text("Dismiss"),
                    color: Colors.redAccent,
                    textColor: Colors.white,
                    onPressed: (){Navigator.pop(context);}

                ),
              )

            ],
          ))

  );
}

Dialog createDeleteDialog() {
  return  Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0),
      ),
      //this right here
      child: Container(
          height: 380.0,
          width: 350,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top:8),
              ),
              Center(
                child: Text("Delete Beneficiary",style: TextStyle(fontSize: 22),),
              ),
              Padding(
                padding: EdgeInsets.only(top:8),
              ),
              Row(
                children: <Widget>[
                  Expanded(
                      child:Container(
                        height:2,
                        margin: EdgeInsets.only(left: 15,right:15),
                        color: Color(0xFF1ea3d8),
                      ))
                ],
              ),
              Padding(
                padding: EdgeInsets.only(top:8),
              ),
              Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.only(left: 25, right: 25, top: 25,),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[

                      Container(
                          child: TextFormField(

                            controller: name,
                            //cursorColor: Color(0xFFA86E52),
                          enabled: false,
                            validator: (val) => val.isEmpty ? 'Name is required' : null,
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
                                labelText: data[indexDelete].name,
                                labelStyle: TextStyle(color: Colors.white),
                                fillColor: Color(0xFF757575)
                            ),
                          )),

                      Padding(padding: EdgeInsets.only(top: 10),),
                      Container(
                          child: TextFormField(

                            controller: account, enabled: false,
                            keyboardType: TextInputType.number,
                            //cursorColor: Color(0xFFA86E52),
                            validator: (val) => val.isEmpty ? 'Account is required' : null,
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
                                labelText: data[indexDelete].account_no, labelStyle: TextStyle(color: Colors.white),
                                fillColor: Color(0xFF757575)
                            ),
                          )
                      ),

                      Padding(padding: EdgeInsets.only(top: 10),),
                      Container(
                          child: TextFormField(
                            controller: limit, enabled: false,
                            keyboardType: TextInputType.number,
                            //cursorColor: Color(0xFFA86E52),
                            validator: (val) => val.isEmpty ? 'Limit is required' : null,
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
                                labelText: data[indexDelete].limit, labelStyle: TextStyle(color: Colors.white),
                                fillColor: Color(0xFF757575)
                            ),
                          )),


                      Padding(padding: EdgeInsets.only(bottom: 20),),

                      Row(
                        children: <Widget>[

                          Container(
                            width: 105,
                            height: 45,
                            child: RaisedButton(onPressed:deleteBeneficiary,
                                elevation: 0.0,
                                color: Color(0xFFbf2b46),
                                textColor: Colors.white,
                                child: new Text("Delete",style: TextStyle(fontSize: 12)),
                                shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(15.0))
                            ),
                          ),

                          Padding(padding: EdgeInsets.only(left: 20),),

                          Container(
                            width: 105,
                            height: 45,
                            child:RaisedButton(onPressed: (){ Navigator.pop(context);},
                                elevation: 0.0,
                                color:  Color(0xFFbf2b46),
                                textColor: Colors.white,
                                child: new Text("Dismiss",style: TextStyle(fontSize: 12)),
                                shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(15.0))
                            ),
                          )


                        ],
                      )


                    ],
                  )
              ),

            ],
          ))

  );
}

void deleteBeneficiary() async{
  showDialog(context: context, builder: (BuildContext context) => createLoadinDialog());

  final key = 'private!!!!!!!!!';
  final iv = '8bytesiv';
  final encrypter =new Encrypter(new Salsa20(key, iv));

  SharedPreferences prefs = await SharedPreferences.getInstance();
  String accountNo = prefs.getString('account');

  DatabaseReference db = FirebaseDatabase.instance.reference();

  String deletingKey;
  List<String> keyList =[];
  await db.child('Beneficiary_details').child(accountNo).once().then((DataSnapshot snapshot){
    var keys = snapshot.value.keys;
    var data = snapshot.value;
    print(keys);
    for (var key in keys) {
      keyList.add(key);
    }
  });

  for (int i=0;i<keyList.length;i++) {
    await db.child('Beneficiary_details').child(accountNo).child(keyList[i]).once().then((DataSnapshot snapshot) {
      var data2 = snapshot.value;
      var accountDD = encrypter.decrypt(data2["Account_no"]);
      if (accountDD == data[indexDelete].account_no){
        deletingKey = keyList[i];
      }
    });
  }
  await db.child('Beneficiary_details').child(accountNo).child(deletingKey).remove();
  data.clear();
  await collectinDataForTransaction();
  Navigator.pop(context);
  Navigator.pop(context);

  showDialog(context: context, builder: (BuildContext context) => createDialogSuccess());

}

Future<void> collectinDataForTransaction() async{

  data.clear();
  // List<CustomerClass> dataObj=[];
  final key = 'private!!!!!!!!!';
  final iv = '8bytesiv';

  final encrypter =new Encrypter(new Salsa20(key, iv));

  SharedPreferences prefs = await SharedPreferences.getInstance();
  String accountNo = prefs.getString('account');

  DatabaseReference db = FirebaseDatabase.instance.reference();

  List<String> keyList =[];
  await db.child('Beneficiary_details').child(accountNo).once().then((DataSnapshot snapshot){
    var keys = snapshot.value.keys;
    var data = snapshot.value;
    print(keys);
    for (var key in keys) {
      keyList.add(key);
    }
  });
  setState(() {
    lengthData = keyList.length;
  });

  for (int i=0;i<keyList.length;i++) {
    List<String> dd = [];

    await db.child('Beneficiary_details').child(accountNo).child(keyList[i]).once().then((DataSnapshot snapshot) {
      var keys = snapshot.value.keys;
      var data = snapshot.value;
      for ( var key1 in keys ) {
        var t1 = data[key1];
        dd.add(encrypter.decrypt(t1.toString()));
      }
    });

    Beneficiary obj = Beneficiary(uid: dd[0],limit: dd[1],account_no: dd[2],name: dd[3]);
    setState(() {
      data.add(obj);
    });
  }
  // return dataObj;
}


}


