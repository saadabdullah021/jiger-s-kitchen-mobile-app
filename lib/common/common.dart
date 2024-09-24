import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jigers_kitchen/model/login_model.dart';
import 'package:jigers_kitchen/views/auth/login/login_screen.dart';

import '../utils/app_keys.dart';
import '../utils/local_db_helper.dart';
import '../utils/widget/delete_item_dialoug.dart';

class Common {
  static Rx<loginModel> loginReponse = loginModel().obs;
  static String fcmToken = "";
  static String currentRole = "admin";
  static logout(BuildContext context) {
    showDeleteItemDialoug(
        description: "Are you sure you want to LOGOUT?",
        yesBtnText: "Logout",
        context: context,
        url: Common.loginReponse.value.data!.profileImage ?? "",
        onYes: () async {
          Get.back();
          SharedPref.getInstance().clearSF();
          SharedPref.getInstance().addBoolToSF(AppKeys.isFirstTime, false);
          Get.offAll(const LoginScreen());
        });
  }
}
