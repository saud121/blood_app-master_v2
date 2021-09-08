import 'package:blood_app/models/constants.dart';
import 'package:blood_app/ui/home/home.dart';
import 'package:blood_app/ui/login/login.dart';
import 'package:blood_app/ui/login/login_viewmodel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import 'dashboard_viewmodel.dart';
import 'home_page.dart';
import 'homepage_viewmodel.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  int _selectedIndex = 0;
  DashboardViewModel model;

  @override
  Widget build(BuildContext context) {
    model = Provider.of<DashboardViewModel>(context, listen: false);
    model.fetchBloodGroupUsers();


    var image =  Container(
      child: Image.asset("assets/images/screen.png"),
      width: 250,
      height: 250,
    );

    var text = Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      alignment: Alignment.center,
      child: Text("Welcome to the blood app. You can find donors within the 15 km radius.Click on the blood groups and find donors.", textAlign: TextAlign.center,style:  TextStyle(fontSize: 18.0, color: Colors.red,),),
    );


    var aPositive = Consumer<DashboardViewModel>(builder: (_, model, child){
      return GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => ChangeNotifierProvider(
                    create: (context) =>
                        HomePageViewModel(model.user,model.aPositiveList, "A+"),
                    lazy: false,
                    child: HomePage(),
                  )));
        },
        child: Container(
          margin: EdgeInsets.fromLTRB(20, 30, 20, 0),
          width: MediaQuery.of(context).size.width,
          height: 80,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.red),
            borderRadius: BorderRadius.all(Radius.circular(10)),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 5.0,
                // has the effect of softening the shadow
                spreadRadius: 3.0,
                // has the effect of extending the shadow
                offset: Offset(
                  2.0, // horizontal, move right 10
                  2.0, // vertical, move down 10
                ),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(left: 20),
                    child: Text(
                      Constants.A_POSITIVE_BLOOD,
                      style: TextStyle(fontSize: 20.0, color: Colors.red, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 20),
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      "${model.aPositiveList.length.toString()} Users",
                      style: TextStyle(fontSize: 20.0, color: Colors.red, fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ),
              Container(
                margin: EdgeInsets.only(right: 20),
                child: Image.asset("assets/images/a_positive.png", width: 45, height: 45,),
              )
            ],
          ),
        ),
      );

    });

    var aNegative = Consumer<DashboardViewModel>(builder: (_, model, child){
      return GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => ChangeNotifierProvider(
                    create: (context) =>
                        HomePageViewModel(model.user, model.aNegativeList, "A-"),
                    lazy: false,
                    child: HomePage(),
                  )));
        },
        child: Container(
          margin: EdgeInsets.fromLTRB(20, 30, 20, 0),
          width: MediaQuery.of(context).size.width,
          height: 80,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.red),
            borderRadius: BorderRadius.all(Radius.circular(10)),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 5.0,
                // has the effect of softening the shadow
                spreadRadius: 3.0,
                // has the effect of extending the shadow
                offset: Offset(
                  2.0, // horizontal, move right 10
                  2.0, // vertical, move down 10
                ),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(left: 20),
                    child: Text(
                      Constants.A_NEGATIVE_BLOOD,
                      style: TextStyle(fontSize: 20.0, color: Colors.red, fontWeight: FontWeight.bold)
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 20),
                    child: Text(
                      "${model.aNegativeList.length.toString()} Users",
                      style: TextStyle(fontSize: 20.0, color: Colors.red, fontWeight: FontWeight.bold)
                    ),
                  )
                ],
              ),
              Container(
                margin: EdgeInsets.only(right: 20),
                child: Image.asset("assets/images/a_negative.png", width: 45, height: 45,),
              )
            ],
          ),
        ),
      );

    });


    var bPositive = Consumer<DashboardViewModel>(builder: (_, model, child){
      return GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => ChangeNotifierProvider(
                    create: (context) =>
                        HomePageViewModel(model.user, model.bPositiveList, "B+"),
                    lazy: false,
                    child: HomePage(),
                  )));
        },
        child: Container(
          margin: EdgeInsets.fromLTRB(20, 30, 20, 0),
          width: MediaQuery.of(context).size.width,
          height: 80,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.red),
            borderRadius: BorderRadius.all(Radius.circular(10)),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 5.0,
                // has the effect of softening the shadow
                spreadRadius: 3.0,
                // has the effect of extending the shadow
                offset: Offset(
                  2.0, // horizontal, move right 10
                  2.0, // vertical, move down 10
                ),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(left: 20),
                    child: Text(
                      Constants.B_POSITIVE_BLOOD,
                      style: TextStyle(fontSize: 20.0, color: Colors.red, fontWeight: FontWeight.bold)
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 20),
                    child: Text(
                      "${model.bPositiveList.length.toString()} Users",
                      style: TextStyle(fontSize: 20.0, color: Colors.red, fontWeight: FontWeight.bold)
                    ),
                  )
                ],
              ),
              Container(
                margin: EdgeInsets.only(right: 20),
                child: Image.asset("assets/images/b_positive.png", width: 45, height: 45,),
              )
            ],
          ),
        ),
      );
    });


    var bNegative = Consumer<DashboardViewModel>(builder: (_, model, child){
      return GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => ChangeNotifierProvider(
                    create: (context) =>
                        HomePageViewModel(model.user, model.bNegativeList, "B-"),
                    lazy: false,
                    child: HomePage(),
                  )));
        },
        child: Container(
          margin: EdgeInsets.fromLTRB(20, 30, 20, 0),
          width: MediaQuery.of(context).size.width,
          height: 80,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.red),
            borderRadius: BorderRadius.all(Radius.circular(10)),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 5.0,
                // has the effect of softening the shadow
                spreadRadius: 3.0,
                // has the effect of extending the shadow
                offset: Offset(
                  2.0, // horizontal, move right 10
                  2.0, // vertical, move down 10
                ),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(left: 20),
                    child: Text(
                      Constants.B_NEGATIVE_BLOOD,
                      style: TextStyle(fontSize: 20.0, color: Colors.red, fontWeight: FontWeight.bold)
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 20),
                    child: Text(
                      "${model.bNegativeList.length.toString()} Users",
                      style: TextStyle(fontSize: 20.0, color: Colors.red, fontWeight: FontWeight.bold)
                    ),
                  )
                ],
              ),
              Container(
                margin: EdgeInsets.only(right: 20),
                child: Image.asset("assets/images/b_negative.png", width: 45, height: 45,),
              )
            ],
          ),
        ),
      );

    });

    var oPositive = Consumer<DashboardViewModel>(builder: (_, model, child){
      return GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => ChangeNotifierProvider(
                    create: (context) =>
                        HomePageViewModel(model.user, model.oPositiveList, "O+"),
                    lazy: false,
                    child: HomePage(),
                  )));
        },
        child: Container(
          margin: EdgeInsets.fromLTRB(20, 30, 20, 0),
          width: MediaQuery.of(context).size.width,
          height: 80,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.red),
            borderRadius: BorderRadius.all(Radius.circular(10)),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 5.0,
                // has the effect of softening the shadow
                spreadRadius: 3.0,
                // has the effect of extending the shadow
                offset: Offset(
                  2.0, // horizontal, move right 10
                  2.0, // vertical, move down 10
                ),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(left: 20),
                    child: Text(
                      Constants.O_POSITIVE_BLOOD,
                      style: TextStyle(fontSize: 20.0, color: Colors.red, fontWeight: FontWeight.bold)
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 20),
                    child: Text(
                      "${model.oPositiveList.length.toString()} Users",
                      style: TextStyle(fontSize: 20.0, color: Colors.red, fontWeight: FontWeight.bold)
                    ),
                  )
                ],
              ),
              Container(
                margin: EdgeInsets.only(right: 20),
                child: Image.asset("assets/images/o_positive.png", width: 45, height: 45,),
              )
            ],
          ),
        ),
      );
    });


    var oNegative = Consumer<DashboardViewModel>(builder: (_, model, child){
      return GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => ChangeNotifierProvider(
                    create: (context) =>
                        HomePageViewModel(model.user, model.oNegativeList, "O-"),
                    lazy: false,
                    child: HomePage(),
                  )));
        },
        child: Container(
          margin: EdgeInsets.fromLTRB(20, 30, 20, 0),
          width: MediaQuery.of(context).size.width,
          height: 80,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.red),
            borderRadius: BorderRadius.all(Radius.circular(10)),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 5.0,
                // has the effect of softening the shadow
                spreadRadius: 3.0,
                // has the effect of extending the shadow
                offset: Offset(
                  2.0, // horizontal, move right 10
                  2.0, // vertical, move down 10
                ),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(left: 20),
                    child: Text(
                      Constants.O_NEGATIVE_BLOOD,
                      style:TextStyle(fontSize: 20.0, color: Colors.red, fontWeight: FontWeight.bold)
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 20),
                    child: Text(
                      "${model.oNegativeList.length.toString()} Users",
                      style: TextStyle(fontSize: 20.0, color: Colors.red, fontWeight: FontWeight.bold)
                    ),
                  )
                ],
              ),
              Container(
                margin: EdgeInsets.only(right: 20),
                child: Image.asset("assets/images/o_negative.png", width: 45, height: 45,),
              )
            ],
          ),
        ),
      );
    });

    var abPositive = Consumer<DashboardViewModel>(builder: (_, model, child){
      return GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => ChangeNotifierProvider(
                    create: (context) =>
                        HomePageViewModel(model.user, model.abPositiveList, "AB+"),
                    lazy: false,
                    child: Home(),
                  )));
        },
        child: Container(
          margin: EdgeInsets.fromLTRB(20, 30, 20, 0),
          width: MediaQuery.of(context).size.width,
          height: 80,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.red),
            borderRadius: BorderRadius.all(Radius.circular(10)),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 5.0,
                // has the effect of softening the shadow
                spreadRadius: 3.0,
                // has the effect of extending the shadow
                offset: Offset(
                  2.0, // horizontal, move right 10
                  2.0, // vertical, move down 10
                ),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(left: 20),
                    child: Text(
                      Constants.AB_POSITIVE_BLOOD,
                      style: TextStyle(fontSize: 20.0, color: Colors.red, fontWeight: FontWeight.bold)
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 20),
                    child: Text(
                      "${model.abPositiveList.length.toString()} Users",
                      style: TextStyle(fontSize: 20.0, color: Colors.red, fontWeight: FontWeight.bold)
                    ),
                  )
                ],
              ),
              Container(
                margin: EdgeInsets.only(right: 20),
                child: Image.asset("assets/images/ab_positive.png", width: 45, height: 45,),
              )
            ],
          ),
        ),
      );
    });


    var abNegative = Consumer<DashboardViewModel>(builder: (_, model, child){
      return GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => ChangeNotifierProvider(
                    create: (context) =>
                        HomePageViewModel(model.user, model.abNegativeList, "AB-"),
                    lazy: false,
                    child: HomePage(),
                  )));
        },
        child: Container(
          margin: EdgeInsets.fromLTRB(20, 30, 20, 0),
          width: MediaQuery.of(context).size.width,
          height: 80,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.red),
            borderRadius: BorderRadius.all(Radius.circular(10)),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 5.0,
                // has the effect of softening the shadow
                spreadRadius: 3.0,
                // has the effect of extending the shadow
                offset: Offset(
                  2.0, // horizontal, move right 10
                  2.0, // vertical, move down 10
                ),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(left: 20),
                    child: Text(
                      Constants.AB_NEGATIVE_BLOOD,
                      style: TextStyle(fontSize: 20.0, color: Colors.red, fontWeight: FontWeight.bold)
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 20),
                    child: Text(
                      "${model.abNegativeList.length.toString()} Users",
                      style: TextStyle(fontSize: 20.0, color: Colors.red, fontWeight: FontWeight.bold)
                    ),
                  )
                ],
              ),
              Container(
                margin: EdgeInsets.only(right: 20),
                child: Image.asset("assets/images/ab_negative.png", width: 45, height: 45,),
              )
            ],
          ),
        ),
      );
    });



    return Scaffold(

      body: SingleChildScrollView(
        child: Container(
          // padding: EdgeInsets.all(15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              image,
              SizedBox(height: 15,),
              text,
              SizedBox(height: 10,),
              aPositive,
              aNegative,
              bPositive,
              bNegative,
              oPositive,
              oNegative,
              abPositive,
              abNegative
            ],
          ),
        )
      ),

    );
  }
}
