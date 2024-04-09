import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:project_final_year/consts/consts.dart';

class AuthController extends GetxController {
  var isLoading = false.obs;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<UserCredential?> loginMethod({context}) async {
    UserCredential? userCredential;
    try {
      await auth.signInWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);
    } on FirebaseAuthException catch (e) {
      VxToast.show(context, msg: e.message.toString());
    }

    return userCredential;
  }

  Future<UserCredential?> signUpMethod({email, password, context}) async {
    UserCredential? userCredential;
    try {
      await auth.createUserWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      VxToast.show(context, msg: e.message.toString());
    }

    return userCredential;
  }

//store data

  storeUserData({name, email, password}) async {
    DocumentReference store =
        firestore.collection(userCollection).doc(currentUser!.uid);

    store.set({
      'name': name,
      'password': password,
      'email': email,
      'imageUrl': '',
      'id': currentUser!.uid,
      'cart_count': '00',
      'wishlist_count': '00',
      'order_count': '00'
    });
  }

  signOutMethod(context) async {
    try {
      await auth.signOut();
    } on FirebaseAuthException catch (e) {
      VxToast.show(context, msg: e.message.toString());
    }
  }
}
