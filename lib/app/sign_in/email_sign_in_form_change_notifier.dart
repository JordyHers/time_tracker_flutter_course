import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_flutter_course/app/sign_in/email_sign_in_change_model.dart';
import 'package:time_tracker_flutter_course/app/sign_in/email_sign_in_model.dart';
import 'package:time_tracker_flutter_course/common_widgets/form_submit_button.dart';
import 'package:time_tracker_flutter_course/common_widgets/show_exeption_alert.dart';
import 'package:time_tracker_flutter_course/services/auth.dart';

class EmailSignInFormChangeNotifier extends StatefulWidget {
  EmailSignInFormChangeNotifier({Key key, @required this.model})
      : super(key: key);
  final EmailSignInChangeModel model;

  /// this is the 'create' logic [Consumer ] and [Provider]
  static Widget create(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    return ChangeNotifierProvider<EmailSignInChangeModel>(
      create: (_) => EmailSignInChangeModel(auth: auth),
      child: Consumer<EmailSignInChangeModel>(
        builder: (_, model, __) => EmailSignInFormChangeNotifier(model: model),
      ),
    );
  }

  ///_____________________________________________________________________________________
  @override
  _EmailSignInFormChangeNotifierState createState() =>
      _EmailSignInFormChangeNotifierState();
}

class _EmailSignInFormChangeNotifierState
    extends State<EmailSignInFormChangeNotifier> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();

  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _surnameFocusNode = FocusNode();

  EmailSignInChangeModel get model => widget.model;

  ///void Dispose Method
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _surnameController.dispose();

    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _nameFocusNode.dispose();
    _surnameFocusNode.dispose();

    super.dispose();
  }

  /// Submit function is called when the button is pressed
  Future<void> _submit() async {
    try {
      await model.submit();
      Navigator.of(context).pop();
    } on FirebaseAuthException catch (e) {
      showExceptionAlertDialog(context,
          title: model.signInFailedText, exception: e);
    }
  }

  void _emailEditingComplete() {
    final newFocus = model.emailValidator.isValid(model.email)
        ? _passwordFocusNode
        : _emailFocusNode;
    FocusScope.of(context).requestFocus(newFocus);
  }

  ///This function switches the state of the button
  void _toggleFormType() {
    widget.model.toggleFormType();
    setState(() {
      if (model.formType == EmailSignInFormType.register) {
        FocusScope.of(context).requestFocus(_nameFocusNode);
      } else {
        FocusScope.of(context).requestFocus(_emailFocusNode);
      }
    });
    _nameController.clear();
    _surnameController.clear();
    _emailController.clear();
    _passwordController.clear();
  }

  List<Widget> _buildChildren() {
    return [
      model.formType == EmailSignInFormType.register
          ? _buildNameField()
          : Opacity(opacity: 0),
      model.formType == EmailSignInFormType.register
          ? _buildSurnameField()
          : Opacity(opacity: 0),
      _buildEmailTextField(),
      SizedBox(height: 8.0),
      _buildPasswordTextField(),
      SizedBox(height: 8.0),
      FormSubmitButton(
        onPressed: model.canSubmitRegister || model.canSubmitSignIn
            ? () => _submit()
            : null,
        text: model.primaryButtonText,
      ),
      SizedBox(height: 8.0),
      FlatButton(
        onPressed: !model.isLoading ? () => _toggleFormType() : null,
        child: Text(model.secondaryButtonText),
      ),
    ];
  }

  ///------------------------------ Widgets -------------------------------------------------

  Widget _buildSurnameField() {
    return TextField(
        focusNode: _surnameFocusNode,
        controller: _surnameController,
        textInputAction: TextInputAction.next,
        onChanged: (surname) => widget.model.updateSurname(surname),
        onEditingComplete: () {
          if (model.surnameValidator.isValid(model.surname) == true) {
            FocusScope.of(context).requestFocus(_emailFocusNode);
          }
        },
        decoration: InputDecoration(
          labelText: 'Surname',
          errorText:
              model.showErrorTextSurname ? model.inValidSurnameErrorText : null,
          enabled: model.isLoading == false,
        ));
  }

  Widget _buildNameField() {
    return TextField(
        focusNode: _nameFocusNode,
        controller: _nameController,
        textInputAction: TextInputAction.next,
        onChanged: (name) => widget.model.updateName(name),
        onEditingComplete: () {
          if (model.nameValidator.isValid(model.name) == true) {
            FocusScope.of(context).requestFocus(_surnameFocusNode);
          }
        },
        decoration: InputDecoration(
          labelText: 'Name',
          errorText:
              model.showErrorTextName ? model.inValidNameErrorText : null,
          enabled: model.isLoading == false,
        ));
  }

  Widget _buildEmailTextField() {
    return TextField(
      focusNode: _emailFocusNode,
      controller: _emailController,
      decoration: InputDecoration(
          labelText: 'Email',
          hintText: 'test@test.com',
          errorText:
              model.showErrorTextEmail ? model.inValidEmailErrorText : null,
          enabled: model.isLoading == false),
      autocorrect: false,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      onEditingComplete: () => _emailEditingComplete(),
      onChanged: (email) => widget.model.updateEmail(email),
    );
  }

  Widget _buildPasswordTextField() {
    return TextField(
      focusNode: _passwordFocusNode,
      controller: _passwordController,
      decoration: InputDecoration(
          labelText: 'Password',
          errorText: model.showErrorTexPassword
              ? model.inValidPasswordErrorText
              : null,
          enabled: model.isLoading == false),
      obscureText: true,
      textInputAction: TextInputAction.done,
      onEditingComplete: () => _submit(),
      onChanged: (password) => widget.model.updatePassword(password),
    );
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
