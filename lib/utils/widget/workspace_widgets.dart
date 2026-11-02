import 'package:flutter/material.dart';
import '../app_colors.dart';
import '../app_text_styles.dart';

/// Branded introduction shared by the two workspace entry points.
class WorkspaceHeader extends StatelessWidget {
  const WorkspaceHeader(
      {super.key,
      required this.eyebrow,
      required this.title,
      required this.subtitle,
      this.icon = Icons.restaurant_rounded});
  final String eyebrow, title, subtitle;
  final IconData icon;

  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.primaryColor,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: .12),
                  borderRadius: BorderRadius.circular(14)),
              child: Icon(icon, color: AppColors.textWhiteColor, size: 24),
            ),
            const SizedBox(width: 12),
            Expanded(
                child: Text(eyebrow.toUpperCase(),
                    style: TextStyle(
                        color: AppColors.textWhiteColor,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.6))),
          ]),
          const SizedBox(height: 22),
          Text(title,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 27,
                  fontWeight: FontWeight.w600,
                  height: 1.2,
                  letterSpacing: -.6)),
          const SizedBox(height: 10),
          Text(subtitle,
              style: TextStyle(
                  color: AppColors.textWhiteColor, fontSize: 13, height: 1.5)),
        ]),
      );
}

class WorkspaceSection extends StatelessWidget {
  const WorkspaceSection(
      {super.key, required this.title, required this.subtitle});
  final String title, subtitle;
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: 28, bottom: 16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title,
              style: AppTextStyles.sectionHeading
                  .copyWith(color: AppColors.homeblack, fontSize: 19)),
          const SizedBox(height: 4),
          Text(subtitle, style: AppTextStyles.secondary),
        ]),
      );
}

class WorkspaceIcon extends StatelessWidget {
  const WorkspaceIcon(
      {super.key, required this.icon, this.color, this.backgroundColor});
  final IconData icon;
  final Color? color, backgroundColor;
  @override
  Widget build(BuildContext context) => Container(
        height: 46,
        width: 46,
        decoration: BoxDecoration(
            color: backgroundColor ??
                (color ?? AppColors.primaryColor).withValues(alpha: .09),
            borderRadius: BorderRadius.circular(14)),
        child: Icon(icon, color: color ?? AppColors.primaryColor, size: 24),
      );
}
