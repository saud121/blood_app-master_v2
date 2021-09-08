import 'package:blood_app/base_main.dart';
import 'package:blood_app/models/user.dart';
import 'package:blood_app/ui/home/home.dart';
import 'package:blood_app/ui/home/home_viewmodel.dart';
import 'package:blood_app/ui/widgets/loading.dart';
import 'package:blood_app/util/auth.dart';
import 'package:blood_app/util/validator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geocoder/model.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

class AdressRegistration extends Base {
 User user;
 AdressRegistration(this.user);
  @override
  _AdressRegistrationState createState() => _AdressRegistrationState();
}

class _AdressRegistrationState extends State<AdressRegistration> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scafoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController currentAddressController = new TextEditingController();
  final TextEditingController addressController = new TextEditingController();
  final TextEditingController districtController = new TextEditingController();
  final TextEditingController provinceController = new TextEditingController();
  final TextEditingController countryController = new TextEditingController();
  List<String> provinces = ["Balochistan", "KPK", "Sindh", "Punjab"];
  List<String> districts = ["Quetta", "Bostan", "Mastung", "Pishin"];
  FirebaseAuth _mAuth;


  bool _autoValidate = false;
  bool _loadingVisible = false;

  @override
  Widget build(BuildContext context) {
    getLocation();

    final logo = Hero(
      tag: 'hero',
      child: CircleAvatar(
          backgroundColor: Colors.red,
          radius: 90.0,
          child: ClipOval(
            child: SvgPicture.asset("assets/images/house.svg",
              width: MediaQuery.of(context).size.width * 0.17,
              height: MediaQuery.of(context).size.height * 0.17,
              placeholderBuilder: (_) => CircularProgressIndicator(),
            ),
          )),
    );


    final currentaddress = TextFormField(
      autofocus: false,
      textCapitalization: TextCapitalization.words,
      controller: currentAddressController,
      enabled: false,
      validator: Validator.validateEmptyField,
      decoration: InputDecoration(
        prefixIcon: Padding(
          padding: EdgeInsets.only(left: 5.0),
          child: Icon(
            Icons.home,
            color: Colors.grey,
          ), // icon is 48px widget.
        ), // icon is 48px widget.
        hintText: 'Enable your location please ...',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );




    final address = TextFormField(
      autofocus: false,
      textCapitalization: TextCapitalization.words,
      controller: addressController,
      validator: Validator.validateEmptyField,
      decoration: InputDecoration(
        prefixIcon: Padding(
          padding: EdgeInsets.only(left: 5.0),
          child: Icon(
            Icons.home,
            color: Colors.grey,
          ), // icon is 48px widget.
        ), // icon is 48px widget.
        hintText: 'Put your permenent address',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final district = TextFormField(
      onTap: ()=> showDistrictsDialogue(),
      autofocus: false,
      textCapitalization: TextCapitalization.words,
      controller: districtController,
      validator: Validator.validateEmptyField,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.calendar_view_day), // icon is 48px widget.
        hintText: 'Enter your District',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
      style: TextStyle(
          fontSize: 16
      ),
    );

    final province = TextFormField(
      onTap: ()=> showProvinceDialogue(),
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      controller: provinceController,
      validator: Validator.validateEmptyField,
      decoration: InputDecoration(
        prefixIcon: Padding(
          padding: EdgeInsets.only(left: 5.0),
          child: Icon(
            Icons.account_balance,
            color: Colors.grey,
          ), // icon is 48px widget.
        ), // icon is 48px widget.
        hintText: 'Enter your Province',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

//    final password = TextFormField(
//      autofocus: false,
//      obscureText: true,
//      controller: _password,
//      validator: Validator.validatePassword,
//      decoration: InputDecoration(
//        prefixIcon: Padding(
//          padding: EdgeInsets.only(left: 5.0),
//          child: Icon(
//            Icons.lock,
//            color: Colors.grey,
//          ), // icon is 48px widget.
//        ), // icon is 48px widget.
//        hintText: 'Password',
//        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
//        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
//      ),
//    );

    final signUpButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        onPressed: () {
          _emailSignUp(
              district: districtController.text,
              province: provinceController.text,
              address: addressController.text,
//              password: _password.text,
              context: context);
        },
        padding: EdgeInsets.all(12),
        color: Theme.of(context).primaryColor,
        child: Text('Complete Registration', style: TextStyle(color: Colors.white)),
      ),
    );

    final signInLabel = FlatButton(
      child: Text(
        'Cancel Registration',
        style: TextStyle(color: Colors.black54),
      ),
      onPressed: () {
        Navigator.pop(context);

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
                      currentaddress,
                      SizedBox(height: 16.0),
                      address,
                      SizedBox(height: 16.0),
                      district,
                      SizedBox(height: 16.0),
                      province,
//                      SizedBox(height: 16.0),
//                      password,
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


  void _emailSignUp(
      {String address,
        String district,
        String province,
        BuildContext context}) async {


    if(currentAddressController.text.isEmpty){
      _scafoldKey.currentState.showSnackBar(
          new SnackBar(content: Text("Please enable the location to get your current location."),
          backgroundColor: Colors.red,
          ));
      return;
    }
    if (_formKey.currentState.validate()) {
      try {
        SystemChannels.textInput.invokeMethod('TextInput.hide');
        //need await so it has chance to go through error if found.
       widget.showProgressDialogue(context, "Creating user...");
      widget.user.address = address;
      widget.user.currentAddress = currentAddressController.text;
      widget.user.district = district;
      widget.user.province = province;
      widget.user.country = "Pakistan";


        // _mAuth = FirebaseAuth.instance;
        // print(widget.user.toJson());
        // _mAuth.createUserWithEmailAndPassword(
        //   email: widget.user.email,
        //   password: widget.user.password,
        // );
       Future<FirebaseUser> firebaseUser = FirebaseAuth.instance.currentUser();
       firebaseUser.then((fbUser){
         if(fbUser != null){
           widget.user.userId = fbUser.uid;
           print(widget.user.toJson());
           Auth.addUserSettingsDB(widget.user, fbUser);
//            widget.pr.hide();
           Navigator.pushAndRemoveUntil(
               context,
               MaterialPageRoute(
                 builder: (_) => ChangeNotifierProvider(
                   create: (context) => HomeViewModel(0),
                   lazy: false,
                   child: Home(),
                 ),
               ),
                   (e) => false);
         }
       });

      } catch (e) {
        widget.dissmissProgressDialgue();
//        _changeLoadingVisible();
        print("Sign Up Error: $e");
//        String exception = Auth.getExceptionText(e);
//        _scafoldKey.currentState.showSnackBar(new SnackBar(content: new Text("Sign Up Error")));
        _scafoldKey.currentState.showSnackBar(
            new SnackBar(content: Text(e.toString())));

      }
    } else {
      setState(() => _autoValidate = true);
    }
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

  void getLocation() async{
    print("address informatics");
    Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    print("asd");
    print(position);

    final coordinates = new Coordinates(position.latitude, position.longitude);
    widget.user.point = GeoPoint(coordinates.latitude, coordinates.longitude);
    print(coordinates);
    var addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
    print(addresses.first);
    var first = addresses.first;
    print(first.addressLine);
    setState(() {
      currentAddressController.text = first.addressLine;
    });
    print("${first.featureName} : ${first.addressLine}");

  }


}
