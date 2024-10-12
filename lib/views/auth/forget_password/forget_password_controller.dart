import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jigers_kitchen/core/apis/app_interface.dart';
import 'package:jigers_kitchen/utils/widget/appwidgets.dart';
import 'package:jigers_kitchen/views/auth/forget_password/set_new_password.dart';
import 'package:jigers_kitchen/views/auth/login/login_screen.dart';

class ForgetPasswordController extends GetxController {
  String email = "";
  String OTP = "";
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  RxBool absecureText = true.obs;
  RxBool absecureText1 = true.obs;
  verifyOtp() async {
    appWidgets.loadingDialog();
    await AppInterface().verifyOtp(Otp: OTP, email: email).then((value) {
      if (value == 200) {
        appWidgets.hideDialog();
        Get.off(() => const SetNewPassword());
      }
    });
  }

  changePassword() async {
    appWidgets.loadingDialog();
    await AppInterface()
        .setNewPassword(password: passwordController.text, email: email)
        .then((value) {
      if (value == 200) {
        appWidgets.hideDialog();
        Get.offAll(() => const LoginScreen());
      }
    });
  }
}
