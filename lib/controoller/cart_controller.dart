import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:project_final_year/consts/consts.dart';
import 'package:project_final_year/consts/lists.dart';
import 'package:project_final_year/controoller/home_controller.dart';
import 'package:project_final_year/views/home_screen/home.dart';

class CartController extends GetxController {
  var addressController = TextEditingController();
  var vendors = [];
  var cityController = TextEditingController();
  var stateController = TextEditingController();
  var postalcodeController = TextEditingController();
  var phoneController = TextEditingController();
  var tPrice = 0.obs;
  var paymentIndex = 0.obs;
  late dynamic productSnapshot;
  var products = [];
  var placingOrder = false.obs;
  calculate(data) {
    tPrice.value = 0;
    for (var i = 0; i < data.length; i++) {
      tPrice.value = tPrice.value + int.parse(data[i]['tprice'].toString());
    }
  }

  changePaymentIndex(index) {
    paymentIndex.value = index;
  }

  placeOrder({required orderPaymentMethod, required totalAmount}) async {
    placingOrder(true);

    await getProductDetails();
    await firestore.collection(ordersCollection).doc().set({
      'order_code': "233981237",
      'order_date': FieldValue.serverTimestamp(),
      'order_by': currentUser!.uid,
      'order_by_name': Get.find<HomeController>().username,
      'order_by_email': currentUser!.email,
      'order_by_address': addressController.text,
      'order_by_state': stateController.text,
      'order_by_city': cityController.text,
      'order_by_phone': phoneController.text,
      'order_by_postalcode': postalcodeController.text,
      'shipping_method': "Home Delivery",
      'payment_method': orderPaymentMethod,
      'order_placed': true,
      'order_confirmed': false,
      'order_deliverd': false,
      'order_on_deliery': false,
      'total_amount': totalAmount,
      'orders': FieldValue.arrayUnion(products),
      'vendors': FieldValue.arrayUnion(vendors)
    });

    placingOrder(false);
  }

  getProductDetails() {
    products.clear();
    vendors.clear();
    for (var i = 0; i < productSnapshot.length; i++) {
      products.add({
        'img': productSnapshot[i]['img'],
        'vendor_id': productSnapshot[i]['vendor_id'],
        'tprice': productSnapshot[i]['tprice'],
        'qty': productSnapshot[i]['qty'],
        'title': productSnapshot[i]['title']
      });
      vendors.add(productSnapshot[i]['vendor_id']);
    }
  }

  clearCart() {
    products.clear();
    for (var i = 0; i < productSnapshot.length; i++) {
      firestore.collection(cartCollection).doc(productSnapshot[i].id).delete();
    }
  }
}
