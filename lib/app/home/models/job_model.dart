import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';

class Job {
  Job({@required this.id, @required this.name, @required this.ratePerHour});

  final String name;
  final int ratePerHour;
  final String id;

  factory Job.fromMap(Map<String, dynamic> data, String documentId) {
    if (data == null) {
      return null;
    }
    final String name = data['name'];
    if(name==null){
      return null;
    }
    final int ratePerHour = data['ratePerHour'];

    return Job(id: documentId, name: name, ratePerHour: ratePerHour);
  }

  Map<String, dynamic> toMap() {
    return {
      //'id' :id,
      'name': name,
      'ratePerHour': ratePerHour,
    };
  }

  ///This is the way hashcode is implemented in the flutter SDK
  @override
  // TODO: implement hashCode
  int get hashCode => hashValues(id, name, ratePerHour);

  /// here we define hash code and equality operator for the Job class
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (runtimeType != other.runtimeType) return false;
    final Job otherJob = other;
    return id == otherJob.id &&
        name == otherJob.name &&
        ratePerHour == otherJob.ratePerHour;
  }
  ///here we need to override the toString method in order not to get
  ///<Instance of Job> every time we run the code.
  ///always implement toSting methods to model classes
  @override
  String toString() => 'id: $id , name: $name , ratePerHour:$ratePerHour';
}
