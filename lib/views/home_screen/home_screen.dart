import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:project_final_year/common_widget/home_button.dart';
import 'package:project_final_year/common_widget/loding_indicator.dart';
import 'package:project_final_year/consts/colors.dart';
import 'package:project_final_year/consts/consts.dart';
import 'package:project_final_year/consts/lists.dart';
import 'package:project_final_year/controoller/home_controller.dart';
import 'package:project_final_year/controoller/product_controller.dart';
import 'package:project_final_year/services/firestore_services.dart';
import 'package:project_final_year/views/category_screen/item_details.dart';
import 'package:project_final_year/views/home_screen/components/featured_button.dart';
import 'package:project_final_year/views/home_screen/search_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(ProductCotroller());
    var homeController = Get.find<HomeController>();
    return Container(
      padding: EdgeInsets.all(12),
      color: lightGrey,
      width: context.screenWidth,
      height: context.screenHeight,
      child: SafeArea(
          child: Column(
        children: [
          Container(
            alignment: Alignment.center,
            height: 60,
            color: lightGrey,
            child: TextFormField(
              controller: homeController.searchController,
              decoration: InputDecoration(
                border: InputBorder.none,
                suffixIcon: Icon(Icons.search).onTap(() {
                  if (homeController
                      .searchController.text.isNotEmptyAndNotNull) {
                    Get.to(
                      () => SearchScreen(
                        title: homeController.searchController.text,
                      ),
                    );
                  }
                }),
                filled: true,
                fillColor: whiteColor,
                hintText: searchanything,
                hintStyle: TextStyle(color: textfieldGrey),
              ),
            ),
          ),
          10.heightBox,
          Expanded(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                children: [
                  VxSwiper.builder(
                      height: 150,
                      enlargeCenterPage: true,
                      aspectRatio: 16 / 9,
                      autoPlay: true,
                      itemCount: slidersList.length,
                      itemBuilder: (context, index) {
                        return Image.asset(
                          slidersList[index],
                          fit: BoxFit.fitHeight,
                        )
                            .box
                            .rounded
                            .clip(Clip.antiAlias)
                            // .margin(const EdgeInsets.all(8))
                            .make();
                      }),
                  20.heightBox,
                  Align(
                      alignment: Alignment.centerLeft,
                      child: featuredCategories.text
                          .color(darkFontGrey)
                          .size(18)
                          .fontFamily(semibold)
                          .make()),
                  20.heightBox,
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(
                          3,
                          (index) => Column(
                                children: [
                                  featuredButton(
                                    icon: featuredImages1[index],
                                    title: featuredTitles1[index],
                                  ),
                                  10.heightBox,
                                  featuredButton(
                                    icon: featuredImages2[index],
                                    title: featuredTitles2[index],
                                  ),
                                ],
                              )).toList(),
                    ),
                  ),
                  20.heightBox,
                  Container(
                    padding: EdgeInsets.all(12),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: redColor,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        featuredProducts.text.white
                            .size(18)
                            .fontFamily(bold)
                            .make(),
                        10.heightBox,
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: FutureBuilder(
                              future: FirestorServices.getFeaturedProduct(),
                              builder: (context,
                                  AsyncSnapshot<QuerySnapshot> snapshot) {
                                if (!snapshot.hasData) {
                                  return Center(
                                    child: loadingIndicator(),
                                  );
                                } else if (snapshot.data!.docs.isEmpty) {
                                  return "No Featured Products!"
                                      .text
                                      .white
                                      .makeCentered();
                                } else {
                                  var featuredData = snapshot.data!.docs;
                                  return Row(
                                    children: List.generate(
                                      featuredData.length,
                                      (index) => Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Image.network(
                                            featuredData[index]['p_imgs'][0],
                                            width: 130,
                                            height: 130,
                                            fit: BoxFit.cover,
                                          ),
                                          10.heightBox,
                                          "${featuredData[index]['p_name']}"
                                              .text
                                              .fontFamily(semibold)
                                              .color(darkFontGrey)
                                              .make(),
                                          10.heightBox,
                                          "${featuredData[index]['p_price']}"
                                              .numCurrency
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
                                          .make()
                                          .onTap(() {
                                        Get.to(
                                          () => ItemDetails(
                                            title:
                                                "${featuredData[index]['p_name']}",
                                            data: featuredData[index],
                                          ),
                                        );
                                      }),
                                    ),
                                  );
                                }
                              }),
                        ),
                      ],
                    ),
                  ),
                  20.heightBox,
                  VxSwiper.builder(
                      height: 150,
                      enlargeCenterPage: true,
                      aspectRatio: 16 / 9,
                      autoPlay: true,
                      itemCount: secondSlidersList.length,
                      itemBuilder: (context, index) {
                        return Image.asset(
                          secondSlidersList[index],
                          fit: BoxFit.fitWidth,
                        )
                            .box
                            .rounded
                            .clip(Clip.antiAlias)
                            .margin(const EdgeInsets.all(8))
                            .make();
                      }),
                  20.heightBox,
                  StreamBuilder(
                      stream: FirestorServices.allProducts(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (!snapshot.hasData) {
                          return loadingIndicator();
                        } else {
                          var allProductsData = snapshot.data!.docs;
                          return GridView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: allProductsData.length,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 8,
                                crossAxisSpacing: 8,
                                mainAxisExtent: 300,
                              ),
                              itemBuilder: (context, index) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Image.network(
                                      allProductsData[index]['p_imgs'][0],
                                      height: 200,
                                      width: 200,
                                      fit: BoxFit.cover,
                                    ),
                                    const Spacer(),
                                    "${allProductsData[index]['p_name']}"
                                        .text
                                        .fontFamily(semibold)
                                        .color(darkFontGrey)
                                        .make(),
                                    10.heightBox,
                                    "${allProductsData[index]['p_price']}"
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
                                    .margin(EdgeInsets.symmetric(horizontal: 4))
                                    .padding(EdgeInsets.all(12))
                                    .make()
                                    .onTap(() {
                                  Get.to(() => ItemDetails(
                                        title:
                                            "${allProductsData[index]['p_name']}",
                                        data: allProductsData[index],
                                      ));
                                });
                              });
                        }
                      })
                ],
              ),
            ),
          )
        ],
      )),
    );
  }
}
