import 'package:get/get.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/product_model.dart';
import '../services/api_service.dart';

class ProductController extends GetxController {
  var isLoading = true.obs;
  var productList = <Product>[].obs;
  final apiService = ApiService();
  var isOffline = false.obs;
  var searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _checkConnectivityAndFetchProducts();
  }

  void _checkConnectivityAndFetchProducts() async {
    final connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
      isOffline(true);
      List<Product>? cachedProducts = await _getCachedProducts();
      if (cachedProducts != null) {
        productList.assignAll(cachedProducts);
        isLoading(false);
      } else {
        isLoading(false);
      }
    } else {
      isOffline(false);
      try {
        await fetchProducts(forceRefresh: true);
      } catch (e) {
        print('Error during data fetch: $e');
        List<Product>? cachedProducts = await _getCachedProducts();
        if (cachedProducts != null) {
          productList.assignAll(cachedProducts);
        }
      }
    }
  }

  Future<void> fetchProducts({bool forceRefresh = false}) async {
    try {
      isLoading(true);
      if (forceRefresh) {
        var products = await apiService.fetchProducts(forceRefresh: true);
        productList.assignAll(products);
        await _cacheProducts(products);
      } else {
        var cachedProducts = await _getCachedProducts();
        if (cachedProducts != null) {
          productList.assignAll(cachedProducts);
        } else {
          var products = await apiService.fetchProducts(forceRefresh: true);
          productList.assignAll(products);
          await _cacheProducts(products);
        }
      }
    } finally {
      isLoading(false);
    }
  }

  Future<void> _cacheProducts(List<Product> products) async {
    final prefs = await SharedPreferences.getInstance();
    final String encodedData = jsonEncode(
      products.map((product) => product.toJson()).toList(),
    );
    await prefs.setString('cachedProducts', encodedData);
  }

  Future<List<Product>?> _getCachedProducts() async {
    final prefs = await SharedPreferences.getInstance();
    final String? encodedData = prefs.getString('cachedProducts');
    if (encodedData != null) {
      List<dynamic> decodedData = jsonDecode(encodedData);
      return decodedData.map((item) => Product.fromJson(item)).toList();
    }
    return null;
  }
}
