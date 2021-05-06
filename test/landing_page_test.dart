import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_flutter_course/app/landing_page.dart';
import 'package:time_tracker_flutter_course/services/auth.dart';

///we don't want to use the real firebase authentication multiple times
///so we create a mock sign-in class. Mock is taken from the Mokito package

class MockAuth extends Mock implements AuthBase {}

class MockUser extends Mock implements User {}

void main() {
  MockAuth mockAuth;

  setUp(() {
    ///A new mock authentication service will be created every time
    ///we run a test.
    mockAuth = MockAuth();
  });
  void stubOnAuthStateChangesYields(Iterable<User> onAuthStateChanges){
    when(mockAuth.authStateChanges()).thenAnswer((_) {
      return Stream <User>.fromIterable(onAuthStateChanges);
    });
  }



  /// Always create widgets with all the ancestors that are needed
  /// here we have to use MaterialApp
  Future<void> pumpLandingPage(WidgetTester tester,
      {VoidCallback onSignedIn}) async {
    await tester.pumpWidget(Provider<AuthBase>(
      create: (_) => mockAuth,
      child: MaterialApp(
        home: Scaffold(
          body: LandingPage(),
        ),
      ),
    ));
  }

  
  testWidgets('stream waiting',  (WidgetTester tester) async {
    stubOnAuthStateChangesYields([]);
    await pumpLandingPage(tester);


  expect(find.byType(CircularProgressIndicator), findsOneWidget);
  
  });

}
