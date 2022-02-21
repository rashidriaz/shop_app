import 'package:flutter/material.dart';

AppBar userProductScreenAppBar({@required Function onPressedForActionButton}) {
  return AppBar(
    title: const Text("Your Product"),
    actions: <Widget>[
      IconButton(
        icon: const Icon(Icons.add),
        onPressed: onPressedForActionButton,
      ),
    ],
  );
}
