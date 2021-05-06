import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_flutter_course/app/home/home_page.dart';
import 'package:time_tracker_flutter_course/app/landing_page.dart';
import 'package:time_tracker_flutter_course/app/sign_in/sign_in_page.dart';
import 'package:time_tracker_flutter_course/services/auth.dart';
import 'mocks.dart';


void main() {
  MockAuth mockAuth;
  MockDatabase mockDatabase;
  StreamController<User> onAuthStateChangedController;

  setUp(() {
    ///A new mock authentication service will be created every time
    ///we run a test.
    mockAuth = MockAuth();
    mockDatabase = MockDatabase();
    onAuthStateChangedController = StreamController<User>();
  });
  
  tearDown((){
    onAuthStateChangedController.close();
  });

  void stubOnAuthStateChangesYields(Iterable<User> onAuthStateChanges){
    onAuthStateChangedController.addStream(Stream<User>.fromIterable(onAuthStateChanges),);
    when(mockAuth.authStateChanges()).thenAnswer((_) {
      return onAuthStateChangedController.stream;
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
          body: LandingPage(
            databaseBuilder: (_)=> mockDatabase,
          ),
        ),
      ),
    ));

    await tester.pump();
  }
  
  testWidgets('stream waiting',  (WidgetTester tester) async {
    stubOnAuthStateChangesYields([]);
    await pumpLandingPage(tester);
  expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('null User',  (WidgetTester tester) async {
    stubOnAuthStateChangesYields([null]);
    await pumpLandingPage(tester);
  expect(find.byType(SignInPage), findsOneWidget);
  });
  testWidgets('non-null User',  (WidgetTester tester) async {
    stubOnAuthStateChangesYields([MockUser.uid('1342552')]);
    await pumpLandingPage(tester);
  expect(find.byType(HomePage), findsOneWidget);
  });

}
