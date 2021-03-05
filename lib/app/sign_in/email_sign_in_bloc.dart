import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:time_tracker_flutter_course/app/sign_in/email_sign_in_model.dart';
import 'package:time_tracker_flutter_course/services/auth.dart';

class EmailSignInBloc {
  EmailSignInBloc({@required this.auth});

  final AuthBase auth;

  final StreamController<EmailSignInModel> _modelController =
      StreamController();

  Stream<EmailSignInModel> get modelStream => _modelController.stream;

  EmailSignInModel _model = EmailSignInModel();

  void dispose() {
    _modelController.close();
  }

  /// Submit function is called when the button is pressed
  Future<void> submit() async {
    print('Submitted called');
    updateWith(submitted: true, isLoading: true);
    try {
      if (_model.formType == EmailSignInFormType.signIn) {
        await auth.signInWithEmailAndPassword(_model.email, _model.password);
      } else {
        await auth.signUpUserWithEmailAndPassword(
            _model.email, _model.password, _model.name, _model.surname);
      }
      // Navigator.of(context).pop();
    } catch (e) {
      updateWith(isLoading: false);
      rethrow;
    }
  }

  void toggleFormType() {
    final formType = _model.formType == EmailSignInFormType.signIn
        ? EmailSignInFormType.register
        : EmailSignInFormType.signIn;
    updateWith(
        email: '',
        password: '',
        name: '',
        surname: '',
        submitted: false,
        formType: formType,
        isLoading: false);
  }

  void updateEmail(String email) => updateWith(email: email);

  void updatePassword(String password) => updateWith(password: password);

  void updateName(String name) => updateWith(name: name);

  void updateSurname(String surname) => updateWith(surname: surname);

  void updateWith({
    String email,
    String password,
    String name,
    String surname,
    EmailSignInFormType formType,
    bool isLoading,
    bool submitted,
  }) {
    // update model
    _model = _model.copyWith(
        name: name,
        surname: surname,
        email: email,
        password: password,
        formType: formType,
        isLoading: isLoading,
        submitted: submitted);

    //add updated model to _modelController
    _modelController.add(_model);
  }
}