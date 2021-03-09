import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';

class Job {
  Job({@required this.id, @required this.name, @required this.ratePerHour});

  final String name;
  final int ratePerHour;
  final String id;


  factory Job.fromMap(Map<String,dynamic> data , String documentId){
    if (data ==null){
      return null;
    }
    final String name = data['name'];
    final int ratePerHour = data['ratePerHour'];

    return Job(
      id: documentId,
      name: name,
      ratePerHour: ratePerHour
    );

  }
  Map<String, dynamic> toMap() {
    return {
      //'id' :id,
      'name': name,
      'ratePerHour': ratePerHour,
    };
  }
}
