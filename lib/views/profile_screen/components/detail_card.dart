import 'package:project_final_year/consts/consts.dart';

Widget detailsCard({width, String? count, String? title}) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      count!.text.fontFamily(bold).size(16).color(darkFontGrey).make(),
      5.heightBox,
      title!.text.color(darkFontGrey).make()
    ],
  ).box.rounded.width(width).height(80).padding(EdgeInsets.all(4)).white.make();
}
