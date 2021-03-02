import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:time_tracker_flutter_course/app/sign_in/sign_in_page.dart';
import 'package:time_tracker_flutter_course/services/auth.dart';
import 'home_page.dart';



class LandingPage extends StatelessWidget {
  const LandingPage({Key key,@required this.auth}) : super(key: key);
  final AuthBase  auth;

  ///In order to pass this value auth declared in the [STATE] for Stateful classes
  ///to the actual LandingPage widget
  ///we need to use the key word [widget.auth]


  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User>(
      ///auth.authStateChanges is the stream  declared in the [auth.dart] class
        stream: auth.authStateChanges(),
        builder: (context,snapshot){
          if (snapshot.connectionState == ConnectionState.active){
            final user = snapshot.data;
            if(user == null){
              return SignInPage(
                auth: auth,
              );
            }
            return HomePage(
              auth: auth,
            );
          }
          return Scaffold(
            body: Center(child: CircularProgressIndicator(),),
          );
        }
        );

  }
}



