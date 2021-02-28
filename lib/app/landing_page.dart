import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:time_tracker_flutter_course/app/sign_in/sign_in_page.dart';
import 'home_page.dart';



class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  User _user;


  @override
  void initState() {
    super.initState();
    _updateUser(FirebaseAuth.instance.currentUser);
  }
  void _updateUser(User user){
   setState(() {
     _user = user ;
   });
  }

  @override
  Widget build(BuildContext context) {
    if(_user == null){
      return SignInPage(
        onSignIn: _updateUser,
      );
    }
    return HomePage(
      onSignOut:()=>_updateUser(null),
    );
  }
}
