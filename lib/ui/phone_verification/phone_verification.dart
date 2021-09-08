import 'dart:async';
import 'dart:convert';

import 'package:blood_app/models/constants.dart';
import 'package:blood_app/models/user.dart';
import 'package:blood_app/ui/home/home.dart';
import 'package:blood_app/ui/home/home_viewmodel.dart';
import 'package:blood_app/ui/registration/health_registration.dart';
import 'package:blood_app/util/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';

class PhoneConformation extends StatefulWidget {
  User user;
  bool isLogin;
  PhoneConformation(this.user, this.isLogin);
  @override
  _PhoneConformationState createState() => _PhoneConformationState();
}

class _PhoneConformationState extends State<PhoneConformation> {
  ProgressDialog pr;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  Timer _timer;
  int _start = 59;
  bool _isButtonDisable = true;
  var forceResendingToken;
  String smsCode;
  FirebaseAuth _mAuth;
  String verificationId;

  AuthCredential _credential;


  TextEditingController firstValue = TextEditingController();
  TextEditingController secondValue = TextEditingController();
  TextEditingController thirdValue = TextEditingController();
  TextEditingController fourthValue = TextEditingController();
  TextEditingController fifthValue = TextEditingController();
  TextEditingController sixValue = TextEditingController();
  var firstNode = new FocusNode();
  var secondNode = new FocusNode();
  var thirdNode = new FocusNode();
  var fourthNode = new FocusNode();
  var fifthNode = new FocusNode();
  var sixNode = new FocusNode();

  @override
  void initState() {
    pr = new ProgressDialog(context);
    pr.style(message: "Verifying Code ...");
    pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: true, showLogs: false);

