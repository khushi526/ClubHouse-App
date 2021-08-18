import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cubhouseclone1/models/usermodel.dart';
import 'package:cubhouseclone1/screens/homescreen.dart';
import 'package:cubhouseclone1/screens/notinvited.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final TextEditingController phoneController=TextEditingController();
  final TextEditingController otpController=TextEditingController();
  bool isLoading=false;
  bool isOtpScreen=false;
  FirebaseAuth _firebaseAuth=FirebaseAuth.instance;
  FirebaseFirestore _firestore=FirebaseFirestore.instance;
  var verificationCode;
  @override
  void dispose() {
    phoneController.dispose();
    super.dispose();
  }
  //phone auth mata
  Future phoneAuth() async{
    var _phoneNumber= "+91" + phoneController.text.trim();
    setState(() {
      isLoading=true;
    });
    await _firebaseAuth.verifyPhoneNumber(
        phoneNumber: _phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential){
          _firebaseAuth.signInWithCredential(credential).then((userData) async {
            if(userData!=null){
              //phone authentication no data store karva mata
              await _firestore.collection('users').doc(userData.user.uid).set({
                'name':'',
                'phone':userData.user.phoneNumber,
                'uid':userData.user.uid,
                'invitesLeft':5,
              });
              //
              print(userData.user.phoneNumber);
              setState(() {
                isLoading=false;
              });
            }
          });
        },
        verificationFailed: (FirebaseAuthException error){
          print("Firebase Error ${error.message}");
        },
        codeSent: (String verificationid, int resendToken){
          setState(() {
            isLoading=false;
            isOtpScreen=true;
            verificationCode=verificationid;
          });
        },
        codeAutoRetrievalTimeout: (String verificationid){
          setState(() {
            isLoading=false;
            verificationCode=verificationid;
          });
        },timeout: Duration(seconds: 120));
  }
  Future otpSignIn() async {
    setState(() {
      isLoading=true;
    });
    try{
      _firebaseAuth.signInWithCredential(PhoneAuthProvider.credential(
          verificationId: verificationCode, 
          smsCode: otpController.text.trim())).then((userData) async {
            UserModel user;
            if(userData!=null){
              //user already exist check karva mata
              var userExist= await _firestore.collection('users').where('phone',isEqualTo :"+91" + phoneController.text).get();
              if(userExist.docs.length>0){
                print("User Already Exits");
                user=UserModel.fromMap(userExist.docs.first);
              }else {
                print("New User Created");
                //phone authentication no data store karva mata
                user = UserModel(
                  name: '',
                  phone: userData.user.phoneNumber,
                  uid: userData.user.uid,
                  invitesLeft: 5,
                );
                await _firestore.collection('users').doc(userData.user.uid).set(
                    UserModel().toMap(user));
              }
                //
              //checking user invited or not
                var userInvited= await _firestore.collection('invites').where('invitee',isEqualTo:"+91" + phoneController.text).get();
                if(userInvited.docs.length<1){
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> NotInvited()));
                  return;
                }
                //
                setState(() {
                  isLoading=false;
                });
                print("Login Successful");


              //Navigate to Home Screen
              Navigator.push(context, MaterialPageRoute(builder: (context)=> HomeScreen(user: user,)));
              //
//              setState(() {
//                isLoading=false;
//              });
//              print("Login Successful");

            }
      });
    }catch(e){
      print(e.toString());
    }
  }
  //
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.blue,
        ),
        child: SafeArea(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.only(top: 60),
                height: 150,
                child: Text("Club House",style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),),
              ),
              Expanded(child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(60),
                  topRight: Radius.circular(60),)
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: 60,),
                      Icon(Icons.connect_without_contact,size: 60,color: Colors.blue,),
                      SizedBox(height: 30,),
                      Text("Login With Phone",style: TextStyle(
                        color: Colors.black,
                        fontSize: 25,
                        fontStyle: FontStyle.italic,
                      ),),
                      isOtpScreen? Padding(padding: EdgeInsets.symmetric(horizontal: 30,vertical: 20),
                        child: TextField(
                          controller: otpController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "Enter otp",
                              hintText: "Enter the otp you got"
                          ),
                        ),):
                      Padding(padding: EdgeInsets.symmetric(horizontal: 30,vertical: 20),
                      child: TextField(
                        controller: phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Enter Phone Number",
                          hintText: "Enter your invited phone number"
                        ),
                      ),),
                      SizedBox(height: 30,),
                      isLoading? CircularProgressIndicator() : Container(
                        height: 50,
                        width: 250,
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: TextButton(
                          //phone authentication mata
                          onPressed: (){
                            isOtpScreen?otpSignIn():phoneAuth();
                          },
                          //
                          child: Text("Login",style: TextStyle(
                            fontSize: 25,
                            color: Colors.white,
                          ),),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
