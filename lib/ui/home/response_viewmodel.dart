import 'package:blood_app/models/chat_notification.dart';
import 'package:blood_app/models/chat_users.dart';
import 'package:blood_app/models/constants.dart';
import 'package:blood_app/models/user.dart';
import 'package:blood_app/ui/chat/chat.dart';
import 'package:blood_app/ui/chat/chat_viewmodel.dart';
import 'package:blood_app/ui/home/response.dart';
import 'package:blood_app/util/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../base_main.dart';

class ResponseViewModel extends ChangeNotifier {
  User user;
  List<ChatUsers> list = List();

  ResponseViewModel(this.user);

  void fetchUser(ChatUsers chatUsers) async {
    chatUsers.user =
        await Auth.getUserFirestore(chatUsers.chatNotification.recieverUUID);
  }

  void fetchNotification() {
    list.clear();
    Firestore.instance
        .collection("chat_notification")
        .where("recieverUUID", isEqualTo: user.userId)
        .getDocuments()
        .then((value) {
      value.documents.forEach((element) {
        ChatUsers chatUsers = ChatUsers();
        ChatNotification chatNotification = ChatNotification();
        chatNotification = ChatNotification.fromJson(element.data);
        chatNotification.documentId = element.documentID;
        chatUsers.chatNotification = chatNotification;
        Auth.getUserFirestore(chatNotification.senderUUID).then((value) {
          chatUsers.user = value;
          print(chatUsers.user.bloodGroup);
          notifyListeners();
        });
        list.add(chatUsers);
      });
      notifyListeners();
    });
  }

  void acceptRequest(ChatUsers list, Base widget, BuildContext context) {
    widget.showProgressDialogue(context, "Accepting request");
    // print(list.chatNotification.);
    list.chatNotification.isDonor = true;
    Firestore.instance
        .collection(Constants.CHAT_NOTIFICATION)
        .document(list.chatNotification.documentId)
        .updateData(list.chatNotification.toJson())
        .then((value) {
      Map<String, Object> data = Map();
      // Map<String, Object> chatMap = Map();
      data['sendUUID'] = list.chatNotification.senderUUID;
      data['recieverUUID'] = list.chatNotification.recieverUUID;
      data['created_at'] = DateTime.now().millisecondsSinceEpoch;

      Firestore.instance.collection("chat").document(list.chatNotification.documentId).setData(data).then((value) => {
            widget.dissmissProgressDialgue().then((value) => {
                  if (value)
                    {
//                      Navigator.push(
//                          context,
//                          MaterialPageRoute(
//                            builder: (_) => ChangeNotifierProvider(
//                              create: (context) => ChatViewModel(
//                                  user, list.user, list.chatNotification),
//                              lazy: false,
//                              child: Chat(),
//                            ),
//                          ))

      notifyListeners()
      }
                })
          });
    });
  }

  void rejectingRequest(ChatUsers list, Base widget, BuildContext context) {
    widget.showProgressDialogue(context, "Rejecting request");
    list.chatNotification.isDonor = false;
    Firestore.instance
        .collection(Constants.CHAT_NOTIFICATION)
        .document(list.chatNotification.documentId)
        .updateData(list.chatNotification.toJson())
        .then((value) {
      widget.dissmissProgressDialgue().then((value) {
        if (value) {
          print("Rejected");
          notifyListeners();
        }
      });
    });
  }
}
