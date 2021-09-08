import 'package:blood_app/models/user.dart';
import 'package:blood_app/util/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';

class HomeViewModel extends ChangeNotifier{
  User user;
  String pageTitle = "Home";
  int index;
  HomeViewModel(this.index);


  Future<User> fetchUser() async{
//    Firestore.instance.collection(""
    FirebaseUser fbUser = await FirebaseAuth.instance.currentUser();
    if(fbUser != null){
      Auth.getUserFirestore(fbUser.uid).then((value){
        user = value;
        updateLocation();
        notifyListeners();
      });
    }
  }
  void changePageTitle(String title){
    pageTitle = title;
    notifyListeners();
  }




  void updateLocation() async{
    Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    final coordinates = new Coordinates(position.latitude, position.longitude);
    user.point = GeoPoint(coordinates.latitude, coordinates.longitude);
    var addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = addresses.first;
    user.currentAddress = first.addressLine;
    Firestore.instance.collection("users").document(user.userId).updateData(user.toJson()).then((value){
      print("Location updated");
    });
  }


}