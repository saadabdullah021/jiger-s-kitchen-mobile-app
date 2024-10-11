import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jigers_kitchen/core/apis/app_interface.dart';
import 'package:jigers_kitchen/model/login_model.dart';
import 'package:jigers_kitchen/utils/widget/appwidgets.dart';
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
          appWidgets.loadingDialog();
          await AppInterface().logout().then((value) {
            if (value == 200) {
              Get.back();
              SharedPref.getInstance().clearSF();
              SharedPref.getInstance().addBoolToSF(AppKeys.isFirstTime, false);
              Get.offAll(const LoginScreen());
            }
          });
        });
  }
}

class PhoneNumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // If the text is being cleared or modified
    if (newValue.text.length < 3 || newValue.text.startsWith('+1')) {
      // Prevent removal of '+1 ' prefix
      return oldValue;
    }

    String formatted = '+1 ';
    String digits = newValue.text
        .replaceAll(RegExp(r'\D'), ''); // Remove non-digit characters

    if (digits.isNotEmpty) {
      formatted +=
          '(${digits.substring(0, digits.length < 3 ? digits.length : 3)})';
    }
    if (digits.length > 3) {
      formatted +=
          ' ${digits.substring(3, digits.length < 6 ? digits.length : 6)}';
    }
    if (digits.length > 6) {
      formatted += '-${digits.substring(6, digits.length)}';
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
