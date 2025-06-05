import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class Order {
  final List<Map<String, dynamic>> items;
  final double totalPrice;
  final String date;

  Order({required this.items, required this.totalPrice, required this.date});

  Map<String, dynamic> toJson() => {
        'items': items,
        'totalPrice': totalPrice,
        'date': date,
      };

  factory Order.fromJson(Map<String, dynamic> json) => Order(
        items: List<Map<String, dynamic>>.from(json['items']),
        totalPrice: json['totalPrice'],
        date: json['date'],
      );
}

Future<void> saveOrder(Order order) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String> existing = prefs.getStringList('orders') ?? [];

  existing.add(jsonEncode(order.toJson()));

  await prefs.setStringList('orders', existing);
}

Future<List<Order>> loadOrders() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String> stored = prefs.getStringList('orders') ?? [];

  return stored.map((e) => Order.fromJson(jsonDecode(e))).toList();
}
Future<void> clearOrders() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.remove('orders');
}

