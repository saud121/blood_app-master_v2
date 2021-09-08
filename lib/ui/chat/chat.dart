import 'dart:io';
import 'dart:math';

import 'package:blood_app/ui/chat/chat_viewmodel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../base_main.dart';

class Chat extends Base {
  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat>{
  TextEditingController chatController = TextEditingController();
  bool isEmoji = false;
  double _height = 150;
  List<File> conversationImages = List();
  List<File> files;
  ChatViewModel model;



  AnimationController _controller;
//  ImagePickerHandler imagePicker;

  @override
  void initState() {

    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    model = Provider.of<ChatViewModel>(context, listen: false);


    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Row(
          children: <Widget>[
            Container(
              margin: EdgeInsets.fromLTRB(20.0, .0, .0, .0),
              child: Text(
                model.sender.firstName,
                style: TextStyle(color: Colors.white),
              ),
            )
          ],
        ),
      ),
      body: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, .0),
//            child: Text(
//              "January 8",
//              style: TextStyle(color: Colors.black45),
//            ),
          ),
          Expanded(
            child: steaming(),
          ),
          Container(
            decoration: BoxDecoration(
              color: Color.fromRGBO(245, 245, 245, 1.0),
              border: Border.all(color: Color.fromRGBO(245, 245, 245, 1.0)),
              borderRadius: BorderRadius.all(Radius.circular(10)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 5.0,
                  // has the effect of softening the shadow
                  spreadRadius: 3.0,
                  // has the effect of extending the shadow
                  offset: Offset(
                    2.0, // horizontal, move right 10
                    2.0, // vertical, move down 10
                  ),
                ),
              ],
            ),
            height: _height,
            child: Column(
              children: <Widget>[
                isEmoji? SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
//                  child: EmojiPicker(
//                    rows: 3,
//                    columns: 7,
//                    recommendKeywords: ["racing", "horse"],
//                    numRecommended: 10,
//                    onEmojiSelected: (emoji, category) {
//                      chatController.text = chatController.text + emoji.toString().split("Emoji:")[1];
//                    },
//                  ),
                  child: Text("QWEQWE"),
                ): Container(),
                Row(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.fromLTRB(10.0, .0, .0, .0),
                      width: MediaQuery.of(context).size.width -20 ,
                      child: TextFormField(

                        controller: chatController,
                        decoration: InputDecoration(
                            hintText: "Write your message...",
                            border: InputBorder.none),
                      ),
                    ),

                  ],
                ),
                Row(
                  children: <Widget>[ Container(
                          margin: EdgeInsets.fromLTRB(20.0, .0, .0, .0),
                          child: IconButton(
                            onPressed: () async {
                              Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
                              print(position.latitude);
                              print(position.longitude);
                              showAlert(position);
                            },
                              tooltip: "Share location",
                              icon: Icon(Icons.location_on),
                            ),
                      ),
                    Spacer(),
                    GestureDetector(
                      onTap: (){
//                        check = -1;
//                        showImage();
                        if(chatController.text != ""){
                          model.sendMessage(chatController.text, widget);
                          chatController.text = "";
                        }else{

                        }
                      },
                      child: Container(

                        margin: EdgeInsets.fromLTRB(0.0, 0.0, 20.0, 0.0),
                        padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.red),
                            color: Colors.red,
                            borderRadius: BorderRadius.all(Radius.circular(50))
                        ),
                        child: Text("Send Message",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                                fontSize: 18)),
                      ),
                    )
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }






  steaming() => StreamBuilder(
    stream: Firestore.instance.collection("chat").document(model.chatId).collection("chat").orderBy("messageTime", descending: false).snapshots(),
    builder: (_, AsyncSnapshot<QuerySnapshot> snapshot){
      print(snapshot.data.documents.length);

//      Map<String, Object> data = snapshot.data.documents.fo



      return ListView.builder(
        shrinkWrap: true,
        itemBuilder: (_, i) {
          Timestamp t = snapshot.data.documents[i].data["messageTime"] ;
          String time = getTimeFromTimestamp(t);
          return
            snapshot.data.documents[i].data["senderUUID"] != model.sender.userId
                ? snapshot.data.documents[i].data["messageType"] != "location" ?
            Container(
            padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 3.0),
            margin: EdgeInsets.fromLTRB(5.0, 0.0, 35.0, 20.0),
            decoration: BoxDecoration(
              color: Color.fromRGBO(245, 245, 245, 1.0),
              border: Border.all(
                  color: Color.fromRGBO(245, 245, 245, 1.0)),
              borderRadius: BorderRadius.all(Radius.circular(10)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 5.0,
                  // has the effect of softening the shadow
                  spreadRadius: 3.0,
                  // has the effect of extending the shadow
                  offset: Offset(
                    2.0, // horizontal, move right 10
                    2.0, // vertical, move down 10
                  ),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  snapshot.data.documents[i].data["message"],
                  style: TextStyle(
                      fontSize: 17.0,
                      color: Colors.black,
                      fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Text(
                      time,
                      style: TextStyle(
                          fontSize: 11.0,
                          color: Colors.black,
                          fontWeight: FontWeight.w400),
                    ),
                  ],
                )
              ],
            )
          ):GestureDetector(
              onTap: (){
                _launchMapsUrl(snapshot.data.documents[i].data["message"]);
              },
              child:  Container(
                padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 3.0),
                margin: EdgeInsets.fromLTRB(5.0, 0.0, 35.0, 20.0),
                decoration: BoxDecoration(
                  color: Color.fromRGBO(245, 245, 245, 1.0),
                  border: Border.all(
                      color: Color.fromRGBO(245, 245, 245, 1.0)),
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 5.0,
                      // has the effect of softening the shadow
                      spreadRadius: 3.0,
                      // has the effect of extending the shadow
                      offset: Offset(
                        2.0, // horizontal, move right 10
                        2.0, // vertical, move down 10
                      ),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      snapshot.data.documents[i].data["message"],
                      style: TextStyle(
                          fontSize: 17.0,
                          color: Colors.black,
                          fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Text(
                          time,
                          style: TextStyle(
                              fontSize: 11.0,
                              color: Colors.black,
                              fontWeight: FontWeight.w400),
                        ),

                      ],
                    )
                  ],
                )
              ),
            )  : snapshot.data.documents[i].data["messageType"] != "location" ?
            Container(
            padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 3.0),
            margin: EdgeInsets.fromLTRB(35.0, 0.0, 5.0, 20.0),
            decoration: BoxDecoration(
              color: Colors.red,
              border: Border.all(
                  color: Colors.red),
              borderRadius: BorderRadius.all(Radius.circular(10)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 5.0,
                  // has the effect of softening the shadow
                  spreadRadius: 3.0,
                  // has the effect of extending the shadow
                  offset: Offset(
                    2.0, // horizontal, move right 10
                    2.0, // vertical, move down 10
                  ),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  snapshot.data.documents[i].data["message"],
                  style: TextStyle(
                      fontSize: 17.0,
                      color: Colors.white,
                      fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Text(
                      time,
                    style: TextStyle(
                          fontSize: 11.0,
                          color: Colors.white,
                          fontWeight: FontWeight.w400),
                    ),
                    Spacer(),
                    // Icon(
                    //   Icons.done_all,
                    //   color: Colors.white,
                    //   size: 15,
                    //
                    // )
                  ],
                )
              ],
            ),
          ) : GestureDetector(
              onTap: (){
                _launchMapsUrl(snapshot.data.documents[i].data["message"]);
              },
              child:  Container(
                padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                margin: EdgeInsets.fromLTRB(35.0, 0.0, 5.0, 20.0),
                decoration: BoxDecoration(
                  color: Colors.red,
                  border: Border.all(
                      color: Colors.red),
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 5.0,
                      // has the effect of softening the shadow
                      spreadRadius: 3.0,
                      // has the effect of extending the shadow
                      offset: Offset(
                        2.0, // horizontal, move right 10
                        2.0, // vertical, move down 10
                      ),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      snapshot.data.documents[i].data["message"],
                      style: TextStyle(
                          fontSize: 17.0,
                          color: Colors.white,
                          fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Text(
                          time,
                          style: TextStyle(
                              fontSize: 11.0,
                              color: Colors.white,
                              fontWeight: FontWeight.w400),
                        ),
                        Spacer(),
                        Icon(
                          Icons.done_all,
                          color: Colors.white,
                          size: 15,

                        )
                      ],
                    )
                  ],
                )
              ),
            );
        },
        itemCount:  snapshot.data.documents.length,
      );
    },
  );

  void showAlert(Position position) {
    showMaterialDialog<String>(
      context: context,
      child: AlertDialog(
        title: const Text('Share location'),
        content: Text(
          'Do you want to share the location',
          style: Theme
              .of(context)
              .textTheme
              .subtitle1
              .copyWith(color: Theme
              .of(context)
              .textTheme
              .caption
              .color),
        ),
        actions: <Widget>[
          FlatButton(
            child: const Text('No'),
            onPressed: () {
              Navigator.pop(context, 'cancel');
            },
          ),
          FlatButton(
            child: const Text('Yes'),
            onPressed: () {
              Navigator.pop(context, 'discard');
              model.sendMapLocation(position, widget);
            },
          ),
        ],
      ),
    );
  }

  void showMaterialDialog<T>({ BuildContext context, Widget child }) {
    showDialog<T>(
      context: context,
      builder: (BuildContext context) => child,
    )
        .then<void>((T value) { // The value passed to Navigator.pop() or null.
      if (value != null) {
//        _scaffoldKey.currentState.showSnackBar(SnackBar(
//          content: Text('You selected: $value'),
//        ));
      }
    });
  }


  void _launchMapsUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  String getTimeFromTimestamp (Timestamp t) {
   Duration i = DateTime.now().difference(t.toDate());
   if(i.inDays > 0){
     return t.toDate().toIso8601String().split("T")[0];
   }else{
     //Apply more conditions like few sends ago and so and so on.
     return "Today";
   }
  }

//  void showImage() {
//    imagePicker.showDialog(context);
//  }
//
//  @override
//  userImage(File _image) {
//    setState(() {
//      conversationImages.add(_image);
//    });
//    return null;
//  }
//
//  void getFiles() async {
//    files = await FilePicker.getMultiFile();
//  }
}