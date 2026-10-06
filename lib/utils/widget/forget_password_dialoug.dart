import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:jigers_kitchen/utils/widget/app_button.dart';

import '../app_colors.dart';
import '../app_dimens.dart';
import '../app_text_styles.dart';
import 'custom_textfiled.dart';
import 'dialog_shell.dart';

/// Password-reset dialog. Signature unchanged.
void forgetPasswordDialog({
  BuildContext? context,
  String? img,
  String? heading,
  String? text,
  TextEditingController? textController,
  VoidCallback? onBtnTap,
  TextStyle? headingStyle,
  TextStyle? textStyle,
  String? btnText,
}) {
  showDialog(
    barrierColor: Colors.black.withOpacity(0.45),
    context: context!,
    builder: (BuildContext context) {
      return DialogShell(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimens.xl,
            vertical: AppDimens.xxl,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (img != null)
                Container(
                  padding: const EdgeInsets.all(AppDimens.lg),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor.withOpacity(0.12),
                    shape: BoxShape.circle,
                  ),
                  child: SvgPicture.asset(img, height: 52),
                ),
              const SizedBox(height: AppDimens.lg),
              Text(
                heading ?? "",
                textAlign: TextAlign.center,
                style: headingStyle ?? AppTextStyles.sectionHeading,
              ),
              const SizedBox(height: AppDimens.lg),
              CustomTextField(
                controller: textController!,
                fillColor: AppColors.lightGreyColor,
                hintText: "Registered Email",
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.done,
                prefixIcon: Icon(
                  Icons.mail_outline_rounded,
                  size: AppDimens.iconMd,
                  color: AppColors.greyColor,
                ),
              ),
              const SizedBox(height: AppDimens.xl),
              CustomButton(
                text: btnText ?? "SUBMIT",
                padding: AppDimens.md,
                onPressed: onBtnTap!,
              ),
            ],
          ),
        ),
      );
    },
  );
}
