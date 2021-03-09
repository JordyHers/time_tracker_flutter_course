import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FirestoreService {
  ///Here we make this class private so that instance of Firestore service
  ///can't be created outside this class. So that we can no longer set
  /// final _service = FirestoreService(); in the [database.dart] But rather
  /// final _service = FirestoreService.instance;
  //
  //
  ///
  /// then we declare a singleton as a static

  FirestoreService._();

  static final instance = FirestoreService._();

  ///----------------------------------------------------------------------
  /// Generic FUNCTIONS

  Future<void> setData({
    @required String path,
    @required Map<String, dynamic> data,
  }) async {
    final reference = FirebaseFirestore.instance.doc(path);
    print('$path: $data');
    await reference.set(data);
  }

  Future<void> deleteData({@required String path}) async {
    final reference = FirebaseFirestore.instance.doc(path);
    print('delete : $path');
    await reference.delete();
  }

  //Here we define a prototype Stream taking a T argument
  Stream<List<T>> collectionStream<T>({
    @required String path,
    @required T Function(Map<String, dynamic> data, String documentId) builder,
  }) {
    final reference = FirebaseFirestore.instance.collection(path);
    final snapshots = reference.snapshots();

    /// Here snapshots returns a stream of documents
    ///available in the given path.[snapshot is a collection
    //snapshots.listen((snapshot) {

    /// Here for each document in the collection snapshot
    /// print their corresponding data [snapshot is a document]
    // snapshot.docs.forEach((snapshot) => print(snapshot.data()));

    /// Here we map all the documents im the collection
    return snapshots.map((snapshot) =>

        /// Here we convert a collection snapshot into a list of documents
        snapshot.docs
            .map((snapshot) => builder(snapshot.data(), snapshot.id))
            .toList());
  }
}
