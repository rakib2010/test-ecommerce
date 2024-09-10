import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/product_model.dart';

class ApiService {
  static const String baseUrl = 'https://fakestoreapi.com';
  static const String cachedProductsKey = 'cached_products';

  Future<List<Product>> fetchProducts({bool forceRefresh = false}) async {
    final prefs = await SharedPreferences.getInstance();

    if (!forceRefresh) {
      String? cachedProducts = prefs.getString(cachedProductsKey);
      if (cachedProducts != null) {
        try {
          List<dynamic> data = jsonDecode(cachedProducts);
          return data.map((item) => Product.fromJson(item)).toList();
        } catch (e) {
          print('Error decoding cached products: $e');
        }
      }
    }

    try {
      final response = await http.get(Uri.parse('$baseUrl/products'));

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);

        await prefs.setString(cachedProductsKey, response.body);

        return data.map((item) => Product.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load products: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching products from API: $e');
      String? cachedProducts = prefs.getString(cachedProductsKey);
      if (cachedProducts != null) {
        List<dynamic> data = jsonDecode(cachedProducts);
        return data.map((item) => Product.fromJson(item)).toList();
      }
      throw e;
    }
  }
}
