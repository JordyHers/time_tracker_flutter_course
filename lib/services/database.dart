import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:time_tracker_flutter_course/app/home/models/job_model.dart';

abstract class Database {
  /// This CREATE UPDATE DELETE
  //Create a new Job / edit an existing job
  Future <void> createJob(Job job);

}


class FirestoreDatabase implements Database {
  FirestoreDatabase ({@required this.uid}): assert (uid!=null);
  final String uid;


  Future <void> createJob(Job job) async {
    final path = '/users/$uid/jobs/job_abc';
    final documentReference = FirebaseFirestore.instance.doc(path);
    await  documentReference.set(job.toMap());


  }



}