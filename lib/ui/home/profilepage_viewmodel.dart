import 'package:blood_app/base_main.dart';
import 'package:blood_app/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class ProfileViemodel extends ChangeNotifier{
  User user;
  ProfileViemodel(this.user);

  void updateHouseInfo () {
    print(user.toJson());
  }
  void updatePersonelInfo () {
    print(user.toJson());
  }
  void updateHealthInfo () {
    print(user.toJson());

  }


  updateFirestore(Base base, BuildContext context){
    base.showProgressDialogue(context, "Updating profile");
    Firestore.instance.collection("users").document(user.userId).updateData(user.toJson()).then((value){
      base.dissmissProgressDialgue().then((value) => print("Updated"));
      notifyListeners();
    });
  }

  void changeAvailability(bool bool, Base base, BuildContext context) {
    user.availability = bool;
    base.showProgressDialogue(context, "Changing availability");
    Firestore.instance.collection("users").document(user.userId).updateData(user.toJson()).then((value){
      base.dissmissProgressDialgue().then((value) => print("Updated"));
      notifyListeners();
    });
  }
}