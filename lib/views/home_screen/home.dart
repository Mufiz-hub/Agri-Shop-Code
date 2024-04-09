import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_final_year/common_widget/exit_dialog.dart';
import 'package:project_final_year/consts/colors.dart';
import 'package:project_final_year/consts/images.dart';
import 'package:project_final_year/consts/strings.dart';
import 'package:project_final_year/consts/styles.dart';
import 'package:project_final_year/controoller/home_controller.dart';
import 'package:project_final_year/views/cart_screen/cart_screen.dart';
import 'package:project_final_year/views/category_screen/category_screen.dart';
import 'package:project_final_year/views/home_screen/home_screen.dart';
import 'package:project_final_year/views/profile_screen/profile_screen.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(HomeController());

    var navbarItem = [
      BottomNavigationBarItem(
          icon: Image.asset(
            icHome,
            width: 26,
          ),
          label: home),
      BottomNavigationBarItem(
          icon: Image.asset(
            icCategories,
            width: 26,
          ),
          label: categories),
      BottomNavigationBarItem(
          icon: Image.asset(
            icCart,
            width: 26,
          ),
          label: cart),
      BottomNavigationBarItem(
          icon: Image.asset(
            icProfile,
            width: 26,
          ),
          label: account),
    ];

    var navBody = [
      HomeScreen(),
      CategoryScreen(),
      CartScreen(),
      ProfileScreen(),
    ];
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) => exitDialog(context),
        );
        return false;
      },
      child: Scaffold(
        body: Column(
          children: [
            Obx(() => Expanded(
                child: navBody.elementAt(controller.currentNavIndex.value))),
          ],
        ),
        bottomNavigationBar: Obx(
          () => BottomNavigationBar(
              currentIndex: controller.currentNavIndex.value,
              selectedItemColor: redColor,
              selectedLabelStyle: TextStyle(fontFamily: semibold),
              type: BottomNavigationBarType.fixed,
              backgroundColor: whiteColor,
              items: navbarItem,
              onTap: (value) {
                controller.currentNavIndex.value = value;
              }),
        ),
      ),
    );
  }
}
