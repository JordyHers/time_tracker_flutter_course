import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_flutter_course/common_widgets/profile_picture.dart';
import 'package:time_tracker_flutter_course/common_widgets/show_alert_dialog.dart';
import 'package:time_tracker_flutter_course/services/auth.dart';

class AccountPage extends StatelessWidget {
  Future<void> _signOut(BuildContext context) async {
    try {
      final auth = Provider.of<AuthBase>(context, listen: false);
      await auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _confirmSignOut(BuildContext context) async {
    final didRequestSignOut = await showAlertDialog(context,
        title: 'Logout',
        content: 'Are you sure you want to log out?',
        defaultActionText: 'Logout',
        cancelActionText: 'Cancel');
    if (didRequestSignOut == true) {
      _signOut(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        title: Text('Account'),
        centerTitle: true,
        actions: [
          FlatButton(
            onPressed: () => _confirmSignOut(context),
            child: Text(
              'Log out',
              style: TextStyle(fontSize: 17.5, color: Colors.white),
            ),
          )
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(130),
          child: _buildUserInfo(auth.currentUser),
        ),
      ),
    );
  }

  Widget _buildUserInfo(User user) {
    return Column(
      children: [
        Avatar(
          radius: 50,
          photoURl: user.photoURL,
        ),
        SizedBox(height: 8,),
        if(user.displayName != null)
          Text(user.displayName,
          style: TextStyle(color: Colors.white),),
        SizedBox(height: 8,),
      ],
    );
  }
}
