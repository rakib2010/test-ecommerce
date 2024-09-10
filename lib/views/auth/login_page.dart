import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:simple_ecommerce/controllers/login_controller.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});
  final loginController = Get.put(LoginController());

    @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login with Google'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: ()async{
            await loginController.signInWithGoogle();

          },
          child: Text('Sign in with Google')
        ),
      ),
    );
  }
}