import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/CartItem.dart';
import '../models/order.dart';

class OrdersProvider with ChangeNotifier {
  String apiUrl = 'https://flutter-shop-877ad.firebaseio.com/';

  List<Order> _orders = [];

  List<Order> get orders {
    return [..._orders];
  }

  Future<void> fetchAndSetOrders() async {
    final response = await http.get(apiUrl + 'orders.json');
    var ordersData = json.decode(response.body) as Map<String, dynamic>;
    List<Order> orders = [];

    if (ordersData != null) {
      ordersData.forEach((orderId, orderData) {
        orders.add(
          Order(
            id: orderId,
            amount: orderData['amount'],
            dateTime: DateTime.parse(orderData['dateTime']),
            products: (orderData['products'] as List<dynamic>)
                .map((item) => CartItem(
                      id: item['id'],
                      price: item['price'],
                      quantity: item['quantity'],
                      title: item['title'],
                    ))
                .toList(),
          ),
        );
      });
    }

    _orders = orders;
    notifyListeners();
  }

  Future<void> addOrder(List<CartItem> products, double total) async {
    try {
      final timeStamp = DateTime.now();
      final response = await http.post(apiUrl + 'orders.json',
          body: json.encode({
            'amount': total,
            'dateTime': timeStamp.toString(),
            'products': products
                .map((item) => {
                      'id': item.id,
                      'title': item.title,
                      'price': item.price,
                      'quantity': item.quantity,
                    })
                .toList(),
          }));

      _orders.insert(
        0,
        Order(
          id: json.decode(response.body)['name'],
          amount: total,
          products: products,
          dateTime: timeStamp,
        ),
      );
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
}
