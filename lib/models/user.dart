import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';


User userFromJson(String str) {
  final jsonData = json.decode(str);
  return User.fromJson(jsonData);
}

String userToJson(User data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}

class User {
  String userId;
  String firstName;
  String phone_number;
  String email;
  String address;
  String currentAddress;
  String password;
   // currentAddress;
  GeoPoint point;
  String bloodGroup;
  bool isDesease;
  String desease;
  String age;
  String deviceToken;
  String groupType;
  String district;
  String country;
  String province;
  bool availability;

  User({
    this.userId,
    this.firstName,
    this.phone_number,
    this.email,
    this.deviceToken,
    this.groupType,
    this.address,
    this.currentAddress,
    this.password,
    this.point,
    this.district,
    this.isDesease,
    this.province,
    this.country,
    this.desease,
    this.age,
    this.bloodGroup,
    this.availability,
  });

  factory User.fromJson(Map<String, dynamic> json) => new User(
        userId: json["userId"],
        firstName: json["firstName"],
        phone_number: json["lastName"],
        email: json["email"],
        deviceToken: json["deviceToken"],
        groupType: json["groupType"],
        address: json["address"],
    currentAddress: json["currentAddress"],
    password: json["password"],
    point: json["coordinates"],
        district: json["district"],
        province: json["province"],
        country: json["country"],
        isDesease: json["isDesease"],
        desease: json["desease"],
        age: json["age"],
        bloodGroup: json["bloodGroup"],
        availability: json["availability"],
      );

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "firstName": firstName,
        "email": email,
        "lastName": phone_number,
        "deviceToken": deviceToken,
        "address": address,
        "currentAddress": currentAddress,
        "password":password,
        "coordinates": point,
        "district": district,
        "province": province,
        "country": country,
        "desease": desease,
        "isDesease": isDesease,
        "age": age,
        "bloodGroup": bloodGroup,
        "groupType": groupType,
        "availability": availability,
      };



  factory User.fromDocument(DocumentSnapshot doc) {
    return User.fromJson(doc.data);
  }
}
