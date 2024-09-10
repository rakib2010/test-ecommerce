import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:simple_ecommerce/views/cart_page.dart';
import '../models/product_model.dart';
import '../controllers/cart_controller.dart';

class ProductDetailPage extends StatelessWidget {
  final Product product;
  final cartController = Get.put(CartController());

  ProductDetailPage({required this.product});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(product.title),
        actions: [
          IconButton(
              onPressed: () => Get.to(() => CartPage()),
              icon: Icon(Icons.shopping_cart))
        ],
        ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: size.height * 0.5,
                width: double.infinity,
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
              SizedBox(height: 16),
              Text(product.title, style: TextStyle(fontSize: 24)),
              SizedBox(height: 8),
              Text('\$${product.price}', style: TextStyle(fontSize: 24)),
              SizedBox(height: 16),
              Text(product.description),
              Center(
                child: Container(
                  margin: EdgeInsets.only(top: 15.0),
                  height: size.height * 0.06,
                  width: size.width * 0.7,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      
                    ),
                    onPressed: () {
                      cartController.addToCart(product);
                      Get.snackbar('Added to Cart', product.title);
                    },
                    child: Text('Add to Cart'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
