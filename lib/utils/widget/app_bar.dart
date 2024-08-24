import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../app_colors.dart';

AppBar appBar({
  Function()? onPressed,
  String? text,
  bool? back,
  List<Widget>? actions, // Changed from Widget? to List<Widget>?
  Color? backgroundColor,
  Color? backColor,
  bool? showback,
}) =>
    AppBar(
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: AppColors.primaryColor,
      ),
      backgroundColor: backgroundColor ?? AppColors.primaryColor,
      surfaceTintColor: backgroundColor ?? AppColors.primaryColor,
      elevation: 0,
      leading: Row(
        children: [
          showback != null && showback == false
              ? const SizedBox()
              : IconButton(
                  constraints: const BoxConstraints(),
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: AppColors.textWhiteColor,
                  ),
                  onPressed: () {
                    Get.back();
                  },
                ),
        ],
      ),
      centerTitle: true,
      title: Text(
        text!,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: AppColors.textWhiteColor,
        ),
      ),
      actions: [
        if (actions != null)
          ...actions, // Spread operator to include multiple actions
        const SizedBox(
          width: 15,
        ),
      ],
    );
