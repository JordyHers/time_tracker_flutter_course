import 'package:flutter/material.dart';
import 'package:time_tracker_flutter_course/common_widgets/form_submit_button.dart';
import 'package:time_tracker_flutter_course/services/auth.dart';

///Declaration of enum
///
/// This enum takes care of the different states of the sign in form
enum EmailSignInFormType { signIn, register }

class EmailSignInForm extends StatefulWidget {
  const EmailSignInForm({Key key, @required this.auth}) : super(key: key);
  final AuthBase auth;

  @override
  _EmailSignInFormState createState() => _EmailSignInFormState();
}

class _EmailSignInFormState extends State<EmailSignInForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();

  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _surnameFocusNode = FocusNode();

  String get _email => _emailController.text;

  String get _name => _nameController.text;

  String get _surname => _surnameController.text;

  String get _password => _passwordController.text;

  ///We declare the initial state of the sign in form as [EmailSignInFormType]
  ///
  /// If the state switches the Text will either display [register] or [signin]
  /// when [Need an account ? register] is pressed.
  EmailSignInFormType _formType = EmailSignInFormType.signIn;

  /// Submit function is called when the button is pressed
  void _submit() async {
    try {
      if (_formType == EmailSignInFormType.signIn) {
        await widget.auth.signInWithEmailAndPassword(_email, _password);
      } else {
        await widget.auth
            .signUpUserWithEmailAndPassword(_email, _password, _name, _surname);
      }
      Navigator.of(context).pop();
    } catch (e) {
      print(e.toString());
    }
  }

  void _emailEditingComplete() {
    FocusScope.of(context).requestFocus(_passwordFocusNode);
  }

  ///This function switches the state of the button
  void _toggleFormType() {
    setState(() {
      _formType = _formType == EmailSignInFormType.signIn
          ? EmailSignInFormType.register
          : EmailSignInFormType.signIn;
    });
    _nameController.clear();
    _surnameController.clear();
    _emailController.clear();
    _passwordController.clear();
  }

  ///This is the list of widgets that are used to construct the Sign in form view
  List<Widget> _buildChildren() {
    if(_formType == EmailSignInFormType.register){
         FocusScope.of(context).requestFocus(_nameFocusNode);}

    final primaryText = _formType == EmailSignInFormType.signIn
        ? 'Sign in '
        : ' Create an account ';
    final secondaryText = _formType == EmailSignInFormType.signIn
        ? ' Need an account ? Register'
        : 'Have an account? Sign in';

    bool submitEnabled = _email.isNotEmpty && _password.isNotEmpty;
    return [
      _formType == EmailSignInFormType.register
          ? TextField(
              focusNode: _nameFocusNode,
              controller: _nameController,
              onEditingComplete: () {
                FocusScope.of(context).requestFocus(_surnameFocusNode);
              },
              decoration: InputDecoration(
                labelText: 'Name',
              ))
          : Opacity(opacity: 0),
      _formType == EmailSignInFormType.register
          ? TextField(
              focusNode: _surnameFocusNode,
              controller: _surnameController,
              onEditingComplete: () {
                FocusScope.of(context).requestFocus(_emailFocusNode);
              },
              decoration: InputDecoration(
                labelText: 'Surname',
              ))
          : Opacity(opacity: 0),
      _buildEmailTextField(),
      SizedBox(height: 8.0),
      _buildPasswordTextField(),
      SizedBox(height: 8.0),
      FormSubmitButton(
        onPressed: submitEnabled ? _submit: null,
        text: primaryText,
      ),
      SizedBox(height: 8.0),
      FlatButton(
        onPressed: _toggleFormType,
        child: Text(secondaryText),
      ),
    ];
  }

  Widget _buildEmailTextField() {
    return TextField(
      focusNode: _emailFocusNode,
      controller: _emailController,
      decoration: InputDecoration(
        labelText: 'Email',
        hintText: 'test@test.com',
      ),
      autocorrect: false,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      onEditingComplete: _emailEditingComplete,
      onChanged: (email)=> _updateState(),
    );
  }

  Widget _buildPasswordTextField() {
    return TextField(
      focusNode: _passwordFocusNode,
      controller: _passwordController,
      decoration: InputDecoration(
        labelText: 'Password',
      ),
      obscureText: true,
      textInputAction: TextInputAction.done,
      onEditingComplete: _submit,
      onChanged: (password)=> _updateState(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: _buildChildren(),
        ),
      ),
    );
  }

  _updateState(){
    print('email is $_email , password : $_password}');
    setState(() {});
  }
}