import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:project_final_year/common_widget/loding_indicator.dart';
import 'package:project_final_year/consts/consts.dart';
import 'package:project_final_year/services/firestore_services.dart';
import 'package:project_final_year/views/orders_screen/orders_details_screen.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        title: 'My Orders'.text.color(darkFontGrey).fontFamily(semibold).make(),
      ),
      body: StreamBuilder(
        stream: FirestorServices.getAllOrders(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: loadingIndicator(),
            );
          } else if (snapshot.data!.docs.isEmpty) {
            return "No order yet!".text.color(darkFontGrey).makeCentered();
          } else {
            var data = snapshot.data!.docs;
            return ListView.builder(
                itemCount: data.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    leading: "${index + 1}"
                        .text
                        .fontFamily(bold)
                        .color(darkFontGrey)
                        .xl
                        .make(),
                    title: data[index]['order_code']
                        .toString()
                        .text
                        .color(redColor)
                        .fontFamily(semibold)
                        .make(),
                    subtitle: data[index]['total_amount']
                        .toString()
                        .numCurrency
                        .text
                        .fontFamily(bold)
                        .make(),
                    trailing: IconButton(
                      onPressed: () {
                        Get.to(() => OrderDetails(
                              data: data[index],
                            ));
                      },
                      icon: Icon(Icons.arrow_forward_ios_rounded),
                      color: darkFontGrey,
                    ),
                  );
                });
          }
        },
      ),
    );
  }
}
