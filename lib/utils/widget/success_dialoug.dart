import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:jigers_kitchen/utils/app_colors.dart';

void showDialogWithAutoDismiss(
    {BuildContext? context,
    String? img,
    String? heading,
    String? text,
    bool? doubleBack,
    bool? autoDismiss,
    bool? showBtn,
    VoidCallback? onBtnTap,
    TextStyle? headingStyle = const TextStyle(
        fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black),
    TextStyle? textStyle = const TextStyle(
        fontSize: 13, fontWeight: FontWeight.normal, color: Colors.black),
    String? btnText}) {
  showDialog(
    barrierColor: AppColors.primaryColor.withOpacity(0.6),
    context: context!,
    builder: (BuildContext context) {
      if (autoDismiss == true) {
        Future.delayed(const Duration(seconds: 2), () {
          Navigator.of(context).pop();
          if (doubleBack == true) {
            Navigator.of(context).pop();
          }
        });
      }
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
                const SizedBox(height: 16.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      heading!,
                      style: headingStyle,
                    ),
                    const SizedBox(
                        height: 8.0), // Space between title and subtitle
                    Text(text!, style: textStyle),
                    const SizedBox(
                      height: 35,
                    )
                  ],
                ),
              ],
            ),
          ));
    },
  );
}
