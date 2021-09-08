import 'package:blood_app/ui/home/archive_request.dart';
import 'package:blood_app/ui/home/archive_request_viewmodel.dart';
import 'package:blood_app/ui/home/profilepage_viewmodel.dart';
import 'package:blood_app/ui/login/login.dart';
import 'package:blood_app/ui/login/login_viewmodel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_dialog/flutter_custom_dialog.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../base_main.dart';

/*
This is profile class, where we have all important stuff like Privacy policy, my courses, purchase new courses and so forth...
*/
class Profile extends Base {


  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  ProfileViemodel model;
  List<String> provinces = ["Balochistan", "KPK", "Sindh", "Punjab"];
  List<String> districts = ["Quetta", "Bostan", "Mastung", "Pishin"];

  TextEditingController adressController = TextEditingController();
  TextEditingController districtController = TextEditingController();
  TextEditingController provinceController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    model = Provider.of<ProfileViemodel>(context, listen: false);


    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.width / 2.5,
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Row(
                    children: <Widget>[
                      Spacer(
                        flex: 3,
                      ),
                      SvgPicture.asset("assets/images/man.svg",  width: 100,
                        height: 100,),
//                      Image.asset(
//                        "assets/images/professor.png",
//                        width: 100,
//                        height: 100,
//                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(15.0, 25.0, .0, 25.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Text(
                              model.user.firstName,
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.red),
                            ),
                            Text(
                              model.user.email,
                              style: TextStyle(color: Colors.red),
                            ),
                            Text(
                              model.user.phone_number,
                              style: TextStyle(color: Colors.red),
                            ),
                          ],
                        ),
                      ),
                      Spacer(
                        flex: 20,
                      ),
                      GestureDetector(
                        onTap: () {
//                          Navigator.push(context,
//                              MaterialPageRoute(builder: (_) {
//                                return EditProfile();
//                              }));
                        },
                        child: Container(),
                      ),
                      Spacer(
                        flex: 3,
                      )
                    ],
                  ),
                ),
                Container(
                  color: Color.fromRGBO(245, 245, 245, 1.0),
                  margin: EdgeInsets.fromLTRB(0.0, 0.0, .0, 0.0),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(10.0),
                        child: Text(
                          "My Account",
                          style: TextStyle(fontSize: 20, color: Colors.black45),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(),
                  child: Column(
                    children: <Widget>[
                      /*
  * This is My courses tile, where listed all the purchased courses.
  * */
                      ListTile(
                        onTap: () {
                          showUserInfo(context);
                        },
                        leading: SvgPicture.asset("assets/images/man.svg", width: 25, height: 25,),
                        title: Text(
                          "My Personel information",
                          style: TextStyle(color: Colors.black54),
                        ),
                      ),
                      Divider(
                        height: 2,
                      ),
                      /*
  * This is Free resources tile, where we put pdf so every individual can learn more.
  * */
                      ListTile(
                        onTap: () {
                          showHealthInfo(context);
                        },
                        leading: SvgPicture.asset("assets/images/health.svg", width: 25, height: 25,),
                        title: Text(
                          "My health information",
                          style: TextStyle(color: Colors.black54),
                        ),
                      ),
                      Divider(
                        height: 2,
                      ),

                      ListTile(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (_) =>  ChangeNotifierProvider(
                            create: (context) => ArchiveRequestViewModel(model.user),
                            lazy: false,
                            child: ArchiveRequest(),
                          )));
                        },
                        leading: Icon(
                          Icons.archive,
                          color: Colors.redAccent,
                          size: 25,
                        ),
                        title: Text(
                          "Archive requests",
                          style: TextStyle(color: Colors.black54),
                        ),
                      ),
                      Divider(
                        height: 2,
                      ),
                      /*
  * This is Learn more tile, where we put pdf so every individual can learn more.
  * */
                      ListTile(
                        onTap: () {
                          showHouseInfo(context);
                        },
                        leading: SvgPicture.asset("assets/images/house.svg", width: 25, height: 25,),
                        title: Text(
                          "My home information",
                          style: TextStyle(color: Colors.black54),
                        ),
                      ),
                      Consumer<ProfileViemodel>(
                        builder: (_, model, child){
                          return ListTile(
                            onTap: () {
                            },
                            leading: SvgPicture.asset("assets/images/doctor.svg", width: 25, height: 25,),
                            title: Text(
                              "Availability",
                              style: TextStyle(color: Colors.black54),
                            ),
                            trailing: Switch(
                              value: model.user.availability,
                              onChanged: (_){
                                model.changeAvailability(_, widget, context);
                              },
                            ),
                          );
                        },

                      )
                    ],
                  ),
                ),
                Container(
                  color: Color.fromRGBO(245, 245, 245, 1.0),
                  margin: EdgeInsets.fromLTRB(0.0, 0.0, .0, 0.0),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(10.0),
                        margin: EdgeInsets.only(left: 10),
                        child: Text(
                          "FAQs",
                          style: TextStyle(fontSize: 20, color: Colors.black45),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  child: Column(
                    children: <Widget>[
                      /*
  * This is Help tile.
  * */
                      ListTile(
                        onTap: () {
                        },
                        leading: Image.asset(
                          "assets/images/light-bulb.png",
                          width: 25,
                          height: 25,
                        ),
                        title: Text(
                          "Help",
                          style: TextStyle(color: Colors.black54),
                        ),
                      ),
                      Divider(
                        height: 2,
                      ),
                      /*
  * This is Term of usage tile.
  * */
                      ListTile(
                        onTap: () {

                        },
                        leading: Image.asset(
                          "assets/images/diploma.png",
                          width: 25,
                          height: 25,
                        ),
                        title: Text(
                          "Term Of Use",
                          style: TextStyle(color: Colors.black54),
                        ),
                      ),
                      Divider(
                        height: 2,
                      ),
                      /*
  * This is Privacy policy tile.
  * */
                      ListTile(
                        onTap: () {
                        },
                        leading: Image.asset(
                          "assets/images/diploma-1.png",
                          width: 25,
                          height: 25,
                        ),
                        title: Text(
                          "Privacy Policy",
                          style: TextStyle(color: Colors.black54),
                        ),
                      ),
                      Divider(
                        height: 2,
                      ),
                      /*
  * This is Rate us tile.
  * */
                      ListTile(
                        onTap: () {
                          launch(
                              "https://play.google.com/store/apps/details?id=com.gil.blood_app");
                        },
                        leading: Icon(
                          Icons.star,
                          color: Colors.yellow,
                          size: 25,
                        ),
                        title: Text(
                          "Rate Us",
                          style: TextStyle(color: Colors.black54),
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(
                  height: 2,
                ),
                /*
  * This is Logout tile.
  * */
                Container(
                    margin: EdgeInsets.fromLTRB(.0, 0.0, .0, .0),
                    child: Column(
                      children: <Widget>[
                        ListTile(
                          onTap: () {
                            FirebaseAuth.instance.signOut().then((value){
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
                            });
                          },
                          leading: Icon(FontAwesomeIcons.signOutAlt, size: 25, color: Colors.pink,),
                          title: Text(
                            "Sign-out",
                            style: TextStyle(color: Colors.black54),
                          ),
                        ),
                      ],
                    ))
              ],
            ),
          ),
        ));
  }



  YYDialog showUserInfo(BuildContext context) {


    GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    TextEditingController emailController = TextEditingController();
    TextEditingController nameController = TextEditingController();
//    TextEditingController fillingController = TextEditingController();
    emailController.text = model.user.email;
    nameController.text = model.user.firstName;
    return YYDialog().build(context)
      ..borderRadius = 4.0
      ..gravity = Gravity.top
      ..margin = EdgeInsets.only(left: 10, right: 10, top: 40)
      ..text(
        padding: EdgeInsets.all(25.0),
        alignment: Alignment.topLeft,
        text: "This is my information.",
        color: Colors.black,
        fontSize: 14.0,
        fontWeight: FontWeight.w500,
      )
      ..widget(
          StatefulBuilder(
            builder: (BuildContext context, StateSetter setState){
              return Container(
                  margin: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          enabled: false,
                          maxLines: 1,
                          textCapitalization: TextCapitalization.characters,
                          keyboardType: TextInputType.url,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(4.0)),
                              hintText: "Phone number ..."),
                        ),
                        SizedBox(height: 10,),
                        TextFormField(
                          autofocus: true,
                          controller: nameController,
                          maxLines: 1,
                          validator: (_) => _.isEmpty ? "Please put the name" : null,
                          keyboardType: TextInputType.url,
                          onEditingComplete: (){
                          },
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(4.0)),
                              hintText: "Name ..."),
                        ),
                        SizedBox(height: 10,),
                        TextFormField(
                          controller: emailController,
                          maxLines: 1,
                          keyboardType: TextInputType.url,
                          validator: (_) => _.isEmpty ? "Please put Email" : null,
                          onEditingComplete: (){
                          },
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(4.0)),
                              hintText: "Email ..."),
                        )
                      ],
                    ),
                  ));
            },
          )
      )
      ..doubleButton(
        padding: EdgeInsets.only(top: 10),
        gravity: Gravity.right,
        withDivider: true,
        text1: "Cancel",
        isClickAutoDismiss: false,
        color1: Colors.blueGrey,
        fontSize1: 14.0,
        fontWeight1: FontWeight.bold,
        onTap1: () {
          print("Cancel");
          Navigator.pop(context);
        },
        text2: "Update",
        color2: Colors.red,
        fontSize2: 14.0,
        fontWeight2: FontWeight.bold,
        onTap2: () {
          if(_formKey.currentState.validate()){
            model.user.email = emailController.text;
            model.user.firstName = nameController.text;
            Navigator.pop(context);
            model.updateFirestore(widget, context);
          }
        },
      )
      ..animatedFunc = (child, animation) {
        return ScaleTransition(
          alignment: Alignment.topCenter,
          child: child,
          scale: Tween(begin: 0.0, end: 1.0).animate(animation),
        );
      }
      ..show();
  }



  YYDialog showHealthInfo(BuildContext context) {

    TextEditingController deseaseController = TextEditingController();
    TextEditingController ageController = TextEditingController();
    TextEditingController bloodGroupController = TextEditingController();

    GlobalKey<FormState> _formKey = GlobalKey<FormState>();

    deseaseController.text = model.user.desease;
    ageController.text = model.user.age;
    bloodGroupController.text = model.user.bloodGroup;


    return YYDialog().build(context)
      ..borderRadius = 4.0
      ..gravity = Gravity.top
      ..margin = EdgeInsets.only(left: 10, right: 10, top: 40)
      ..text(
        padding: EdgeInsets.all(25.0),
        alignment: Alignment.topLeft,
        text: "This is health information.",
        color: Colors.black,
        fontSize: 14.0,
        fontWeight: FontWeight.w500,
      )
      ..widget(
          StatefulBuilder(
            builder: (BuildContext context, StateSetter setState){
              return Container(
                  margin: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          maxLines: 1,
                          controller: deseaseController,
                          textCapitalization: TextCapitalization.characters,
                          keyboardType: TextInputType.url,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(4.0)),
                              hintText: "Disease (Optional)"),
                        ),
                        SizedBox(height: 10,),
                        TextFormField(
                          autofocus: true,
                          controller: ageController,
                          maxLines: 1,
                          validator: (_) => _.isEmpty ? "Please put age" : null,
                          keyboardType: TextInputType.url,
                          onEditingComplete: (){
                          },
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(4.0)),
                              hintText: "Age ..."),
                        ),
                        SizedBox(height: 10,),
                        TextFormField(
                          controller: bloodGroupController,
                          maxLines: 1,
                          validator: (_) => _.isEmpty ? "Please put blood group" : null,
                          keyboardType: TextInputType.url,
                          onEditingComplete: (){
                          },
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(4.0)),
                              hintText: "Blood group ..."),
                        )
                      ],
                    ),
                  ));
            },
          )
      )
      ..doubleButton(
        padding: EdgeInsets.only(top: 10),
        gravity: Gravity.right,

        withDivider: true,
        text1: "Cancel",
        color1: Colors.blueGrey,
        fontSize1: 14.0,
        isClickAutoDismiss: false,
        fontWeight1: FontWeight.bold,
        onTap1: () {
          print("Cancel");
          Navigator.pop(context);
        },
        text2: "Update",
        color2: Colors.red,
        fontSize2: 14.0,
        fontWeight2: FontWeight.bold,
        onTap2: () {
          if(_formKey.currentState.validate()){
            model.user.desease = deseaseController.text;
            model.user.age = ageController.text;
            model.user.bloodGroup = bloodGroupController.text;
            Navigator.pop(context);
            model.updateFirestore(widget, context);
          }
        },
      )
      ..animatedFunc = (child, animation) {
        return ScaleTransition(
          alignment: Alignment.topCenter,
          child: child,
          scale: Tween(begin: 0.0, end: 1.0).animate(animation),
        );
      }
      ..show();
  }

  YYDialog showHouseInfo(BuildContext context) {



//    TextEditingController fillingController = TextEditingController();

    adressController.text = model.user.address;
    districtController.text = model.user.district;
    provinceController.text = model.user.province;
    GlobalKey<FormState> _formKey = GlobalKey<FormState>();




    return YYDialog().build(context)
      ..borderRadius = 4.0
      ..gravity = Gravity.top
      ..margin = EdgeInsets.only(left: 10, right: 10, top: 40)
      ..text(
        padding: EdgeInsets.all(25.0),
        alignment: Alignment.topLeft,
        text: "This is my information.",
        color: Colors.black,
        fontSize: 14.0,
        fontWeight: FontWeight.w500,
      )
      ..widget(
          StatefulBuilder(
            builder: (BuildContext context, StateSetter setState){
              return Container(
                  margin: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: adressController,
                          autofocus: true,
                          maxLines: 1,
                          validator: (_) => _.isEmpty ? "Please put address" : null,
                          keyboardType: TextInputType.url,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(4.0)),
                              hintText: "address ..."),
                        ),
                        SizedBox(height: 10,),
                        TextFormField(
                          onTap: ()=> showDistrictsDialogue(),
                          controller: districtController,
                          maxLines: 1,
                          keyboardType: TextInputType.url,
                          validator: (_) => _.isEmpty ? "Please put district" : null,
                          onEditingComplete: (){
                          },
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(4.0)),
                              hintText: "district ..."),
                        ),
                        SizedBox(height: 10,),
                        TextFormField(
                          onTap: ()=> showProvinceDialogue(),
                          controller: provinceController,
                          maxLines: 1,
                          keyboardType: TextInputType.url,
                          validator: (_) => _.isEmpty ? "Please put province" : null,
                          onEditingComplete: (){
                          },
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(4.0)),
                              hintText: "Province ..."),
                        )
                      ],
                    ),
                  ));
            },
          )
      )
      ..doubleButton(
        padding: EdgeInsets.only(top: 10),
        gravity: Gravity.right,
        withDivider: true,
        text1: "Cancel",

        isClickAutoDismiss: false,
        color1: Colors.blueGrey,
        fontSize1: 14.0,
        fontWeight1: FontWeight.bold,
        onTap1: () {
          print("Cancel");
          Navigator.pop(context);
        },
        text2: "Update",
        color2: Colors.red,
        fontSize2: 14.0,
        fontWeight2: FontWeight.bold,
        onTap2: () {
          setState(() {
//            model.
          if(_formKey.currentState.validate()){
            model.user.address = adressController.text;
            model.user.district = districtController.text;
            model.user.province = provinceController.text;
            Navigator.pop(context);
            model.updateFirestore(widget, context);
          }
          });

        },
      )
      ..animatedFunc = (child, animation) {
        return ScaleTransition(
          alignment: Alignment.topCenter,
          child: child,
          scale: Tween(begin: 0.0, end: 1.0).animate(animation),
        );
      }
      ..show();
  }


  showDistrictsDialogue () {
    showMaterialDialog<String>(
      context: context,
      child: SimpleDialog(
        title: const Text('Select your district'),
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height * .35,
            width: MediaQuery.of(context).size.width *.80,
            child: ListView.builder(
                itemCount: districts.length,
                shrinkWrap: true,
                itemBuilder: (_, i){
                  return ListTile(
                    title:  Text(districts[i]),
                    leading: CircleAvatar(child: Text(districts[i][0])),
                    onTap: () {
                      Navigator.pop(context, 'Y');
                      districtController.text = districts[i];
                    },
                  );
                }),
          )
        ],
      ),
    );
  }

  showProvinceDialogue () {
    showMaterialDialog<String>(
      context: context,
      child: SimpleDialog(
        title: const Text('Select your province'),
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height * .35,
            width: MediaQuery.of(context).size.width *.80,
            child: ListView.builder(
                itemCount: provinces.length,
                shrinkWrap: true,
                itemBuilder: (_, i){
                  return ListTile(
                    title:  Text(provinces[i]),
                    leading: CircleAvatar(child: Text(provinces[i][0])),
                    onTap: () {
                      Navigator.pop(context, 'Y');
                      provinceController.text = provinces[i];
                    },
                  );
                }),
          )
        ],
      ),
    );
  }

  void showMaterialDialog<T>({ BuildContext context, Widget child }) {
    showDialog<T>(
      context: context,
      builder: (BuildContext context) => child,
    )
        .then<void>((T value) { // The value passed to Navigator.pop() or null.
      if (value != null) {
//        _scafoldKey.currentState.showSnackBar(SnackBar(
//          content: Text('You selected: $value'),
//        ));
      }
    });
  }



}
