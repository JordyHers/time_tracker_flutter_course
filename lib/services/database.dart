
import 'package:flutter/material.dart';
import 'package:time_tracker_flutter_course/app/home/models/job_model.dart';
import 'package:time_tracker_flutter_course/services/api_path.dart';
import 'package:time_tracker_flutter_course/services/firestore_service.dart';

abstract class Database {
  /// This CREATE UPDATE DELETE
  //Create a new Job / edit an existing job
  Future<void> createJob(Job job);

  Stream<List<Job>> JobsStream();
}

class FirestoreDatabase implements Database {
  FirestoreDatabase({@required this.uid}) : assert(uid != null);
  final String uid;

  final _service = FirestoreService.instance;



  Future<void> createJob(Job job) =>
      _service.setData(path: APIPath.job(uid, 'job_abc'), data: job.toMap());

  Stream<List<Job>> JobsStream() => _service.collectionStream(
      path: APIPath.jobs(uid), builder: (data) => Job.fromMap(data));



}
