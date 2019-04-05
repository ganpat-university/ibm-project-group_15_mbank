import 'package:flutter/material.dart';
import 'dart:io';
import 'package:uuid/uuid.dart';
import 'package:encrypt/encrypt.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
import 'package:mbank_admin/Model/CustomerClass.dart';

class SearchUser extends StatefulWidget{

  SearchUser({Key key}) : super(key: key,);
  @override
  _SearchUser createState() => new _SearchUser();
}

class _SearchUser extends State<SearchUser>{

  List<CustomerClass2> data=[];

 TextEditingController accountNo = new TextEditingController();
 final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
 final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
 bool _autovalidate = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  String balance="";
  String branch,name,phone,type;
  bool netBanking;
  String keyUpdate="";
  int lengthData=0;
 var formatter = new DateFormat.yMd();
 var formatter2 = new DateFormat("h:mm a");


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
       if(x == accountNo.text){

         collectinDataForTransaction();
         setState(() {
           keyUpdate =key ;
         });

         balance = encrypter.decrypt(data[key]['Balance']);
         phone = encrypter.decrypt(data[key]['Phone_no']);
         name= encrypter.decrypt(data[key]['Name']);
         type= encrypter.decrypt(data[key]['Type']);
         branch = encrypter.decrypt(data[key]['Branch']);
         netBanking = (data[key]['netBanking']);
       }
     }
      if(keyUpdate==null){
        setState(() {
          keyUpdate=" ";
          balance=null;
        });

      }
   });
 }

  @override
  void dispose() {
    // TODO: implement dispose
    accountNo.clear();
    super.dispose();
  }

 Future<void> collectinDataForTransaction() async{

    data.clear();
    // List<CustomerClass> dataObj=[];
    final key = 'private!!!!!!!!!';
    final iv = '8bytesiv';

    final encrypter =new Encrypter(new Salsa20(key, iv));
    DatabaseReference db = FirebaseDatabase.instance.reference();

    List<String> keyList =[];
    await db.child('Transaction_Details').child(accountNo.text).once().then((DataSnapshot snapshot){
      var keys = snapshot.value.keys;
      var data = snapshot.value;
      print(keys);
      for (var key in keys) {
        keyList.add(key);
      }
    });

    print("length"+keyList.length.toString());

    setState(() {
      lengthData = keyList.length;
    });

    CustomerClass2 obj;
    for (int i=0;i<keyList.length;i++) {
      List<String> dd = [];

      await db.child('Transaction_Details').child(accountNo.text)
          .child(keyList[i])
          .once()
          .then((DataSnapshot snapshot) {
        var keys = snapshot.value.keys;
        var data = snapshot.value;
        obj = CustomerClass2(time: DateTime.parse(data["Time"]), type: data["Type"], currentBal: data["Current_Balance"].toString(), amount: data["Transaction_amount"], uid: data["Uid"]);

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
      backgroundColor: Colors.black54,
        key: _scaffoldKey,
      appBar:  AppBar(
        title: Text("Search user",style: TextStyle(color: Colors.white),),
        backgroundColor:  Color(0xFFbf2b46),
        elevation: 3.0,
        actions: <Widget>[
        ],
      ),


      body: Column(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[

        Padding(
          padding: EdgeInsets.only(top: 10),
        ),
        Row(
          children: <Widget>[
            Expanded(
              flex: 5,
              child:Container(
                padding: EdgeInsets.all(10),
                height: 60,
                child:Form(
                    key: _formKey,
                    autovalidate: _autovalidate,
                child:
                TextFormField(
                  controller: accountNo,
                  validator: (val) => val.length<10? 'Account no is not correct' : null,
                  style: TextStyle(color: Colors.white),
                  cursorColor: Colors.white,

                  decoration: InputDecoration(
                      focusedBorder: new OutlineInputBorder(borderSide: new BorderSide(color:Colors.white), borderRadius: const BorderRadius.all(const Radius.circular(15.0),),),
                      border: new OutlineInputBorder(borderSide: new BorderSide(color: Colors.white), borderRadius: const BorderRadius.all(const Radius.circular(15.0),),),
                      errorBorder:     new OutlineInputBorder(borderSide: new BorderSide(color: Colors.red), borderRadius: const BorderRadius.all(const Radius.circular(15.0),),),
                      labelStyle: TextStyle(color: Colors.white),
                      prefixIcon: Icon(
                        Icons.search,color: Colors.white,
                        size: 28.0,
                      ),
                      helperStyle: TextStyle(color: Colors.white),
                      hintStyle: TextStyle(color: Colors.white),
                      fillColor: Colors.white,
                      hintText: "Enter Account no"
                  ),
                )
                )
            )),
           Expanded(
               flex: 2,
               child:
            Container(
              height: 62,
              padding: EdgeInsets.only(right: 10,top:10,),
              child: RaisedButton(onPressed: search,
                  elevation: 0.0,
                  shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(15.0)),
                  color: Colors.white,
                  textColor: Colors.black,
                  child:Text("Search")),
            ))


          ],
        ),

        Padding(
          padding: EdgeInsets.only(top: 18),
        ),

        Row(
          children: <Widget>[
            Expanded(
                child:Container(
                  height:1,
                  margin: EdgeInsets.only(left: 15,right:15),
                  color: Colors.white,
                ))
          ],
        ),

        Padding(
          padding: EdgeInsets.only(top: 10),
        ),

        keyUpdate==null?Expanded(child: Center(child: CircularProgressIndicator(backgroundColor: Colors.white,),)):
            keyUpdate.length>2? Column(

              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: 15),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text("Account holder's name : ",style: TextStyle(color: Colors.white70,fontSize: 18),),
                    ),

                    Expanded(
                      flex: 1,
                      child: Text(name,style: TextStyle(color: Colors.white,fontSize: 18),),
                    )
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10),
                ),
                Row(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: 15),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text("Branch : ",style: TextStyle(color: Colors.white70,fontSize: 18),),
                    ),

                    Expanded(
                      flex: 1,
                      child: Text(branch,style: TextStyle(color: Colors.white,fontSize: 18),),
                    ),

                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20),
                ),
                Row(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: 15),
                    ),


                    Expanded(
                      flex: 1,
                      child: Text("Account type : ",style: TextStyle(color: Colors.white70,fontSize: 18),),
                    ),

                    Expanded(
                      flex: 1,
                      child: Text(type,style: TextStyle(color: Colors.white,fontSize: 18),),
                    ),

                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20),
                ),
                Row(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: 15),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text("Phone no : ",style: TextStyle(color: Colors.white70,fontSize: 18),),
                    ),

                    Expanded(
                      flex: 1,
                      child: Text(phone,style: TextStyle(color: Colors.white,fontSize: 18),),
                    ),

                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20),
                ),
                Row(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: 15),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text("NetBanking enabled : ",style: TextStyle(color: Colors.white70,fontSize: 18),),
                    ),

                    Expanded(
                      flex: 1,
                      child: Text(netBanking.toString(),style: TextStyle(color: Colors.white,fontSize: 18),),
                    ),

                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20),
                ),
                Row(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: 15),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text("Current balance : ",style: TextStyle(color: Colors.white70,fontSize: 18),),
                    ),

                    Expanded(
                      flex: 1,
                      child: Text(balance,style: TextStyle(color: Colors.white,fontSize: 18),),
                    )
                  ],
                ),

                Padding(
                  padding: EdgeInsets.only(top: 18),
                ),

                Row(
                  children: <Widget>[
                    Expanded(
                        child:Container(
                          height:1,
                          margin: EdgeInsets.only(left: 15,right:15),
                          color: Colors.white,
                        ))
                  ],
                ),

                Padding(
                  padding: EdgeInsets.only(top: 10),
                ),


                 Column(
                  children: <Widget>[

                    Center(
                      child:Text("Transaction Details",style: TextStyle(fontSize: 18,color: Colors.white70),) ,
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 8),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Center(child:
                        Container(
                            width: 250,
                            alignment: Alignment.center,
                            height: 2,
                            color: Colors.white30,

                        ))
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 5),
                    ),
                    Row(
                      children: <Widget>[

                        Expanded(
                          flex:1,
                          child:Center(child:
                          Text("Date",style: TextStyle(color: Colors.white),),)
                        ),

                        Expanded( flex:2,
                          child: Text("UID",style: TextStyle(color: Colors.white),),
                        ),

                        Expanded(child: Text("Debit/Credit",style: TextStyle(color: Colors.white),),
                          flex:1,
                        ),

                        Expanded( flex:1,
                          child: Text("Current Balance",style: TextStyle(color: Colors.white),),
                        ),

                      ],
                    )
                    ,
                    Padding(
                      padding: EdgeInsets.only(top: 8,left: 15),
                    ),

                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            height: 2,
                            color: Colors.redAccent,
                          ),
                        )
                      ],
                    ),

                    Padding(
                      padding: EdgeInsets.only(top: 10),
                    ),



                    Container(
                      height: 270,
                      child: new ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: data.length,
                        shrinkWrap: true,
                        physics: BouncingScrollPhysics(),
                        itemBuilder: ( context, int index) {
                          return Column(
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Expanded(
                                      flex:1,
                                      child: Column(
                                        children: <Widget>[
                                          Text(formatter.format(data[index].time) ,style: TextStyle(color: Colors.white),),
                                          Text(formatter2.format(data[index].time) ,style: TextStyle(color: Colors.white),),
                                        ],
                                      )
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 5),
                                  ),
                                  Expanded( flex:2,
                                    child: Text(data[index].uid.substring(1,20),style: TextStyle(color: Colors.white),),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 5),
                                  ),
                                  Expanded(child: Text(data[index].amount,style:  TextStyle(color: data[index].type=="Debit"?Colors.redAccent:Colors.green),),
                                    flex:1,
                                  ),

                                  Expanded( flex:1,
                                    child: Text(data[index].currentBal,style: TextStyle(color: Colors.white),),
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
                                        color: Colors.white,
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


              ],)
                :balance==null?

            Expanded(child: Center(child:  Text("Data not found",style: TextStyle(color: Colors.white,fontSize: 36)),),)
                :Center(child: Text("",style: TextStyle(color: Colors.white,fontSize: 36),),)

      ],
    ));

  }


  void search() async{
   setState(() {
     keyUpdate=null;
   });
   _autovalidate=true;
   await checkingForInfo();



  }


 void showMessage(String message, [MaterialColor color = Colors.red]) {
   _scaffoldKey.currentState.showSnackBar(new SnackBar(backgroundColor: color, content: new Text(message)));
 }

}