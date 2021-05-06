import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_flutter_course/app/sign_in/email_sign_in_form_stateful.dart';
import 'package:time_tracker_flutter_course/app/sign_in/sign_in_page.dart';
import 'package:time_tracker_flutter_course/services/auth.dart';
import 'mocks.dart';


void main() {
  MockAuth mockAuth;

  setUp(() {
    ///A new mock authentication service will be created every time
    ///we run a test.
    mockAuth = MockAuth();
  });

  /// Always create widgets with all the ancestors that are needed
  /// here we have to use MaterialApp
  Future<void> pumpSignInPage(WidgetTester tester) async {
    await tester.pumpWidget(Provider<AuthBase>(
      create: (_) => mockAuth,
      child: MaterialApp(
          home: Builder(builder:(context)=> SignInPage.create(context))
      ),
    ));
  }
}
