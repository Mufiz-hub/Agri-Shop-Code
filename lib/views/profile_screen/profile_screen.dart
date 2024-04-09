import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:project_final_year/common_widget/bg_widget.dart';
import 'package:project_final_year/common_widget/loding_indicator.dart';
import 'package:project_final_year/consts/consts.dart';
import 'package:project_final_year/consts/lists.dart';
import 'package:project_final_year/controoller/auth_controller.dart';
import 'package:project_final_year/controoller/profile_controller.dart';
import 'package:project_final_year/services/firestore_services.dart';
import 'package:project_final_year/views/auth_screen/login_screen.dart';
import 'package:project_final_year/views/chat_screen/messaging_screen.dart';
import 'package:project_final_year/views/orders_screen/orders_screen.dart';
import 'package:project_final_year/views/profile_screen/components/detail_card.dart';
import 'package:project_final_year/views/profile_screen/edit_profile_screen.dart';
import 'package:project_final_year/views/wishlist_screen/wishlist_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(ProfileController());
    return bgWidget(
      child: Scaffold(
        body: StreamBuilder(
            stream: FirestorServices.getUser(currentUser!.uid),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) {
                print("Snapshot has no data   ${snapshot}");
                return const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(redColor),
                  ),
                );
              } else {
                var data = snapshot.data!.docs[0];
                return SafeArea(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Align(
                          alignment: Alignment.topRight,
                          child: Icon(
                            Icons.edit,
                            color: whiteColor,
                          ),
                        ).onTap(() {
                          controller.nameController.text = data["name"];

                          Get.to(() => EditProfileScreen(
                                data: data,
                              ));
                        }),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Row(
                          children: [
                            data['imageUrl'] == ''
                                ? Image.asset(
                                    imgProfile2,
                                    width: 100,
                                    fit: BoxFit.cover,
                                  ).box.roundedFull.clip(Clip.antiAlias).make()
                                : Image.network(
                                    data['imageUrl'],
                                    width: 100,
                                    fit: BoxFit.cover,
                                  ).box.roundedFull.clip(Clip.antiAlias).make(),
                            5.widthBox,
                            Expanded(
                                child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                "${data['name']}"
                                    .text
                                    .white
                                    .fontFamily(semibold)
                                    .make(),
                                "${data['email']}".text.white.make(),
                              ],
                            )),
                            OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                    side: BorderSide(
                                  color: whiteColor,
                                )),
                                onPressed: () =>
                                    controller.logOutandGotoLogin(),
                                child: "Log Out"
                                    .text
                                    .white
                                    .fontFamily(semibold)
                                    .make())
                          ],
                        ),
                      ),
                      20.heightBox,
                      FutureBuilder(
                          future: FirestorServices.getCounts(),
                          builder:
                              (BuildContext context, AsyncSnapshot snapshot) {
                            if (!snapshot.hasData) {
                              return Center(
                                child: loadingIndicator(),
                              );
                            } else {
                              var countData = snapshot.data;
                              return Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  detailsCard(
                                      width: context.screenWidth / 3.4,
                                      count: "${countData[0]}",
                                      title: "In your cart"),
                                  detailsCard(
                                      width: context.screenWidth / 3.4,
                                      count: "${countData[1]}",
                                      title: "In your wishlist"),
                                  detailsCard(
                                      width: context.screenWidth / 3.4,
                                      count: "${countData[2]}",
                                      title: "your orders"),
                                ],
                              );
                            }
                          }),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      //   children: [
                      //     detailsCard(
                      //         width: context.screenWidth / 3.4,
                      //         count: "${data['cart_count']}",
                      //         title: "In your cart"),
                      //     detailsCard(
                      //         width: context.screenWidth / 3.4,
                      //         count: "${data['wishlist_count']}",
                      //         title: "In your wishlist"),
                      //     detailsCard(
                      //         width: context.screenWidth / 3.4,
                      //         count: "${data['order_count']}",
                      //         title: "your orders"),
                      //   ],
                      // ),
                      ListView.separated(
                              shrinkWrap: true,
                              separatorBuilder: (context, index) {
                                return Divider(
                                  color: lightGrey,
                                );
                              },
                              itemCount: profileButtonsList.length,
                              itemBuilder: (BuildContext context, int index) {
                                return ListTile(
                                  onTap: () {
                                    switch (index) {
                                      case 0:
                                        Get.to(() => OrdersScreen());
                                        break;
                                      case 1:
                                        Get.to(() => WishlistScreen());
                                        break;
                                      case 2:
                                        Get.to(() => MessegesScreen());
                                        break;
                                    }
                                  },
                                  leading: Image.asset(
                                    profileButtonsIcons[index],
                                    width: 22,
                                  ),
                                  title: profileButtonsList[index]
                                      .text
                                      .color(darkFontGrey)
                                      .fontFamily(semibold)
                                      .make(),
                                );
                              })
                          .box
                          .white
                          .rounded
                          .shadowSm
                          .margin(EdgeInsets.all(12))
                          .padding(EdgeInsets.symmetric(horizontal: 16))
                          .make()
                          .box
                          .color(redColor)
                          .make()
                    ],
                  ),
                );
              }
            }),
      ),
    );
  }
}
