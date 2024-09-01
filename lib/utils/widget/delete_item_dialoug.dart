import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jigers_kitchen/utils/widget/app_button.dart';

import '../app_colors.dart';

void showDeleteItemDialoug({
  BuildContext? context,
}) {
  showDialog(
    barrierColor: AppColors.primaryColor.withOpacity(0.6),
    context: context!,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        contentPadding: EdgeInsets.zero,
        content: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 20,
              ),
              const SizedBox(height: 16.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "Alert",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                      height: 8.0), // Space between title and subtitle
                  const Text(
                    "Are you sure you want to DELETE the order?",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 13,
                        fontWeight: FontWeight.normal),
                  ),
                  const SizedBox(height: 20.0),
                  CustomButton(
                    padding: 10,
                    bgColor: AppColors.textGreyColor,
                    textColor: AppColors.greyColor,
                    text: "Cacnel",
                    onPressed: () {
                      Get.back();
                    },
                  ),
                  const SizedBox(height: 20.0),
                  CustomButton(
                    text: "Delete",
                    onPressed: () {
                      Get.back();
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}
