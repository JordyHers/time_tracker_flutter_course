import 'package:flutter/material.dart';
import 'package:time_tracker_flutter_course/app/sign_in/validators.dart';
import 'package:time_tracker_flutter_course/common_widgets/form_submit_button.dart';
import 'package:time_tracker_flutter_course/services/auth.dart';

///Declaration of enum
///
/// This enum takes care of the different states of the sign in form
enum EmailSignInFormType { signIn, register }

class EmailSignInForm extends StatefulWidget with EmailAndPasswordValidators {
  EmailSignInForm({Key key, @required this.auth}) : super(key: key);
  final AuthBase auth;

  @override
  _EmailSignInFormState createState() => _EmailSignInFormState();
}

class _EmailSignInFormState extends State<EmailSignInForm> {
  ///--------------------------------------------------------------------
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

  bool _submitted = false;
  bool _isLoading = false;



  ///We declare the initial state of the sign in form as [EmailSignInFormType]
  ///
  ///
  /// If the state switches the Text will either display [register] or [signin]
  /// when [Need an account ? register] is pressed.
  EmailSignInFormType _formType = EmailSignInFormType.signIn;

  /// Submit function is called when the button is pressed
  void _submit() async {
    print('Submitted called');
    setState(() {
      _submitted = true;
      _isLoading =true;
    });
    try {

      if (_formType == EmailSignInFormType.signIn) {
        await widget.auth.signInWithEmailAndPassword(_email, _password);
      } else {
        await widget.auth.signUpUserWithEmailAndPassword(_email, _password, _name, _surname);
      }
      Navigator.of(context).pop();
    } catch (e) {
      print(e.toString());
    } finally{
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _emailEditingComplete() {
    FocusScope.of(context).requestFocus(_passwordFocusNode);
  }

  ///This function switches the state of the button
  void _toggleFormType() {
    setState(() {
      _submitted = false;
      _formType = _formType == EmailSignInFormType.signIn
          ? EmailSignInFormType.register
          : EmailSignInFormType.signIn;

      if (_formType == EmailSignInFormType.register) {
        FocusScope.of(context).requestFocus(_nameFocusNode);
      } else{
        FocusScope.of(context).requestFocus(_emailFocusNode);
      }

    });
    _nameController.clear();
    _surnameController.clear();
    _emailController.clear();
    _passwordController.clear();
  }

  ///-----------------------------------------------------------------------------------------
  ///
  ///
  ///
  ///This is the list of widgets that are used to construct the Sign in form view
  List<Widget> _buildChildren() {


    final primaryText = _formType == EmailSignInFormType.signIn
        ? 'Sign in '
        : ' Create an account ';
    final secondaryText = _formType == EmailSignInFormType.signIn
        ? ' Need an account ? Register'
        : 'Have an account? Sign in';

    bool submitSignInEnabled = widget.emailValidator.isValid(_email) &&
        widget.passwordValidator.isValid(_password) && !_isLoading;

    bool submitRegisterEnabled = widget.emailValidator.isValid(_email) &&
        widget.passwordValidator.isValid(_password) &&
        widget.nameValidator.isValid(_name) &&
        widget.surnameValidator.isValid(_surname);

    bool showErrorTextName = _submitted && ! widget.nameValidator.isValid(_name);
    bool showErrorTextSurname = _submitted && ! widget.surnameValidator.isValid(_surname) &&
    !_isLoading;

    return [
      ///These codes will display the Name and Surname fields
      ///
      ///when the button switches to register
      _formType == EmailSignInFormType.register
          ? TextField(
              focusNode: _nameFocusNode,
              controller: _nameController,
              onEditingComplete: () {
                FocusScope.of(context).requestFocus(_surnameFocusNode);
              },
              decoration: InputDecoration(
                labelText: 'Name',
                errorText: showErrorTextName ? widget.inValidNameErrorText : null,
                enabled: _isLoading ==false,
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
                errorText: showErrorTextSurname ? widget.inValidSurnameErrorText : null,
                enabled: _isLoading == false,
              ))
          : Opacity(opacity: 0),
      _buildEmailTextField(),
      SizedBox(height: 8.0),
      _buildPasswordTextField(),
      SizedBox(height: 8.0),
      FormSubmitButton(
        onPressed:
            submitRegisterEnabled || submitSignInEnabled ? _submit : null,
        text: primaryText,
      ),
      SizedBox(height: 8.0),
      FlatButton(
        onPressed: !_isLoading ? _toggleFormType : null,
        child: Text(secondaryText),
      ),
    ];
  }

  ///------------------------------ Widgets -------------------------------------------------
  ///
  ///
  ///
  Widget _buildEmailTextField() {
    bool showErrorTextEmail = _submitted && !widget.emailValidator.isValid(_email);
    return TextField(
      focusNode: _emailFocusNode,
      controller: _emailController,
      decoration: InputDecoration(
        labelText: 'Email',
        hintText: 'test@test.com',
        errorText: showErrorTextEmail ? widget.inValidEmailErrorText : null,
        enabled: _isLoading ==false
      ),
      autocorrect: false,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      onEditingComplete: _emailEditingComplete,
      onChanged: (email) => _updateState(),
    );
  }

  Widget _buildPasswordTextField() {
    bool showErrorTextPassword =_submitted && !widget.passwordValidator.isValid(_password);
    return TextField(
      focusNode: _passwordFocusNode,
      controller: _passwordController,
      decoration: InputDecoration(
        labelText: 'Password',
        errorText: showErrorTextPassword ? widget.inValidPasswordErrorText :null,
          enabled: _isLoading ==false
      ),
      obscureText: true,
      textInputAction: TextInputAction.done,
      onEditingComplete: _submit,
      onChanged: (password) => _updateState(),
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

  ///This method reloads the page
  _updateState() {
    setState(() {});
  }
}
