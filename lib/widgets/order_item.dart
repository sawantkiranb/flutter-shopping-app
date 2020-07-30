import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/order.dart';

class OrderItem extends StatefulWidget {
  final Order order;
  OrderItem(this.order);

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  var _expanded = false;
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text(
              '\$${widget.order.amount}',
            ),
            subtitle: Text(
              DateFormat.yMMMEd().format(widget.order.dateTime),
            ),
            trailing: IconButton(
              icon: Icon(
                Icons.expand_more,
              ),
              onPressed: () {
                setState(() {
                  _expanded = !_expanded;
                });
              },
            ),
          ),
          if (_expanded)
            Container(
              margin: EdgeInsets.all(20),
              child: Column(
                children: <Widget>[
                  ...widget.order.products.map(
                    (product) => ListTile(
                      leading: Text(
                        '${widget.order.products.indexOf(product) + 1}',
                      ),
                      title: Text(
                        product.title,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text('${product.price} X ${product.quantity}'),
                      trailing: Text('${product.price * product.quantity}'),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
