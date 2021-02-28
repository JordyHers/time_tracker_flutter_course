import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:time_tracker_flutter_course/app/sign_in/sign_in_page.dart';
import 'package:time_tracker_flutter_course/services/auth.dart';
import 'home_page.dart';



class LandingPage extends StatefulWidget {
  const LandingPage({Key key,@required this.auth}) : super(key: key);
  final AuthBase  auth;

  ///In order to pass this value auth declared in the [STATE]
  ///to the actual LandingPage widget
  ///we need to use the key word [widget]

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  User _user;


  @override
  void initState() {
    super.initState();
    ///First we need to initiate the current state of the user
    _updateUser(widget.auth.currentUser);
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
        auth: widget.auth,
        onSignIn: _updateUser,
      );
    }
    return HomePage(
      auth: widget.auth,
      onSignOut:()=>_updateUser(null),
    );
  }
}
