import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoppping_app/providers/orders_provider.dart';
import '../widgets/cart_item.dart';
import '../providers/cart_provider.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
      ),
      body: Column(
        children: <Widget>[
          Card(
            margin: EdgeInsets.all(10),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Total',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Spacer(),
                  Chip(
                    label: Text(
                      '\$${cartProvider.totalAmount.toStringAsFixed(2)}',
                      style: TextStyle(
                        color:
                            Theme.of(context).primaryTextTheme.headline6.color,
                      ),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  OrderButton(cartProvider: cartProvider),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: ListView.builder(
              itemBuilder: (ctx, i) => CartItem(
                id: cartProvider.items.values.toList()[i].id,
                title: cartProvider.items.values.toList()[i].title,
                price: cartProvider.items.values.toList()[i].price,
                quantity: cartProvider.items.values.toList()[i].quantity,
                productId: cartProvider.items.keys.toList()[i],
              ),
              itemCount: cartProvider.itemCount,
            ),
          ),
        ],
      ),
    );
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key key,
    @required this.cartProvider,
  }) : super(key: key);

  final CartProvider cartProvider;

  @override
  _OrderButtonState createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var _isLoading = false;

  Future<void> _placeOrder() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await Provider.of<OrdersProvider>(context, listen: false).addOrder(
        widget.cartProvider.items.values.toList(),
        widget.cartProvider.totalAmount,
      );

      widget.cartProvider.clear();
    } catch (error) {
      await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
                title: Text('An error occured'),
                content: Text('Something went wrong.'),
                actions: <Widget>[
                  FlatButton(
                    onPressed: () {
                      Navigator.of(ctx).pop();
                    },
                    child: Text('Ok'),
                  ),
                ],
              ));
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: (widget.cartProvider.totalAmount <= 0 || _isLoading)
          ? null
          : _placeOrder,
      child: _isLoading
          ? CircularProgressIndicator()
          : Text(
              'Order Now',
              style: TextStyle(
                color: Theme.of(context).primaryColor,
              ),
            ),
    );
  }
}
