import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:project_final_year/common_widget/loding_indicator.dart';
import 'package:project_final_year/common_widget/our_button.dart';
import 'package:project_final_year/consts/colors.dart';
import 'package:project_final_year/consts/consts.dart';
import 'package:project_final_year/consts/lists.dart';
import 'package:project_final_year/controoller/cart_controller.dart';
import 'package:project_final_year/controoller/product_controller.dart';
import 'package:project_final_year/services/firestore_services.dart';
import 'package:project_final_year/views/chat_screen/chat_screen.dart';

class ItemDetails extends StatelessWidget {
  final String? title;
  final dynamic data;

  const ItemDetails({super.key, required this.title, this.data});

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<ProductCotroller>();
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        controller.resetValues();
        return true;
      },
      child: Scaffold(
        backgroundColor: lightGrey,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              controller.resetValues();
              Get.back();
            },
          ),
          title: title!.text.color(darkFontGrey).fontFamily(bold).make(),
          actions: [
            IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.share,
                )),
            Obx(
              () => IconButton(
                  onPressed: () {
                    if (controller.isFav.value) {
                      controller.removeToWishlist(context, data.id);
                    } else {
                      controller.addToWishlist(context, data.id);
                    }
                  },
                  icon: Icon(
                    Icons.favorite_outlined,
                    color: controller.isFav.value ? redColor : darkFontGrey,
                  )),
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
                child: Padding(
              padding: EdgeInsets.all(8),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    VxSwiper.builder(
                        autoPlay: true,
                        height: 350,
                        aspectRatio: 3,
                        viewportFraction: 1.0,
                        itemCount: data['p_imgs'].length,
                        itemBuilder: (context, index) {
                          return Image.network(
                            data['p_imgs'][index],
                            width: double.infinity,
                            fit: BoxFit.cover,
                          );
                        }),
                    10.heightBox,
                    title!.text
                        .fontFamily(semibold)
                        .color(darkFontGrey)
                        .size(16)
                        .make(),
                    10.heightBox,
                    VxRating(
                      isSelectable: false,
                      value: double.parse(data['p_rating']),
                      onRatingUpdate: (value) {},
                      normalColor: textfieldGrey,
                      selectImage: golden,
                      count: 5,
                      size: 25,
                      maxRating: 5,
                    ),
                    10.heightBox,
                    "${data['p_price']}"
                        .numCurrency
                        .text
                        .color(redColor)
                        .size(18)
                        .fontFamily(bold)
                        .make(),
                    10.heightBox,
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              "Seller".text.white.fontFamily(semibold).make(),
                              5.heightBox,
                              "${data['p_seller']}"
                                  .text
                                  .color(darkFontGrey)
                                  .fontFamily(semibold)
                                  .size(16)
                                  .make(),
                            ],
                          ),
                        ),
                        CircleAvatar(
                          backgroundColor: Colors.white,
                          child: Icon(
                            Icons.message_rounded,
                            color: darkFontGrey,
                          ).onTap(() {
                            Get.to(() => ChatScreen(), arguments: [
                              data['p_seller'],
                              data['vendor_id'],
                            ]);
                          }),
                        )
                      ],
                    )
                        .box
                        .height(60)
                        .padding(EdgeInsets.symmetric(horizontal: 16))
                        .color(textfieldGrey)
                        .make(),
                    20.heightBox,
                    Column(
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              width: 100,
                              child:
                                  "Quantity: ".text.color(textfieldGrey).make(),
                            ),
                            Obx(
                              () => Row(
                                children: [
                                  IconButton(
                                      onPressed: () {
                                        controller.decreaseQuantity();
                                        controller.calculateTotalPrice(
                                            int.parse(data['p_price']));
                                      },
                                      icon: Icon(Icons.remove)),
                                  controller.quantityCount.value.text
                                      .size(16)
                                      .color(darkFontGrey)
                                      .fontFamily(bold)
                                      .make(),
                                  IconButton(
                                      onPressed: () {
                                        controller.increaseQuantity(
                                            int.parse(data['p_quantity']));
                                        controller.calculateTotalPrice(
                                            int.parse(data['p_price']));
                                      },
                                      icon: Icon(Icons.add)),
                                  10.heightBox,
                                  "(${data['p_quantity']} available)"
                                      .text
                                      .color(textfieldGrey)
                                      .make()
                                ],
                              ),
                            )
                          ],
                        ).box.padding(EdgeInsets.all(8)).make(),
                        Obx(
                          () => Row(
                            children: [
                              SizedBox(
                                width: 100,
                                child:
                                    "Total:".text.color(textfieldGrey).make(),
                              ),
                              "${controller.totalPrice.value}"
                                  .numCurrency
                                  .text
                                  .color(redColor)
                                  .fontFamily(bold)
                                  .size(16)
                                  .make()
                            ],
                          ).box.padding(EdgeInsets.all(8)).make(),
                        )
                      ],
                    ).box.white.shadowSm.make(),
                    10.heightBox,
                    "Description"
                        .text
                        .color(darkFontGrey)
                        .fontFamily(semibold)
                        .make(),
                    10.heightBox,
                    "${data['p_desc']}".text.color(darkFontGrey).make(),
                    10.heightBox,
                    ListView(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      children: List.generate(
                          itemDetailButtonsList.length,
                          (index) => ListTile(
                                title: "${itemDetailButtonsList[index]}"
                                    .text
                                    .fontFamily(semibold)
                                    .color(darkFontGrey)
                                    .make(),
                                trailing: Icon(Icons.arrow_forward),
                              )),
                    ),
                    20.heightBox,
                    productsyoumaylike.text
                        .color(darkFontGrey)
                        .fontFamily(bold)
                        .size(16)
                        .make(),
                    10.heightBox,
                    StreamBuilder(
                        stream: FirestorServices.allProducts(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (!snapshot.hasData) {
                            return Center(child: loadingIndicator());
                          } else {
                            var data = snapshot.data!.docs;
                            // Get total number of products
                            int totalProducts = data.length;

                            // Generate a random index within the range of available products
                            Random random = Random();
                            int randomIndex = random.nextInt(totalProducts);

                            // Get a random product from the list
                            QueryDocumentSnapshot<Object?> randomProduct =
                                data[randomIndex];

                            // Extract product details
                            // String productName = randomProduct['p_name'];
                            // String productDescription = randomProduct['p_desc'];
                            return SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: List.generate(
                                    data.length - 1,
                                    (index) => Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Image.network(
                                              randomProduct['p_imgs'][0],
                                              width: 150,
                                              fit: BoxFit.cover,
                                            ),
                                            10.heightBox,
                                            "${randomProduct['p_name']}"
                                                .text
                                                .fontFamily(semibold)
                                                .color(darkFontGrey)
                                                .make(),
                                            10.heightBox,
                                            "${randomProduct['p_price']}"
                                                .text
                                                .color(redColor)
                                                .fontFamily(bold)
                                                .size(16)
                                                .make()
                                          ],
                                        )
                                            .box
                                            .white
                                            .roundedSM
                                            .margin(EdgeInsets.symmetric(
                                                horizontal: 4))
                                            .padding(EdgeInsets.all(8))
                                            .make()),
                              ),
                            );
                          }
                        }),
                  ],
                ),
              ),
            )),
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ourButton(
                  color: redColor,
                  onpress: () {
                    if (controller.quantityCount.value > 0) {
                      controller.addToCart(
                          context: context,
                          title: data['p_name'],
                          img: data['p_imgs'][0],
                          qty: controller.quantityCount.value,
                          vendorID: data['vendor_id'],
                          sellerName: data['p_seller'],
                          tprice: controller.totalPrice.value);
                      VxToast.show(context, msg: "Added To Cart!");
                    } else {
                      return VxToast.show(context,
                          msg: "Minimum 1 Product Is Required");
                    }
                  },
                  textColor: whiteColor,
                  title: "Add to cart"),
            ),
          ],
        ),
      ),
    );
  }
}
