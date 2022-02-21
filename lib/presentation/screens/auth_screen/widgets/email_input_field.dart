import 'package:flutter/material.dart';
import '../../../../helpers/validations.dart';
class EmailInputField extends StatelessWidget {
  final Function(String) onSaved;

  EmailInputField({@required this.onSaved});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Email'),
      keyboardType: TextInputType.emailAddress,
      validator: Validations.isEmail,
      onSaved: onSaved,
    );
  }
}
