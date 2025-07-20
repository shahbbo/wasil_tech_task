import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/error/exceptions.dart';
import '../models/cart_item_model.dart';

abstract class CartLocalDataSource {
  Future<List<CartItemModel>> getCartItems();
  Future<void> saveCartItems(List<CartItemModel> items);
  Future<void> clearCart();
}

class CartLocalDataSourceImpl implements CartLocalDataSource {
  final SharedPreferences sharedPreferences;
  static const String cartKey = 'CART_ITEMS';

  CartLocalDataSourceImpl(this.sharedPreferences);

  @override
  Future<List<CartItemModel>> getCartItems() async {
    try {
      final jsonString = sharedPreferences.getString(cartKey);
      if (jsonString != null) {
        final jsonList = json.decode(jsonString) as List;
        return jsonList
            .map((item) => CartItemModel.fromJson(item))
            .toList();
      }
      return [];
    } catch (e) {
      throw CacheException('Failed to get cart items');
    }
  }

  @override
  Future<void> saveCartItems(List<CartItemModel> items) async {
    try {
      final jsonList = items.map((item) => item.toJson()).toList();
      final jsonString = json.encode(jsonList);
      await sharedPreferences.setString(cartKey, jsonString);
    } catch (e) {
      throw CacheException('Failed to save cart items');
    }
  }

  @override
  Future<void> clearCart() async {
    try {
      await sharedPreferences.remove(cartKey);
    } catch (e) {
      throw CacheException('Failed to clear cart');
    }
  }
}