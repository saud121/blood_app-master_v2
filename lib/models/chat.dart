import 'package:blood_app/models/user.dart';
import 'package:blood_app/ui/chat/chat.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Chat{
  String documentId;
  String senderUUID;
  String recieverUUID;
  int created_at;


  Chat({this.senderUUID, this.recieverUUID, this.created_at});

  factory Chat.fromJson(Map<String, dynamic> json) => new Chat(
    senderUUID: json["sendUUID"],
    recieverUUID: json["recieverUUID"],
    created_at: json["created_at"],
  );



  factory Chat.fromDocument(DocumentSnapshot doc) {
    return Chat.fromJson(doc.data);
  }


}



class ChatUser{
  Chat chat;
  User sender;
  User reciever;

  ChatUser({this.chat, this.sender, this.reciever});
}