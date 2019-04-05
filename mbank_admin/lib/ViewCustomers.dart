import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mbank_admin/Model/CustomerClass.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:encrypt/encrypt.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mbank_admin/Model/globals.dart';






class ViewCustomers extends StatefulWidget{
  ViewCustomers({Key key}) : super(key: key,);
  @override
  _ViewCustomers createState() => new _ViewCustomers();
}

class _ViewCustomers extends State<ViewCustomers>{


  @override
  void initState() {
    super.initState();
    setState(() {
      collectingDataForView();
    });


    Future.delayed(Duration(seconds: 2),
        (){print(dataList.length);}
    );

  }


  Future<void> collectingDataForView() async{
    final key = 'private!!!!!!!!!';
    final iv = '8bytesiv';
    final encrypter =new Encrypter(new Salsa20(key, iv));

    DatabaseReference db = FirebaseDatabase.instance.reference();
    await db.child("account_details").once().then((DataSnapshot snapshot){

      var keys = snapshot.value.keys;
      var data = snapshot.value;
      for (var key in keys) {
        var x1 = encrypter.decrypt(data[key]['Account_no']);
        var x2 = encrypter.decrypt(data[key]['Balance']);
        var x3 = encrypter.decrypt(data[key]['Branch']);
        var x4 = encrypter.decrypt(data[key]['Name']);
        var x5 = encrypter.decrypt(data[key]['Phone_no']);
        var x6 = encrypter.decrypt(data[key]['Type']);
        var x7 = data[key]['netBanking'];

    setState(() {
      dataList.add(
          CustomerClass(
              account: x1,balance: x2,branch: x3,name: x4,phone: x5,type: x6,netBank: x7
          )
      );
    });
      }
    });


  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        backgroundColor:Colors.black,

        appBar: AppBar(
          title: Text("View Customers",style: TextStyle(color: Colors.white),),
          backgroundColor: Color(0xFFbf2b46),
          elevation: 0.0,
          actions: <Widget>[
          ],
        ),

        body:dataList.length==null?Center(child: CircularProgressIndicator(),):
        Column(
          mainAxisSize: MainAxisSize.max,

          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 15),
            ),

            Row(
              children: <Widget>[
                Padding(padding: EdgeInsets.only(left: 10),),
                Expanded(
                  flex:1,
                  child: Text("SN",style: TextStyle(color: Colors.white),),
                ),
                Expanded(
                  flex:2,
                  child: Text("Name",style: TextStyle(color: Colors.white),),
                ),

                Expanded( flex:2,
                  child: Text("Account_no",style: TextStyle(color: Colors.white,fontSize: 12),),
                ),

                Expanded(child: Text("Branch",style: TextStyle(color: Colors.white),),
                  flex:2,
                ),

                Expanded( flex:1,
                  child: Text("A/C Type",style: TextStyle(color: Colors.white),),
                ),

                Expanded( flex:2,
                  child: Text("Balance",style: TextStyle(color: Colors.white),),
                ),

                Expanded( flex:1,
                  child: Text("Netbanking",style: TextStyle(color: Colors.white,fontSize: 12),),
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
                    color: Color(0xFFbf2b46),
                  ),
                )
              ],
            ),

            Padding(
              padding: EdgeInsets.only(top: 15),
            ),

            Expanded(

              child: new ListView.builder(
                itemCount: dataList.length,
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
                            child: Text((index+1).toString(),style: TextStyle(color: Colors.white,fontSize: 12),),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 5),
                          ),
                          Expanded(
                            flex:2,
                            child: Text(dataList[index].name,style: TextStyle(color: Colors.white,fontSize: 12),),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 5),
                          ),
                          Expanded( flex:2,
                            child: Text(dataList[index].account,style: TextStyle(color: Colors.white,fontSize: 11),),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 5),
                          ),
                          Expanded(child: Text(dataList[index].branch,style: TextStyle(color: Colors.white,fontSize: 12),),
                            flex:2,
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 5),
                          ),
                          Expanded( flex:1,
                            child: Text(dataList[index].type,style: TextStyle(color: Colors.white,fontSize: 10),),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 5),
                          ),
                          Expanded( flex:2,
                            child: Text(dataList[index].balance,style: TextStyle(color: Colors.white,fontSize: 12),),
                          ),
                          Expanded( flex:1,
                            child: Text(dataList[index].netBank.toString(),style: TextStyle(color: (dataList[index].netBank==true)?Colors.green:Colors.red),),
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: 10),
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
    );
  }

@override
  void dispose() {
    // TODO: implement dispose
  dataList.clear();

    super.dispose();
  }


}


