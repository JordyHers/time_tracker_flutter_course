import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:time_tracker_flutter_course/app/home/models/job_model.dart';
import 'package:time_tracker_flutter_course/services/api_path.dart';

abstract class Database {
  /// This CREATE UPDATE DELETE
  //Create a new Job / edit an existing job
  Future<void> createJob(Job job);
}

class FirestoreDatabase implements Database {
  FirestoreDatabase({@required this.uid}) : assert(uid != null);
  final String uid;

  Future<void> createJob(Job job) =>
      _setData(path: APIPath.job(uid, 'job_abc'), data: job.toMap());

  Future<void> _setData({String path, Map<String, dynamic> data}) async {
    final reference = FirebaseFirestore.instance.doc(path);
    print('$path: $data');
    await reference.set(data);
  }
}
