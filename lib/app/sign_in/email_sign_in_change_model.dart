import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_flutter_course/app/sign_in/validators.dart';
import 'email_sign_in_model.dart';

/// This enum takes care of the different states of the sign in form


class EmailSignInChangeModel with EmailAndPasswordValidators, ChangeNotifier {
  EmailSignInChangeModel(
      {this.name = '',
      this.surname = '',
      this.email = '',
      this.password = '',
      this.formType = EmailSignInFormType.signIn,
      this.isLoading = false,
      this.submitted = false});

  String get primaryButtonText {
    return formType == EmailSignInFormType.signIn
        ? 'Sign in '
        : ' Create an account ';
  }

  String get secondaryButtonText {
    return formType == EmailSignInFormType.signIn
        ? ' Need an account ? Register'
        : 'Have an account? Sign in';
  }

  bool get canSubmitSignIn {
    return emailValidator.isValid(email) &&
        passwordValidator.isValid(password) &&
        !isLoading;
  }

  bool get canSubmitRegister {
    return emailValidator.isValid(email) &&
        passwordValidator.isValid(password) &&
        nameValidator.isValid(name) &&
        surnameValidator.isValid(surname) &&
        !isLoading;
  }

  bool get showErrorTextName {
    return submitted && !nameValidator.isValid(name);
  }

  bool get showErrorTextSurname {
    return submitted && !surnameValidator.isValid(surname) && !isLoading;
  }
  bool get showErrorTextEmail {
    return submitted && !emailValidator.isValid(email);
  }

  bool get showErrorTexPassword {
    return submitted && !passwordValidator.isValid(password);;
  }

  String name;
  String surname;
  String email;
  String password;
  EmailSignInFormType formType;
  bool isLoading;
  bool submitted;

  void updateWith({
    String name,
    String surname,
    String email,
    String password,
    EmailSignInFormType formType,
    bool isLoading,
    bool submitted,
  }) {
      this.email = email ?? this.email;
      this.password= password ?? this.password;
      this.formType= formType ?? this.formType;
      this.name= name ?? this.name;
      this.surname= surname ?? this.surname;
      this.isLoading= isLoading ?? this.isLoading;
      this.submitted= submitted ?? this.submitted;

      notifyListeners();
  }
// model.copyWith(email:email)
}
