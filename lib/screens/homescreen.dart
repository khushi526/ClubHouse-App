import 'package:cubhouseclone1/main.dart';
import 'package:cubhouseclone1/models/usermodel.dart';
import 'package:cubhouseclone1/screens/createclub.dart';
import 'package:cubhouseclone1/screens/invitescreen.dart';
import 'package:cubhouseclone1/screens/myclub.dart';
import 'package:cubhouseclone1/screens/profilescreen.dart';
import 'package:cubhouseclone1/screens/upcomingclub.dart';
import 'package:cubhouseclone1/widgets/ongoingclub.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
class HomeScreen extends StatefulWidget {
  final UserModel user;
  HomeScreen({@required this.user});
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  //name add karva mata
  void initState() {
    if(widget.user.name==""){
      Future.microtask(() => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>ProfileScreen(widget.user))));
    }
    super.initState();
  }
  //
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff1efe5),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        child: Icon(Icons.add),
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>CreateClub(widget.user)));
        },
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              leading: Icon(Icons.mic),
              title: Text("My New Clubs"),
              onTap: (){
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context)=>MyClubScreen(widget.user)));
              },
            ),
            ListTile(
              leading: Icon(Icons.share),
              title: Text("Invite"),
              onTap: (){
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context)=>InvitesScreen(widget.user)));
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Text("Home",style: TextStyle(color: Colors.black),),
        actions: [
          IconButton(icon: Icon(Icons.power_settings_new_outlined),
            onPressed: (){
            //user neh logout karva mata
            FirebaseAuth.instance.signOut().then((value){
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> AuthenticateUser()));
            });
            },)
          //
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            OngoingClub(widget.user),
            SizedBox(height: 10,),
            Text("Upcoming Week",style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),),
            SizedBox(height: 10,),
            Icon(Icons.arrow_circle_down),
            UpcomingClub(widget.user),
          ],
        ),
      ),
    );
  }
}
