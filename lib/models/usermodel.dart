import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
//phone authentication no data store karva matame;
class UserModel{
  String name;
  String uid;
  String phone;
  int invitesLeft;
  UserModel({this.name,this.uid,this.phone,this.invitesLeft});
  factory UserModel.fromMap(QueryDocumentSnapshot documentSnapshot){
    return UserModel(
      name: documentSnapshot['name'],
      phone: documentSnapshot['phone'],
      uid: documentSnapshot['uid'],
      invitesLeft: documentSnapshot['invitesLeft'],
    );
  }
  Map<String,dynamic> toMap(UserModel user)=>{
    'name':user.name,
    'uid':user.uid,
    'phone':user.phone,
    'invitesLeft':user.invitesLeft,
  };
  //
}
