import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:simple_ecommerce/controllers/login_controller.dart';
import 'package:simple_ecommerce/views/cart_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../controllers/product_controller.dart';
import 'product_detail_page.dart';

class ProductListPage extends StatelessWidget {
  final productController = Get.put(ProductController());
  final loginController = Get.put(LoginController());
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Products'),
        actions: [
          IconButton(
            onPressed: () => Get.to(() => CartPage()),
            icon: Icon(Icons.shopping_cart),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              onChanged: (query) {
                productController.searchQuery.value = query;
              },
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Search products...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ),
          Expanded(
            child: Obx(() {
              if (productController.isLoading.value) {
                return Center(child: CircularProgressIndicator());
              }

              final searchQuery = productController.searchQuery.value.toLowerCase();
              final filteredProducts = productController.productList
                  .where((product) =>
                      product.title.toLowerCase().contains(searchQuery))
                  .toList();

              if (filteredProducts.isEmpty) {
                return Center(child: Text('No products found.'));
              }

              return RefreshIndicator(
                onRefresh: () async {
                  await productController.fetchProducts(forceRefresh: true);
                },
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10.0,
                    mainAxisSpacing: 10.0,
                    childAspectRatio: 3 / 4,
                  ),
                  itemCount: filteredProducts.length,
                  itemBuilder: (context, index) {
                    final product = filteredProducts[index];
                    return GestureDetector(
                      onTap: () {
                        Get.to(() => ProductDetailPage(product: product));
                      },
                      child: Card(
                        color: Colors.white,
                        elevation: 10.0,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: CachedNetworkImage(
                                imageUrl: product.image,
                                fit: BoxFit.contain,
                                width: double.infinity,
                                placeholder: (context, url) =>
                                    Center(child: CircularProgressIndicator()),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                product.title,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text('\$${product.price}'),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

class ProductSearchDelegate extends SearchDelegate {
  final ProductController productController;

  ProductSearchDelegate(this.productController);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
          productController.searchQuery.value = query;
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container(); // This is not used as search results are displayed in the same page
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container(); // This can be used for showing search suggestions if needed
  }
}
