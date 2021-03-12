import 'package:cloud_firestore/cloud_firestore.dart';
 import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_flutter_course/app/home/job_entries/job_entries_page.dart';
import 'package:time_tracker_flutter_course/app/home/jobs/edit_job_page.dart';
import 'package:time_tracker_flutter_course/app/home/jobs/list_item_builder.dart';
import 'package:time_tracker_flutter_course/common_widgets/show_alert_dialog.dart';
import 'package:time_tracker_flutter_course/common_widgets/show_exeption_alert.dart';
import 'package:time_tracker_flutter_course/services/auth.dart';
import 'package:time_tracker_flutter_course/services/database.dart';

import '../models/job_model.dart';
import 'jobs_list_tile.dart';

class JobsPage extends StatelessWidget {


  Future<void> _delete(BuildContext context, Job job) async {
    try {
      final database = Provider.of<Database>(context, listen: false);
      await database.deleteJob(job);
    } on FirebaseException catch (e) {
      showExceptionAlertDialog(
        context,
        title: 'Operation failed',
        exception: e,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        title: Text('Jobs'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.add, color: Colors.white,),
        onPressed: () => EditJobPage.show(context,
        database: Provider.of<Database>(context, listen: false)),
          ),

        ],
      ),
      body: _buildContents(context),

    );
  }

  Widget _buildContents(BuildContext context) {
    final database = Provider.of<Database>(context, listen: false);
      return StreamBuilder<List<Job>>(
        stream: database.jobsStream(),
        builder: (context, snapshot) {
          return ListItemsBuilder<Job>(
            snapshot: snapshot,
            itemBuilder: (context, job) => Dismissible(
              key: Key('jod-${job.id}'),
              background: Container(
                color: Colors.red,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(310.0, 12.0, 4.0, 8.0),
                  child: Text(
                    'Delete',
                    style: TextStyle(fontWeight: FontWeight.w300, fontSize: 17),
                  ),
                ),
              ),
              direction: DismissDirection.endToStart,
              onDismissed: (direction) => _delete(context, job),
              child: JobListTile(
                  job: job, onTap: () => JobEntriesPage.show(context, job)),
            ),
          );
        },
      );
  }
}
