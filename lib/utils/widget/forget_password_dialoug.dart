import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:jigers_kitchen/utils/widget/app_button.dart';

import '../app_colors.dart';
import '../app_images.dart';
import 'custom_textfiled.dart';

void forgetPasswordDialog({
  BuildContext? context,
  String? img,
  String? heading,
  String? text,
  TextEditingController? textController,
  VoidCallback? onBtnTap,
  TextStyle? headingStyle = const TextStyle(
      fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black),
  TextStyle? textStyle = const TextStyle(
      fontSize: 13, fontWeight: FontWeight.normal, color: Colors.black),
  String? btnText,
}) {
  showDialog(
    barrierColor: AppColors.primaryColor.withOpacity(0.6),
    context: context!,
    builder: (BuildContext context) {
      return Dialog(
        insetPadding: const EdgeInsets.symmetric(
            horizontal: 20), // Adjust horizontal padding here
        child: Container(
          width: double.infinity, // Full width of the screen
          decoration: BoxDecoration(
            color: AppColors.dialougBG,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              SvgPicture.asset(
                img!,
                height: 80.0,
              ),
              const SizedBox(height: 5.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    heading!,
                    textAlign: TextAlign.center,
                    style: headingStyle,
                  ),
                  const SizedBox(height: 8.0),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CustomTextField(
                      controller: textController!,
                      fillColor: AppColors.textWhiteColor,
                      hintText: "Registered Email",
                      prefixIcon: Image.asset(AppImages.mailIcon),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5.0),
              InkWell(
                onTap: onBtnTap,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CustomButton(
                    text: "SUBMIT",
                    onPressed: onBtnTap!,
                    padding: 10,
                  ),
                ),
              ),
              const SizedBox(height: 35.0),
            ],
          ),
        ),
      );
    },
  );
}
