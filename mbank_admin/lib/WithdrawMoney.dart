import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';
import 'package:encrypt/encrypt.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mbank_admin/DashboardPage.dart';
import 'package:firebase_auth/firebase_auth.dart';


class WithdrawMoney extends StatefulWidget{
  WithdrawMoney({Key key}) : super(key: key);

  @override
  _WithdrawMoney createState() => new _WithdrawMoney();

}

class _WithdrawMoney extends State<WithdrawMoney> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  bool otpfieldEnbled =false;
  String dialogText;
  String keyUpdate;
  TextEditingController accountno= new TextEditingController();
  TextEditingController balance= new TextEditingController();
  TextEditingController deposited= new TextEditingController();
  TextEditingController otpController = new TextEditingController();

  List _lan = ["Aburoad","Ahmedabad","Banglore","Mumbai"];

  List<DropdownMenuItem<String>> _dropDownMenuItems;
  String _currentlan;

  String buttonText= "Send otp";

  String lan;
  String branch;
  String currentBalance;
  String phoneNoforOtp;
  @override
  void initState() {
    _dropDownMenuItems = getDropDownMenuItems();
    super.initState();
  }

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

  void cancel(){
    Navigator.pop(context);
  }

  Future<void> checkingForInfo() async {
    setState(() {
      dialogText = "Checking account info from the server";
    });

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
        var y = encrypter.decrypt(data[key]['Branch']);
        if(x == accountno.text && y == _currentlan){
          keyUpdate =key ;
          currentBalance = encrypter.decrypt(data[key]['Balance']);
          phoneNoforOtp = "+91"+encrypter.decrypt(data[key]['Phone_no']);
        }
      }});
  }


  Dialog createDialog() {
    return  Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0),
      ),
      //this right here
      child: Container(
        height: 180.0,
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
                    Text(dialogText,style: TextStyle(fontSize: 21),),

                    Padding(padding: EdgeInsets.only(top: 20),),
                    Center(child: CircularProgressIndicator(),),

                    Padding(padding: EdgeInsets.only(bottom: 20),),
                  ],
                )
            ),
          ],
        ),
      ),
    );
  }

  void onDismiss(){
   Navigator.pop(context);
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

  String verificationId;
  bool otpVerification =false;

  Future<void> verifyPhone() async {


    final PhoneCodeAutoRetrievalTimeout autoRetrieve = (String verId) {
      this.verificationId = verId;
      Future.delayed(Duration(seconds: 2),(){});
      setState(() {
        dialogText = "Automatic verfying otp...";
      });

    };

    final PhoneCodeSent smsCodeSent = (String verId, [int forceCodeResend]) {
      this.verificationId = verId;
      showMessage("Otp is sent to your registered phone no. Please enter otp", Colors.blue);
      Future.delayed(Duration(seconds: 2),(){});
      print("sending");
    };

    final PhoneVerificationCompleted verifiedSuccess = (FirebaseUser user) {
      setState(() {
        otpVerification=true;
      });
      showMessage("Otp verfication is successfull", Colors.green);
      Future.delayed(Duration(seconds: 2),(){});
      onDismiss();
    };

    final PhoneVerificationFailed veriFailed = (AuthException exception) {
      print('${exception.message}');
      showMessage("Otp verfication failed.", Colors.red);
      Future.delayed(Duration(seconds: 2),(){});
    };

    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: this.phoneNoforOtp,
        codeAutoRetrievalTimeout: autoRetrieve,
        codeSent: smsCodeSent,
        timeout: const Duration(seconds: 5),
        verificationCompleted: verifiedSuccess,
        verificationFailed: veriFailed);
  }


  Future<bool> sendingOtp() async{

   if(accountno.text.length==0 && balance.text.length==0){
     showMessage("Please fill all the details", Colors.red);
    }
    else {
     showDialog(context: context, builder: (BuildContext context) => createDialog());
   }
    await checkingForInfo();
    if(keyUpdate==null){
      onDismiss();
      showMessage("Please check account no and branch!!!!!", Colors.red);
    }else{
      await verifyPhone();

      Future.delayed(Duration(seconds: 2),);

      if(otpVerification){

        showMessage("Opt verfication complete", Colors.green);
          return true;
      }
      else{
        showMessage("Opt verfication failes", Colors.red);
        setState(() {
        buttonText = "Verify";
        otpfieldEnbled=true;
        });

        Future.delayed(Duration(seconds: 2),);
        onDismiss();
      }
    }
    return false;
  }

 Future<void> verifyotp() async{
   showMessage("Verifying....", Colors.blue);
   try {
     FirebaseUser user;
     final AuthCredential credential = PhoneAuthProvider.getCredential(
       verificationId: verificationId,
       smsCode: otpController.text,
     );
     user = await FirebaseAuth.instance.signInWithCredential(credential);
     if(user!=null){ setState(() {
       otpVerification =true;
     });
     showMessage("Opt verfication complete", Colors.green);

     }else{showMessage("Opt verfication failed", Colors.red);}
   } catch (e) {
     print(e.message);
   }
 }

  @override
  Widget build(BuildContext context) {

    return new Scaffold(
        key: _scaffoldKey,
        backgroundColor:Colors.black,

        appBar: AppBar(
          title: Text("Withdraw Money",style: TextStyle(color: Colors.white),),
          backgroundColor:  Color(0xFFbf2b46),
          elevation: 0.0,),


        body: SingleChildScrollView(child:
        Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,

            children: <Widget>[

              Container(
                margin: EdgeInsets.only(top: 40)
                ,child: new Row(
                children: <Widget>[
                  Expanded(
                      child: Text("",textAlign: TextAlign.center,style:TextStyle(fontSize: 30,color: Colors.white,fontFamily:'mukta'),)
                  )
                ],),),

              Container(

                  child:  new Container(
                      margin: EdgeInsets.only(top: 20),
                      width: 300,
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
                                      width: 250,
                                      child: TextFormField(
                                        style: TextStyle(color: Colors.white),
                                        controller: accountno,
                                        //cursorColor: Color(0xFFA86E52),
                                        keyboardType: TextInputType.number,
                                        decoration: new InputDecoration(
                                            focusedBorder: new OutlineInputBorder(
                                              borderSide: new BorderSide(color: Color(0xFFA86E52)),
                                              borderRadius: const BorderRadius.all(const Radius.circular(15.0),),
                                            ),
                                            border: new OutlineInputBorder(
                                              borderSide: new BorderSide(color: Color.fromRGBO(246, 242, 199, 1.0)),
                                              borderRadius: const BorderRadius.all(const Radius.circular(15.0),),
                                            ),
                                            filled: true,
                                            hintStyle: new TextStyle(color: Colors.white),
                                            hintText: "Enter Account no",
                                            fillColor: Color(0xFF757575)),
                                      )
                                  ),



                                  Container(
                                      margin: EdgeInsets.only(top: 20),
                                      padding: EdgeInsets.only(left: 10),
                                      width: 250,
                                      decoration:  new BoxDecoration(
                                          color: Color(0xFF757575),
                                          border: Border.all(color:Color.fromRGBO(246,242,199, 1.0),),
                                          borderRadius: BorderRadius.all(Radius.circular(15.0))
                                      ),
                                      child: DropdownButton(
                                        hint: Text("Select Branch"),
                                        value: _currentlan,
                                        items: _dropDownMenuItems,
                                        onChanged: changedDropDownItem,
                                        style: TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.normal),
                                        isExpanded: true,
                                        elevation: 12,
                                        iconSize: 42,
                                      )
                                  ),

                                  Container(
                                      padding: EdgeInsets.only(top: 20),
                                      width: 250,
                                      child: TextFormField(
                                        controller:balance,style: TextStyle(color: Colors.white),
                                        keyboardType: TextInputType.number,
                                        //cursorColor: Color(0xFFA86E52),
                                        decoration: new InputDecoration(
                                            focusedBorder: new OutlineInputBorder(
                                              borderSide: new BorderSide(color: Color(0xFFA86E52)),
                                              borderRadius: const BorderRadius.all(const Radius.circular(15.0),),
                                            ),
                                            border: new OutlineInputBorder(
                                              borderSide: new BorderSide(color: Color.fromRGBO(246, 242, 199, 1.0)),
                                              borderRadius: const BorderRadius.all(const Radius.circular(15.0),),
                                            ),
                                            filled: true,
                                            hintStyle: new TextStyle(color: Colors.white),
                                            hintText: "Amount",
                                            fillColor: Color(0xFF757575)),
                                      )
                                  ),

                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Container(
                                          padding: EdgeInsets.only(top: 20),
                                          width: 150,
                                          child: otpfieldEnbled?TextFormField(
                                            controller:otpController,style: TextStyle(color: Colors.white),
                                            keyboardType: TextInputType.number,
                                            //cursorColor: Color(0xFFA86E52),
                                            decoration: new InputDecoration(
                                            disabledBorder:new OutlineInputBorder(
                                              borderSide: new BorderSide(color: Colors.black),
                                              borderRadius: const BorderRadius.all(const Radius.circular(15.0),),
                                            ) ,
                                                focusedBorder: new OutlineInputBorder(
                                                  borderSide: new BorderSide(color: Color(0xFFA86E52)),
                                                  borderRadius: const BorderRadius.all(const Radius.circular(15.0),),
                                                ),
                                                border: new OutlineInputBorder(
                                                  borderSide: new BorderSide(color: Color.fromRGBO(246, 242, 199, 1.0)),
                                                  borderRadius: const BorderRadius.all(const Radius.circular(15.0),),
                                                ),
                                                filled: true,
                                                hintStyle: new TextStyle(color: Colors.white),
                                                hintText: "Enter otp here",
                                                fillColor: Color(0xFF757575)
                                            ),
                                          ):TextFormField(
                                            controller:otpController,style: TextStyle(color: Colors.white),
                                            enabled: false,
                                            keyboardType: TextInputType.number,
                                            //cursorColor: Color(0xFFA86E52),
                                            decoration: new InputDecoration(

                                                focusedBorder: new OutlineInputBorder(
                                                  borderSide: new BorderSide(color: Color(0xFFA86E52)),
                                                  borderRadius: const BorderRadius.all(const Radius.circular(15.0),),
                                                ),
                                                border: new OutlineInputBorder(
                                                  borderSide: new BorderSide(color: Color.fromRGBO(246, 242, 199, 1.0)),
                                                  borderRadius: const BorderRadius.all(const Radius.circular(15.0),),
                                                ),
                                                filled: true,
                                                hintStyle: new TextStyle(color: Colors.black12),
                                                hintText: "Enter  here",
                                                fillColor: Colors.black54
                                            ),
                                          )


                                      ),

                                      Container(
                                        width: 90,
                                          height: 70,
                                          margin: EdgeInsets.only(left: 10),
                                          padding: EdgeInsets.only(top: 20,),
                                          child: RaisedButton(onPressed: buttonText=="Verify"?verifyotp:sendingOtp,
                                            elevation: 0.0,
                                            color: Colors.redAccent,
                                            textColor: Colors.white,
                                              child: new Text(buttonText,style: TextStyle(fontSize: 14)),
                                              shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(15.0))
                                          )
                                      ),
                                    ],
                                  ),

                                  Container(
                                    width: 150,
                                    height: 70,
                                    padding: EdgeInsets.only(top: 20),
                                    margin: EdgeInsets.only(bottom: 20),
                                    child: !otpVerification?RaisedButton(onPressed:null,

                                        elevation: 0.0,
                                        color: Colors.black12,
                                        textColor: Colors.white,
                                        child: new Text("Withdraw",style: TextStyle(fontSize: 14)),
                                        shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(15.0))
                                    ) : RaisedButton(onPressed: createTrans,

                                        elevation: 0.0,
                                        color: Colors.redAccent,
                                        textColor: Colors.white,
                                        child: new Text("Withdraw",style: TextStyle(fontSize: 14)),
                                        shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(15.0))
                                    ),)

                                ],


                              ))))),
            ]),


        ) );



  }

  void changedDropDownItem(String selectedCity) {
    setState(() {
      _currentlan = selectedCity;
      lan=_currentlan;
      print(lan);
    });
  }
  void showMessage(String message, MaterialColor color) {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(backgroundColor: color, content: new Text(message)));
  }

  Dialog createDialogError() {
    return  Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0),
        ),
        //this right here
        child: Container(
            margin: EdgeInsets.all(16.0),
            height: 150.0,
            width: 100,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[

                Center(
                  child: Text("You don't have sufficient to withdraw. kindly try again with amount smaller then available balance",style: TextStyle(fontSize: 16),),
                ),
                Center(
                  child: RaisedButton(
                      child: Text("Dismiss"),
                      color: Colors.redAccent,
                      textColor: Colors.white,
                      onPressed: (){
                        Navigator.pop(context); Navigator.pop(context);
                      }

                  ),
                )

              ],
            ))

    );
  }
  void createTrans() async{
    var uuid = new Uuid();
    final key = 'private!!!!!!!!!';
    final iv = '8bytesiv';
    int newBalance;

    final encrypter =new Encrypter(new Salsa20(key, iv));
    showDialog(context: context, builder: (BuildContext context) => createLoadinDialog());
    await checkingForInfo();

    Future.delayed(Duration(seconds: 5), );

    if(keyUpdate!=null) {

      if (int.parse(currentBalance) < int.parse(balance.text)) {
        Navigator.pop(context);
        showDialog(context: context, builder: (BuildContext context) => createLoadinDialog());
        
        setState(() {
          otpVerification=false;
          buttonText="Send otp";
          otpController.clear();
          otpfieldEnbled=false;
        });

      }
      else {
        newBalance = int.parse(currentBalance) - int.parse(balance.text);
        currentBalance = newBalance.toString();

        String uid = uuid.v1();

        print("Balance" + newBalance.toString());
        print("Time" + DateTime.now().toString());

        DatabaseReference db = FirebaseDatabase.instance.reference();

        await db.child("Transaction_Details").child(accountno.text)
            .child(uid)
            .set({
          "Uid": uid,
          "Transaction_amount": balance.text,
          "Type":"Debit",
          "Current_Balance": newBalance,
          "Time": DateTime.now().toString(),
        });

        await db.child('account_details').child(keyUpdate).update(
            {"Balance": encrypter.encrypt(newBalance.toString())});

        Future.delayed(Duration(seconds: 2),);
        Navigator.pop(context);
        showDialog(context: context, builder: (BuildContext context) => createSuccessDialog(accountno.text));
      }
  }
  }


  Dialog createSuccessDialog(String account) {
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


                    Text("₹ "+balance.text+" has been successfully added to the account no "+account,style: TextStyle(fontSize: 18),),
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
                  child: RaisedButton(onPressed:(){Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) =>dashboard()),
                  );},
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

  @override
  void dispose() {
    // TODO: implement dispose
    balance.clear();
    accountno.clear();
    deposited.clear();
    super.dispose();
  }

}
