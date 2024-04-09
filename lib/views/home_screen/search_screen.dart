import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:project_final_year/common_widget/loding_indicator.dart';
import 'package:project_final_year/consts/colors.dart';
import 'package:project_final_year/consts/consts.dart';
import 'package:project_final_year/services/firestore_services.dart';
import 'package:project_final_year/views/category_screen/item_details.dart';

class SearchScreen extends StatelessWidget {
  String? title;
  SearchScreen({super.key, this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        title: title!.text.color(darkFontGrey).make(),
      ),
      body: FutureBuilder(
          future: FirestorServices.getSearchProducts(title),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: loadingIndicator(),
              );
            } else if (snapshot.data!.docs.isEmpty) {
              return "No Product Found!".text.makeCentered();
            } else {
              var data = snapshot.data!.docs;
              var filtered = data
                  .where(
                    (element) => element['p_name']
                        .toString()
                        .toLowerCase()
                        .contains(title!.toLowerCase()),
                  )
                  .toList();
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: GridView(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    mainAxisExtent: 300,
                  ),
                  children: filtered
                      .mapIndexed((currentValue, index) => Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image.network(
                                filtered[index]['p_imgs'][0],
                                height: 200,
                                width: 200,
                                fit: BoxFit.cover,
                              ),
                              const Spacer(),
                              "${filtered[index]['p_name']}"
                                  .text
                                  .fontFamily(semibold)
                                  .color(darkFontGrey)
                                  .make(),
                              10.heightBox,
                              "${filtered[index]['p_price']}"
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
                              .shadowMd
                              .margin(EdgeInsets.symmetric(horizontal: 4))
                              .padding(EdgeInsets.all(12))
                              .make()
                              .onTap(() {
                            Get.to(() => ItemDetails(
                                  title: "${filtered[index]['p_name']}",
                                  data: filtered[index],
                                ));
                          }))
                      .toList(),
                ),
              );
            }
          }),
    );
  }
}
