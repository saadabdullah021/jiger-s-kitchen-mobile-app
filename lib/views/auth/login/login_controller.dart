import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jigers_kitchen/core/apis/app_interface.dart';

import '../../../utils/widget/appwidgets.dart';
import '../../jigar_home_screen/jiagar_home.dart';

class LoginController extends GetxController {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  RxBool showPassword = true.obs;
  RxBool checkedValue = false.obs;
  login() async {
    appWidgets.loadingDialog();
    await AppInterface()
        .login(
      userName: nameController.text,
      password: passwordController.text,
    )
        .then((value) {
      if (value == 200) {
        appWidgets.hideDialog();
        Get.off(const JigarHome());
      }
    });
  }
}
