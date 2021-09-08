import 'package:blood_app/models/chat_notification.dart';
import 'package:blood_app/models/chat_users.dart';
import 'package:blood_app/ui/chat/chat.dart';
import 'package:blood_app/ui/chat/chat_viewmodel.dart';
import 'package:blood_app/ui/home/response_viewmodel.dart';
import 'package:blood_app/util/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../base_main.dart';

class Response extends Base {
  @override
  _ResponseState createState() => _ResponseState();
}

class _ResponseState extends State<Response> {
  ResponseViewModel model;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    model = Provider.of<ResponseViewModel>(context, listen: false);
    model.fetchNotification();
    return Scaffold(
      key: _scaffoldKey,
        body: Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Consumer<ResponseViewModel>(
        builder: (_, model, child) {
          return ListView.builder(
              itemCount: model.list.length,
              itemBuilder: (_, i) {
                return model.list[i].user == null
                    ? Container(
                  margin: EdgeInsets.symmetric(vertical: 5),
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [CircularProgressIndicator()],
                  ),
                )
                    : Column(
                        children: [
                          ListTile(
                            onTap: (){
                              if(model.list[i].chatNotification.isDonor == null){
                                _scaffoldKey.currentState.showSnackBar(SnackBar(
                                  content: Text("Didn't see"),
                                ));
                              }else if(!model.list[i].chatNotification.isDonor){
                                _scaffoldKey.currentState.showSnackBar(SnackBar(
                                  content: Text("Request rejected"),
                                ));
                              }else{
//                                Navigator.push(context, MaterialPageRoute(
//                                  builder: (_) => ChangeNotifierProvider(
//                                    create: (context) => ChatViewModel(model.user, model.list[i].user, model.list[i].chatNotification),
//                                    lazy: false,
//                                    child: Chat(),
//                                  ),
//                                ));
                              }
                            },
                            contentPadding: EdgeInsets.only(top: 5, left: 10, bottom: 5),
                            leading: CircleAvatar(
                                backgroundColor: Colors.red,
                                radius: 30.0,
                                child: ClipOval(
                                  child: Text(
                                    model.list[i].user.bloodGroup,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                )),
                            title: Text(model.list[i].user.firstName),
                            subtitle: Text(model.list[i].chatNotification.isDonor == null ? "Do you want to donate the blood?" : model.list[i].chatNotification.isDonor ? "Great, Tap the text and chat with User" : "No problem, another individual will donate the blood."),
                            trailing: model.list[i].chatNotification.isDonor == null ? Wrap(
                              children: [
                                IconButton(
                                  onPressed: (){
                                    model.acceptRequest(model.list[i], widget, context);
                                  },
                                  icon: Icon(Icons.check, color: Colors.green,),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                IconButton(
                                  onPressed: (){
                                    model.rejectingRequest(model.list[i], widget, context);

                                  },
                                  icon: Icon(Icons.clear, color: Colors.red,),
                                )
                              ],
                            ) : SizedBox(width: 0, height: 0,) ,
                          ),
                          Divider(
                            height: 0.2,
                          )
                        ],
                      );
              });
        },
      ),
    ));
  }
  //                            subtitle: Text(model.list[i].chatNotification.isDonor == null ? "Not seen yet!" : model.list[i].chatNotification.isDonor ? "Accept"),
}
