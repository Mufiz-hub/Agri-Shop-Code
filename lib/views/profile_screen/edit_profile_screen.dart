import 'dart:io';

// import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'package:get/get_instance/get_instance.dart';
import 'package:project_final_year/common_widget/bg_widget.dart';
import 'package:project_final_year/common_widget/custom_textfield.dart';
import 'package:project_final_year/common_widget/loding_indicator.dart';
import 'package:project_final_year/common_widget/our_button.dart';
import 'package:project_final_year/consts/consts.dart';
// import 'package:project_final_year/consts/images.dart';
import 'package:project_final_year/controoller/profile_controller.dart';

class EditProfileScreen extends StatelessWidget {
  final dynamic data;
  const EditProfileScreen({super.key, this.data});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(ProfileController());

    return bgWidget(
        child: Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Obx(
          () => Column(mainAxisSize: MainAxisSize.min, children: [
            //if image url and controller means inside selected image is  empty then show default image
            data['imageUrl'] == '' && controller.profileImgPath.isEmpty
                ? Image.asset(
                    imgProfile2,
                    width: 100,
                    fit: BoxFit.cover,
                  ).box.roundedFull.clip(Clip.antiAlias).make()
                //if image url is not empty and controller is empty then show a network image that availible on firebase
                : data['imageUrl'] != '' && controller.profileImgPath.isEmpty
                    ? Image.network(
                        data['imageUrl'],
                        width: 100,
                        fit: BoxFit.cover,
                      ).box.roundedFull.clip(Clip.antiAlias).make()
                    //if image url is empty but controller is not empty then show controller selected image
                    : Image.file(
                        File(controller.profileImgPath.value),
                        width: 100,
                        fit: BoxFit.cover,
                      ).box.roundedFull.clip(Clip.antiAlias).make(),
            10.heightBox,
            ourButton(
                color: redColor,
                onpress: () {
                  controller.changeImage(context);
                },
                textColor: whiteColor,
                title: "Change"),
            Divider(),
            20.heightBox,
            customTextField(
                conroller: controller.nameController,
                hint: nameHint,
                title: name,
                isPass: false),
            10.heightBox,
            customTextField(
                conroller: controller.oldpassController,
                hint: passwordHint,
                title: oldPass,
                isPass: true),
            10.heightBox,
            customTextField(
                conroller: controller.newpassController,
                hint: passwordHint,
                title: newPass,
                isPass: true),
            20.heightBox,
            controller.isLoading.value
                ? loadingIndicator()
                : SizedBox(
                    width: context.screenWidth - 60,
                    child: ourButton(
                        color: redColor,
                        onpress: () async {
                          controller.isLoading(true);
//checkin if image is selected or not
                          if (controller.profileImgPath.value.isNotEmpty) {
                            await controller.uploadImage();
                          } else {
                            controller.profileImageLink = data['imageUrl'];
                          }
                          //checking if old password is correct in databse or not if correct then and then only user can change password

                          if (data['password'] ==
                              controller.oldpassController.text) {
                            await controller.changeAuthPassword(
                                email: data['email'],
                                password: controller.oldpassController.text,
                                newPassword: controller.newpassController.text);
                            await controller.updateProfile(
                                imgUrl: controller.profileImageLink,
                                name: controller.nameController.text,
                                password: controller.newpassController.text);
                            VxToast.show(context,
                                msg: "Profile Updated Successfully!");
                          } else {
                            VxToast.show(context, msg: "Wrong Old Password");
                            controller.isLoading(false);
                          }
                        },
                        textColor: whiteColor,
                        title: "Save"),
                  ),
          ])
              .box
              .white
              .shadowSm
              .padding(EdgeInsets.all(16))
              .margin(EdgeInsets.only(top: 50, left: 12, right: 12))
              .rounded
              .make(),
        ),
      ),
    ));
  }
}
