import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:project_final_year/common_widget/loding_indicator.dart';
import 'package:project_final_year/common_widget/our_button.dart';
import 'package:project_final_year/consts/colors.dart';
import 'package:project_final_year/consts/consts.dart';
import 'package:project_final_year/controoller/cart_controller.dart';
import 'package:project_final_year/services/firestore_services.dart';
import 'package:project_final_year/views/cart_screen/shipping_screen.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(CartController());
    return Scaffold(
        bottomNavigationBar: SizedBox(
          height: 60,
          child: myButton(
              color: redColor,
              title: "Procced To Shipping",
              onpress: () {
                Get.to(() => ShippingDetails());
              },
              textColor: whiteColor),
        ),
        backgroundColor: whiteColor,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: "Shopping Cart"
              .text
              .color(darkFontGrey)
              .fontFamily(semibold)
              .make(),
        ),
        body: StreamBuilder(
          stream: FirestorServices.getCart(currentUser!.uid),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: loadingIndicator(),
              );
            } else if (snapshot.data!.docs.isEmpty) {
              return Center(
                child: "Cart is empty!".text.color(darkFontGrey).make(),
              );
            } else {
              var data = snapshot.data!.docs;
              controller.productSnapshot = data;
              controller.calculate(data);
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(children: [
                  Expanded(
                      child: Container(
                    child: ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          leading: Image.network(
                            "${data[index]['img']}",
                            width: 80,
                            fit: BoxFit.cover,
                          ),
                          title:
                              "${data[index]['title']} (x${data[index]['qty']})"
                                  .text
                                  .fontFamily(semibold)
                                  .size(16)
                                  .make(),
                          subtitle: "${data[index]['tprice']}"
                              .numCurrency
                              .text
                              .color(redColor)
                              .fontFamily(semibold)
                              .make(),
                          trailing: Icon(
                            Icons.delete,
                            color: redColor,
                          ).onTap(() {
                            FirestorServices.deleteDocument(data[index].id);
                          }),
                        );
                      },
                    ),
                  )),
                  Obx(
                    () => Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        "Total Price"
                            .text
                            .fontFamily(semibold)
                            .color(darkFontGrey)
                            .make(),
                        "${controller.tPrice.value}"
                            .numCurrency
                            .text
                            .fontFamily(semibold)
                            .color(darkFontGrey)
                            .make()
                      ],
                    )
                        .box
                        .padding(EdgeInsets.all(12))
                        .color(lightGolden)
                        .width(context.screenWidth - 60)
                        .roundedSM
                        .make(),
                  ),
                  10.heightBox,
                  // SizedBox(
                  //   width: context.screenWidth - 60,
                  //   child: ourButton(
                  //       color: redColor,
                  //       title: "Procced To Shipping",
                  //       onpress: () {},
                  //       textColor: whiteColor),
                  // )
                ]),
              );
            }
          },
        ));
  }
}
