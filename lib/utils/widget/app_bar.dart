import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../app_colors.dart';
import '../app_dimens.dart';

/// Shared app bar. Signature unchanged; styling standardized.
AppBar appBar({
  Function()? onPressed,
  String? text,
  bool? back,
  bool? showDrawer,
  List<Widget>? actions,
  Color? backgroundColor,
  Color? backColor,
  bool? showback,
}) =>
    AppBar(
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: backgroundColor ?? AppColors.primaryColor,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      backgroundColor: backgroundColor ?? AppColors.primaryColor,
      surfaceTintColor: backgroundColor ?? AppColors.primaryColor,
      elevation: 0,
      titleSpacing: 0,
      iconTheme: IconThemeData(color: AppColors.textWhiteColor),
      leading: showDrawer == true
          ? null
          : (showback != null && showback == false) ||
                  (back != null && back == false)
              ? const SizedBox.shrink()
              : Builder(
                  builder: (context) => IconButton(
                    tooltip: 'Back',
                    icon: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: AppDimens.iconMd,
                      color: backColor ?? AppColors.textWhiteColor,
                    ),
                    onPressed: () {
                      if (onPressed != null) {
                        onPressed();
                      } else if (Navigator.of(context).canPop()) {
                        Navigator.of(context).pop();
                      } else {
                        Get.back();
                      }
                    },
                  ),
                ),
      centerTitle: true,
      title: Text(
        text ?? '',
        textAlign: TextAlign.center,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: 19,
          fontWeight: FontWeight.w600,
          color: AppColors.textWhiteColor,
        ),
      ),
      actions: [
        if (actions != null) ...actions,
        const SizedBox(width: AppDimens.md),
      ],
    );

/// Circular icon action for the app bar, e.g. refresh or cart.
class AppBarAction extends StatelessWidget {
  const AppBarAction({
    super.key,
    required this.icon,
    required this.onTap,
    this.color,
    this.tooltip,
  });

  final IconData icon;
  final VoidCallback onTap;
  final Color? color;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: tooltip,
      onPressed: onTap,
      icon: Container(
        height: 34,
        width: 34,
        decoration: BoxDecoration(
          color: AppColors.textWhiteColor,
          borderRadius: BorderRadius.circular(AppDimens.md),
        ),
        child: Icon(
          icon,
          size: AppDimens.iconMd,
          color: color ?? AppColors.redColor,
        ),
      ),
    );
  }
}
