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

        /// we use verify instead of expect.
        /// expects : asserts actual value vs matcher
        /// verify: check id method is called on a mock
        /// Sometime we can call expect and verify

        verifyNever(mockAuth.signInWithEmailAndPassword(any,any));
      });
}
