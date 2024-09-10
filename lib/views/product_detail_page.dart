import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/product_model.dart';
import '../controllers/cart_controller.dart';

class ProductDetailPage extends StatelessWidget {
  final Product product;
  final cartController = Get.put(CartController());

  ProductDetailPage({required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(product.title)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(product.image),
            SizedBox(height: 16),
            Text(product.title, style: TextStyle(fontSize: 24)),
            SizedBox(height: 8),
            Text('\$${product.price}', style: TextStyle(fontSize: 24)),
            SizedBox(height: 16),
            Text(product.description),
            Spacer(),
            ElevatedButton(
              onPressed: () {
                cartController.addToCart(product);
                Get.snackbar('Added to Cart', product.title);
              },
              child: Text('Add to Cart'),
            ),
          ],
        ),
      ),
    );
  }
}
