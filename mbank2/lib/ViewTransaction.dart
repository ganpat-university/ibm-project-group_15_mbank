import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:mbank2/controller/CustomerClass.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:encrypt/encrypt.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mbank2/globals.dart';
import 'package:intl/intl.dart';


class ViewTransaction extends StatefulWidget{
  FirebaseUser user;
  ViewTransaction({Key key,this.user}) : super(key: key,);

  @override
  _ViewTransaction createState() => new _ViewTransaction();
}

class _ViewTransaction extends State<ViewTransaction>{


  @override
  void initState() {
    super.initState();
    collectinDataForTransaction();
  }
  var formatter = new DateFormat.yMd();
  var formatter2 = new DateFormat("h:mm a");

  Dialog createLoadingDialog() {
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
                ),

              ],
            ))

    );
  }

  Future<void> collectinDataForTransaction() async{
   // showDialog(context: context, builder: (BuildContext context) => createLoadingDialog());
    data.clear();
    // List<CustomerClass> dataObj=[];
    final key = 'private!!!!!!!!!';
    final iv = '8bytesiv';

    final encrypter =new Encrypter(new Salsa20(key, iv));
    DatabaseReference db = FirebaseDatabase.instance.reference();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String accountNo = prefs.getString('account');

    List<String> keyList =[];
    await db.child('Transaction_Details').child(accountNo).once().then((DataSnapshot snapshot){
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
    CustomerClass obj;


    for (int i=0;i<keyList.length;i++) {
      List<String> dd = [];

      await db.child('Transaction_Details').child(accountNo)
          .child(keyList[i])
          .once()
          .then((DataSnapshot snapshot) {
        var keys = snapshot.value.keys;
        var data = snapshot.value;

         obj = CustomerClass(time: DateTime.parse(data["Time"]), type: data["Type"], currentBal: data["Current_Balance"].toString(), amount: data["Transaction_amount"], uid: data["Uid"]);

      });
      setState(() {
        data.add(obj);
      });
    }

    // return dataObj;
  }

  @override
  Widget build(BuildContext context) {
    data.sort((a, b) => a.time.compareTo(b.time));
    return new Scaffold(
        backgroundColor: Colors.white,

      appBar: AppBar(
      title: Text("View Transaction",style: TextStyle(color: Colors.white),),
      backgroundColor: Color(0xFFbf2b46),
      elevation: 3.0,
      actions: <Widget>[
      ],
     ),

      body:
      Column(
        mainAxisSize: MainAxisSize.max,

        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 15),
          ),

          Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 10),
              ),
              Expanded(
                flex:1,
                child: Text("Date"),
              ),

              Expanded( flex:2,
                child: Text("UID"),
              ),

              Expanded(child: Text("Debit/Credit"),
                flex:1,
              ),

              Expanded( flex:1,
                child: Text("Current Balance"),
              ),

            ],
          )
          ,
          Padding(
            padding: EdgeInsets.only(top: 5),
          ),

          Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  height: 2,
                  color: Color(0xFF1ea3d8),
                ),
              )
            ],
          ),

          Padding(
            padding: EdgeInsets.only(top: 15),
          ),

          Expanded(

            child: new ListView.builder(
                itemCount: data.length,
                physics: BouncingScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: ( context, int index) {
                  return Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(left: 10),
                          ),
                          Expanded(
                              flex:1,
                              child: Column(
                                children: <Widget>[
                                  Text(formatter.format(data[index].time) ,),
                                  Text(formatter2.format(data[index].time) ),
                                ],
                              )
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 10),
                          ),
                          Expanded( flex:2,
                            child: Text(data[index].uid.substring(1,20)),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 5),
                          ),
                          Expanded(child: Text(data[index].amount,style:  TextStyle(color: data[index].type=="Debit"?Colors.redAccent:Colors.green),),
                            flex:1,
                          ),

                          Expanded( flex:1,
                            child: Text(data[index].currentBal),
                          ),


                        ],
                      ),

                      Padding(
                        padding: EdgeInsets.only(top: 10),
                      ),

                      Row(
                        children: <Widget>[
                          Expanded(
                              child:Container(
                                height:1,
                                margin: EdgeInsets.only(left: 15,right:15),
                                color: Colors.black26,
                              ))
                        ],
                      ),

                      Padding(
                        padding: EdgeInsets.only(left: 15,right: 10,top: 10),
                      ),
                    ],
                  );


                }
            ,),
          )


        ],

      )
     );
  }




}


