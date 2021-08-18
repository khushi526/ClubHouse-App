import 'package:cubhouseclone1/models/club.dart';
import 'package:cubhouseclone1/models/usermodel.dart';
import 'package:cubhouseclone1/screens/clubscreen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
class OngoingClub extends StatelessWidget {
  final UserModel userModel;
  OngoingClub(this.userModel);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(15),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Color(0xFFE7E4D3)
      ),
      child: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('clubs').where('status',isEqualTo: 'ongoing').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.docs.length < 1) {
              return Container(
                width: double.infinity,
                child: Text("No Ongoing club at this moment", style: TextStyle(
                    color: Colors.teal
                ),
                  textAlign: TextAlign.center,),
              );
            }
            return Column(
              children: snapshot.data.docs.map((club){
                DateTime dateTime=DateTime.parse(club['dateTime'].toDate().toString());
                var formatedTime=DateFormat.jm().format(dateTime);
                Club clubDetail= new Club.fromMap(club);
                return GestureDetector(
                  onTap: () async {
                    PermissionStatus micStatus= await PermissionHandler().checkPermissionStatus(PermissionGroup.microphone);
                    if(micStatus != PermissionStatus.granted){
                      await PermissionHandler().requestPermissions([PermissionGroup.microphone]);
                    }
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> ClubScreen(userModel, clubDetail)));
                  },
                  child: Padding(padding: EdgeInsets.only(bottom: 10),
                  child: Row(
                    children: [
                      Text("${formatedTime}",style: TextStyle(color: Colors.green),),
                      SizedBox(width: 20,),
                      Flexible(child: Text("${clubDetail.title}",style: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold,
                      ),
                        overflow: TextOverflow.ellipsis,
                      ))
                    ],
                  )),
                );
              }).toList(),


            );
          }
          return LinearProgressIndicator();
        }),
    );
    }
  }
