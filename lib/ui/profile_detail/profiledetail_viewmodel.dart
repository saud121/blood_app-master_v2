import 'package:blood_app/models/chat_notification.dart';
import 'package:blood_app/models/constants.dart';
import 'package:blood_app/models/user.dart';
import 'package:blood_app/ui/home/home.dart';
import 'package:blood_app/ui/home/home_viewmodel.dart';
import 'package:blood_app/ui/profile_detail/profile_detail.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../base_main.dart';

class ProfileDetailViewModel extends ChangeNotifier{
  User user;
  User currentuser;
  ProfileDetailViewModel(this.user, this.currentuser);

  void sendNotification(Base widget, BuildContext context) {
    int now = DateTime.now().millisecondsSinceEpoch;

    ChatNotification chatNotification = ChatNotification(
      senderTokenId: currentuser.deviceToken,
      recieverTokenId: user.deviceToken,
      recieverUUID: user.userId,
      senderUUID: currentuser.userId,
      createdTimestamp: now,
      isDonor: null,
      isSeen: false,
      seenTimestamp: null,
    );
    print(chatNotification.toJson());

    widget.showProgressDialogue(context, "Sending Notification");
    Firestore.instance.collection(Constants.CHAT_NOTIFICATION)
        .document(currentuser.userId + user.userId).setData(chatNotification.toJson()).then((value){
          widget.dissmissProgressDialgue().then((value){
            if(value){
              Navigator.push(context, MaterialPageRoute(
                builder: (_) => ChangeNotifierProvider(
                  create: (context) => HomeViewModel(1),
                  lazy: false,
                  child: Home(),
                ),
              ));
            }
          });
    });
  }
}