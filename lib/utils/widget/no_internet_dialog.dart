import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../app_colors.dart';
import '../app_dimens.dart';
import 'app_button.dart';
import 'dialog_shell.dart';

/// One app-wide, accessible prompt for failed network requests.
class NoInternetDialog extends StatelessWidget {
  const NoInternetDialog({super.key});

  static Future<bool> show() async {
    final active = _active;
    if (active != null) return active.future;

    final result = Completer<bool>();
    _active = result;
    try {
      final answer = await Get.dialog<bool>(
        const NoInternetDialog(),
        barrierDismissible: false,
        barrierColor: const Color(0x990F172A),
      );
      if (!result.isCompleted) result.complete(answer ?? false);
      return answer ?? false;
    } finally {
      if (!result.isCompleted) result.complete(false);
      if (identical(_active, result)) _active = null;
    }
  }

  static Completer<bool>? _active;

  @override
  Widget build(BuildContext context) {
    return DialogShell(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 72,
              width: 72,
              decoration: BoxDecoration(
                color: AppColors.redColor.withValues(alpha: .1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.wifi_off_rounded,
                color: AppColors.redColor,
                size: 34,
              ),
            ),
            const SizedBox(height: AppDimens.xl),
            Text(
              'No internet connection',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.homeblack,
                fontSize: 19,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppDimens.sm),
            Text(
              'Check your Wi-Fi or mobile data, then try again.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.newOrderGrey,
                fontSize: 13,
                height: 1.5,
              ),
            ),
            const SizedBox(height: AppDimens.xxl),
            CustomButton(
              text: 'Try again',
              icon: Icons.refresh_rounded,
              onPressed: () => Get.back<bool>(result: true),
            ),
            const SizedBox(height: AppDimens.sm),
            SecondaryButton(
              text: 'Close',
              onPressed: () => Get.back<bool>(result: false),
              padding: AppDimens.md,
            ),
          ],
        ),
      ),
    );
  }
}
