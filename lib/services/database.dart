import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:time_tracker_flutter_course/app/home/models/job_model.dart';
import 'package:time_tracker_flutter_course/services/api_path.dart';

abstract class Database {
  /// This CREATE UPDATE DELETE
  //Create a new Job / edit an existing job
  Future<void> createJob(Job job);
  Stream<List<Job>> JobsStream();
}

class FirestoreDatabase implements Database {
  FirestoreDatabase({@required this.uid}) : assert(uid != null);
  final String uid;

  Future<void> createJob(Job job) =>
      _setData(path: APIPath.job(uid, 'job_abc'), data: job.toMap());

  Stream<List<Job>> JobsStream(){
    final path = APIPath.jobs(uid);
    final reference = FirebaseFirestore.instance.collection(path);
    final snapshots = reference.snapshots();
    /// Here snapshots returns a stream of documents
    ///available in the given path.[snapshot is a collection
    //snapshots.listen((snapshot) {

      /// Here for each document in the collection snapshot
      /// print their corresponding data [snapshot is a document]
     // snapshot.docs.forEach((snapshot) => print(snapshot.data()));

    /// Here we convert a collection snapshot into a list
    return snapshots.map((snapshot) =>  snapshot.docs.map((snapshot){
      ///then the second snapshot = document turns them into data
      final data = snapshot.data();
      return data != null ? Job(
        name: data['name'],
        ratePerHour: data['ratePerHour'],
      ) : null ;
    },).toList());

  }

  Future<void> _setData({String path, Map<String, dynamic> data}) async {
    final reference = FirebaseFirestore.instance.doc(path);
    print('$path: $data');
    await reference.set(data);
  }
}
