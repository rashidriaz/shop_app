import 'package:flutter/material.dart';

class AlertDialogBox extends StatelessWidget {
  final String title;
  final String message;
  final String buttonText;
  final BuildContext context;
  final Function onPressed;

  AlertDialogBox(
      {@required this.title,
        @required this.message,
        @required this.buttonText,
        this.onPressed,
        @required this.context});

  @override
  Widget build(BuildContext context) {
    Widget button = TextButton(
      child: Text(buttonText),
      onPressed: () {
        Navigator.of(context).pop();
        onPressed();
      },
    );

    return AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        button,
      ],
    );
  }
}
