import 'package:blood_app/base_main.dart';
import 'package:blood_app/models/constants.dart';
import 'package:blood_app/ui/home/profilepage_viewmodel.dart';
import 'package:blood_app/ui/profile_detail/profiledetail_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileDetail extends Base {
  @override
  _ProfileDetailState createState() => _ProfileDetailState();
}

class _ProfileDetailState extends State<ProfileDetail> {
  ProfileDetailViewModel model;
  @override
  Widget build(BuildContext context) {
    model = Provider.of<ProfileDetailViewModel>(context, listen: false);
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text("Details"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: width,
              height: height * .15,
              child: Row(
                mainAxisAlignment:MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 10,
                  ),CircleAvatar(
                      backgroundColor: Colors.red,
                      radius: 50.0,
                      child: ClipOval(
                        child: Text(model.user.bloodGroup, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),),
                      )),
                  SizedBox(
                    width: 30,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Container(
                      //   child: Text(model.user.firstName, style: TextStyle(color: Colors.black, fontWeight: FontWeight.normal, fontSize: 20),),
                      // ),
                      Container(
                        // child: Text(model.user.phone_number, style: TextStyle(color: Colors.black, fontWeight: FontWeight.normal, fontSize: 20),),
                      ),
                      // Container(
                      //   child: Text(model.user.email, style: TextStyle(color: Colors.black, fontWeight: FontWeight.normal, fontSize: 20),),
                      // ),
                    ],
                  )
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  onPressed: (){_message(model.user.phone_number);},
                  icon:Icon(Icons.message, color: Colors.yellow,),
                ),
                IconButton(
                  onPressed: (){_call(model.user.phone_number);},
                  icon: Icon(Icons.call, color: Colors.blue,),
                ),
                IconButton(
                  onPressed: (){_whatsapp(model.user.phone_number);},
                  icon: Icon(FontAwesomeIcons.whatsapp, color: Colors.green,),
                ),
                IconButton(
                  onPressed: (){model.sendNotification(widget, context);},
                  icon:  Icon(Icons.notifications, color: Colors.blue,),
                )
              ],
            ),
            ListTile(
              leading: Icon(Icons.email),
              title: Text(model.user.age),
              subtitle: Text("Age"),
            ),
            ListTile(
              leading: Icon(Icons.healing),
              title: Text(model.user.desease),
              subtitle: Text("Disease"),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text(model.user.address),
              subtitle: Text("Address"),
            ),
            ListTile(
              leading: Icon(Icons.add_box),
              title: Text(model.user.district),
              subtitle: Text("District"),
            ),
            ListTile(
              leading: Icon(Icons.account_balance),
              title: Text(model.user.province),
              subtitle: Text("Province"),
            )
          ],
        ),
      ),
    );

  }

  _call(String phoneNumber) async {
    launch('tel:' + phoneNumber);
  }
  _mail(String email) async {
    final Uri _emailLaunchUri = Uri(
        scheme: 'mailto',
        path: email,
        queryParameters: {
          'subject': 'Important announcement'
        }
    );
    launch(_emailLaunchUri.toString());
  }

  _message(String phone) async {
    launch('sms:' + phone);
  }

  Future<void> _whatsapp(String phone) async {
    var whatsappUrl = "whatsapp://send?phone=$phone";

    await canLaunch(whatsappUrl)
        ? launch(whatsappUrl)
        : print(
        Constants.WHATSAPP_NOT_INSTALLED);
  }
}
