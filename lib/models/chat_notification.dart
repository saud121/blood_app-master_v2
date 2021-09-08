import 'package:cloud_firestore/cloud_firestore.dart';

class ChatNotification{
  String documentId;
  String senderTokenId;
  String recieverTokenId;
  bool isDonor;
  bool isSeen;
  int createdTimestamp;
  int seenTimestamp;
  String senderUUID;
  String recieverUUID;


  ChatNotification(
     {this.documentId,
      this.senderTokenId,
      this.recieverTokenId,
      this.isDonor,
      this.isSeen,
      this.createdTimestamp,
      this.seenTimestamp,
      this.senderUUID,
      this.recieverUUID});

  Map<String, dynamic> toJson() => {
    "senderTokenId": senderTokenId,
    "recieverTokenId": recieverTokenId,
    "isDonor": isDonor,
    "isSeen": isSeen,
    "createdTimestamp": createdTimestamp,
    "seenTimestamp": seenTimestamp,
    "senderUUID": senderUUID,
    "recieverUUID": recieverUUID,
  };
  factory ChatNotification.fromJson(Map<String, dynamic> json) => new ChatNotification(
    senderTokenId: json["senderTokenId"],
    recieverTokenId: json["recieverTokenId"],
    isDonor: json["isDonor"],
    isSeen: json["isSeen"],
    createdTimestamp: json["createdTimestamp"],
    seenTimestamp: json["seenTimestamp"],
    senderUUID: json["senderUUID"],
    recieverUUID: json["recieverUUID"],
  );
  factory ChatNotification.fromDocument(DocumentSnapshot doc) {
    return ChatNotification.fromJson(doc.data);
  }

}