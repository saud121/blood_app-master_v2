import 'package:blood_app/models/user.dart';
import 'package:blood_app/util/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';

class DashboardViewModel extends ChangeNotifier {

  User user;
  String pageTitle = "Home";
  int index;

  DashboardViewModel(this.user);

  List<User> aPositiveList = List();
  List<User> aNegativeList = List();
  List<User> bPositiveList = List();
  List<User> bNegativeList = List();
  List<User> oPositiveList = List();
  List<User> oNegativeList = List();
  List<User> abPositiveList = List();
  List<User> abNegativeList = List();

  void fetchBloodGroupUsers() async {
    CollectionReference reference = Firestore.instance.collection("users");


    //Retrieving A Positive users;
    reference.where("bloodGroup", isEqualTo: "A+").where("availability", isEqualTo: true).getDocuments().then((value) {
      aPositiveList.clear();
      value.documents.forEach((element) {
        User user = User.fromDocument(element);
        Geolocator().distanceBetween(this.user.point.latitude,this.user.point.longitude,user.point.latitude, user.point.longitude).then((value){
          print("Distance between two user is ${value.toString()} meters");
          if(this.user.userId != user.userId && value <= 15000){
        aPositiveList.add(user);
        // notifyListeners();
          }
        });

      });
    });

    //Retrieving A Negative users;
    reference.where("bloodGroup", isEqualTo: "A-").where("availability", isEqualTo: true).getDocuments().then((value) {
      aNegativeList.clear();
      value.documents.forEach((element) {
        User user = User.fromDocument(element);
        Geolocator().distanceBetween(this.user.point.latitude,this.user.point.longitude,user.point.latitude, user.point.longitude).then((value){
          print("Distance between two user is ${value.toString()} meters");
          if(this.user.userId != user.userId && value <= 15000){
        aNegativeList.add(user);
        // notifyListeners();

          }
        });
      });
    });


    //Retrieving B Positive users;
    reference.where("bloodGroup", isEqualTo: "B+").where("availability", isEqualTo: true).getDocuments().then((value) {
      bPositiveList.clear();
      value.documents.forEach((element) {
        User user = User.fromDocument(element);
        Geolocator().distanceBetween(this.user.point.latitude,this.user.point.longitude,user.point.latitude, user.point.longitude).then((value){
          print("Distance between two user is ${value.toString()} meters");
          if(this.user.userId != user.userId && value <= 15000){
        bPositiveList.add(user);
        // notifyListeners();
          }
        });
      });

    });


    //Retrieving B negative users;
    reference.where("bloodGroup", isEqualTo: "B-").where("availability", isEqualTo: true).getDocuments().then((value) {
      bNegativeList.clear();
      value.documents.forEach((element) {
        User user = User.fromDocument(element);
        Geolocator().distanceBetween(this.user.point.latitude,this.user.point.longitude,user.point.latitude, user.point.longitude).then((value){
          print("Distance between two user is ${value.toString()} meters");
          if(this.user.userId != user.userId && value <= 15000){
          bNegativeList.add(user);
          // notifyListeners();

          }
        });
      });
    });


    //Retrieving O Positive users;
    reference.where("bloodGroup", isEqualTo: "O+").where("availability", isEqualTo: true).getDocuments().then((value) {
      oPositiveList.clear();
      value.documents.forEach((element) {
        User user = User.fromDocument(element);
        Geolocator().distanceBetween(this.user.point.latitude,this.user.point.longitude,user.point.latitude, user.point.longitude).then((value){
          print("Distance between two user is ${value.toString()} meters");
          if(this.user.userId != user.userId && value <= 15000){
        oPositiveList.add(user);
        // notifyListeners();

          }
        });
      });
    });

    //Retrieving O negative users;
    reference.where("bloodGroup", isEqualTo: "O-").where("availability", isEqualTo: true).getDocuments().then((value) {
      oNegativeList.clear();
      value.documents.forEach((element) {
        User user = User.fromDocument(element);
        Geolocator().distanceBetween(this.user.point.latitude,this.user.point.longitude,user.point.latitude, user.point.longitude).then((value){
          print("Distance between two user is ${value.toString()} meters");
          if(this.user.userId != user.userId && value <= 15000){
        oNegativeList.add(user);
        // notifyListeners();
          }
        });
      });
    });

    //Retrieving AB Positive users;
    reference.where("bloodGroup", isEqualTo: "AB+").where("availability", isEqualTo: true).getDocuments().then((value) {
      abPositiveList.clear();
      value.documents.forEach((element) {
        User user = User.fromDocument(element);
        Geolocator().distanceBetween(this.user.point.latitude,this.user.point.longitude,user.point.latitude, user.point.longitude).then((value){
          print("Distance between two user is ${value.toString()} meters");
          if(this.user.userId != user.userId && value <= 15000){
        abPositiveList.add(user);
        // notifyListeners();
          }
        });
      });
    });


    //Retrieving AB Negative users;
    reference.where("bloodGroup", isEqualTo: "AB-").where("availability", isEqualTo: true).getDocuments().then((value) {
      abNegativeList.clear();
      value.documents.forEach((element) {
        User user = User.fromDocument(element);
        Geolocator().distanceBetween(this.user.point.latitude,this.user.point.longitude,user.point.latitude, user.point.longitude).then((value){
          print("Distance between two user is ${value.toString()} meters");
          if(this.user.userId != user.userId && value <= 15000){
        abNegativeList.add(user);
        // notifyListeners();
          }
        });
      });
    });


  }

  void changePageTitle(String title) {
    pageTitle = title;
    // notifyListeners();
  }


  Future<User> fetchUser() async{
//    Firestore.instance.collection(""
    FirebaseUser fbUser = await FirebaseAuth.instance.currentUser();
    if(this.user.userId != user.userId && fbUser != null){
      user = await Auth.getUserFirestore(fbUser.uid);
      // notifyListeners();
    }
  }
}