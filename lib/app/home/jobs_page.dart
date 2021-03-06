import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_flutter_course/common_widgets/show_alert_dialog.dart';
import 'package:time_tracker_flutter_course/common_widgets/show_exeption_alert.dart';
import 'package:time_tracker_flutter_course/services/auth.dart';
import 'package:time_tracker_flutter_course/services/database.dart';

import 'models/job_model.dart';

class JobsPage extends StatelessWidget {
  Future<void> _createJob(BuildContext context) async {
    try {
      final database = Provider.of<Database>(context, listen: false);
      await database.createJob(Job(name: 'Blogging', ratePerHour: 10));
    } on FirebaseException catch (e) {
      // if( e.code == 'permission-denied'){}
      showExceptionAlertDialog(context,
          title: 'Operation Failed', exception: e);
    }
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
    if (didRequestSignOut == true) {
      _signOut(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    //TODO: Temporary code delete me as soon as done
    final database = Provider.of<Database>(context, listen: false);
    database.JobsStream();

    return Scaffold(
      appBar: AppBar(
        title: Text('Jobs'),
        centerTitle: true,
        actions: [
          FlatButton(
            onPressed: () => _confirmSignOut(context),
            child: Text(
              'Log out',
              style: TextStyle(fontSize: 18.0, color: Colors.white),
            ),
          )
        ],
      ),
      body:_buildContents(context),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _createJob(context),
        child: Icon(Icons.add),
      ),
    );
  }


  Widget _buildContents(BuildContext context) {
    final database = Provider.of<Database> (context,listen:false);
    return StreamBuilder<List<Job>>(
      stream: database.JobsStream(),
      builder: (context, snapshot){
        if (snapshot.hasData){

          final users = snapshot.data;
          final children = users.map((user) => Text(user.name)).toList();
          return ListView( children: children);
        }
        if(snapshot.hasError){
          return Center (child: Text('Some Error Occured'));
        }
        return Center (child: CircularProgressIndicator(),);

      },

    );

  }
}
