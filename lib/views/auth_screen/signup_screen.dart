import 'package:get/get.dart';
import 'package:project_final_year/common_widget/loding_indicator.dart';
import 'package:project_final_year/consts/consts.dart';
import 'package:project_final_year/controoller/auth_controller.dart';
import 'package:project_final_year/views/home_screen/home.dart';
import '../../common_widget/applogo_common.dart';
import '../../common_widget/bg_widget.dart';
import '../../common_widget/custom_textfield.dart';
import '../../common_widget/our_button.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool? isCheck = false;

  var controller = Get.put(AuthController());

  var nameController = TextEditingController();

  var emailController = TextEditingController();

  var passwordController = TextEditingController();

  var passwordRetypeController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return bgWidget(
        child: Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Column(
          children: [
            (context.screenHeight * 0.1).heightBox,
            applogoWidget(),
            10.heightBox,
            "Join The $appname".text.fontFamily(bold).white.size(18).make(),
            15.heightBox,
            Column(
              children: [
                customTextField(
                    hint: nameHint,
                    title: name,
                    conroller: nameController,
                    isPass: false),
                customTextField(
                    hint: emailHint,
                    title: email,
                    conroller: emailController,
                    isPass: false),
                customTextField(
                    hint: passwordHint,
                    title: password,
                    conroller: passwordController,
                    isPass: true),
                customTextField(
                    hint: passwordHint,
                    title: retypePassword,
                    conroller: passwordRetypeController,
                    isPass: true),

                Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                        onPressed: () {}, child: forgetPass.text.make())),
                5.heightBox,
                // ourButton().box.width(context.screenWidth - 50).make(),

                Row(
                  children: [
                    Checkbox(
                      checkColor: redColor,
                      value: isCheck,
                      onChanged: (newValue) {
                        setState(() {
                          isCheck = newValue;
                        });
                      },
                    ),
                    10.widthBox,
                    Expanded(
                      child: RichText(
                        text: const TextSpan(
                          children: [
                            TextSpan(
                                text: "I agree to the ",
                                style: TextStyle(
                                  fontFamily: bold,
                                  color: fontGrey,
                                )),
                            TextSpan(
                                text: termAndCond,
                                style: TextStyle(
                                  fontFamily: bold,
                                  color: redColor,
                                )),
                            TextSpan(
                                text: " & ",
                                style: TextStyle(
                                  fontFamily: bold,
                                  color: fontGrey,
                                )),
                            TextSpan(
                                text: privacyPolicy,
                                style: TextStyle(
                                  fontFamily: bold,
                                  color: redColor,
                                )),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                controller.isLoading.value
                    ? loadingIndicator()
                    : ourButton(
                        color: isCheck == true ? redColor : lightGrey,
                        title: signup,
                        textColor: whiteColor,
                        onpress: () async {
                          if (isCheck != false) {
                            controller.isLoading(true);
                            try {
                              await controller
                                  .signUpMethod(
                                      email: emailController.text,
                                      password: passwordController.text,
                                      context: context)
                                  .then((value) {
                                return controller.storeUserData(
                                    email: emailController.text,
                                    name: nameController.text,
                                    password: passwordController.text);
                              }).then((value) {
                                VxToast.show(context, msg: loogedin);
                                Get.offAll(() => const Home());
                              });
                            } catch (e) {
                              auth.signOut();
                              VxToast.show(context, msg: e.toString());
                              controller.isLoading(false);
                            }
                          }
                        },
                      ).box.width(context.screenWidth - 50).make(),

                10.heightBox,

                RichText(
                  text: const TextSpan(
                    children: [
                      TextSpan(
                        text: alradyHaveAccount,
                        style: TextStyle(
                          fontFamily: bold,
                          color: fontGrey,
                        ),
                      ),
                      TextSpan(
                        text: login,
                        style: TextStyle(
                          fontFamily: bold,
                          color: redColor,
                        ),
                      ),
                    ],
                  ),
                ).onTap(() {
                  Get.back();
                })
              ],
            )
                .box
                .white
                .rounded
                .padding(EdgeInsets.all(16))
                .width(context.screenWidth - 70)
                .shadowSm
                .make()
          ],
        ),
      ),
    ));
  }
}
