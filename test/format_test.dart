import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:time_tracker_flutter_course/app/home/job_entries/format.dart';

void main(){

group('hours',(){
  test('positive',(){
    /// One the left Format I enter on the right format expected
    /// we check what happens when the value entered is Positive
    expect(Format.hours(10), '10h');
  });

  test('zero',(){
    /// One the left Format I enter on the right format expected
    expect(Format.hours(0), '0h');
  });

  test('negative',(){
    /// One the left Format I enter on the right format expected
    expect(Format.hours(-5), '0h');
  });

  test('decimal',(){
    /// One the left Format I enter on the right format expected
    expect(Format.hours(4.5), '4.5h');
  });

});


group('date- GB Locale',(){
  /// The setUp method is called first and first set the  datetime format
  /// this code always runs before each test

  setUp(() async {
    Intl.defaultLocale ='en_GB';
    await initializeDateFormatting(Intl.defaultLocale);
  });
  test('2019-08-12',(){
    expect(Format.date(DateTime(2019,8,12)), '12 Aug 2019');
  });
});



group('dayOfWeek - GB Locale',(){
  setUp(() async {
    Intl.defaultLocale ='en_GB';
    await initializeDateFormatting(Intl.defaultLocale);
  });
  test('Monday',(){
    expect(Format.dayOfWeek(DateTime(2019,8,12)), 'Mon');
  });

});

group('currency- US Locale',(){
  setUp(() {
    Intl.defaultLocale ='en_US';
  });
  test('positive',(){

    expect(Format.currency(10), '\$10');
  });

  test('zero',(){
    /// One the left Format I enter on the right format expected
    expect(Format.currency(0), '');
  });

  test('negative',(){
    /// One the left Format I enter on the right format expected
    expect(Format.currency(-5), '-\$5');
  });
  

});
}