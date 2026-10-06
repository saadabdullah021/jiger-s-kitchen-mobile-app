import 'package:flutter/cupertino.dart' show CupertinoPageTransitionsBuilder;
import 'package:flutter/material.dart';
import 'package:jigers_kitchen/utils/app_colors.dart';

import 'app_dimens.dart';
import 'app_text_styles.dart';

class AppTheme {
  /// Shared input border builder so every field in the app matches.
  static OutlineInputBorder _inputBorder(Color color, {double width = 1}) =>
      OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppDimens.radiusInput),
        borderSide: BorderSide(color: color, width: width),
      );

  static final light = ThemeData.light().copyWith(
    splashColor: Colors.transparent,
    highlightColor: Colors.transparent,
    colorScheme: ColorScheme.light(
      primary: AppColors.appColor,
      error: AppColors.redColor,
    ),
    buttonTheme: const ButtonThemeData(textTheme: ButtonTextTheme.primary),
    hoverColor: Colors.transparent,
    textTheme: ThemeData.light().textTheme.apply(
          fontFamily: 'Poppins',
        ),
    primaryTextTheme: ThemeData.light().textTheme.apply(
          fontFamily: 'Poppins',
        ),
    scaffoldBackgroundColor: AppColors.textWhiteColor,
    dividerTheme: DividerThemeData(
      color: AppColors.dividerGreyColor,
      thickness: 1,
      space: AppDimens.lg,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.textWhiteColor,
      elevation: 0,
      iconTheme: const IconThemeData(
        color: Colors.white,
      ),
      titleTextStyle: const TextStyle(
          color: Colors.black,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w600,
          fontSize: 18),
    ),
    // One consistent, fast page transition across the app.
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.android: FadeForwardsPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      },
    ),
    cardTheme: CardThemeData(
      color: AppColors.textWhiteColor,
      elevation: 0,
      margin: const EdgeInsets.only(bottom: AppDimens.md),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimens.radiusCard),
        side: BorderSide(color: AppColors.borderColor),
      ),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: AppColors.textWhiteColor,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimens.radiusSheet),
      ),
      titleTextStyle: AppTextStyles.sectionHeading,
      contentTextStyle: AppTextStyles.body,
    ),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: AppColors.textWhiteColor,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppDimens.radiusSheet),
        ),
      ),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: AppColors.secondaryColor,
      contentTextStyle: AppTextStyles.body.copyWith(
        color: AppColors.textWhiteColor,
      ),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimens.radiusInput),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.lightGreyColor,
      hintStyle: AppTextStyles.body.copyWith(color: AppColors.greyColor),
      errorStyle: AppTextStyles.error,
      // Keeps fields compact rather than unnecessarily tall.
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppDimens.lg,
        vertical: AppDimens.md + 2,
      ),
      border: _inputBorder(Colors.transparent),
      enabledBorder: _inputBorder(Colors.transparent),
      focusedBorder: _inputBorder(AppColors.primaryColor, width: 1.4),
      errorBorder: _inputBorder(AppColors.redColor),
      focusedErrorBorder: _inputBorder(AppColors.redColor, width: 1.4),
      disabledBorder: _inputBorder(Colors.transparent),
      prefixIconColor: AppColors.greyColor,
      suffixIconColor: AppColors.greyColor,
    ),
    checkboxTheme: CheckboxThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimens.xs),
      ),
      side: BorderSide(color: AppColors.borderColor, width: 1.5),
    ),
    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: AppColors.primaryColor,
    ),
  );

  static final dark = ThemeData.dark().copyWith(
    textTheme: ThemeData.dark().textTheme.apply(
          fontFamily: 'Poppins',
        ),
    primaryTextTheme: ThemeData.dark().textTheme.apply(
          fontFamily: 'Poppins',
        ),
    scaffoldBackgroundColor: Colors.black,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.black,
      elevation: 0,
      iconTheme: IconThemeData(
        color: Colors.white,
      ),
      titleTextStyle: TextStyle(color: Colors.white),
    ),
  );
}
