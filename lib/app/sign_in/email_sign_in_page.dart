import 'package:flutter/material.dart';
import 'package:time_tracker_flutter_course/app/sign_in/email_sign_in_form_bloc_based.dart';
import 'package:time_tracker_flutter_course/app/sign_in/email_sign_in_form_change_notifier.dart';


class EmailSignInPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text('Sign In'),
        elevation: 0.0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            /// Here we can change the child to
            ///
            /// EmailSignInFormChangeNotifier.create(context)
            /// EmailSignInFormBlocBased.create(context)
            /// EmailSignInFormStateful.create(context)
            /// According to your technique please choose one
            child: EmailSignInFormBlocBased.create(context),
          ),
        ),
      ),
    );
  }
}
