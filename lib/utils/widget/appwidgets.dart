import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../app_colors.dart';

class appWidgets {
  static void loadingDialog() {
    Get.dialog(loadingWidget());
  }

  static Widget loadingWidget({double? height, double? width}) {
    return Center(
        child: CircularProgressIndicator(
      color: AppColors.primaryColor,
    ));
  }

  static void hideDialog() {
    if (Get.isDialogOpen!) {
      Get.back();
    }
  }

  showToast(title, message) {
    return Get.snackbar(title, message,
        snackPosition: SnackPosition.TOP,
        duration: const Duration(milliseconds: 3000),
        colorText: AppColors.textWhiteColor,
        backgroundColor: AppColors.primaryColor,
        margin: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
        borderColor: AppColors.textBlackColor,
        borderRadius: 8,
        borderWidth: 0);
  }
}