    // TODO: implement initState
    WidgetsBinding.instance.addPostFrameCallback((_){
      FocusScope.of(context).requestFocus(firstNode);
      phoneAuth();
    });
    timerForSplash();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.fromLTRB(30.0, 100.0, .0, .0),
            child: Text(Constants.PHONE_CONFIRMATION
              ,style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.pink
              ),),

          ),
          Container(
            margin: EdgeInsets.fromLTRB(30.0, 10.0, .0, .0),
            child: Text(Constants.PHONE_CONFIRMATION_TEXT
              ,style: TextStyle(
                  fontSize: 17.0,
                  color: Colors.black
              ),),

          ),
          Row(
            children: <Widget>[
              Container(
                width: 40.0,
                height: 50.0,
                margin: EdgeInsets.fromLTRB(30.0, 10.0, 0.0, 0.0),
                padding: EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 5.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black45),
                  borderRadius:
                  BorderRadius.all(Radius.circular(4)),
                ),
                child: Form(
                  child: TextField(
                    focusNode: firstNode,
                    controller: firstValue,
                    maxLength: 1,

                    onChanged: (text){
                      print(text);
                      FocusScope.of(context).requestFocus(secondNode);

                    },
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                        counterStyle: TextStyle(height: double.minPositive,),
                        counterText: ""
                    ),
                  ),
                ),
              ),
              Container(
                width: 40.0,
                height: 50.0,
                margin: EdgeInsets.fromLTRB(10.0, 10.0, 0.0, 0.0),
                padding: EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 5.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black45),
                  borderRadius:
                  BorderRadius.all(Radius.circular(4)),
                ),
                child: Form(
                  child: TextFormField(
                    focusNode: secondNode,
                    controller: secondValue,
                    maxLength: 1,
                    onChanged: (text){
                      print(text);
                      FocusScope.of(context).requestFocus(thirdNode);

                    },
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                        counterStyle: TextStyle(height: double.minPositive,),
                        counterText: ""
                    ),
                  ),
                ),
              ),
              Container(
                width: 40.0,
                height: 50.0,
                margin: EdgeInsets.fromLTRB(10.0, 10.0, 0.0, 0.0),
                padding: EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 5.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black45),
                  borderRadius:
                  BorderRadius.all(Radius.circular(4)),
                ),
                child: Form(
                  child: TextFormField(
                    focusNode: thirdNode,
                    controller: thirdValue,
                    maxLength: 1,

                    onChanged: (text){
                      print(text);
                      FocusScope.of(context).requestFocus(fourthNode);

                    },
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                        counterStyle: TextStyle(height: double.minPositive,),
                        counterText: ""
                    ),
                  ),
                ),
              ),
              Container(
                width: 40.0,
                height: 50.0,
                margin: EdgeInsets.fromLTRB(10.0, 10.0, 0.0, 0.0),
                padding: EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 5.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black45),
                  borderRadius:
                  BorderRadius.all(Radius.circular(4)),
                ),
                child: Form(
                  child: TextFormField(
                    focusNode: fourthNode,
                    controller: fourthValue,
                    maxLength: 1,
                    onChanged: (text){
                      print(text);
                      FocusScope.of(context).requestFocus(fifthNode);

                    },
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                        counterStyle: TextStyle(height: double.minPositive,),
                        counterText: ""
                    ),
                  ),
                ),
              ),
              Container(
                width: 40.0,
                height: 50.0,
                margin: EdgeInsets.fromLTRB(10.0, 10.0, 0.0, 0.0),
                padding: EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 5.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black45),
                  borderRadius:
                  BorderRadius.all(Radius.circular(4)),
                ),
                child: Form(
                  child: TextFormField(
                    focusNode: fifthNode,
                    controller: fifthValue,
                    maxLength: 1,

                    onChanged: (text){
                      print(text);
                      FocusScope.of(context).requestFocus(sixNode);
                    },
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                        counterStyle: TextStyle(height: double.minPositive,),
                        counterText: ""
                    ),
                  ),
                ),
              ),
              Container(
                width: 40.0,
                height: 50.0,
                margin: EdgeInsets.fromLTRB(10.0, 10.0, 0.0, 0.0),
                padding: EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 5.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black45),
                  borderRadius:
                  BorderRadius.all(Radius.circular(4)),
                ),
                child: Form(
                  child: TextFormField(
                    focusNode: sixNode,
                    controller: sixValue,
                    maxLength: 1,
                    onChanged: (text){
                      String value1, value2, value3, value4, value5, value6;
                      value1 = firstValue.text;
                      value2 = secondValue.text;
                      value3 = thirdValue.text;
                      value4 = fourthValue.text;
                      value5 = fifthValue.text;
                      value6 = sixValue.text;
                      if(value1 != "" && value2 != "" && value3 != "" && value4 != "" && value5 != "" && value6 != "" ){
//                        Navigator.pushAndRemoveUntil(
//                            context,
//                            MaterialPageRoute(
//                              builder: (_) => CareGiverProfile(),
//                            ),
//                                (e) => false);
//                        pr.dismiss();
                      String code = value1 + value2 + value3 + value4 + value5 + value6;
                      pr.show();
                        _authenticatePhoneNumber(code);
//                      if(widget.isLogin){
//                      }else{
//                        _authenticatePhoneNumber(code);
//                      }



                      }else{
                        pr.hide();
                        _scaffoldKey.currentState
                            .showSnackBar(SnackBar(content: Text("Please put the OTP number")));
                      }


                    },
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                        counterStyle: TextStyle(height: double.minPositive,),
                        counterText: ""
                    ),
                  ),
                ),
              )
            ],
          ),
          Row(
            children: <Widget>[
              Spacer(flex: 4,),
              Container(
                margin: EdgeInsets.fromLTRB(20.0, 20.0, 0.0, 0.0),

                child: Text("0:" + _start.toString(), style: TextStyle(color: Colors.red),),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(20.0, 20.0, 0.0, 0.0),
                child: FlatButton(
                  onPressed: _isButtonDisable ? null : (){
                    phoneAuth();
                    _scaffoldKey.currentState
                        .showSnackBar(SnackBar(content: Text("OTP code sent on your given number")));
                    setState(() {
                      _isButtonDisable = true;
                      _start = 59;

                    });
                  },
                  child: Text("Send Again", style: TextStyle(color: _isButtonDisable ?  Colors.black38 : Colors.pink),),
                ),
              ), Spacer()
            ],
          )
        ],
      ),
    );
  }
  Future<void> timerForSplash() async {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(oneSec, (Timer timer) {
      if (this.mounted) {
        setState(
              () {
            if (_start < 1) {
              _isButtonDisable = false;

            } else {
              _start = _start - 1;
              print(_start);
            }
          },
        );
      } else {
//          print(_start);
      }
    });
  }



  void _authenticatePhoneNumber(String userCode) {
    FirebaseAuth auth = FirebaseAuth.instance;
    smsCode = userCode.trim();
    if(smsCode == ""){
      pr.hide();
      _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("Please enter the OTP code"),));
      return;
    } else if(verificationId == null){
      pr.hide();
      _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("Verification Id is empty, try to resend the OTP code"),));
    }
    _credential = PhoneAuthProvider.getCredential(verificationId: verificationId, smsCode: smsCode);
    auth.signInWithCredential(_credential).then((AuthResult result){
      if(widget.isLogin){
//        Auth.checkUs
        Auth.checkUserExist(result.user.uid).then((isExist){
          if(isExist){
            Auth.getUserFirestore(result.user.uid);
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                builder: (context) => ChangeNotifierProvider(
                  create: (context) => HomeViewModel(0),
                  lazy: false,
                  child: Home(),
                )
            ),
                    (e) => false);
          }else{
            pr.hide();
            auth.signOut();
            _scaffoldKey.currentState.showSnackBar(SnackBar(
                content: Text("This user is not exists please sign up for new user")));
          }
        });
      }else{
        Auth.checkUserExist(result.user.uid).then((isExist){
          if(!isExist){
//            Auth.addUserSettingsDB(new User(
//              userId: result.user.uid,
//              email: widget.user.email,
//              firstName: widget.user.firstName,
//              phone_number: (widget.user.phone_number),
//              deviceToken: widget.user.deviceToken,
//              groupType: "group1",
//            ),
//                result.user
//            );
            Navigator.push(context, MaterialPageRoute(
                builder: (context) => Health(widget.user)
            ));
          }else{
            pr.hide();
            auth.signOut();
            _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("This user is already exists, please login on previous page")));
          }
        });
      }
    }).catchError((e){
      print( "Catch expression 2: " + e.message.toString());
      pr.hide();
      _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(e.message)));
    });
  }

  void phoneAuth() async{
    _mAuth = FirebaseAuth.instance;

    try{
      _mAuth.verifyPhoneNumber(
          phoneNumber: widget.isLogin ? widget.user.email : widget.user.phone_number,
          timeout: Duration(seconds: 120),
          verificationCompleted: (AuthCredential authCredential){
            _scaffoldKey.currentState.showSnackBar(SnackBar(
                content: Text("Token access succesfully")));
            pr.show();
            _authenticatePhoneNumber(fetchOTP(authCredential.toString()));
          },
          verificationFailed: (AuthException authException) {
            pr.hide();
            _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(authException.message)));
            print("autheExecption" + authException.message);
          },
          codeSent: (String verificationId, [int forceResendingToken]){
            this.verificationId = verificationId;
            this.forceResendingToken = forceResendingToken;
          },
          codeAutoRetrievalTimeout: (String verificationId){
            verificationId = verificationId;
            print("autoRetrieval exception:" + verificationId);
            print("Timout");
          },
          forceResendingToken: forceResendingToken
      );
    }catch(e){
      print("Catch exception: " + e.toString());
    }
  }

  String fetchOTP(String jsons) {
//    String jsons = '{jsonObject: {"zza":"AM5PThBPhjSJ8mEILEfkq16KzHPWeqW2jJ47K5PPilurSnnKFhr0qFJBUVfDwcQyRUQGzD5MeSMIJ-q4PbG08LezxR6_OAienEW8FggAv15a9nX6WmZAANDrhUmtVLq1cpRfR707zzFAjnDmx-BX0fva0Q-IrsdnStWZGmrpZKGnEc6-7a2mN_MzYTGu5oCw2bxZ7axpTZQVLVoD4TRLnUfzPodvTNa8npE2SdGt8VaKSLkr3D47GE4","zzb":"548785","zzc":false,"zze":true}}';
    final jsonData = jsons.split(",")[1].split(":")[1];
    String string = "";
    for(int i = 1; i < jsonData.length - 1 ; i++){
      string = string + jsonData[i];
    }
    print(string);
    return string;
  }

}