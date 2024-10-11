import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jigers_kitchen/core/apis/app_interface.dart';

import '../../../common/common.dart';
import '../../../utils/widget/appwidgets.dart';
import '../../Dashboard_screen/dashboard_screen.dart';
import '../../jigar_home_screen/jiagar_home.dart';
import '../../jigar_home_screen/jigar_home_controller.dart';

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
            remeber: checkedValue.value)
        .then((value) {
      if (value == 200) {
        appWidgets.hideDialog();
        if (Common.currentRole == "chef" ||
            Common.currentRole == "delivery_user") {
          Get.put(HomeController());
          Get.off(const DashboardScreen());
        } else {
          Get.delete<HomeController>();
          Get.off(const JigarHome());
        }
      }
    });
  }
}
