import 'package:flutter/material.dart';

import '../app_colors.dart';
import '../app_images.dart';

Widget noData() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Center(
        child: CircleAvatar(
          backgroundColor: AppColors.primaryColor,
          radius: 100,
          child: Center(
            child: Image.asset(
              AppImages.chef,
              height: 150,
            ),
          ),
        ),
      ),
      const SizedBox(
        height: 15,
      ),
      Text(
        "Oops!",
        style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w600,
            color: AppColors.primaryColor),
      ),
      const SizedBox(
        height: 15,
      ),
      Text(
        "No Data Found",
        style: TextStyle(
            fontSize: 21,
            fontWeight: FontWeight.w500,
            color: AppColors.textBlackColor),
      ),
      const SizedBox(
        height: 15,
      ),
    ],
  );
}
