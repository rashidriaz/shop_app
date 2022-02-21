import 'package:flutter/material.dart';

void showErrorDialog(String errorMessage, BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text("An Error Occurred"),
      content: Text(errorMessage),
      actions: [
        TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("Okay")),
      ],
    ),
  );
}