import 'package:flutter/material.dart';
import 'package:project_final_year/consts/consts.dart';
import 'package:project_final_year/views/orders_screen/components/order_place_details.dart';
import 'package:project_final_year/views/orders_screen/components/order_status.dart';
import 'package:intl/intl.dart' as intl;

class OrderDetails extends StatelessWidget {
  final dynamic data;
  const OrderDetails({super.key, this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        title: "Order Details!"
            .text
            .fontFamily(semibold)
            .color(darkFontGrey)
            .make(),
      ),
      body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(children: [
              orderStatus(
                  color: redColor,
                  icon: Icons.done,
                  title: "Placed",
                  showDone: data['order_placed']),
              orderStatus(
                  color: Colors.blue,
                  icon: Icons.thumb_up,
                  title: "Confirmed",
                  showDone: data['order_confirmed']),
              orderStatus(
                  color: Colors.yellow,
                  icon: Icons.car_crash,
                  title: "On Delivery",
                  showDone: data['order_on_deliery']),
              orderStatus(
                  color: Colors.purple,
                  icon: Icons.done_all_rounded,
                  title: "Deliverd",
                  showDone: data['order_deliverd']),
              Divider(),
              10.heightBox,
              Column(children: [
                orderPlaceDetails(
                    d1: data['order_code'],
                    d2: data['shipping_method'],
                    title1: "Order Code",
                    title2: "Shipping Method"),
                orderPlaceDetails(
                    d1: intl.DateFormat()
                        .add_yMd()
                        .format((data['order_date'].toDate())),
                    d2: data['payment_method'],
                    title1: "Order Date",
                    title2: "Payment Method"),
                orderPlaceDetails(
                    d1: "Unpaid",
                    d2: "Order Placed",
                    title1: "Payment Status",
                    title2: "Delivery Status"),
                //added this this widget single child scroll view for overcome oveflowing error in side address fields below line i added with my self.
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            "Shipping Address".text.fontFamily(semibold).make(),
                            "${data['order_by_name']}".text.make(),
                            "${data['order_by_email']}".text.make(),
                            "${data['order_by_address']}".text.make(),
                            "${data['order_by_city']}".text.make(),
                            "${data['order_by_state']}".text.make(),
                            "${data['order_by_phone']}".text.make(),
                            "${data['order_by_postalcode']}".text.make(),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 130,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            "Shipping Address".text.fontFamily(semibold).make(),
                            "${data['total_amount']}"
                                .text
                                .color(redColor)
                                .fontFamily(bold)
                                .make(),
                          ],
                        ),
                      )
                    ],
                  ),
                )
              ]).box.shadowMd.white.make(),
              Divider(),
              10.heightBox,
              "Order Products"
                  .text
                  .size(16)
                  .color(darkFontGrey)
                  .fontFamily(semibold)
                  .make(),
              10.heightBox,
              ListView(
                shrinkWrap: true,
                children: List.generate(data['orders'].length, (index) {
                  return orderPlaceDetails(
                      title1: data['orders'][index]['title'],
                      title2: data['orders'][index]['tprice'],
                      d1: "${data['orders'][index]['qty']}x",
                      d2: "Refundable");
                }).toList(),
              )
                  .box
                  .outerShadowMd
                  .white
                  .margin(EdgeInsets.only(bottom: 4))
                  .make(),
              20.heightBox,
            ]),
          )),
    );
  }
}
