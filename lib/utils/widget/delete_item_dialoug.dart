import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jigers_kitchen/core/contstants.dart';
import 'package:jigers_kitchen/utils/widget/app_button.dart';

import '../app_colors.dart';

void showDeleteItemDialoug({
  BuildContext? context,
  String? description,
  VoidCallback? onYes,
  VoidCallback? onCancel,
  String? url,
}) {
  showDialog(
    barrierColor: AppColors.primaryColor.withOpacity(0.6),
    context: context!,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        insetPadding: const EdgeInsets.symmetric(horizontal: 20),
        child: Padding(
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
                  CircleAvatar(
                    backgroundColor: AppColors.textGreyColor,
                    backgroundImage: NetworkImage(Constants.webUrl + url!),
                    radius: 40,
                  ),
                  const SizedBox(height: 14.0),
                  const Text(
                    "Alert",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                      height: 8.0), // Space between title and subtitle
                  Text(
                    description ?? "",
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 13,
                        fontWeight: FontWeight.normal),
                  ),
                  const SizedBox(height: 20.0),
                  CustomButton(
                    bgColor: AppColors.textGreyColor,
                    textColor: AppColors.greyColor,
                    text: "Cancel",
                    onPressed: () {
                      Get.back();
                    },
                  ),
                  const SizedBox(height: 20.0),
                  CustomButton(
                    text: "Delete",
                    onPressed: onYes!,
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
