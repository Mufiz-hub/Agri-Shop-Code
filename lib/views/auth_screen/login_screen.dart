import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:project_final_year/common_widget/applogo_common.dart';
import 'package:project_final_year/common_widget/bg_widget.dart';
import 'package:project_final_year/common_widget/custom_textfield.dart';
import 'package:project_final_year/common_widget/loding_indicator.dart';
import 'package:project_final_year/common_widget/our_button.dart';
import 'package:project_final_year/consts/consts.dart';
import 'package:project_final_year/consts/lists.dart';
import 'package:project_final_year/controoller/auth_controller.dart';
import 'package:project_final_year/views/auth_screen/signup_screen.dart';
import 'package:project_final_year/views/forget_password/forget_password.dart';
import 'package:project_final_year/views/home_screen/home.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(AuthController());

    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    return bgWidget(
        child: Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Column(
          children: [
            (context.screenHeight * 0.1).heightBox,
            applogoWidget(),
            10.heightBox,
            "Log In to $appname".text.fontFamily(bold).white.size(18).make(),
            15.heightBox,
            Obx(
              () => Column(
                children: [
                  customTextField(
                      hint: emailHint,
                      title: email,
                      isPass: false,
                      conroller: emailController),
                  customTextField(
                      hint: passwordHint,
                      title: password,
                      isPass: true,
                      conroller: passwordController),
                  Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                          onPressed: () {
                            Get.to(() => ForgotPasswordScreen());
                          },
                          child: forgetPass.text.make())),
                  5.heightBox,
                  // ourButton().box.width(context.screenWidth - 50).make(),
                  controller.isLoading.value
                      ? loadingIndicator()
                      : ourButton(
                          color: redColor,
                          title: login,
                          textColor: whiteColor,
                          onpress: () async {
                            try {
                              controller.isLoading(true);

                              await FirebaseAuth.instance
                                  .signInWithEmailAndPassword(
                                      email: emailController.text,
                                      password: passwordController.text)
                                  .then((value) {
                                if (value != null) {
                                  Get.offAll(() => const Home());
                                  VxToast.show(context, msg: loogedin);
                                }
                              });
                            } on FirebaseAuthException catch (e) {
                              VxToast.show(context, msg: e.message.toString());
                              controller.isLoading(false);
                            }
                          }).box.width(context.screenWidth - 50).make(),

                  5.heightBox,
                  createNewAccount.text.color(fontGrey).make(),
                  5.heightBox,
                  ourButton(
                      color: lightGolden,
                      title: signup,
                      textColor: redColor,
                      onpress: () {
                        Get.to(() => const SignUpScreen());
                      }).box.width(context.screenWidth - 50).make(),

                  10.heightBox,
                  liginWith.text.color(fontGrey).make(),
                  5.heightBox,

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                        2,
                        (index) => Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CircleAvatar(
                                backgroundColor: lightGrey,
                                radius: 25,
                                child: Image.asset(
                                  socialIconList[index],
                                  width: 35,
                                ),
                              ),
                            )),
                  ),
                ],
              )
                  .box
                  .white
                  .rounded
                  .padding(const EdgeInsets.all(16))
                  .width(context.screenWidth - 70)
                  .shadowSm
                  .make(),
            )
          ],
        ),
      ),
    ));
  }
}
