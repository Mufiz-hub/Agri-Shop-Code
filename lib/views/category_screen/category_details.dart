import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_final_year/common_widget/bg_widget.dart';
import 'package:project_final_year/common_widget/loding_indicator.dart';
import 'package:project_final_year/consts/colors.dart';
import 'package:project_final_year/consts/images.dart';
import 'package:project_final_year/consts/styles.dart';
import 'package:project_final_year/controoller/home_controller.dart';
import 'package:project_final_year/controoller/product_controller.dart';
import 'package:project_final_year/services/firestore_services.dart';
import 'package:project_final_year/views/category_screen/item_details.dart';
import 'package:velocity_x/velocity_x.dart';

class CategoryDetails extends StatefulWidget {
  final String? title;
  const CategoryDetails({super.key, required this.title});

  @override
  State<CategoryDetails> createState() => _CategoryDetailsState();
}

class _CategoryDetailsState extends State<CategoryDetails> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    switchCategory(widget.title);
  }

  switchCategory(title) {
    if (controller.subCat.contains(title)) {
      productMethod = FirestorServices.getSubCategory(title);
    } else {
      productMethod = FirestorServices.getProduct(title);
    }
  }

  var controller = Get.find<ProductCotroller>();
  dynamic productMethod;
  @override
  Widget build(BuildContext context) {
    return bgWidget(
        child: Scaffold(
      appBar: AppBar(
        title: widget.title!.text.white.fontFamily(bold).make(),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(
                  controller.subCat.length,
                  (index) => "${controller.subCat[index]}"
                          .text
                          .size(12)
                          .fontFamily(semibold)
                          .color(darkFontGrey)
                          .makeCentered()
                          .box
                          .rounded
                          .size(120, 60)
                          .margin(EdgeInsets.symmetric(horizontal: 4))
                          .white
                          .make()
                          .onTap(() {
                        switchCategory("${controller.subCat[index]}");
                        setState(() {});
                      })),
            ),
          ),
          20.heightBox,
          StreamBuilder(
            stream: productMethod,
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) {
                return Expanded(
                  child: Center(
                    child: loadingIndicator(),
                  ),
                );
              } else if (snapshot.data!.docs.isEmpty) {
                return Expanded(
                  child: "No Products Found!"
                      .text
                      .color(darkFontGrey)
                      .makeCentered(),
                );
              } else {
                var data = snapshot.data!.docs;
                return Expanded(
                    child: GridView.builder(
                        physics: BouncingScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: data.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisExtent: 250,
                          mainAxisSpacing: 8,
                          crossAxisSpacing: 8,
                        ),
                        itemBuilder: (context, index) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image.network(
                                data[index]['p_imgs'][0],
                                height: 150,
                                width: 200,
                                fit: BoxFit.cover,
                              ),
                              "${data[index]['p_name']}"
                                  .text
                                  .fontFamily(semibold)
                                  .color(darkFontGrey)
                                  .make(),
                              10.heightBox,
                              "${data[index]['p_price']}"
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
                              .outerShadowSm
                              .margin(EdgeInsets.symmetric(horizontal: 4))
                              .padding(EdgeInsets.all(12))
                              .make()
                              .onTap(() {
                            controller.checkIfFav(data[index]);
                            Get.to(() => ItemDetails(
                                  title: ("${data[index]['p_name']}"),
                                  data: data[index],
                                ));
                          });
                        }));
              }
            },
          ),
        ],
      ),
    ));
  }
}
