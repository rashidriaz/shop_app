import 'package:flutter/material.dart';
import 'package:shop_app/modals/auth_mode.dart';


Row switchMode({Function onTap, BuildContext context, AuthMode authMode, String text}) {
  return Row(
    children: [
      const Text(
        "Don't have an account? Click here to ",
        style: TextStyle(fontSize: 14),
      ),
      InkWell(
        onTap: onTap,
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            color: Theme.of(context).primaryColor,
          ),
        ),
      ),
    ],
  );
}
