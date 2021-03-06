import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

abstract class Database {
  /// This CREATE UPDATE DELETE
  //Create a new Job / edit an existing job
  Future <void> createJob(Map<String, dynamic> jobData);

}


class FirestoreDatabase implements Database {
  FirestoreDatabase ({@required this.uid}): assert (uid!=null);
  final String uid;


  Future <void> createJob(Map<String, dynamic> jobData) async {
    final path = '/users/$uid/jobs/job_abc';
    final documentReference = FirebaseFirestore.instance.doc(path);
    await  documentReference.set(jobData);


  }



}