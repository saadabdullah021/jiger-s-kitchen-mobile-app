import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:jigers_kitchen/utils/app_colors.dart';
import 'package:jigers_kitchen/utils/widget/appwidgets.dart';

import '../app_dimens.dart';
import '../app_text_styles.dart';
import 'app_button.dart';
import 'dialog_shell.dart';

/// Success feedback dialog. Signature and auto-dismiss behaviour unchanged.
void showDialogWithAutoDismiss(
    {BuildContext? context,
    String? img,
    String? heading,
    String? text,
    bool? doubleBack,
    bool? autoDismiss,
    bool? showBtn,
    VoidCallback? onBtnTap,
    TextStyle? headingStyle,
    TextStyle? textStyle,
    String? btnText}) {
  // Ensure any active loader is immediately dismissed
  appWidgets.hideDialog();

  void openDialog(BuildContext targetContext) {
    if (!targetContext.mounted) return;
    Timer? dismissTimer;
    showDialog<void>(
      barrierColor: Colors.black.withOpacity(0.45),
      context: targetContext,
      builder: (BuildContext dialogContext) {
      if (autoDismiss == true) {
        dismissTimer ??= Timer(const Duration(seconds: 2), () {
          // The dialog may already be gone if the user navigated away.
          if (!dialogContext.mounted) return;
          if (ModalRoute.of(dialogContext)?.isCurrent != true) return;
          final navigator = Navigator.of(dialogContext);
          navigator.pop();
          if (doubleBack == true) {
            if (navigator.canPop()) navigator.pop();
          }
        });
      }
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
                  child: SvgPicture.asset(img, height: 56),
                )
              else
                Icon(
                  Icons.check_circle_outline_rounded,
                  size: 64,
                  color: AppColors.primaryColor,
                ),
              const SizedBox(height: AppDimens.lg),
              Text(
                heading ?? "",
                textAlign: TextAlign.center,
                style: headingStyle ?? AppTextStyles.pageTitle,
              ),
              if (text != null && text.isNotEmpty) ...[
                const SizedBox(height: AppDimens.sm),
                Text(
                  text,
                  textAlign: TextAlign.center,
                  style: textStyle ?? AppTextStyles.secondary,
                ),
              ],
              if (showBtn == true && onBtnTap != null) ...[
                const SizedBox(height: AppDimens.xl),
                CustomButton(
                  text: btnText ?? "OK",
                  padding: AppDimens.md,
                  onPressed: onBtnTap,
                ),
              ],
            ],
          ),
        ),
      );
    },
  ).whenComplete(() => dismissTimer?.cancel());
  }

  // Schedule presentation on post-frame so the loader pop animation completes
  // cleanly before presenting the success dialog.
  WidgetsBinding.instance.addPostFrameCallback((_) {
    final ctx = (context != null && context.mounted)
        ? context
        : (Get.overlayContext ?? Get.key.currentContext ?? context);
    if (ctx != null) {
      openDialog(ctx);
    }
  });
}
