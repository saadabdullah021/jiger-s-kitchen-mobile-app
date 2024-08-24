import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jigers_kitchen/utils/app_colors.dart';
import 'package:jigers_kitchen/utils/app_images.dart';

import '../../utils/widget/app_button.dart';

class NoDataScreen extends StatelessWidget {
  const NoDataScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double height = Get.height;
    double width = Get.width;
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: height * 0.15,
          ),
          Center(
            child: CircleAvatar(
              backgroundColor: AppColors.textWhiteColor,
              radius: 150,
              child: Center(
                child: Image.asset(
                  AppImages.chef,
                  height: 250,
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
                color: AppColors.yellowColor),
          ),
          const SizedBox(
            height: 15,
          ),
          Text(
            "No Data Found",
            style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.w500,
                color: AppColors.textWhiteColor),
          ),
          const SizedBox(
            height: 15,
          ),
          Text(
            "We encountered an error\nwhile trying to connect our server",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w300,
                color: AppColors.textWhiteColor),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: CustomButton(
              text: "Return To Home",
              bgColor: AppColors.textWhiteColor,
              textColor: AppColors.textBlackColor,
              onPressed: () {
                Get.back();
              },
            ),
          ),
          const SizedBox(
            height: 25,
          ),
        ],
      ),
    );
  }
}
