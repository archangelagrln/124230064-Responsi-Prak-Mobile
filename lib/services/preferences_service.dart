import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  static const String _keyUsername = 'logged_in_username';
  static const String _keyIsLoggedIn = 'is_logged_in';
  static const String _keyCart = 'cart_items';
  static const String _keyProfileImage = 'profile_image_path';

  Future<void> saveSession(String username) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUsername, username);
    await prefs.setBool(_keyIsLoggedIn, true);
  }

  Future<String?> getLoggedInUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUsername);
  }

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyIsLoggedIn) ?? false;
  }

  Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyUsername);
    await prefs.remove(_keyIsLoggedIn);
  }

  Future<void> addToCart(int productId) async {
    final prefs = await SharedPreferences.getInstance();
    List<int> cart = await getCartItems();
    if (!cart.contains(productId)) {
      cart.add(productId);
      await prefs.setString(_keyCart, json.encode(cart));
    }
  }

  Future<void> removeFromCart(int productId) async {
    final prefs = await SharedPreferences.getInstance();
    List<int> cart = await getCartItems();
    cart.remove(productId);
    await prefs.setString(_keyCart, json.encode(cart));
  }

  Future<List<int>> getCartItems() async {
    final prefs = await SharedPreferences.getInstance();
    String? cartString = prefs.getString(_keyCart);
    if (cartString == null || cartString.isEmpty) {
      return [];
    }
    List<dynamic> cartList = json.decode(cartString);
    return cartList.map((e) => e as int).toList();
  }

  Future<bool> isInCart(int productId) async {
    List<int> cart = await getCartItems();
    return cart.contains(productId);
  }

  Future<void> saveProfileImage(String imagePath) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyProfileImage, imagePath);
  }

  Future<String?> getProfileImage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyProfileImage);
  }

  Future<void> removeProfileImage() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyProfileImage);
  }
}
