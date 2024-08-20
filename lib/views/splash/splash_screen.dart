import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:jigers_kitchen/utils/app_colors.dart';
import 'package:jigers_kitchen/utils/app_images.dart';

import 'splash_controller.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SplashController _controller = Get.put(SplashController());
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(),
          Center(
            child: Image.asset(
              AppImages.appIcon,
              height: 250,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 40),
            child: Text(
              "Delicious Healthy\nIndian Cuisine",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: AppColors.textWhiteColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 27),
            ),
          )
        ],
      )),
    );
  }
}
