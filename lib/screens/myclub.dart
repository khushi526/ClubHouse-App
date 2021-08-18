import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cubhouseclone1/models/club.dart';
import 'package:cubhouseclone1/models/clubpage.dart';
import 'package:cubhouseclone1/models/usermodel.dart';
import 'package:cubhouseclone1/screens/clubscreen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
class MyClubScreen extends StatelessWidget {
  final UserModel userModel;
  MyClubScreen( this.userModel);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff1efe5),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ClubPage(userModel),
          ],
        ),
      ),
    );
  }
}
