import 'package:blood_app/models/chat_notification.dart';
import 'package:blood_app/models/chat_users.dart';
import 'package:blood_app/ui/chat/chat.dart';
import 'package:blood_app/ui/chat/chat_viewmodel.dart';
import 'package:blood_app/ui/home/notificationpage_viewmodel.dart';
import 'package:blood_app/util/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

import '../../base_main.dart';

class NotificationsPage extends Base {
  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<ChatUsers> list = List();
  NotificationViewModel model;
  double width, height;

  @override
  Widget build(BuildContext context) {
    model = Provider.of<NotificationViewModel>(context, listen: false);
    model.fetchNotification();
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Scaffold(
        key: _scaffoldKey,
        body: Scaffold(
          body: Container(
              width: width,
              height: height,
              child:
                  Consumer<NotificationViewModel>(builder: (_, model, child) {
                return ListView.builder(
                    itemCount: model.list.length,
                    itemBuilder: (_, i) {
                      return model.list[i].user == null ?
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [CircularProgressIndicator()],
                        ),
                      ):
                      Column(
                        children: [
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 5),
                            child: Slidable(
                              actionPane: SlidableDrawerActionPane(),
                              actionExtentRatio: 0.25,
                              child: Container(
                                child: ListTile(
                                  onTap: (){
                                    if(model.list[i].chatNotification.isDonor == null){
                                      _scaffoldKey.currentState.showSnackBar(SnackBar(
                                        content: Text("Request is still pending"),
                                      ));
                                    }else if(!model.list[i].chatNotification.isDonor){
                                      _scaffoldKey.currentState.showSnackBar(SnackBar(
                                        content: Text("Request rejected"),
                                      ));
                                    }else{
//                                      Navigator.push(context, MaterialPageRoute(
//                                        builder: (_) => ChangeNotifierProvider(
//                                          create: (context) => ChatViewModel(model.user, model.list[i].user, model.list[i].chatNotification),
//                                          lazy: false,
//                                          child: Chat(),
//                                        ),
//                                      ));
                                    }
                                  },
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
                                  subtitle: Text(model.retreiveTime(model
                                      .list[i].chatNotification.createdTimestamp
                                      )),
                                  trailing: returnChip(i),
                                ),
                              ),
                              secondaryActions: <Widget>[
                                IconSlideAction(
                                  caption: 'Delete',
                                  color: Colors.red,
                                  icon: Icons.delete,
                                  onTap: () {
                                    model.deleteNotification(model.list[i], context, widget);
                                  },
                                ),
                              ],
                            ),
                          ),
                          Divider(height: 0.2,)
                        ],
                      );
                    });
              })),
        ));
  }

  returnChip(int i) {
    if(model.retrieveTimeInInt(model.list[i].chatNotification.createdTimestamp) > 0){
      return Chip(
        backgroundColor: Colors.redAccent,
        label: Text("Expired"),
      );
    }
    return  Chip(
      backgroundColor:  model.list[i].chatNotification.isDonor == null ? Colors.blue :
      model.list[i].chatNotification.isDonor ? Colors.green : Colors.red,
      label: model.list[i].chatNotification.isDonor == null ? Text("Pending", style: TextStyle(color: Colors.white),) :
        model.list[i].chatNotification.isDonor ? Text("Accepted", style: TextStyle(color: Colors.white)) : Text("Rejected", style: TextStyle(color: Colors.white)),
    );
  }
}
