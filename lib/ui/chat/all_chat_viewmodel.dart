import 'package:blood_app/models/chat.dart';
import 'package:blood_app/models/user.dart';
import 'package:blood_app/util/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';


class AllChatViewModel extends ChangeNotifier{
  User user;
  AllChatViewModel(this.user);
  List<ChatUser> sendlist = List();
  List<ChatUser> recievelist = List();
  bool isSendLoading = true;
  bool isReceiveLoading = true;
  bool isSendEmpty = false;
  bool isReceiveEmpty = false;
  Firestore _fireStoreDataBase = Firestore.instance;


  void fetchSendChatUser(){
    print(user.userId);

    Firestore.instance.collection("chat").where("sendUUID", isEqualTo: user.userId ).getDocuments().then((value) {
      value.documents.forEach((element){
        ChatUser chatUser = ChatUser();
        Chat chat = Chat.fromJson(element.data);
        chat.documentId = element.documentID;
        print(chat.recieverUUID);
        print(chat.senderUUID);
        chatUser.chat = chat;
        Auth.getUserFirestore(chat.senderUUID).then((value) {
          chatUser.sender = value;
          notifyListeners();
        });
        Auth.getUserFirestore(chat.recieverUUID).then((value){
           chatUser.reciever = value;
           notifyListeners();
        });
        sendlist.add(chatUser);
      });
      isSendLoading = false;
      isSendEmpty = sendlist.length == 0;
      print(sendlist.length);
      print(isSendEmpty);
      notifyListeners();
    });
  }
  void fetchReceiveChatUser(){
    print(user.userId);

    Firestore.instance.collection("chat").where("recieverUUID", isEqualTo: user.userId ).getDocuments().then((value) {
      value.documents.forEach((element){
        ChatUser chatUser = ChatUser();
        Chat chat = Chat.fromJson(element.data);
        chat.documentId = element.documentID;
        print(chat.recieverUUID);
        print(chat.senderUUID);
        chatUser.chat = chat;
        Auth.getUserFirestore(chat.senderUUID).then((value) {
          chatUser.sender = value;
          notifyListeners();
        });
        Auth.getUserFirestore(chat.recieverUUID).then((value){
          chatUser.reciever = value;
          notifyListeners();
        });
        recievelist.add(chatUser);
      });
      isReceiveLoading = false;
      isReceiveEmpty = recievelist.length == 0;
      print(recievelist.length);
      print(isReceiveEmpty);
      notifyListeners();
    });
  }


  void fetchUser(Chat chat) async{

  }

  Stream<List<ChatUser>> getUserList() {
    return _fireStoreDataBase.collection("chat").where("uuid", arrayContainsAny: [user.userId])
        .snapshots()
        .map((snapShot) => snapShot.documents
        .map((document) =>  ChatUser(chat: document.data[''],sender: document.data[''], reciever: document.data['']))
        .toList());
  }

  
}