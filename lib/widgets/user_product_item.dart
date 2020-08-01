import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/products_provider.dart';

import '../screens/edit_product_screen.dart';

class UserProductItem extends StatelessWidget {
  final String id;
  final String imageUrl;
  final String title;

  UserProductItem({this.id, this.title, this.imageUrl});

  @override
  Widget build(BuildContext context) {
    final _scaffold = Scaffold.of(context);
    final _themeContext = Theme.of(context);

    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
      ),
      title: Text(title),
      trailing: Container(
        width: 100,
        child: Row(
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(EditProductScreen.routeName, arguments: id);
              },
              color: _themeContext.primaryColor,
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () async {
                try {
                  await Provider.of<ProductsProvider>(context, listen: false)
                      .deleteProduct(id);
                } catch (error) {
                  _scaffold.hideCurrentSnackBar();
                  _scaffold.showSnackBar(
                    SnackBar(
                      content: Text('Failed to delete product'),
                      backgroundColor: _themeContext.errorColor,
                    ),
                  );
                }
              },
              color: _themeContext.errorColor,
            ),
          ],
        ),
      ),
    );
  }
}
