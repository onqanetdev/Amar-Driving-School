import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class CartService {
  static const _cartKey = 'cart_item';

  static Future<void> saveCartItem(String planType, int _count) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String, dynamic> cartItem = {
      'planType': planType,
      'count': _count,
    };
    await prefs.setString(_cartKey, jsonEncode(cartItem));
  }

  static Future<Map<String, dynamic>?> getCartItem() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? jsonString = prefs.getString(_cartKey);
    if (jsonString != null) {
      return jsonDecode(jsonString);
    }
    return null;
  }

  static Future<void> clearCart() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_cartKey);
  }

  static Future<bool> hasCartItem() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(_cartKey);
  }
}