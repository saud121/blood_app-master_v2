import 'dart:async';
import 'dart:math';

import 'package:blood_app/models/constants.dart';
import 'package:blood_app/models/user.dart';
import 'package:blood_app/ui/login/login.dart';
import 'package:blood_app/ui/login/login_viewmodel.dart';
import 'package:blood_app/ui/phone_verification/phone_verification.dart';
import 'package:blood_app/ui/widgets/loading.dart';
import 'package:blood_app/util/validator.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_custom_dialog/flutter_custom_dialog.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../base_main.dart';

class SignUpScreen extends Base {
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scafoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _firstName = new TextEditingController();
  final TextEditingController _lastName = new TextEditingController();
  final TextEditingController _email = new TextEditingController();
  final TextEditingController _password = new TextEditingController();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  String deviceToken = '';
  bool _autoValidate = false;
  bool _loadingVisible = false;
  FirebaseAuth _mAuth;
  String countryCode = "+92";
  bool isResend = false;

  var _codeController = TextEditingController();
  var forceResendingToken;
  String smsCode;

  AuthCredential _credential;

  @override
  void initState() {
    _notificationInit();
    super.initState();
  }

  Widget build(BuildContext context) {
    final logo = Hero(
      tag: 'hero',
      child: CircleAvatar(
          backgroundColor: Colors.red,
          radius: 90.0,
          child: ClipOval(
            child: SvgPicture.asset("assets/images/donor.svg",
              width: MediaQuery.of(context).size.width * 0.17,
              height: MediaQuery.of(context).size.height * 0.17,
              placeholderBuilder: (_) => CircularProgressIndicator(),
            ),
          )),
    );

    final firstName = TextFormField(
      autofocus: false,
      textCapitalization: TextCapitalization.words,
      controller: _firstName,
      validator: Validator.validateName,
      decoration: InputDecoration(
        prefixIcon: Padding(
          padding: EdgeInsets.only(left: 5.0),
          child: Icon(
            Icons.person,
            color: Colors.grey,
          ), // icon is 48px widget.
        ), // icon is 48px widget.
        hintText: 'Name',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final lastName = TextFormField(
      keyboardType: TextInputType.phone,
      autofocus: false,
      textCapitalization: TextCapitalization.words,
      controller: _lastName,
//      validator: Validator.validateNumber,
      decoration: InputDecoration(
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
        ), // icon is 48px widget.
        hintText: 'Mobile number',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
      style: TextStyle(
          fontSize: 16
      ),
    );

    final email = TextFormField(
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      controller: _email,
      validator: Validator.validateEmail,
      decoration: InputDecoration(
        prefixIcon: Padding(
          padding: EdgeInsets.only(left: 5.0),
          child: Icon(
            Icons.email,
            color: Colors.grey,
          ), // icon is 48px widget.
        ), // icon is 48px widget.
        hintText: 'Email',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

   // final password = TextFormField(
   //   autofocus: false,
   //   obscureText: true,
   //   controller: _password,
   //   validator: Validator.validatePassword,
   //   decoration: InputDecoration(
   //     prefixIcon: Padding(
   //       padding: EdgeInsets.only(left: 5.0),
   //       child: Icon(
   //         Icons.lock,
   //         color: Colors.grey,
   //       ), // icon is 48px widget.
   //     ), // icon is 48px widget.
   //     hintText: 'Password',
   //     contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
   //     border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
   //   ),
   // );

    final signUpButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        onPressed: () {
          _emailSignUp(
              firstName: _firstName.text,
              lastName: _lastName.text,
              email: _email.text,
             password: _password.text,
              context: context);
        },
        padding: EdgeInsets.all(12),
        color: Theme.of(context).primaryColor,
        child: Text('SIGN UP', style: TextStyle(color: Colors.white)),
      ),
    );

    final signInLabel = FlatButton(
      child: Text(
        'Have an Account? Sign In.',
        style: TextStyle(color: Colors.black54),
      ),
      onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => ChangeNotifierProvider(
          create: (context) => LoginViewModel(),
          lazy: false,
          child: SignUpScreen(),
        )));

      },
    );
//    var forgetAndCreateAccountButton = Container(
//      height: 40,
//      child: IntrinsicHeight(
//        child: Row(
//          mainAxisAlignment: MainAxisAlignment.spaceAround,
//          children: [forgotLabel,
//            VerticalDivider(
//              width: 2,
//            ),
//            signUpLabel],
//        ),
//      ),
//    );



    return Scaffold(
      key: _scafoldKey,
      backgroundColor: Colors.white,
      body: LoadingScreen(
          color: Colors.black,
          child: Form(
            key: _formKey,
            autovalidate: _autoValidate,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 40, 24, 5),
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      SizedBox(height: 50.0),
                      logo,
                      SizedBox(height: 35.0),
                      firstName,
                      SizedBox(height: 16.0),
                      lastName,
                      SizedBox(height: 16.0),
                      email,
                     // SizedBox(height: 16.0),
                     // password,
                      SizedBox(height: 8.0),
                      signUpButton,
                      signInLabel,

                    ],
                  ),
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
        "open whatsapp app link or do a snackbar with notification that there is no whatsapp installed");
  }

  void _emailSignUp(
      {String firstName,
        String lastName,
        String email,
        String password,
        BuildContext context}) async {
    if (_formKey.currentState.validate()) {
      try {
        SystemChannels.textInput.invokeMethod('TextInput.hide');
        await _changeLoadingVisible();
        //need await so it has chance to go through error if found.

        User user = User(
            firstName: firstName,
            phone_number: (countryCode + lastName),
            email: email,
            password:password,
            deviceToken: deviceToken,
            availability: true,
            groupType: "group1"
        );

          // await _mAuth.createUserWithEmailAndPassword(
          //   email: email,
          //   password: password,
          // );
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => PhoneConformation(
                  user,
                  false
              ),
            ));
      } catch (e) {
//        _changeLoadingVisible();
        print("Sign Up Error: $e");
//        String exception = Auth.getExceptionText(e);
//        _scafoldKey.currentState.showSnackBar(new SnackBar(content: new Text("Sign Up Error")));
        _scafoldKey.currentState.showSnackBar(
            new SnackBar(content: Text(e)));

      }
    } else {
      setState(() => _autoValidate = true);
    }
  }

  void _notificationInit() {
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
      },
    );
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(
            sound: true, badge: true, alert: true, provisional: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
    _firebaseMessaging.getToken().then((String token) {
      print(token);
      this.deviceToken = token;
      print("Token initialize: "+deviceToken);

    });
  }

  void validateUrl(String documentId, bool isWhatsAppNumber) async {
    widget.fetchImportantLink(documentId).then((value) {
      value.get().then((value) {
        String url = value['url'];
        print(url);
        widget.dissmissProgressDialgue().then((isOkay) {
          if (isOkay) {
            if (isWhatsAppNumber) {
              contactInstructor(url);
            } else {
              launch("tel: " + url);
            }
          }
        });
      });
    });
  }


}
