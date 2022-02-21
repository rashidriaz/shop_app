import 'package:flutter/material.dart';

ElevatedButton submitFormButton({Function onPressed, bool isLoading}) {
  return ElevatedButton(
    onPressed: onPressed,
    child: isLoading
        ? CircularProgressIndicator()
        : Icon(
      Icons.keyboard_arrow_right_sharp,
      size: 40,
    ),
    style: ElevatedButton.styleFrom(
        shape: CircleBorder(), padding: EdgeInsets.all(18)),
  );
}