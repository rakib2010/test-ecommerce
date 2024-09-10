import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:simple_ecommerce/views/checkout_page.dart';



class LoginController extends GetxController {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  var isLoadin = false.obs;
  User? user;



  signInWithGoogle() async {
    isLoadin(true);
    try {
      await InternetAddress.lookup('google.com');
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      user = userCredential.user;

      print('user ============= $user');

      if (user != null) {
        Get.to(() => CheckoutPage());
        String uid = user!.uid;
        String displayName = user!.displayName ?? "No display name";
        String email = user!.email ?? "No email";
        String photoURL = user!.photoURL ?? "No photo URL";

        print('User ID: $uid');
        print('Display Name: $displayName');
        print('Email: $email');
        print('Photo URL: $photoURL');
      }
    } catch (e) {
      print('\n_signInWithGoogle: $e');
      return null;
    } finally{
      isLoadin(false);
    }
  }
}
