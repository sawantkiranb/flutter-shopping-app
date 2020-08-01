import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../providers/product_provider.dart';
import '../screens/product_detail_screen.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(
      context,
      listen: false,
    );

    final _scaffold = Scaffold.of(context);
    final _theme = Theme.of(context);

    return Consumer<ProductProvider>(
      builder: (ctx, data, child) => ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(
              ProductDetailScreen.routeName,
              arguments: data.product.id,
            );
          },
          child: GridTile(
            footer: GridTileBar(
              backgroundColor: Colors.black87,
              title: Text(data.product.title),
              leading: IconButton(
                onPressed: () async {
                  try {
                    await data.toggleFavouriteStatus();
                  } catch (error) {
                    _scaffold.showSnackBar(SnackBar(
                      content: !data.product.isFavourite
                          ? Text('Failed to mark as favourite')
                          : Text('Failed to remove from favourite'),
                      backgroundColor: _theme.errorColor,
                    ));
                  }
                },
                icon: Icon(
                  data.product.isFavourite
                      ? Icons.favorite
                      : Icons.favorite_border,
                  color: Theme.of(context).accentColor,
                ),
              ),
              trailing: IconButton(
                onPressed: () {
                  cartProvider.addItem(
                    productId: data.product.id,
                    title: data.product.title,
                    price: data.product.price,
                  );
                  Scaffold.of(context).hideCurrentSnackBar();
                  Scaffold.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Item added to cart'),
                      duration: Duration(seconds: 2),
                      action: SnackBarAction(
                          label: 'UNDO',
                          onPressed: () {
                            cartProvider.removeSingleItem(data.product.id);
                          }),
                    ),
                  );
                },
                icon: Icon(
                  Icons.shopping_cart,
                  color: Theme.of(context).accentColor,
                ),
              ),
            ),
            child: Image.network(
              data.product.imageUrl,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
