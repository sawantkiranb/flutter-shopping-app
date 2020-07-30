import './CartItem.dart';

class Order {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  Order({this.id, this.amount, this.products, this.dateTime});
}
