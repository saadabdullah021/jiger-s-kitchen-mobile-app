import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jigers_kitchen/utils/app_colors.dart';
import 'package:jigers_kitchen/utils/app_images.dart';

import '../../core/apis/base_api.dart';
import 'splash_controller.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    BaseApi Auth = Get.put(BaseApi());
    SplashController controller = Get.put(SplashController());
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(AppImages.splash), fit: BoxFit.cover)),
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(),
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
      ),
    );
  }
}
