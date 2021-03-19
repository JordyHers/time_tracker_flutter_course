import 'package:flutter_test/flutter_test.dart';
import 'package:time_tracker_flutter_course/app/home/models/job_model.dart';

void main(){
  group('fromMap',(){
    /// It is important to test models FormMap and toMap
    /// we verify if the data is returned as null when a null value is entered
    ///
    test('null data',(){
      final job = Job.fromMap(null, 'abc');
      expect(job,null);

    });
    test('job with all properties',(){

      ///here we pass a Map String data and a abc document Id
      final job = Job.fromMap({
        'name': 'Blogging',
        'ratePerHour': 10,
      }, 'abc');

      ///Here we verify id, name and ratePerHour
      // expect(job.name,'Blogging');
      // expect(job.ratePerHour,10);
      // expect(job.id,'abc');

      /// if we leave it   expect(job,Job(name: 'Blogging',ratePerHour: 10,id: 'abc'));
      /// like this we get an error Instance of Job. To solve it we need to create an
      /// override in the models_page for the hashcode and the operator
      ///
      expect(job,Job(name: 'Blogging',ratePerHour: 10,id: 'abc'));

    });

    test ('missing name',(){

      final job = Job.fromMap({
        'ratePerHour':10,
      },'abc');
      expect(job,null);
    });
  });

  group('toMap',(){
    test('valid name, ratePerHour',(){
      final job = Job(id: 'abc', name: 'Programming', ratePerHour: 50);
      expect(job.toMap(),{
        'name': 'Programming',
        'ratePerHour':50,
      });

    });

  });
}