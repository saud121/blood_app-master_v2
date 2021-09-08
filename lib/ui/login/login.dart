
import 'dart:convert';

import 'package:blood_app/models/constants.dart';
import 'package:blood_app/models/user.dart';
import 'package:blood_app/ui/phone_verification/phone_verification.dart';
import 'package:blood_app/ui/registration/registration.dart';
import 'package:blood_app/ui/widgets/loading.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../base_main.dart';


class SignInScreen extends Base {
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scafoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _email = new TextEditingController();
  final TextEditingController _password = new TextEditingController();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  bool _autoValidate = false;
  bool _loadingVisible = false;

  String countryCode = "+92";

  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {

    final logo = Hero(
      tag: 'hero',
      child: CircleAvatar(
          backgroundColor: Colors.red,
          radius: 100.0,
          child: ClipOval(

            child: SvgPicture.asset("assets/images/man.svg",
              width: MediaQuery.of(context).size.width * 0.20,
              height: MediaQuery.of(context).size.height * 0.20,
              placeholderBuilder: (_) => CircularProgressIndicator(),
            ),
          )),
    );

    final email = TextFormField(
      keyboardType: TextInputType.phone,
      autofocus: false,
      controller: _email,
//      validator: Validator.validateEmail,
      decoration: InputDecoration(
        focusColor: Colors.red,
        prefixIcon: Padding(
            padding: EdgeInsets.only(left: 5.0),
            child: CountryCodePicker(
              onChanged: (_){
                countryCode = _.dialCode;
                print(countryCode);
              },
              // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
              initialSelection: 'PK',
              favorite: ['+92'],
              // optional. Shows only country name and flag
              showCountryOnly: false,
              // optional. Shows only country name and flag when popup is closed.
              showOnlyCountryWhenClosed: false,
              // optional. aligns the flag and the Text left
              alignLeft: false,
            ) // icon is 48px widget.
        ),
        // icon is 48px widget.
        hintText: 'Phone number',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
        fillColor: Colors.red,
      ),
    );


    final loginButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        onPressed: () {
          _emailLogin(
              email: _email.text, password: _password.text, context: context);
        },
        padding: EdgeInsets.all(12),
        color: Colors.red,
        child: Text('SIGN IN', style: TextStyle(color: Colors.white)),
      ),
    );



    final signUpLabel = FlatButton(
      child: Text(
        'Create an Account',
        style: TextStyle(color: Colors.red),
      ),
      onPressed: () {
        Navigator.push(context, MaterialPageRoute(
            builder: (_) => SignUpScreen()
        ));
      },
    );

    var text = Center(
      child: Container(
        width: MediaQuery
            .of(context)
            .size
            .width,
        child: Text(
          Constants.SIGN_IN_MESSAGE,
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 25,
              color: Colors.red
          ),

        ),
      ),
    );
    var forgetAndCreateAccountButton = Container(
      height: 40,
      child: IntrinsicHeight(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            signUpLabel
          ],
        ),
      ),
    );
    return Scaffold(
      key: _scafoldKey,
      backgroundColor: Colors.white,
      body: LoadingScreen(
          child: Form(
            key: _formKey,
            autovalidate: _autoValidate,
            child: Padding(
              padding: EdgeInsets.fromLTRB(20, 100, 20, 10),
              child:
              SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    text,
                    SizedBox(height: 50.0),
                    logo,
                    SizedBox(height: 40.0),
                    email,
//                    SizedBox(height: 20.0),
//                    password,
                    SizedBox(height: 10.0),
                    loginButton,
                    forgetAndCreateAccountButton,

                  ],
                ),
              ),
            ),
          ),
          inAsyncCall: _loadingVisible),
    );
  }

  Future<void> _changeLoadingVisible() async {
    setState(() {
      _loadingVisible = !_loadingVisible;
    });
  }

  Future<void> contactInstructor(String phone) async {
    var whatsappUrl = "whatsapp://send?phone=$phone";

    await canLaunch(whatsappUrl)
        ? launch(whatsappUrl)
        : print(
        Constants.WHATSAPP_NOT_INSTALLED);
  }

  void _emailLogin(
      {String email, String password, BuildContext context}) async {
    if (_formKey.currentState.validate()) {
      try {
        SystemChannels.textInput.invokeMethod('TextInput.hide');
//        await _changeLoadingVisible();
        //need await so it has chance to go through error if found.
//        await StateWidget.of(context).logInUser(email, password);

        if(email != "" && email.length == 10){
          email = countryCode + email;
          print(email);
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => PhoneConformation(
                    User(email: email),
                    true
                ),
              ));
        }else{
          _scafoldKey.currentState.showSnackBar(
              new SnackBar(content: Text("Please put the correct mobile number")));
        }


      } catch (e) {
        print("Sign In Error: $e");


        _scafoldKey.currentState.showSnackBar(
            new SnackBar(content: Text(e)));
//        Flushbar(
//          title: "Sign In Error",
//          message: exception,
//          duration: Duration(seconds: 5),
//        )..show(context);
      }
    } else {
      setState(() => _autoValidate = true);
    }
  }




}
