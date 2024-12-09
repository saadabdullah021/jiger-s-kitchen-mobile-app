import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jigers_kitchen/utils/widget/app_button.dart';
import 'package:jigers_kitchen/utils/widget/appwidgets.dart';

import '../../../utils/app_colors.dart';
import '../../../utils/app_images.dart';
import '../../../utils/widget/app_bar.dart';
import '../../../utils/widget/custom_textfiled.dart';
import 'forget_password_controller.dart';

class SetNewPassword extends StatefulWidget {
  const SetNewPassword({super.key});

  @override
  State<SetNewPassword> createState() => _LoginPageState();
}

class _LoginPageState extends State<SetNewPassword> {
  final ForgetPasswordController _controller = Get.find();
  final GlobalKey<FormState> _key = GlobalKey();
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.sizeOf(context).height;
    double width = MediaQuery.sizeOf(context).width;
    return Scaffold(
        appBar: appBar(text: "Change Password"),
        body: SingleChildScrollView(
            child: Form(
          key: _key,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 40,
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 8.0, left: 8.0, top: 8),
                  child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Password".tr,
                        style: TextStyle(color: AppColors.greyColor),
                      )),
                ),
                const SizedBox(
                  height: 10,
                ),
                Obx(
                  () => CustomTextField(
                    controller: _controller.passwordController,
                    hintText: "Password",
                    obscureText: _controller.absecureText.value,
                    suffixIcon: _controller.absecureText.isTrue
                        ? Icon(Icons.visibility, color: AppColors.textFiledGrey)
                        : Icon(Icons.visibility_off,
                            color: AppColors.textFiledGrey),
                    onSuffixIconTap: () {
                      _controller.absecureText.value =
                          !_controller.absecureText.value;
                    },
                    prefixIcon: Image.asset(AppImages.lock),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 8.0, left: 8.0, top: 8),
                  child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Confirm Password".tr,
                        style: TextStyle(color: AppColors.greyColor),
                      )),
                ),
                const SizedBox(
                  height: 10,
                ),
                Obx(
                  () => CustomTextField(
                    controller: _controller.confirmPasswordController,
                    hintText: "Confirm Password",
                    obscureText: _controller.absecureText1.value,
                    suffixIcon: _controller.absecureText1.isTrue
                        ? Icon(Icons.visibility, color: AppColors.textFiledGrey)
                        : Icon(Icons.visibility_off,
                            color: AppColors.textFiledGrey),
                    onSuffixIconTap: () {
                      _controller.absecureText1.value =
                          !_controller.absecureText1.value;
                    },
                    prefixIcon: Image.asset(AppImages.lock),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                CustomButton(
                    text: "Change Password",
                    onPressed: () {
                      if (_key.currentState?.validate() ?? false) {
                        _key.currentState!.save();
                        if (_controller.passwordController.text !=
                            _controller.confirmPasswordController.text) {
                          appWidgets()
                              .showToast("Sorry", "Both password must be same");
                        } else {
                          _controller.changePassword();
                        }
                      }
                    }),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        )));
  }
}
