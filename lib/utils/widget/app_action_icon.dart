import 'package:flutter/material.dart';

import '../app_colors.dart';

/// Shared visual treatment for compact edit and delete actions.
///
/// Keeping these actions in one widget prevents grey/default icons from
/// appearing in one list while the rest of the app uses branded colors.
class AppActionIcon extends StatelessWidget {
  final IconData icon;
  final Color color;

  AppActionIcon.edit({super.key})
      : icon = Icons.edit_rounded,
        color = AppColors.primaryColor;

  AppActionIcon.delete({super.key})
      : icon = Icons.delete_outline_rounded,
        color = AppColors.redColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 34,
      height: 34,
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Icon(icon, size: 19, color: color),
    );
  }
}
