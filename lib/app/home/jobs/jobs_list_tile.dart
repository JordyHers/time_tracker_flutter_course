import 'package:flutter/material.dart';
import 'package:time_tracker_flutter_course/app/home/models/job_model.dart';

class JobListTile extends StatelessWidget {
  const JobListTile({Key key, @required this.job, @required this.onTap})
      : super(key: key);
  final Job job;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        job.name,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
      onTap: onTap,
      trailing: Icon(Icons.chevron_right),
    );
  }
}
