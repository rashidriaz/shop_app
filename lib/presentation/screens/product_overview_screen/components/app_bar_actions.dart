import 'package:flutter/material.dart';
import 'package:shop_app/modals/filter_options.dart';

import 'add_cart_icon.dart';

List<Widget> appBarActions({ @required BuildContext context, @required Function onSelected})=> [
  PopupMenuButton(
    icon: Icon(
      Icons.more_vert,
    ),
    itemBuilder: (_) => [
      PopupMenuItem(
        child: Text("Only Favorites"),
        value: FilterOption.Favorites,
      ),
      PopupMenuItem(
        child: Text("Show All"),
        value: FilterOption.All,
      ),
    ],
    onSelected: onSelected,
  ),
  addCartIcon(context),
];