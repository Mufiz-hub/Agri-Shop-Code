import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_final_year/common_widget/loding_indicator.dart';
import 'package:project_final_year/common_widget/our_button.dart';
import 'package:project_final_year/consts/colors.dart';
import 'package:project_final_year/controoller/product_controller.dart';
import 'package:velocity_x/src/flutter/toast.dart';

import 'package:project_final_year/consts/consts.dart';
import 'package:project_final_year/consts/lists.dart';
import 'package:project_final_year/consts/styles.dart';
import 'package:project_final_year/controoller/cart_controller.dart';
import 'package:project_final_year/views/home_screen/home.dart';

class PaymentMethods extends StatelessWidget {
  const PaymentMethods({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<CartController>();
    var controllerProduct = Get.find<ProductCotroller>();
    return Obx(
      () => Scaffold(
        backgroundColor: whiteColor,
        bottomNavigationBar: SizedBox(
          height: 60,
          child: controller.placingOrder.value
              ? Center(
                  child: loadingIndicator(),
                )
              : myButton(
                  onpress: () async {
                    try {
                      await controller.placeOrder(
                        orderPaymentMethod:
                            paymentMethods[controller.paymentIndex.value],
                        totalAmount: controller.tPrice.value,
                      );
                      await controller.clearCart();
                      try {
                        String productId = 'JqxX7ZHgneMgWsMBzMwf';
                        int quantity = int.parse(
                            controllerProduct.quantityCount.value.toString());
                        controllerProduct.updateProductQuantity(
                            productId, quantity);
                      } catch (e) {
                        print(
                            "error occcuring while updating quantity the error is :- $e");
                      }
                      VxToast.show(context, msg: 'Order Placed Successfully!');
                      Get.offAll(Home());
                    } catch (e) {
                      print('Error occurred: $e');
                      // Handle error here
                    }
                  },
                  color: redColor,
                  textColor: whiteColor,
                  title: "Place my order!",
                ),
        ),
        appBar: AppBar(
          title: "Choose Payment Method"
              .text
              .color(darkFontGrey)
              .fontFamily(semibold)
              .make(),
        ),
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Obx(
            () => Column(
                children: List.generate(paymentMethodsImg.length, (index) {
              return GestureDetector(
                onTap: () {
                  controller.changePaymentIndex(index);
                },
                child: Container(
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: controller.paymentIndex.value == index
                              ? redColor
                              : Colors.transparent,
                          width: 4),
                      borderRadius: BorderRadius.circular(12)),
                  margin: EdgeInsets.only(bottom: 8),
                  child: Stack(
                    alignment: Alignment.topRight,
                    children: [
                      Image.asset(
                        paymentMethodsImg[index],
                        width: double.infinity,
                        color: controller.paymentIndex.value == index
                            ? Colors.black.withOpacity(0.4)
                            : Colors.transparent,
                        colorBlendMode: controller.paymentIndex.value == index
                            ? BlendMode.darken
                            : BlendMode.color,
                        height: 120,
                        fit: BoxFit.cover,
                      ),
                      controller.paymentIndex.value == index
                          ? Transform.scale(
                              scale: 1.3,
                              child: Checkbox(
                                  activeColor: Colors.green,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50)),
                                  value: true,
                                  onChanged: ((value) {})),
                            )
                          : Container(),
                      Positioned(
                        bottom: 10,
                        right: 10,
                        child: "${paymentMethods[index]}"
                            .text
                            .white
                            .size(16)
                            .fontFamily(bold)
                            .make(),
                      ),
                    ],
                  ),
                ),
              );
            })),
          ),
        ),
      ),
    );
  }
}
//ccc