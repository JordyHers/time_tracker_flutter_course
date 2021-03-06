import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_flutter_course/common_widgets/show_alert_dialog.dart';
import 'package:time_tracker_flutter_course/services/auth.dart';
import 'package:time_tracker_flutter_course/services/database.dart';

class JobsPage extends StatelessWidget {


  Future<void> _createJob( BuildContext context) async {
    final database = Provider.of<Database>(context, listen: false);
   await  database.createJob({
      'name': 'Blogging',
      'ratePerHour': 10
    });


  }
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
    if(didRequestSignOut == true){
      _signOut(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Jobs'),
        centerTitle: true,
        actions: [
          FlatButton(
            onPressed:() => _confirmSignOut(context),
            child: Text(
              'Log out',
              style: TextStyle(fontSize: 18.0, color: Colors.white),
            ),
          )
        ],

      ),
      floatingActionButton: FloatingActionButton(
        onPressed: ()=>_createJob(context),
        child: Icon(Icons.add),
      ),
    );
  }


}
