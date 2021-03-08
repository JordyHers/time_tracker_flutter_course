
import 'package:flutter/material.dart';
import 'package:time_tracker_flutter_course/app/home/models/job_model.dart';
import 'package:time_tracker_flutter_course/services/api_path.dart';
import 'package:time_tracker_flutter_course/services/firestore_service.dart';

abstract class Database {
  /// This CREATE UPDATE DELETE
  //Create a new Job / edit an existing job
  Future<void> setJob(Job job);

  Stream<List<Job>> jobsStream();
}

/// This string gets the current time to use it as unique ID. this use
/// Iso8601String fir a specific format;
String documentIdFromCurrentDate()=> DateTime.now().toIso8601String();


class FirestoreDatabase implements Database {
  FirestoreDatabase({@required this.uid}) : assert(uid != null);
  final String uid;

  final _service = FirestoreService.instance;



  Future<void> setJob(Job job) =>
      _service.setData(path: APIPath.job(uid, job.id), data: job.toMap());

  Stream<List<Job>> jobsStream() => _service.collectionStream(
      path: APIPath.jobs(uid), builder: (data,documentId) => Job.fromMap(data,documentId));



}
