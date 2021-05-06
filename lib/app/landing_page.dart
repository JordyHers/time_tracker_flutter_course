import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_flutter_course/app/home/home_page.dart';
import 'package:time_tracker_flutter_course/app/provider/model_change_notifier.dart';
import 'package:time_tracker_flutter_course/app/provider/view_change_notifier.dart';
import 'package:time_tracker_flutter_course/app/sign_in/sign_in_page.dart';
import 'package:time_tracker_flutter_course/services/auth.dart';
import 'package:time_tracker_flutter_course/services/database.dart';


class LandingPage extends StatelessWidget {
  final Database Function (String) databaseBuilder;

  const LandingPage({Key key, @required this.databaseBuilder}) : super(key: key);
  ///In order to pass this value auth declared in the [STATE] for Stateful classes
  ///to the actual LandingPage widget
  ///we need to use the key word [widget.auth]

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    return StreamBuilder<User>(

        ///auth.authStateChanges is the stream  declared in the [auth.dart] class
        stream: auth.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            final user = snapshot.data;
            if (user == null) {
              return SignInPage.create(context);
            }

            /// Here we have added a provider [Database] as a parent of the Jobs
            /// Page
            return Provider<Database>(
              create: (_) => databaseBuilder(user.uid),
             child: ChangeNotifierProvider(
               create: (_)=> UserProvider(),
                 //child: ViewChangeNotifier()),
              child: HomePage()),
            );
          }
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        });
  }
}
