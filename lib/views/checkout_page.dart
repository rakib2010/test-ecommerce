import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/cart_controller.dart';

class CheckoutPage extends StatelessWidget {
  final CartController cartController = Get.find<CartController>();
   void confirmOrder() {
    
    print('Order confirmed!');
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(title: Text('Checkout')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Order Summary', style: TextStyle(fontSize: 24)),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: cartController.cartItems.length,
                itemBuilder: (context, index) {
                  final product = cartController.cartItems[index];
                  return ListTile(
                    title: Text(product.title),
                    subtitle: Text('\$${product.price}'),
                  );
                },
              ),
            ),
            Center(
              child: Text('Total: \$${cartController.totalPrice}',
                  style: TextStyle(fontSize: 24)),
            ),
            Center(
                child: Container(
                  margin: EdgeInsets.only(top: 15.0),
                  height: size.height * 0.06,
                  width: size.width * 0.7,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      
                    ),
                    onPressed: () {
                       cartController.checkUser();
                    },

                    
                    child: Text('Confirm Order'),
                  ),
                ),
              ),
            
          ],
        ),
      ),
    );
  }
}
