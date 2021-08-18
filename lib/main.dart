import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cubhouseclone1/models/usermodel.dart';
import 'package:cubhouseclone1/screens/authscreen.dart';
import 'package:cubhouseclone1/screens/homescreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import './screens/notinvited.dart';
//firebase mata
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}
//
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Club House',
      theme: ThemeData(
        primaryColor: Colors.blue,
      ),
      home: AuthenticateUser(),
    );
  }
}
//user aleardy login hoi toh home scrren per direct java mata
class AuthenticateUser extends StatelessWidget {
  final FirebaseAuth _firebaseAuth=FirebaseAuth.instance;
  Future checkCurrentUser() async {
    if (_firebaseAuth.currentUser != null) {
      //checking user invited or not
      var userInvited = await FirebaseFirestore.instance.collection('invites')
          .where('invitee', isEqualTo: _firebaseAuth.currentUser.phoneNumber)
          .get();
      if (userInvited.docs.length < 1) {
        return NotInvited();
      }
      //
        var userExist = await FirebaseFirestore.instance.collection('users')
            .where('uid', isEqualTo: _firebaseAuth.currentUser.uid)
            .get();
        UserModel user = UserModel.fromMap(userExist.docs.first);
        return HomeScreen(user: user);
      } else {
      return AuthScreen();
    }
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: checkCurrentUser(),
        builder: (context,snapshot){
        if(snapshot.connectionState==ConnectionState.waiting){
          return Container(
            color: Colors.blue,
            child: Center(
              child: CircularProgressIndicator(backgroundColor: Colors.white,),
            ),
          );
        }else{
          return snapshot.data;
        }
        });
  }
}
//
