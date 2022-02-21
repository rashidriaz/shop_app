import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products_provider.dart';
import 'package:shop_app/presentation/screens/edit_product_screen.dart';

class UserProductItem extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;

  const UserProductItem(this.title, this.imageUrl, this.id);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
      ),
      trailing: Container(
        width: 100,
        child: Row(
          children: [
            editButton(context, id),
            deleteIcon(context, id),
          ],
        ),
      ),
    );
  }

  IconButton deleteIcon(BuildContext context, String id) {
    final scaffold = Scaffold.of(context);
    return IconButton(
      icon: Icon(Icons.delete),
      onPressed: () async {
        try {
          await Provider.of<Products>(context, listen: false).deleteProduct(id);
        } catch (error) {
          scaffold.showSnackBar(
            SnackBar(
              content: Text("Deletion Failed", textAlign: TextAlign.center,),
            ),
          );
        }
      },
      color: Theme.of(context).errorColor,
    );
  }

  IconButton editButton(BuildContext context, String id) {
    return IconButton(
      icon: Icon(Icons.edit),
      onPressed: () {
        Navigator.of(context)
            .pushNamed(EditProductScreen.routeName, arguments: id);
      },
      color: Theme.of(context).primaryColor,
    );
  }
}
