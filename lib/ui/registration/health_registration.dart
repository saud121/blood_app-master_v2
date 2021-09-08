import 'package:blood_app/models/blood.dart';
import 'package:blood_app/models/user.dart';
import 'package:blood_app/ui/registration/address_registration.dart';
import 'package:blood_app/ui/widgets/loading.dart';
import 'package:blood_app/util/validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';

class Health extends StatefulWidget {
  User user;

  Health(this.user);

  @override
  _HealthState createState() => _HealthState();
}

class _HealthState extends State<Health> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scafoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController deseaseController = new TextEditingController();
  final TextEditingController ageController = new TextEditingController();
  final TextEditingController bloodController = new TextEditingController();

//  final TextEditingController deseaseController = new TextEditingController();
  bool isDesease = false;

  String deviceToken = '';
  bool _autoValidate = false;
  bool _loadingVisible = false;

  List<String> deseaseList = [
    "Cancer",
  "Cardiac disease",
  "Sever lung disease",
  "Hepatitis B and C",
  "HIV infection, AIDS or Sexually Transmitted Diseases (STD)",
  "High risk occupation (e.g. prostitution)",
  "Unexplained weight loss of more than 5 kg over 6 months",
  "Chronic alcoholism",
  "Other conditions or disease stated in the Guide to Medical Assessment of Blood Donors"
];

  @override
  Widget build(BuildContext context) {
    final logo = Hero(
      tag: 'hero',
      child: CircleAvatar(
          backgroundColor: Colors.red,
          radius: 90.0,
          child: ClipOval(
            child: SvgPicture.asset(
              "assets/images/health.svg",
              width: MediaQuery.of(context).size.width * 0.17,
              height: MediaQuery.of(context).size.height * 0.17,
              placeholderBuilder: (_) => CircularProgressIndicator(),
            ),
          )),
    );



    final desease = ListTile(
      contentPadding: EdgeInsets.all(0.0),
      leading: Padding(
        padding: EdgeInsets.only(left: 5.0),
        child: Icon(
          Icons.person,
        ), // icon is 48px widget.
      ),
      title: Text("Do you have any desease?"),
      trailing: Padding(
        padding: EdgeInsets.only(right: 5.0),
        child: Switch(
          onChanged: (_) {
            setState(() {
              isDesease = _;
            });
          },
          value: isDesease,
        ), // icon is 48px widget.
      ),
    );

//
//    TextFormField(
//      autofocus: false,
//      textCapitalization: TextCapitalization.words,
//      validator: Validator.validateEmptyField,
//      initialValue: '',
//      decoration: InputDecoration(
//        prefixIcon: Padding(
//          padding: EdgeInsets.only(left: 5.0),
//          child: Icon(
//            Icons.person,
//          ), // icon is 48px widget.
//        ),
//        // icon is 48px widget.
//        suffixIcon: Padding(
//          padding: EdgeInsets.only(right: 5.0),
//          child: Switch(
//            onChanged: (_) {
//              setState(() {
//                isDesease = _;
//              });
//            },
//            value: isDesease,
//          ), // icon is 48px widget.
//        ),
//        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
//        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
//      ),
//    );
    final deseaseName = TextFormField(
      autofocus: false,
      textCapitalization: TextCapitalization.words,
      controller: deseaseController,
      validator: Validator.validateEmptyField,
      onTap: (){
        showDeseaseDialogue();
      },
      decoration: InputDecoration(
        hintText: "Select the desease",
        prefixIcon: Padding(
          padding: EdgeInsets.only(left: 5.0),
          child: Icon(
            Icons.person,
          ), // icon is 48px widget.
        ), // icon is 48px widget.
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final age = TextFormField(
      keyboardType: TextInputType.number,
      maxLength: 2,
      autofocus: false,
      textCapitalization: TextCapitalization.words,
      controller: ageController,
      validator: Validator.validateEmptyField,
      decoration: InputDecoration(
        prefixIcon: Padding(
            padding: EdgeInsets.only(left: 5.0),
            child:
                Icon(Icons.airline_seat_flat_angled)), // icon is 48px widget.
        hintText: 'Enter your age...',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
      style: TextStyle(fontSize: 16),
    );

    final bloodGroup = TextFormField(
      onTap: () => showBloodDialogue(),
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      controller: bloodController,
      validator: Validator.validateEmptyField,
      decoration: InputDecoration(
        prefixIcon: Padding(
          padding: EdgeInsets.only(left: 5.0),
          child: Icon(
            Icons.email,
            color: Colors.grey,
          ), // icon is 48px widget.
        ), // icon is 48px widget.
        hintText: 'Enter your blood group',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final signUpButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        onPressed: () {
          _emailSignUp(
              desease: deseaseController.text,
              age: ageController.text,
              bloodgroup: bloodController.text,
//              password: _password.text,
              context: context);
        },
        padding: EdgeInsets.all(12),
        color: Theme.of(context).primaryColor,
        child: Text('Continue Registration',
            style: TextStyle(color: Colors.white)),
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
                      desease,
                      isDesease ? Column(
                        children: [
                          SizedBox(height: 16.0),
                          deseaseName,
                        ],
                      ) : Container(),
                      SizedBox(height: 16.0),
                      age,
                      SizedBox(height: 16.0),
                      bloodGroup,
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

  showBloodDialogue() {
    showMaterialDialog<String>(
      context: context,
      child: SimpleDialog(
        title: const Text('Select your blood group'),
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height * .5,
            width: MediaQuery.of(context).size.width * .80,
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: bloodList.length,
                itemBuilder: (_, i) {
                  return ListTile(
                    title: Text(bloodList[i].blood + bloodList[i].group),
                    leading: CircleAvatar(
                        child:
                            Text(bloodList[i].blood[0] + bloodList[i].group)),
                    onTap: () {
                      Navigator.pop(context, 'Y');
                      bloodController.text =
                          bloodList[i].blood + bloodList[i].group;
                    },
                  );
                }),
          )
        ],
      ),
    );
  }


  showDeseaseDialogue() {
    showMaterialDialog<String>(
      context: context,
      child: SimpleDialog(
        title: const Text('Select your desease'),
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height * .5,
            width: MediaQuery.of(context).size.width * .80,
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: deseaseList.length,
                itemBuilder: (_, i) {
                  return ListTile(
                    title: Text(deseaseList[i]),
                    leading: CircleAvatar(
                        child:
                        Text(deseaseList[i][0])),
                    onTap: () {
                      Navigator.pop(context, 'Y');
                      deseaseController.text =
                          deseaseList[i];
                    },
                  );
                }),
          )
        ],
      ),
    );
  }

  void showMaterialDialog<T>({BuildContext context, Widget child}) {
    showDialog<T>(
      context: context,
      builder: (BuildContext context) => child,
    ).then<void>((T value) {
      // The value passed to Navigator.pop() or null.
      if (value != null) {
//        _scafoldKey.currentState.showSnackBar(SnackBar(
//          content: Text('You selected: $value'),
//        ));
      }
    });
  }

  void _emailSignUp(
      {String desease,
      String age,
      String bloodgroup,
      BuildContext context}) async {
    if (_formKey.currentState.validate()) {
      try {
        SystemChannels.textInput.invokeMethod('TextInput.hide');
//        await _changeLoadingVisible();
        //need await so it has chance to go through error if found.

        widget.user.bloodGroup = bloodController.text;
        widget.user.age = ageController.text;
        widget.user.desease = deseaseController.text;
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AdressRegistration(
               widget.user,
              ),
            ));
      } catch (e) {
//        _changeLoadingVisible();
        print("Sign Up Error: $e");
//        String exception = Auth.getExceptionText(e);
//        _scafoldKey.currentState.showSnackBar(new SnackBar(content: new Text("Sign Up Error")));
        _scafoldKey.currentState.showSnackBar(new SnackBar(content: Text(e)));
      }
    } else {
      setState(() => _autoValidate = true);
    }
  }
}
