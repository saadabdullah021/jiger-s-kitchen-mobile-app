import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Typography hierarchy for the app.
///
/// Poppins is the app font (declared in pubspec and applied via [AppTheme]),
/// so these styles intentionally omit `fontFamily` and inherit it.
class AppTextStyles {
  AppTextStyles._();

  /// Large screen/heading text, e.g. dialog headings.
  static TextStyle get pageTitle => TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: AppColors.textBlackColor,
        height: 1.25,
      );

  /// Section heading inside a screen.
  static TextStyle get sectionHeading => TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: AppColors.textBlackColor,
        height: 1.3,
      );

  /// Heading inside a card or list row.
  static TextStyle get cardHeading => TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: AppColors.textBlackColor,
        height: 1.3,
      );

  /// Default body copy.
  static TextStyle get body => TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: AppColors.textBlackColor,
        height: 1.4,
      );

  /// Emphasised body copy, used for values next to a label.
  static TextStyle get bodyMedium => TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: AppColors.textBlackColor,
        height: 1.4,
      );

  /// De-emphasised supporting text.
  static TextStyle get secondary => TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w400,
        color: AppColors.newOrderGrey,
        height: 1.4,
      );

  /// Smallest supporting text: timestamps, hints, metadata.
  static TextStyle get caption => TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: AppColors.newOrderGrey,
        height: 1.35,
      );

  /// Text inside buttons.
  static TextStyle get button => TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: AppColors.textWhiteColor,
        letterSpacing: 0.2,
      );

  /// Validation and helper text.
  static TextStyle get error => TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: AppColors.redColor,
        height: 1.3,
      );

  /// Status pills and small uppercase labels.
  static TextStyle get badge => TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w700,
        color: AppColors.textWhiteColor,
        letterSpacing: 0.3,
      );

  /// Large numeric readouts, e.g. dashboard counters.
  static TextStyle statValue(Color color, {double fontSize = 28}) => TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.w600,
        color: color,
        height: 1.1,
      );
}
