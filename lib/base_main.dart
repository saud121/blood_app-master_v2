import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';

class Base extends StatefulWidget{

  ProgressDialog pr ;

  Future<bool> showProgressDialogue(BuildContext context, String message){
    pr = new ProgressDialog(context);
    pr.style(message: message, );
    pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: true, showLogs: false,
    );

   return pr.show();
  }

  Future<bool> showProgressDialogueForAudio(BuildContext context, String message){
    pr = new ProgressDialog(context);
    pr.style(
        message: message,
        borderRadius: 10.0,
        progressTextStyle: TextStyle(
            color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
        messageTextStyle: TextStyle(
            color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600)
    );
    pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: true, showLogs: false,
    );

   return pr.show();
  }




  Future<bool> dissmissProgressDialgue(){
    if(pr != null){
      return pr.hide();
    }
  }

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    throw UnimplementedError();
  }


  Future<DocumentReference> fetchImportantLink(String documentId)async{
    String url = "";
    DocumentReference snapshot = await Firestore.instance.collection("important_links")
        .document(documentId);

    return snapshot;
  }







}