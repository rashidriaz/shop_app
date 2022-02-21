import 'package:flutter/material.dart';
import '../../../../helpers/validations.dart';

class PasswordInputField extends StatefulWidget {
  final Function(String) onSaved;
  final Function(String) onChanged;

  PasswordInputField(
      {@required this.onChanged, @required this.onSaved});

  @override
  _PasswordInputFieldState createState() => _PasswordInputFieldState();
}

class _PasswordInputFieldState extends State<PasswordInputField> {
  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'Password',
        suffixIcon: IconButton(
          icon: Icon(
            _isObscure ? Icons.visibility : Icons.visibility_off,
          ),
          onPressed: () {
            setState(() {
              _isObscure = !_isObscure;
            });
          },
        ),
      ),
      obscureText: _isObscure,
onChanged: widget.onChanged,
      validator: Validations.validatePassword,
      onSaved: widget.onSaved,
    );
  }
}
