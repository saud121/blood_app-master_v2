import 'dart:async';
import 'dart:math';

import 'package:blood_app/models/constants.dart';
import 'package:blood_app/ui/home/home.dart';
import 'package:blood_app/ui/home/home_viewmodel.dart';
import 'package:blood_app/ui/login/login.dart';
import 'package:blood_app/ui/login/login_viewmodel.dart';
import 'package:blood_app/ui/registration/registration.dart';
import 'package:blood_app/ui/registration/registration_viewmodel.dart';
import 'package:blood_app/util/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class Splash extends StatefulWidget {
  Splash({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  Timer _timer;

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    timerForSplash();
    return Scaffold(
        backgroundColor: Colors.white,
        body:
        Container(
//             decoration: BoxDecoration(
//               gradient: RadialGradient(
//                 colors: <Color>[
//                   Colors.pink.withOpacity(0.0),
//                   Colors.pink.withOpacity(0.1),
//                   Colors.pink.withOpacity(0.2),
//                   Colors.pink.withOpacity(0.3),
//                   Colors.pink.withOpacity(0.4),
//                   Colors.pink.withOpacity(0.5),
//                   Colors.pink.withOpacity(0.6),
//                   Colors.pink.withOpacity(0.7),
//                   Colors.pink.withOpacity(0.8),
//                   Colors.pink.withOpacity(0.9),
//                   Colors.pink.withOpacity(1.0),
//                 ],
//                 stops: [
//                   0.0,
//                   0.1,
//                   0.2,
//                   0.3,
//                   0.4,
//                   0.5,
//                   0.6,
//                   0.7,
//                   0.8,
//                   0.9,
//                   1.0,
//                 ],
//               ),
//             ),
          child:  _splashBody(),
        )
    ); // This trailing comma makes auto-formatting nicer for build methods.
    // ;
  }

  /*
    This method is splash message in order to check the user either he is login or not..
   */
  Widget _splashBody() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Spacer(),
        Container(
          width: double.infinity,
          margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SvgPicture.asset("assets/images/heartbeat.svg",
                width: MediaQuery.of(context).size.width * 0.30,
                height: MediaQuery.of(context).size.height * 0.30,
                placeholderBuilder: (_) => CircularProgressIndicator(),
              ),
              Text(
                Constants.APP_NAME,
                style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                    color: Colors.pink),
              )
            ],
          ),
        ),
        Spacer(),
        Container(
          margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 30.0),
          child: Text("Powered by GIL",  style: TextStyle(
              color: Colors.pink)),
        )
      ],
    );
  }

  int _start = 5;

  Future<void> timerForSplash() async {
    Future<FirebaseUser> user = FirebaseAuth.instance.currentUser();

    Future.delayed(Duration(seconds: 1)).then((value) => {
      // hide your widget
      user.then((user) {
        if (user != null) {
         checkUserExist(user);
          return;
        } else {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (_) => ChangeNotifierProvider(
                  create: (context) => LoginViewModel(),
                  lazy: false,
                  child: SignInScreen(),
                ),
              ),
                  (e) => false);
          return;
        }
      })
    });


  }

  void checkUserExist(FirebaseUser user) async{
    bool check = await Auth.checkUserExist(user.uid);
    if(check){
      Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (_) => ChangeNotifierProvider(
          create: (context) => HomeViewModel(0),
          lazy: false,
          child: Home(),
        ),
      ));
    }else{
      Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (_) => ChangeNotifierProvider(
          create: (context) => RegistrationViewModel(),
          lazy: false,
          child: SignUpScreen(),
        ),
      ));
    }
  }
}
