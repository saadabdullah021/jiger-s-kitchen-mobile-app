import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jigers_kitchen/utils/app_colors.dart';
import 'package:jigers_kitchen/utils/app_dimens.dart';
import 'package:jigers_kitchen/utils/app_images.dart';
import 'package:jigers_kitchen/utils/app_text_styles.dart';
import 'package:jigers_kitchen/utils/widget/appwidgets.dart';
import 'package:jigers_kitchen/views/auth/login/login_controller.dart';
import 'package:jigers_kitchen/views/auth/signup/signup_screen.dart';

import '../../../utils/widget/app_button.dart';
import '../../../utils/widget/animations.dart';
import '../../../utils/widget/custom_textfiled.dart';
import '../../../utils/widget/forget_password_dialoug.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final LoginController controller = Get.put(LoginController());
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGreyColor,
      body: SafeArea(
          child: Stack(
        children: [
          // Background image
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Image.asset(
              AppImages.loginImg,
              height: MediaQuery.sizeOf(context).height * 0.4,
              fit: BoxFit.cover,
            ),
          ),
          // Scrollable content
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.textWhiteColor,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(AppDimens.radiusSheet),
                ),
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(
                  AppDimens.xl,
                  AppDimens.xxl,
                  AppDimens.xl,
                  AppDimens.xxl,
                ),
                child: Form(
                  key: _formKey,
                  child: FadeSlideIn(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Image.asset(
                            AppImages.loginIcon,
                            height: 80,
                          ),
                        ),
                        const SizedBox(height: AppDimens.xl),
                        Text(
                          "Sign In",
                          style: AppTextStyles.pageTitle,
                        ),
                        const SizedBox(height: AppDimens.xs),
                        Text(
                          "Hello there, sign in to continue",
                          style: AppTextStyles.secondary,
                        ),
                        const SizedBox(height: AppDimens.xl),
                        CustomTextField(
                          controller: controller.nameController,
                          hintText: "Username/Business Name",
                          prefixIcon: const Icon(Icons.person_outline_rounded),
                          textInputAction: TextInputAction.next,
                        ),
                        const SizedBox(height: AppDimens.md),
                        Obx(
                          () => CustomTextField(
                            controller: controller.passwordController,
                            hintText: "Password",
                            obscureText: controller.showPassword.value,
                            suffixIcon: controller.showPassword.isTrue
                                ? const Icon(Icons.visibility_rounded)
                                : const Icon(Icons.visibility_off_rounded),
                            onSuffixIconTap: () {
                              controller.showPassword.value =
                                  !controller.showPassword.value;
                            },
                            prefixIcon: const Icon(Icons.lock_outline_rounded),
                            textInputAction: TextInputAction.done,
                          ),
                        ),
                        const SizedBox(height: AppDimens.sm),
                        Obx(
                          () => Wrap(
                            alignment: WrapAlignment.spaceBetween,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            spacing: 12,
                            children: <Widget>[
                              Row(mainAxisSize: MainAxisSize.min, children: [
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
                                  style: AppTextStyles.secondary,
                                ),
                              ]),
                              InkWell(
                                onTap: () {
                                  forgetPasswordDialog(
                                    context: context,
                                    textController: controller.nameController,
                                    img: AppImages.forgetPassword,
                                    onBtnTap: () {
                                      if (controller.nameController.text ==
                                          "") {
                                        appWidgets().showToast(
                                            "Sorry", "Please add email");
                                      } else {
                                        controller.forgetPassword();
                                      }
                                    },
                                    headingStyle: TextStyle(
                                      color: AppColors.jetBlackColor,
                                      fontSize: 21,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    heading: "It’s okay!\nReset your password.",
                                  );
                                },
                                child: Text(
                                  'Forgot Password?',
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    color: AppColors.primaryColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: AppDimens.lg),
                        Obx(() => CustomButton(
                            isLoading: controller.isSubmitting.value,
                            text: "LOGIN",
                            onPressed: () {
                              if (_formKey.currentState?.validate() ?? false) {
                                controller.login();
                              }
                            })),
                        const SizedBox(height: AppDimens.xl),
                        Center(
                          child: Text(
                            'Don’t have an account?',
                            style: AppTextStyles.secondary,
                          ),
                        ),
                        const SizedBox(height: AppDimens.xs),
                        Center(
                          child: InkWell(
                            onTap: () {
                              Get.to(() => SignUpScreen());
                            },
                            child: Text(
                              'Create Account',
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.primaryColor,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      )),
    );
  }
}
