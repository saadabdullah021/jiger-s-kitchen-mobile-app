import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jigers_kitchen/core/contstants.dart';
import 'package:jigers_kitchen/utils/widget/app_button.dart';

import '../app_colors.dart';
import '../app_dimens.dart';
import '../app_text_styles.dart';
import 'app_network_image.dart';
import 'dialog_shell.dart';

/// Destructive-action confirmation dialog. Signature unchanged.
void showDeleteItemDialoug({
  BuildContext? context,
  String? description,
  VoidCallback? onYes,
  VoidCallback? onCancel,
  String? yesBtnText,
  String? url,
}) {
  final bool isDestructive = (yesBtnText ?? "Delete").toLowerCase() == "delete";

  showDialog(
    barrierColor: Colors.black.withOpacity(0.45),
    context: context!,
    builder: (BuildContext context) {
      return DialogShell(
        child: Padding(
          padding: const EdgeInsets.all(AppDimens.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (url != null && url.isNotEmpty)
                AppNetworkAvatar(url: Constants.webUrl + url, radius: 36)
              else
                Container(
                  height: 72,
                  width: 72,
                  decoration: BoxDecoration(
                    color: (isDestructive
                            ? AppColors.redColor
                            : AppColors.primaryColor)
                        .withOpacity(0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isDestructive
                        ? Icons.delete_outline_rounded
                        : Icons.help_outline_rounded,
                    size: 32,
                    color: isDestructive
                        ? AppColors.redColor
                        : AppColors.primaryColor,
                  ),
                ),
              const SizedBox(height: AppDimens.lg),
              Text(
                "Alert",
                style: AppTextStyles.sectionHeading,
              ),
              const SizedBox(height: AppDimens.sm),
              Text(
                description ?? "",
                textAlign: TextAlign.center,
                style: AppTextStyles.secondary,
              ),
              const SizedBox(height: AppDimens.xl),
              // Cancel stays first, matching the original dialog order.
              SecondaryButton(
                text: "Cancel",
                padding: AppDimens.md,
                onPressed: onCancel ?? () => Get.back(),
              ),
              const SizedBox(height: AppDimens.md),
              CustomButton(
                text: yesBtnText ?? "Delete",
                bgColor:
                    isDestructive ? AppColors.redColor : AppColors.primaryColor,
                padding: AppDimens.md,
                onPressed: onYes!,
              ),
            ],
          ),
        ),
      );
    },
  );
}
