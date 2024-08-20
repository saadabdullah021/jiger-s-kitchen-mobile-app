import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jigers_kitchen/utils/app_colors.dart';
import 'package:jigers_kitchen/utils/app_images.dart';
import 'package:jigers_kitchen/views/auth/login/login_controller.dart';
import 'package:jigers_kitchen/views/auth/signup/signup_screen.dart';

import '../../../utils/widget/app_button.dart';
import '../../../utils/widget/custom_textfiled.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    LoginController controller = Get.put(LoginController());
    return Scaffold(
        body: Stack(
      children: [
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Image.asset(
            AppImages.loginImg,
            height: Get.height * 0.4,
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          top: Get.height * 0.35,
          child: Container(
            height: Get.height * 0.6,
            decoration: BoxDecoration(
              color: AppColors.textWhiteColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 30,
                  ),
                  Center(
                    child: Image.asset(
                      AppImages.loginIcon,
                      height: 80,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    "Sign In",
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 21),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    "Hello there, sign in to continue",
                    style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 12,
                        color: AppColors.textFiledGrey),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CustomTextField(
                    controller: controller.nameController,
                    hintText: "Username/Business Name",
                    prefixIcon: Image.asset(
                      AppImages.user,
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Obx(
                    () => CustomTextField(
                        controller: controller.passwordController,
                        hintText: "Password",
                        obscureText: controller.showPassword.value,
                        suffixIcon: Icon(Icons.visibility_off,
                            color: AppColors.textFiledGrey),
                        onSuffixIconTap: () {
                          controller.showPassword.value =
                              !controller.showPassword.value;
                        },
                        prefixIcon: Image.asset(
                          AppImages.lock,
                        )),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Obx(
                    () => Row(
                      children: <Widget>[
                        Checkbox(
                          checkColor: AppColors.textWhiteColor,
                          activeColor: AppColors.primaryColor,
                          value: controller.checkedValue.value,
                          onChanged: (bool? value) {
                            controller.checkedValue.value = value!;
                          },
                        ),
                        Text(
                          'Remember me',
                          style: TextStyle(
                              fontSize: 14, color: AppColors.textFiledGrey),
                        ),
                        const Spacer(),
                        Text(
                          'Forgot Password?',
                          style: TextStyle(
                              fontSize: 14, color: AppColors.primaryColor),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CustomButton(
                    text: "LOGIN",
                    onPressed: () {},
                  ),
                  const Spacer(),
                  Center(
                    child: Text(
                      'Don’t have an account?',
                      style: TextStyle(
                          fontSize: 14, color: AppColors.textFiledGrey),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Center(
                    child: InkWell(
                      onTap: () {
                        Get.to(() => const SignUpScreen());
                      },
                      child: Text(
                        'Create Account',
                        style: TextStyle(
                            fontSize: 14, color: AppColors.primaryColor),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    ));
  }
}
