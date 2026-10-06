import 'package:flutter/material.dart';
import 'package:jigers_kitchen/utils/app_colors.dart';

import '../app_dimens.dart';
import '../app_text_styles.dart';
import 'animations.dart';

/// Primary app button.
///
/// Existing call sites keep working unchanged; [isLoading] and [enabled] are
/// optional additions. While loading or disabled the tap handler is not wired
/// up at all, which is what prevents duplicate submits.
class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? bgColor;
  final Color? textColor;
  final double? padding;

  /// Shows an inline spinner and blocks taps.
  final bool isLoading;

  /// When false the button is greyed out and inert.
  final bool enabled;

  /// Optional leading icon.
  final IconData? icon;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.padding,
    this.bgColor,
    this.textColor,
    this.isLoading = false,
    this.enabled = true,
    this.icon,
  });

  bool get _interactive => enabled && !isLoading;

  @override
  Widget build(BuildContext context) {
    final Color background = bgColor ?? AppColors.primaryColor;
    final Color foreground = textColor ?? AppColors.textWhiteColor;

    return PressableScale(
      onTap: _interactive ? onPressed : null,
      child: AnimatedOpacity(
        opacity: enabled ? 1 : 0.5,
        duration: AppDurations.fast,
        child: AnimatedContainer(
          duration: AppDurations.fast,
          curve: Curves.easeOut,
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: padding ?? AppDimens.lg),
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.circular(AppDimens.radiusButton),
          ),
          child: Center(
            // Swap label <-> spinner without resizing the button.
            child: AnimatedSwitcher(
              duration: AppDurations.fast,
              child: isLoading
                  ? SizedBox(
                      key: const ValueKey('loading'),
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.2,
                        valueColor: AlwaysStoppedAnimation<Color>(foreground),
                      ),
                    )
                  : Row(
                      key: const ValueKey('label'),
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (icon != null) ...[
                          Icon(icon, size: AppDimens.iconMd, color: foreground),
                          const SizedBox(width: AppDimens.sm),
                        ],
                        Flexible(
                          child: Text(
                            text,
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.button
                                .copyWith(color: foreground),
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Secondary/outlined button for lower-emphasis actions such as "Cancel".
class SecondaryButton extends StatelessWidget {
  const SecondaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.padding,
    this.icon,
    this.enabled = true,
  });

  final String text;
  final VoidCallback onPressed;
  final double? padding;
  final IconData? icon;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return PressableScale(
      onTap: enabled ? onPressed : null,
      child: AnimatedOpacity(
        opacity: enabled ? 1 : 0.5,
        duration: AppDurations.fast,
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: padding ?? AppDimens.lg),
          decoration: BoxDecoration(
            color: AppColors.textWhiteColor,
            borderRadius: BorderRadius.circular(AppDimens.radiusButton),
            border: Border.all(color: AppColors.borderColor),
          ),
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null) ...[
                  Icon(icon,
                      size: AppDimens.iconMd, color: AppColors.greyColor),
                  const SizedBox(width: AppDimens.sm),
                ],
                Flexible(
                  child: Text(
                    text,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.button
                        .copyWith(color: AppColors.greyColor),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
