import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/cart_item.dart';

class CartHelper {
  static const String _cartKey = 'cart_items';

  static Future<List<CartItem>> getCartItems() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_cartKey);
    if (data != null) {
      final List<dynamic> decoded = jsonDecode(data);
      return decoded.map((e) => CartItem.fromJson(e)).toList();
    }
    return [];
  }

  static Future<void> saveCartItems(List<CartItem> items) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = items.map((e) => e.toJson()).toList();
    prefs.setString(_cartKey, jsonEncode(jsonList));
  }

  static Future<void> addToCart(CartItem newItem) async {
    List<CartItem> currentItems = await getCartItems();

    final existingIndex = currentItems.indexWhere((item) => item.id == newItem.id);
    if (existingIndex >= 0) {
      currentItems[existingIndex].quantity += newItem.quantity;
    } else {
      currentItems.add(newItem);
    }

    await saveCartItems(currentItems);
  }

  static Future<void> clearCart() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(_cartKey);
  }
}
