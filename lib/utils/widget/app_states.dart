import 'package:flutter/material.dart';

import '../app_colors.dart';
import '../app_dimens.dart';
import '../app_text_styles.dart';
import 'animations.dart';
import 'app_button.dart';

/// Shared layout for empty/error placeholders so both read consistently.
class _StatePlaceholder extends StatelessWidget {
  const _StatePlaceholder({
    required this.icon,
    required this.iconColor,
    required this.iconBackground,
    required this.title,
    this.description,
    this.actionText,
    this.actionIcon,
    this.onAction,
  });

  final IconData icon;
  final Color iconColor;
  final Color iconBackground;
  final String title;
  final String? description;
  final String? actionText;
  final IconData? actionIcon;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return FadeSlideIn(
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppDimens.xxl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 88,
                width: 88,
                decoration: BoxDecoration(
                  color: iconBackground,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 40, color: iconColor),
              ),
              const SizedBox(height: AppDimens.xl),
              Text(
                title,
                textAlign: TextAlign.center,
                style: AppTextStyles.sectionHeading,
              ),
              if (description != null) ...[
                const SizedBox(height: AppDimens.sm),
                Text(
                  description!,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.secondary,
                ),
              ],
              if (actionText != null && onAction != null) ...[
                const SizedBox(height: AppDimens.xl),
                SizedBox(
                  width: 220,
                  child: CustomButton(
                    text: actionText!,
                    onPressed: onAction!,
                    padding: AppDimens.md,
                    icon: actionIcon ?? Icons.add_rounded,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Shown when a request succeeded but returned nothing.
class AppEmptyState extends StatelessWidget {
  const AppEmptyState({
    super.key,
    this.title = "Nothing here yet",
    this.description,
    this.icon = Icons.inbox_outlined,
    this.actionText,
    this.actionIcon,
    this.onAction,
  });

  final String title;
  final String? description;
  final IconData icon;
  final String? actionText;
  final IconData? actionIcon;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return _StatePlaceholder(
      icon: icon,
      iconColor: AppColors.primaryColor,
      iconBackground: AppColors.primaryColor.withOpacity(0.12),
      title: title,
      description: description,
      actionText: actionText,
      actionIcon: actionIcon,
      onAction: onAction,
    );
  }
}

/// Shown when a request failed. Offers a retry when one is available.
class AppErrorState extends StatelessWidget {
  const AppErrorState({
    super.key,
    this.title = "Something went wrong",
    this.description = "Please check your connection and try again.",
    this.icon = Icons.error_outline_rounded,
    this.onRetry,
    this.retryText = "Retry",
  });

  final String title;
  final String? description;
  final IconData icon;
  final VoidCallback? onRetry;
  final String retryText;

  @override
  Widget build(BuildContext context) {
    return _StatePlaceholder(
      icon: icon,
      iconColor: AppColors.redColor,
      iconBackground: AppColors.redColor.withOpacity(0.12),
      title: title,
      description: description,
      actionText: onRetry == null ? null : retryText,
      onAction: onRetry,
    );
  }
}
