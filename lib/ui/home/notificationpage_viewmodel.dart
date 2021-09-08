import 'package:blood_app/models/chat_notification.dart';
import 'package:blood_app/models/chat_users.dart';
import 'package:blood_app/models/user.dart';
import 'package:blood_app/ui/home/notifications_page.dart';
import 'package:blood_app/util/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import '../../base_main.dart';

class NotificationViewModel extends ChangeNotifier{
  User user;
  NotificationViewModel(this.user);
  List<ChatUsers> list = List();



  void fetchNotification(){
    list.clear();
    List<ChatUsers> listFilter = List();
    Firestore.instance.collection("chat_notification").where("senderUUID", isEqualTo: user.userId).getDocuments().then((value){
      value.documents.forEach((element) {
        ChatUsers chatUsers = ChatUsers();
        ChatNotification chatNotification = ChatNotification();
        chatNotification = ChatNotification.fromJson(element.data);
        chatNotification.documentId = element.documentID;
        chatUsers.chatNotification = chatNotification;
        Auth.getUserFirestore(chatNotification.recieverUUID)
            .then((value){
          chatUsers.user = value;
          print(chatUsers.user.bloodGroup);
          notifyListeners();
        });
        list.add(chatUsers);
      });

      for(int i =0; i < list.length; i++){
        print(retrieveTimeInInt(list[i].chatNotification.createdTimestamp));
        if(retrieveTimeInInt(list[i].chatNotification.createdTimestamp) == 0){
          listFilter.add(list[i]);
        }
      }
      list = listFilter;
      notifyListeners();
    });
  }

  int retrieveTimeInInt(int time){
    DateTime now  = DateTime.now();
    DateTime notification  = DateTime.fromMillisecondsSinceEpoch(time);
    int duration = now.difference(notification).inDays;
    return duration;
  }

  String retreiveTime(int time) {
    DateTime now  = DateTime.now();
    DateTime notification  = DateTime.fromMillisecondsSinceEpoch(time);
    int duration = now.difference(notification).inSeconds;
    String timeAgo = " Seconds ago";
    if(duration > 60){
       duration = now.difference(notification).inMinutes;
       timeAgo = " Minutes ago";
    }
    if(duration > 60){
      duration = now.difference(notification).inHours;
      timeAgo = " Hourse ago";
    }
    if(duration > 24){
      duration = now.difference(notification).inDays;
      timeAgo = " Days ago";
    }
    return duration.toString() + timeAgo;
  }


  void deleteNotification(ChatUsers list, BuildContext context,Base widget) {
    widget.showProgressDialogue(context, "Deleting request");
    print(list.chatNotification.documentId);
    Firestore.instance.collection("chat_notification").document(list.chatNotification.documentId).delete().then((value) {
      widget.dissmissProgressDialgue().then((value){
        if(value){
          this.list.remove(list);
          notifyListeners();
        }
      });
    });

  }
}