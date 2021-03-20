import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_flutter_course/app/sign_in/email_sign_in_form_stateful.dart';
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

  /// Always create widgets with all the ancestors that are needed
  /// here we have to use MaterialApp
  Future<void> pumpEmailSignInForm(WidgetTester tester,
      {VoidCallback onSignedIn}) async {
    await tester.pumpWidget(Provider<AuthBase>(
      create: (_) => mockAuth,
      child: MaterialApp(
        home: Scaffold(
          body: EmailSignInFormStateful(
            onSignedIn: onSignedIn,
          ),
        ),
      ),
    ));
  }

  void stubSignInWithEmailAndPasswordSucceeds() {
    when(mockAuth.signInWithEmailAndPassword(any, any))
        .thenAnswer((_) => Future<User>.value(MockUser()));
  }

  void stubSignInWithEmailAndPasswordThrows() {
    when(mockAuth.signInWithEmailAndPassword(any, any)).thenThrow(
        FirebaseAuthException(code: 'ERROR_WRONG_PASSWORD'));
  }

  group('sign in', () {
    testWidgets(
        " When user doesn't enter the email and password "
        "And user taps on the sign-in button"
        "Then signInWithEmailAndPassword is not called"
        " AND usr is not signed-in", (WidgetTester tester) async {
      var signedIn = false;
      await pumpEmailSignInForm(tester, onSignedIn: () => signedIn = true);

      /// Then we need to simulate a tap action , but first we need to find it
      ///
      final signInButton = find.text('Sign in');
      await tester.tap(signInButton);

      /// we use verifyNever instead of expect.
      /// expects : asserts actual value vs matcher
      /// verify: check id method is called on a mock
      /// Sometime we can call expect and verify
      expect(signedIn, false);
      verifyNever(mockAuth.signInWithEmailAndPassword(any, any));
    });

    testWidgets(
        " When user  Enters a valid  email and password "
        "And user taps on the sign-in button"
        "Then signInWithEmailAndPassword is not called"
        "AND user is signed-in", (WidgetTester tester) async {
      var signedIn = false;
      await pumpEmailSignInForm(tester, onSignedIn: () => signedIn = true);

      stubSignInWithEmailAndPasswordSucceeds();

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
      expect(signedIn, true);
    });


    testWidgets(
        " When user  Enters an invalid  email and password "
            "And user taps on the sign-in button"
            "Then signInWithEmailAndPassword is not called"
            "AND user is not signed-in", (WidgetTester tester) async {
      var signedIn = false;
      await pumpEmailSignInForm(tester, onSignedIn: () => signedIn = true);

      stubSignInWithEmailAndPasswordThrows();

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
      expect(signedIn, false);
    });
  });

  group('register', () {
    testWidgets(
        " When user taps on the secondary button "
        "Then form toggles to registration mode", (WidgetTester tester) async {
      await pumpEmailSignInForm(tester);

      /// Then we need to simulate a tap action , but first we need to find it
      ///
      final registerButton = find.text('Need an account ? Register');
      await tester.tap(registerButton);

      await tester.pump();
      final createAccountButton = find.text('Create an account');
      expect(createAccountButton, findsOneWidget);
    });

    testWidgets(
        " When user  Enters the email and password "
        "And user taps on the sign-in button"
        "Then registers then createUserWithEmailAndPassword is called",
        (WidgetTester tester) async {
      await pumpEmailSignInForm(tester);
      const email = 'email@email.com';
      const password = '111111';
      const name = 'name';
      const surname = 'surname';

      final registerButton = find.text('Need an account ? Register');
      await tester.tap(registerButton);

      await tester.pump();

      /// ---------------------------------------
      ///Here the widget key is used to find a specific widget
      ///by referring the key given to it.
      final emailField = find.byKey(Key('email'));
      //here we expect to find the widget
      expect(emailField, findsOneWidget);
      await tester.enterText(emailField, email);

      /// ---------------------------------------
      ///Here the widget key is used to find a specific widget
      ///by referring the key given to it.
      final nameField = find.byKey(Key('name'));
      //here we expect to find the widget
      expect(nameField, findsOneWidget);
      await tester.enterText(nameField, name);

      /// ---------------------------------------
      ///Here the widget key is used to find a specific widget
      ///by referring the key given to it.
      final surnameField = find.byKey(Key('surname'));
      //here we expect to find the widget
      expect(surnameField, findsOneWidget);
      await tester.enterText(surnameField, surname);

      ///-----------------------------------------
      ///
      final passwordField = find.byKey(Key('password'));
      //here we expect to find the widget
      expect(passwordField, findsOneWidget);
      await tester.enterText(passwordField, password);

      ///When we build test widgets are not automatically rebuild
      ///so we need to call it manually for animation we use pumpAndSettle
      await tester.pump();

      final createAccountButton = find.text('Create an account');
      expect(createAccountButton, findsOneWidget);

      await tester.tap(createAccountButton);

      /// we use verify instead of expect.
      /// expects : asserts actual value vs matcher
      /// verify: check id method is called on a mock
      /// Sometime we can call expect and verify

      ///  .called(1) states the number of time the method is called
      verify(mockAuth.signUpUserWithEmailAndPassword(
              email, password, name, surname))
          .called(1);
    });
  });
}
