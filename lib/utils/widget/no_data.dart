import 'package:flutter/material.dart';

import '../app_colors.dart';
import '../app_dimens.dart';
import '../app_images.dart';
import '../app_text_styles.dart';
import 'animations.dart';

/// Empty-state placeholder.
///
/// The `noData(double?)` signature is kept because 12 screens call it; the
/// parameter is still honoured as the illustration size. Prefer
/// [AppEmptyState] for new code, which supports a description and an action.
Widget noData(double? height, {String? title, String? description}) {
  final double size = (height ?? 96).clamp(64.0, 140.0);

  return FadeSlideIn(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          height: size,
          width: size,
          decoration: BoxDecoration(
            color: AppColors.primaryColor.withOpacity(0.12),
            shape: BoxShape.circle,
          ),
          child: Padding(
            padding: EdgeInsets.all(size * 0.18),
            child: Image.asset(
              AppImages.chef,
              fit: BoxFit.contain,
            ),
          ),
        ),
        const SizedBox(height: AppDimens.xl),
        Text(
          title ?? "No data found",
          textAlign: TextAlign.center,
          style: AppTextStyles.sectionHeading,
        ),
        const SizedBox(height: AppDimens.sm),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppDimens.xxl),
          child: Text(
            description ?? "There is nothing to show here yet.",
            textAlign: TextAlign.center,
            style: AppTextStyles.secondary,
          ),
        ),
      ],
    ),
  );
}
