import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project_final_year/common_widget/loding_indicator.dart';
import 'package:project_final_year/consts/consts.dart';
import 'package:project_final_year/services/firestore_services.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        title:
            'My Wishlist'.text.color(darkFontGrey).fontFamily(semibold).make(),
      ),
      body: StreamBuilder(
        stream: FirestorServices.getWishlist(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: loadingIndicator(),
            );
          } else if (snapshot.data!.docs.isEmpty) {
            return "No Wishlist yet!".text.color(darkFontGrey).makeCentered();
          } else {
            var data = snapshot.data!.docs;
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: data.length,
                      itemBuilder: (BuildContext context, index) {
                        return ListTile(
                          leading: Image.network(
                            "${data[index]['p_imgs'][0]}",
                            width: 80,
                            fit: BoxFit.cover,
                          ),
                          title: "${data[index]['p_name']}"
                              .text
                              .fontFamily(semibold)
                              .size(16)
                              .make(),
                          subtitle: "${data[index]['p_price']}"
                              .numCurrency
                              .text
                              .color(redColor)
                              .fontFamily(semibold)
                              .make(),
                          trailing: Icon(
                            Icons.favorite,
                            color: redColor,
                          ).onTap(() async {
                            await firestore
                                .collection(productCollection)
                                .doc(data[index].id)
                                .set({
                              'p_wishlist':
                                  FieldValue.arrayRemove([currentUser!.uid]),
                            }, SetOptions(merge: true));
                          }),
                        );
                      }),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
