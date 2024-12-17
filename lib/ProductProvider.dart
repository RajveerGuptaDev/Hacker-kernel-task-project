import 'dart:convert';

import'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
class ProductProvider extends ChangeNotifier {
  List<Map<String, String>> _products = [];
  List<Map<String, String>> _filteredProducts = [];

  List<Map<String, String>> get filteredProducts => _filteredProducts;

  ProductProvider() {
    loadProducts();
  }
  Future<void> loadProducts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedProducts = prefs.getString('products');
    if (savedProducts != null) {
      _products = List<Map<String, String>>.from(jsonDecode(savedProducts));
      _filteredProducts = _products;
      notifyListeners();
    }
  }

  Future<void> saveProducts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('products', jsonEncode(_products));
  }

  void searchProducts(String query) {
    _filteredProducts = _products
        .where((product) => product['name']!.toLowerCase().contains(query.toLowerCase()))
        .toList();
    notifyListeners();
  }

  void addProduct(Map<String, String> product) {
    _products.add(product);
    _filteredProducts = _products;
    saveProducts();
    notifyListeners();
  }

  void deleteProduct(int index) {
    _products.removeAt(index);
    _filteredProducts = _products;
    saveProducts();
    notifyListeners();
  }
}
