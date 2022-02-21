import 'package:flutter/material.dart';
import 'package:shop_app/modals/auth_mode.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/modals/http_exception.dart';
import 'package:shop_app/presentation/screens/auth_screen/components/error_message.dart';
import 'package:shop_app/presentation/screens/auth_screen/components/submit_form_button.dart';
import 'package:shop_app/presentation/screens/auth_screen/components/toggle_signin_and_registration_form_button.dart';
import 'package:shop_app/providers/auth.dart';
import '../components/error_dialog.dart' as dialogs;

import 'confirm_password_form_field_with_animation.dart';
import 'email_input_field.dart';
import 'password_input_field.dart';

class AuthCard extends StatefulWidget {
  const AuthCard({
    Key key,
  }) : super(key: key);

  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthMode _authMode = AuthMode.LOGIN;
  Map<String, String> _authData = {
    'email': '',
    'password': '',
  };
  var _isLoading = false;
  AnimationController _controller;
  Animation<Offset> _slideAnimation;
  Animation<double> _opacityAnimation;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    _slideAnimation = Tween<Offset>(
      begin: Offset(0, -1.5),
      end: Offset(0, 0),
    ).animate(
      CurvedAnimation(
        curve: Curves.easeInBack,
        parent: _controller,
      ),
    );
    _opacityAnimation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
    });
    try {
      if (_authMode == AuthMode.LOGIN) {
        await Provider.of<Auth>(context, listen: false)
            .logIn(_authData['email'], _authData['password']);
      } else {
        await Provider.of<Auth>(context, listen: false)
            .signUp(_authData['email'], _authData['password']);
      }
    } on HttpException catch (error) {
      String errorMessage = getErrorMessage(error);
      dialogs.showErrorDialog(errorMessage, context);
    } catch (error) {
      const errorMessage = "Couldn't authenticate you. Please try again later!";
      dialogs.showErrorDialog(errorMessage, context);
    }
    setState(() {
      _isLoading = false;
    });
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.LOGIN) {
      setState(() {
        _authMode = AuthMode.SIGNUP;
      });
      _controller.forward();
    } else {
      setState(() {
        _authMode = AuthMode.LOGIN;
      });
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Container(
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeIn,
        width: deviceSize.width > 700 ? 500 : double.infinity,
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                EmailInputField(onSaved: _onSavedForEmail),
                PasswordInputField(
                    onChanged: _onSavedForPasswordField,
                    onSaved: _onSavedForPasswordField),
                ConfirmPasswordFormFieldWithAnimation(
                    authMode: _authMode,
                    slideAnimation: _slideAnimation,
                    opacityAnimation: _opacityAnimation,
                    getPassword: getPassword),
                const SizedBox(
                  height: 20,
                ),
                if (_isLoading)
                  CircularProgressIndicator()
                else
                  Align(
                    alignment: Alignment.center,
                    child: submitFormButton(
                      onPressed: _isLoading ? null : _submit,
                      isLoading: _isLoading,
                    ),
                  ),
                SizedBox(
                  height: 15,
                ),
                switchMode(
                    onTap: _switchAuthMode,
                    context: context,
                    text: _authMode == AuthMode.SIGNUP ? 'Login' : 'Signup'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onSavedForPasswordField(value) {
    _authData['password'] = value;
  }

  void _onSavedForEmail(value) {
    _authData['email'] = value;
  }

  String getPassword(){
    return _authData['password'];
  }
}