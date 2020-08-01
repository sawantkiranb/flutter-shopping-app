import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/order_item.dart';
import '../providers/orders_provider.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = '/orders';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pushReplacementNamed('/');
          },
        ),
        title: Text('Your Orders'),
      ),
      body: FutureBuilder(
        future: Provider.of<OrdersProvider>(context, listen: false)
            .fetchAndSetOrders(),
        builder: (ctx, dataSnapShot) {
          if (dataSnapShot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return Consumer<OrdersProvider>(
                builder: (ctx, orderData, child) => ListView.builder(
                      itemBuilder: (ctx, i) => OrderItem(orderData.orders[i]),
                      itemCount: orderData.orders.length,
                    ));
          }
        },
      ),
    );
  }
}
