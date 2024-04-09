import 'package:get/get.dart';
import 'package:project_final_year/common_widget/custom_textfield.dart';
import 'package:project_final_year/common_widget/our_button.dart';
import 'package:project_final_year/consts/consts.dart';
import 'package:project_final_year/controoller/cart_controller.dart';
import 'package:project_final_year/views/cart_screen/payment_method.dart';

class ShippingDetails extends StatelessWidget {
  const ShippingDetails({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<CartController>();
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        title: "Shipping Info"
            .text
            .color(darkFontGrey)
            .fontFamily(semibold)
            .make(),
      ),
      bottomNavigationBar: SizedBox(
        height: 60,
        child: myButton(
          onpress: () {
            if (controller.addressController.text.length > 10 &&
                controller.cityController.text.isNotEmpty &&
                controller.postalcodeController.text.isNotEmpty &&
                controller.stateController.text.isNotEmpty &&
                controller.phoneController.text.isNotEmpty) {
              Get.to(() => PaymentMethods());
            } else {
              VxToast.show(context, msg: "Please fill form properly");
            }
          },
          color: redColor,
          textColor: whiteColor,
          title: "Continue",
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            customTextField(
                hint: "Address",
                isPass: false,
                title: "Addess",
                conroller: controller.addressController),
            customTextField(
                hint: "City",
                isPass: false,
                title: "City",
                conroller: controller.cityController),
            customTextField(
                hint: "State",
                isPass: false,
                title: "State",
                conroller: controller.stateController),
            customTextField(
                hint: "Postal Code",
                isPass: false,
                title: "Postal Code",
                conroller: controller.postalcodeController),
            customTextField(
                hint: "Phone",
                isPass: false,
                title: "Phone",
                conroller: controller.phoneController),
          ],
        ),
      ),
    );
  }
}
