import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:simple_ecommerce/views/checkout_page.dart';
import '../controllers/cart_controller.dart';

class CartPage extends StatelessWidget {
  final cartController = Get.put(CartController(), permanent: true);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
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
                    leading: CachedNetworkImage(
                      imageUrl: product.image,
                      width: 60.0,
                      fit: BoxFit.contain,
                      placeholder: (context, url) =>
                          Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                    title: Text(product.title),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Obx(() => Text('\$${product.price * product.quantity.value}')), 
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(Icons.remove_circle_outline),
                              onPressed: () {
                                cartController.decreaseQuantity(product);
                              },
                            ),
                            Obx(() => Text('${product.quantity.value}')), 
                            IconButton(
                              icon: Icon(Icons.add_circle_outline),
                              onPressed: () {
                                cartController.increaseQuantity(product);
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.remove_circle, color: Colors.red,),
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
            child: Obx(() {
              return Text('Total: \$${cartController.totalPrice}',
                  style: TextStyle(fontSize: 24));
            }),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 15.0),
            height: size.height * 0.06,
            width: size.width * 0.7,
            child: ElevatedButton(
              onPressed: () {
                Get.to(() => CheckoutPage());
              },
              child: Text('Checkout'),
            ),
          ),
        ],
      ),
    );
  }
}
