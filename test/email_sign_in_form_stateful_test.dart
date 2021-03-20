import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_flutter_course/app/sign_in/email_sign_in_form_stateful.dart';
import 'package:time_tracker_flutter_course/services/auth.dart';

///we don't want to use the real firebase authentication multiple times
///so we create a mock signin class. Mock is taken from the Mokito package

class MockAuth extends Mock implements AuthBase {}

void main() {
  MockAuth mockAuth;

  setUp(() {
    ///A new mock authentication service will be created everytime
    ///we run a test.
    mockAuth = MockAuth();
  });

  /// Always create widgets with all the ancestors that are needed
  /// here we have to use MaterialApp
  Future<void> pumpEmailSignInForm(WidgetTester tester) async {
    await tester.pumpWidget(Provider<AuthBase>(
      create: (_) => mockAuth,
      child: MaterialApp(
        home: Scaffold(
          body: EmailSignInFormStateful(),
        ),
      ),
    ));
  }

  group('sign in', () {
    testWidgets(
        " When user doesn't enter the email and password "
        "And user taps on the sign-in button"
        "Then signInWithEmailAndPassword is not called",
        (WidgetTester tester) async {
      await pumpEmailSignInForm(tester);

      /// Then we need to simulate a tap action , but first we need to find it
      ///
      final signInButton = find.text('Sign in');
      await tester.tap(signInButton);

      /// we use verifyNever instead of expect.
      /// expects : asserts actual value vs matcher
      /// verify: check id method is called on a mock
      /// Sometime we can call expect and verify

      verifyNever(mockAuth.signInWithEmailAndPassword(any, any));
    });


    testWidgets(
        " When user  Enters the email and password "
        "And user taps on the sign-in button"
        "Then signInWithEmailAndPassword is not called",
        (WidgetTester tester) async {
      await pumpEmailSignInForm(tester);
     const email = 'email@email.com';
     const password = '111111';

     /// ---------------------------------------
      ///Here the widget key is used to find a specific widget
      ///by referring the key given to it.
     final emailField = find.byKey(Key('email'));
     //here we expect to find the widget
     expect(emailField, findsOneWidget);
     await tester.enterText(emailField, email);


     ///-----------------------------------------
      ///
      final passwordField = find.byKey(Key('password'));
      //here we expect to find the widget
      expect(passwordField, findsOneWidget);
      await tester.enterText(passwordField, password);

      ///When we build test widgets are not automatically rebuild
      ///so we need to call it manually for animation we use pumpAndSettle
      await tester.pump();



      /// Then we need to simulate a tap action , but first we need to find it
      ///
      final signInButton = find.text('Sign in');
      await tester.tap(signInButton);

      /// we use verify instead of expect.
      /// expects : asserts actual value vs matcher
      /// verify: check id method is called on a mock
      /// Sometime we can call expect and verify


      ///  .called(1) states the number of time the method is called
      verify(mockAuth.signInWithEmailAndPassword(email, password)).called(1);
    });
  });
}
