import 'package:flutter/services.dart';
import 'package:project_final_year/common_widget/our_button.dart';
import 'package:project_final_year/consts/consts.dart';

Widget exitDialog(context) {
  return Dialog(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    child: Column(mainAxisSize: MainAxisSize.min, children: [
      "Confirm".text.fontFamily(bold).size(18).color(darkFontGrey).make(),
      const Divider(),
      10.heightBox,
      "Are You Sure You Want To Exit???"
          .text
          .size(16)
          .color(darkFontGrey)
          .make(),
      10.heightBox,
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ourButton(
              color: redColor,
              onpress: () {
                SystemNavigator.pop();
              },
              textColor: whiteColor,
              title: "Yes"),
          ourButton(
              color: redColor,
              onpress: () {
                Navigator.pop(context);
              },
              textColor: whiteColor,
              title: "No"),
        ],
      )
    ]).box.color(lightGrey).padding(EdgeInsets.all(12)).rounded.make(),
  );
}
