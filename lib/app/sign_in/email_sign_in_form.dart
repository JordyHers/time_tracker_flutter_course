import 'package:flutter/material.dart';
import 'package:time_tracker_flutter_course/common_widgets/form_submit_button.dart';
import 'package:time_tracker_flutter_course/services/auth.dart';

///Declaration of enum
///
/// This enum takes care of the different states of the sign in form
enum EmailSignInFormType { signIn, register }

class EmailSignInForm extends StatefulWidget {
  const EmailSignInForm({Key key,@required this.auth}) : super(key: key);
  final AuthBase auth;


  @override
  _EmailSignInFormState createState() => _EmailSignInFormState();
}

class _EmailSignInFormState extends State<EmailSignInForm> {



  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _surname = TextEditingController();

  ///We declare the initial state of the sign in form as [EmailSignInFormType]
  ///
  /// If the state switches the Text will either display [register] or [signin]
  /// when [Need an account ? register] is pressed.
  EmailSignInFormType _formType = EmailSignInFormType.signIn;


  /// Submit function is called when the button is pressed
  void _submit() {
    print('email: ${_email.text}  , password: ${_password.text}');
  }




///This function switches the state of the button
  void _toggleFormType() {
    setState(() {
      _formType = _formType == EmailSignInFormType.signIn
          ? EmailSignInFormType.register
          : EmailSignInFormType.signIn;
    });
    _name.clear();
    _surname.clear();
    _email.clear();
    _password.clear();
  }

  ///This is the list of widgets that are used to construct the Sign in form view
  List<Widget> _buildChildren() {
    final primaryText = _formType == EmailSignInFormType.signIn
        ? 'Sign in '
        : ' Create an account ';
    final secondaryText = _formType == EmailSignInFormType.signIn
        ? ' Need an account ? Register'
        : 'Have an account? Sign in';
    return [

       _formType == EmailSignInFormType.register ?  TextField(
           controller: _name,
           decoration: InputDecoration(
           labelText: 'Name',
           hintText: '',
       )) : Opacity(opacity: 0),

      _formType == EmailSignInFormType.register ?  TextField(
           controller: _surname,
           decoration: InputDecoration(
           labelText: 'Surname',
           hintText: '',
       )) : Opacity(opacity: 0),


      TextField(
        controller: _email,
        decoration: InputDecoration(
          labelText: 'Email',
          hintText: 'test@test.com',
        ),
      ),
      SizedBox(height: 8.0),
      TextField(
        controller: _password,
        decoration: InputDecoration(
          labelText: 'Password',
        ),
        obscureText: true,
      ),
      SizedBox(height: 8.0),
      FormSubmitButton(
        onPressed: _submit,
        text: primaryText,
      ),
      SizedBox(height: 8.0),
      FlatButton(
        onPressed: _toggleFormType,
        child: Text(secondaryText),
      ),
    ];
  }






  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: _buildChildren(),
      ),
    );
  }
}
