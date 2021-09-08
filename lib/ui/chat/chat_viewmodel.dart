import 'package:blood_app/models/chat_notification.dart';
import 'package:blood_app/models/user.dart';
import 'package:blood_app/ui/chat/chat.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';

class ChatViewModel extends ChangeNotifier{
  User sender;
  User receiver;
  String chatId;

//  ChatNotification chatNotification;
  ChatViewModel(this.sender, this.receiver, this.chatId,);

  void sendMessage(String text, Chat widget, ) async {
    Map<String, Object>  data = Map();
    data['message'] = text;
    data['messageType'] = "txt";
    data['messageTime'] = DateTime.now();
    data['senderUUID'] = sender.userId;
    data['senderName'] = sender.firstName;
    data['senderBloodGroup'] = sender.bloodGroup;
    data['recieverUUID'] = receiver.userId;
    data['recieverName'] = receiver.firstName;
    data['recieverBloodGroup'] = receiver.bloodGroup;


    print(chatId);
    await Firestore.instance
        .collection("chat")
        .document(chatId)
        .collection("chat")
        .add(data);
  }

  void sendMapLocation(Position position, Chat widget, ) async {

    String text = "http://maps.google.com/maps?q=loc:${position.latitude},${position.longitude}";

    Map<String, Object>  data = Map();
    data['message'] = text;
    data['messageType'] = "location";
    data['messageTime'] = DateTime.now();
    data['senderUUID'] = sender.userId;
    data['senderName'] = sender.firstName;
    data['senderBloodGroup'] = sender.bloodGroup;
    data['recieverUUID'] = receiver.userId;
    data['recieverName'] = receiver.firstName;
    data['recieverBloodGroup'] = receiver.bloodGroup;


    print(chatId);
    await Firestore.instance
        .collection("chat")
        .document(chatId)
        .collection("chat")
        .add(data);
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


}