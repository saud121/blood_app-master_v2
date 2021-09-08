import 'package:blood_app/ui/chat/all_chat_viewmodel.dart';
import 'package:blood_app/ui/chat/chat.dart';
import 'package:blood_app/ui/chat/chat_viewmodel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class AllChat extends StatefulWidget {
  @override
  _AllChatState createState() => _AllChatState();
}

class _AllChatState extends State<AllChat> {
  AllChatViewModel model;



  @override
  Widget build(BuildContext context) {
    model = Provider.of<AllChatViewModel>(context, listen: false);
    model.fetchSendChatUser();
    model.fetchReceiveChatUser();

    return DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: TabBar(
            labelColor: Colors.red,
            unselectedLabelColor: Colors.black,
            tabs: [
              Tab(text: "Seekers chat",),
              Tab(text: "Donors chat"),
            ],
          ),
          body: TabBarView(
            // physics: NeverScrollableScrollPhysics(),

            children: [
              Consumer<AllChatViewModel>(
                builder: (_, model, child){
                  return Container(
                    child: model.isSendLoading  ? Center(
                      child: CircularProgressIndicator(),
                    ): model.isSendEmpty ? Center(
                      child: Lottie.asset('assets/animation/crying.json'),
                    ): ListView.builder(
                        itemCount: model.sendlist.length,
                        itemBuilder: (_, int index) =>
                            Column(
                              children: [
                                model.sendlist[index].reciever != null ?
                                ListTile(
                                  onTap: (){
                                    Navigator.push(context, MaterialPageRoute(builder: (_) =>  ChangeNotifierProvider(
                                      create: (context) => ChatViewModel(model.sendlist[index].sender, model.sendlist[index].reciever, model.sendlist[index].chat.documentId,),
                                      lazy: false,
                                      child: Chat(),
                                    )));
                                  },
                                  leading: CircleAvatar(
                                      backgroundColor: Colors.red,
                                      radius: 30.0,
                                      child: ClipOval(
                                        child: Text(model.sendlist[index].reciever.bloodGroup, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                                      )),
                                  title: model.sendlist[index].reciever != null ? Text(
                                    model.sendlist[index].reciever.firstName,
                                  ) : CircularProgressIndicator(),
                                  subtitle: model.sendlist[index].reciever != null ? Text(
                                    model.sendlist[index].reciever.phone_number,
                                  ): CircularProgressIndicator() ,
                                ) : Center(child: CircularProgressIndicator(),),
                                Divider(height: 1,)
                              ],
                            )
                    ),
                  );
                },
              ),
              Consumer<AllChatViewModel>(
                builder: (_, model, child){
                  return Container(
                    child: model.isReceiveLoading  ? Center(
                      child: CircularProgressIndicator(),
                    ): model.isReceiveEmpty ? Center(
                      child: Lottie.asset('assets/animation/crying.json'),
                    ): ListView.builder(
                        itemCount: model.recievelist.length,
                        itemBuilder: (_, int index) =>
                            Column(
                              children: [
                                model.recievelist[index].reciever != null ?
                                ListTile(
                                  onTap: (){
                                    Navigator.push(context, MaterialPageRoute(builder: (_) =>  ChangeNotifierProvider(
                                      create: (context) => ChatViewModel(model.recievelist[index].sender, model.recievelist[index].reciever, model.recievelist[index].chat.documentId,),
                                      lazy: false,
                                      child: Chat(),
                                    )));
                                  },
                                  leading: CircleAvatar(
                                      backgroundColor: Colors.red,
                                      radius: 30.0,
                                      child: ClipOval(
                                        child: Text(model.recievelist[index].reciever.bloodGroup, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                                      )),
                                  title: model.recievelist[index].reciever != null ? Text(
                                    model.recievelist[index].reciever.firstName,
                                  ) : CircularProgressIndicator(),
                                  subtitle: model.recievelist[index].reciever != null ? Text(
                                    model.recievelist[index].reciever.phone_number,
                                  ): CircularProgressIndicator() ,
                                ) : Center(child: CircularProgressIndicator(),),
                                Divider(height: 1,)
                              ],
                            )
                    ),
                  );
                },
              )
            ],
          )),
    );
  }

//  chatsStreaming() => StreamBuilder(
//        stream: Firestore.instance
//            .collection("chat")
//            .where("senderUUID", isEqualTo: model.user.userId)
//            .snapshots(),
//        builder: (_, snapshot) {
//
//          return ListView.builder(
//            itemCount: snapshot.data,
//              itemBuilder: (_, i) => ListTile(
//                    title: Text(""),
//                  ));
//        },
//      );
}
