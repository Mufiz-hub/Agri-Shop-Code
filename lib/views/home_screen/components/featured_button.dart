import 'package:get/get_core/get_core.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:project_final_year/consts/consts.dart';
import 'package:project_final_year/views/category_screen/category_details.dart';

Widget featuredButton({String? title, icon}) {
  return Row(
    children: [
      Image.asset(
        icon,
        width: 60,
        fit: BoxFit.fill,
      ),
      10.widthBox,
      title!.text.fontFamily(semibold).color(darkFontGrey).make().onTap(() {
        Get.to(() => CategoryDetails(title: title));
      }),
    ],
  )
      .box
      .white
      .width(200)
      .margin(EdgeInsets.symmetric(horizontal: 4))
      .padding(EdgeInsets.all(4))
      .roundedSM
      .outerShadowSm
      .make();
}
