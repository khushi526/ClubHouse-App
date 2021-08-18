import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cubhouseclone1/models/club.dart';
import 'package:cubhouseclone1/models/usermodel.dart';
import 'package:cubhouseclone1/screens/clubscreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
class UpcomingClub extends StatelessWidget {
  final UserModel user;
  UpcomingClub(this.user);
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('clubs').where('status',isEqualTo: 'new').where('dateTime',isLessThan: DateTime.now().add(Duration(days: 7))).snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot){
        if(snapshot.hasData) {
          if (snapshot.data.docs.length < 1) {
            return Container(
              margin: EdgeInsets.only(top: 30),
              child: Column(
                children: [
                  Icon(Icons.face_sharp, size: 100,),
                  Text("No Clubs available"),
                  Text("Create your own Club"),
                ],
              ),
            );
          }
          return ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: snapshot.data.docs.length,
            itemBuilder: (context,index){
              var data=snapshot.data.docs[index];
              Club clubDetail=new Club.fromMap(data);
              DateTime dateTime=DateTime.parse(clubDetail.dateTime.toDate().toString());
              var formatedDateTime=DateFormat.MMMd().add_jm().format(dateTime);
              return GestureDetector(
                onTap: () async {
                  PermissionStatus micStatus= await PermissionHandler().checkPermissionStatus(PermissionGroup.microphone);
                  if(micStatus != PermissionStatus.granted){
                    await PermissionHandler().requestPermissions([PermissionGroup.microphone]);
                  }
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> ClubScreen(user, clubDetail)));
                },
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 15,vertical: 5),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("${clubDetail.title}",style: TextStyle(
                            fontSize: 18,
                          ),),
                          SizedBox(height: 10,),
                          Row(
                            children: [
                              Icon(Icons.wysiwyg),
                              SizedBox(width: 5,),
                              Text("${clubDetail.category}"),
                              SizedBox(width: 20,),
                              Icon(Icons.calendar_today_rounded),
                              SizedBox(width: 5,),
                              Text("$formatedDateTime"),
                            ],
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(Icons.person),
                              SizedBox(width: 20,),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: clubDetail.speakers.map((speaker)=>Text(speaker.values.last)).toList(),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );

        }
        return Container(
          height: 300,
          child: Center(
            child: CircularProgressIndicator(),
          ),
        );
        });
  }
}
