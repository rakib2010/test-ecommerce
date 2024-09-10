import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:simple_ecommerce/controllers/login_controller.dart';
import 'package:simple_ecommerce/models/product_model.dart';
import 'package:simple_ecommerce/views/auth/login_page.dart';

class CartController extends GetxController {
  final LoginController loginController = Get.find();
  var cartItems = <Product>[].obs;
  var totalPrice = 0.0.obs;
  Box cartBox = Hive.box('cartBox');
  bool verified = false;

  @override
  void onInit() {
    super.onInit();
    loadCartFromHive();
  }

  checkUser() async {
    User? user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    Get.to(() => LoginPage());
  } else {
    Get.snackbar('successful', 'Your order is placed successfully');
  }
  }

  void addToCart(Product product) {
    int index = cartItems.indexWhere((item) => item.id == product.id);
    if (index != -1) {
      cartItems[index].quantity.value++;
    } else {
      product.quantity = 1.obs;
      cartItems.add(product);
    }
    updateTotalPrice();
    saveCartToHive();
  }

  void removeFromCart(Product product) {
    cartItems.remove(product);
    updateTotalPrice();
    saveCartToHive();
  }

  void increaseQuantity(Product product) {
    product.quantity.value++;
    updateTotalPrice();
    saveCartToHive();
  }

  void decreaseQuantity(Product product) {
    if (product.quantity.value > 1) {
      product.quantity.value--;
      updateTotalPrice();
      saveCartToHive();
    }
  }

  void updateTotalPrice() {
    totalPrice.value = cartItems.fold(
        0, (sum, item) => sum + (item.price * item.quantity.value));
  }

  void saveCartToHive() {
    cartBox.put('cartItems', cartItems.map((item) => item.toJson()).toList());
  }

  void loadCartFromHive() {
    List<dynamic>? storedItems = cartBox.get('cartItems');

    if (storedItems != null) {
      cartItems.value = storedItems.map((itemJson) {
        final item = Map<String, dynamic>.from(itemJson as Map);
        return Product.fromJson(item);
      }).toList();

      updateTotalPrice();
    }
  }
}
