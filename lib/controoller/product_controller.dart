import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:project_final_year/consts/consts.dart';
import 'package:project_final_year/models/category_model.dart';

class ProductCotroller extends GetxController {
  var totalPrice = 0.obs;
  var quantityCount = 0.obs;
  var subCat = [];
  var isFav = false.obs;

  getSubCategory(title) async {
    subCat.clear();
    var data = await rootBundle.loadString("lib/services/category_model.json");
    var decoded = categoryModelFromJson(data);
    var s =
        decoded.categories.where((element) => element.name == title).toList();
    for (var e in s[0].subcategory) {
      subCat.add(e);
    }
  }

  increaseQuantity(totalQuantity) {
    if (quantityCount.value < totalQuantity) {
      quantityCount.value++;
    }
  }

  decreaseQuantity() {
    if (quantityCount.value > 0) {
      quantityCount.value--;
    }
  }

  calculateTotalPrice(price) {
    totalPrice.value = price * quantityCount.value;
  }

  addToCart({title, img, sellerName, qty, tprice, context, vendorID}) async {
    await firestore.collection(cartCollection).doc().set({
      'title': title,
      'img': img,
      'sellerName': sellerName,
      'qty': qty,
      'vendor_id': vendorID,
      'tprice': tprice,
      'added_by': currentUser!.uid
    }).catchError((error) {
      VxToast.show(context, msg: error.toString());
    });
  }

  resetValues() {
    totalPrice.value = 0;
    quantityCount.value = 0;
  }

  addToWishlist(context, docId) async {
    await firestore.collection(productCollection).doc(docId).set({
      'p_wishlist': FieldValue.arrayUnion([currentUser!.uid])
    }, SetOptions(merge: true));
    isFav(true);
    VxToast.show(context, msg: "Added To Wishlisht");
  }

  removeToWishlist(context, docId) async {
    await firestore.collection(productCollection).doc(docId).set({
      'p_wishlist': FieldValue.arrayRemove([currentUser!.uid])
    }, SetOptions(merge: true));
    isFav(false);
    VxToast.show(context, msg: "Removed From Wishlist");
  }

  checkIfFav(data) {
    if (data['p_wishlist'].contains(currentUser!.uid)) {
      isFav(true);
    } else {
      isFav(false);
    }
  }

  // Your existing code...

  // Function to update quantity when a user buys a product
  // Function to update quantity when a user buys a product
  Future<void> updateProductQuantity(
      String productId, int quantityBought) async {
    try {
      // Retrieve the product document from Firestore
      DocumentSnapshot productSnapshot =
          await firestore.collection(productCollection).doc(productId).get();
      if (productSnapshot.exists) {
        // Cast the data to a Map<String, dynamic> type
        Map<String, dynamic>? productData =
            productSnapshot.data() as Map<String, dynamic>?;

        // Get the current quantity of the product
        int currentQuantity = productData?['p_quantity'] ?? 0;

        // Ensure that the product has sufficient quantity
        if (currentQuantity >= quantityBought) {
          // Calculate the new quantity after the purchase
          int newQuantity = currentQuantity - quantityBought;

          String newQuantityString = newQuantity.toString();

          // Update the quantity of the product in Firestore using set method
          await firestore.collection(productCollection).doc(productId).set({
            'p_quantity': newQuantityString,
          }, SetOptions(merge: true));
        } else {
          // Handle the case where the product is out of stock
          throw Exception('Product is out of stock');
        }
      } else {
        // Handle the case where the product document does not exist
        throw Exception('Product not found');
      }
    } catch (error) {
      // Handle any errors that occur during the update process
      print('Error updating product quantity: $error');
      rethrow; // Rethrow the error to propagate it to the caller
    }
  }
}
