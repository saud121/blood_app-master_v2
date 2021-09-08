import 'package:blood_app/base_main.dart';
import 'package:blood_app/models/chat_notification.dart';
import 'package:blood_app/models/constants.dart';
import 'package:blood_app/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePageViewModel extends ChangeNotifier{

  User userCurrent;
  List<User> users = List();
  bool isEmpty = false;
  bool isLoading = false;
  String bloodGroup;
  HomePageViewModel(this.userCurrent, this.users, this.bloodGroup);
  void filterTheList(String s) {}

  // void usersList() async {
  //   users.clear();
  //  QuerySnapshot userSnaps = await Firestore.instance.collection("users").where("availability", isEqualTo: true).getDocuments();
  //  userSnaps.documents.forEach((element) {
  //    if(element.documentID != userCurrent.userId){
  //      users.add(User.fromDocument(element));
  //    }
  //  });
  //  print("asdasd");
  //  isEmpty = users.length == 0;
  //  isLoading = false;
  //  notifyListeners();
  // }

  void fetchUser(String district) async{
    users.clear();
    isLoading = true;
    QuerySnapshot userSnaps = await Firestore.instance.collection("users").where("availability", isEqualTo: true).where("district", isEqualTo: district).getDocuments();
    userSnaps.documents.forEach((element) {
      if(element.documentID != userCurrent.userId){
        users.add(User.fromDocument(element));
      }
    });
    print("asdasd");
    isEmpty = users.length == 0;
    isLoading = false;
    notifyListeners();
  }

  void sendBroadcast (Base widget, BuildContext context,) {
    for(int i =0; i < users.length; i++){
      if(users[i].userId != userCurrent.userId){
        sendNotification(widget, context, users[i]);
      }
    }
  }




  void sendNotification(Base widget, BuildContext context, User user) {
    int now = DateTime.now().millisecondsSinceEpoch;
    ChatNotification chatNotification = ChatNotification(
      senderTokenId: userCurrent.deviceToken,
      recieverTokenId: user.deviceToken,
      recieverUUID: user.userId,
      senderUUID: userCurrent.userId,
      createdTimestamp: now,
      isDonor: null,
      isSeen: false,
      seenTimestamp: null,
    );
    print(chatNotification.toJson());
    Firestore.instance.collection(Constants.CHAT_NOTIFICATION)
        .document(userCurrent.userId + user.userId).setData(chatNotification.toJson()).then((value){
          widget.dissmissProgressDialgue();
    });
  }


}