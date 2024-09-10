import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:simple_ecommerce/views/checkout_page.dart';
import '../controllers/cart_controller.dart';

class CartPage extends StatelessWidget {
  final cartController = Get.put(CartController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Cart')),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              return ListView.builder(
                itemCount: cartController.cartItems.length,
                itemBuilder: (context, index) {
                  final product = cartController.cartItems[index];
                  return ListTile(
                    leading: Image.network(product.image),
                    title: Text(product.title),
                    subtitle: Text('\$${product.price}'),
                    trailing: IconButton(
                      icon: Icon(Icons.remove_circle),
                      onPressed: () {
                        cartController.removeFromCart(product);
                      },
                    ),
                  );
                },
              );
            }),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text('Total: \$${cartController.totalPrice}',
                style: TextStyle(fontSize: 24)),
          ),
          ElevatedButton(
            onPressed: () {
              Get.to(() => CheckoutPage());
            },
            child: Text('Checkout'),
          ),
        ],
      ),
    );
  }
}
