import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens/edit_product_screen.dart';
import '../widgets/user_product_item.dart';
import '../providers/products_provider.dart';
import '../widgets/app_drawer.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = '/user-products';

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Products'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductScreen.routeName);
            },
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
          future: Provider.of<ProductsProvider>(
            context,
            listen: false,
          ).fetchAndSetproducts(),
          builder: (ctx, dataSnapshot) {
            if (dataSnapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return Padding(
                padding: EdgeInsets.all(10),
                child: Consumer<ProductsProvider>(
                  builder: (ctx, productsData, child) => ListView.builder(
                    itemCount: productsData.items.length,
                    itemBuilder: (_, i) => Column(
                      children: <Widget>[
                        UserProductItem(
                          id: productsData.items[i].id,
                          title: productsData.items[i].title,
                          imageUrl: productsData.items[i].imageUrl,
                        ),
                        Divider(),
                      ],
                    ),
                  ),
                ),
              );
            }
          }),
    );
  }
}
