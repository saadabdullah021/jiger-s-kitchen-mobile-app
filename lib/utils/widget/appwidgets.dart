import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../app_colors.dart';
import '../app_dimens.dart';
import '../app_images.dart';

/// Shared loading/toast helpers.
///
/// Class name and method signatures are unchanged (47 call sites depend on
/// them); only the presentation is upgraded.
class appWidgets {
  static bool _isLoading = false;

  /// Returns true if a blocking loading dialog is currently active.
  static bool get isLoading => _isLoading;

  /// Backward-compatible alias for loadingDialog.
  static void loadingDocumentDialog() {
    loadingDialog();
  }

  /// Blocking loader used while a mutating request is in flight.
  static void loadingDialog() {
    if (_isLoading) return;
    _isLoading = true;
    Get.dialog(
      const _BlockingLoader(),
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.35),
    ).then((_) {
      _isLoading = false;
    });
  }

  /// Branded loader used while a customer order is being submitted.
  ///
  /// This keeps the checkout feedback distinct from a generic background
  /// request and reuses the cooking animation already shipped with the app.
  static void orderPlacementLoadingDialog() {
    if (_isLoading) return;
    _isLoading = true;
    Get.dialog(
      const _OrderPlacementLoader(),
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.35),
    ).then((_) {
      _isLoading = false;
    });
  }

  static Widget loadingWidget({double? height, double? width}) {
    return Center(
      child: SizedBox(
        height: height ?? 28,
        width: width ?? 28,
        child: CircularProgressIndicator(
          strokeWidth: 2.4,
          color: AppColors.primaryColor,
        ),
      ),
    );
  }

  static DateTime _lastDialogCloseTime = DateTime.fromMillisecondsSinceEpoch(0);

  /// Dismisses the loading dialog immediately without hanging.
  static void hideDialog() {
    final bool wasLoading = _isLoading;
    _isLoading = false;

    if (wasLoading) {
      _lastDialogCloseTime = DateTime.now();
      // 1. Primary: dismiss the dialog directly via the root navigator
      try {
        final context = Get.overlayContext ?? Get.context;
        if (context != null) {
          final nav = Navigator.of(context, rootNavigator: true);
          if (nav.canPop()) {
            nav.pop();
            return;
          }
        }
      } catch (_) {}

      // 2. Fallback via Get.back()
      try {
        Get.back();
        return;
      } catch (_) {}
    }

    // If GetX reports a dialog is still open, dismiss it
    if (Get.isDialogOpen ?? false) {
      _lastDialogCloseTime = DateTime.now();
      try {
        Get.back();
      } catch (_) {}
    }
  }

  void _presentSnackbar({
    required String title,
    required String message,
    required Color backgroundColor,
    required IconData icon,
  }) {
    if (Get.testMode) return;

    // Delay 400ms so any dialog pop animation fully completes before
    // mounting the toast. Using Future.delayed (not addPostFrameCallback)
    // because the pop takes several frames to finish.
    Future.delayed(const Duration(milliseconds: 400), () {
      try {
        // Get overlay directly from the navigator state — this is always
        // the root app overlay, never a dialog's overlay.
        final navigatorState = Get.key.currentState;
        final overlayState = navigatorState?.overlay;
        if (overlayState != null) {
          _ToastOverlay.show(
            overlayState: overlayState,
            title: title,
            message: message,
            backgroundColor: backgroundColor,
            icon: icon,
          );
          return;
        }
      } catch (_) {}

      // Fallback: try via context
      try {
        final context = Get.overlayContext ?? Get.context;
        if (context != null && context.mounted) {
          final overlayState = Overlay.maybeOf(context, rootOverlay: true);
          if (overlayState != null) {
            _ToastOverlay.show(
              overlayState: overlayState,
              title: title,
              message: message,
              backgroundColor: backgroundColor,
              icon: icon,
            );
          }
        }
      } catch (_) {}
    });
  }

  dynamic showToast(dynamic title, dynamic message) {
    final String cleanTitle = _asText(title, fallback: 'Notice');
    final String cleanMessage =
        _asText(message, fallback: 'Please check your inputs.');
    final bool isError = cleanTitle.toLowerCase().contains('sorry') ||
        cleanTitle.toLowerCase().contains('error') ||
        cleanTitle.toLowerCase().contains('fail');

    _presentSnackbar(
      title: cleanTitle,
      message: cleanMessage,
      backgroundColor: isError ? AppColors.redColor : AppColors.primaryColor,
      icon: isError ? Icons.error_outline_rounded : Icons.info_outline_rounded,
    );
    return null;
  }

  void showErrorToast(dynamic title, dynamic message) {
    _presentSnackbar(
      title: _asText(title, fallback: 'Error'),
      message:
          _asText(message, fallback: 'Something went wrong. Please try again.'),
      backgroundColor: AppColors.redColor,
      icon: Icons.error_outline_rounded,
    );
  }

  /// API messages are dynamic and occasionally null; avoid rendering "null".
  static String _asText(dynamic value, {String fallback = ''}) {
    if (value == null) return fallback;
    final String text = value.toString().trim();
    return text.isEmpty || text == 'null' ? fallback : text;
  }
}

/// Standalone top overlay toast that cannot be popped by Get.back() or Navigator.pop()
class _ToastOverlay {
  static OverlayEntry? _activeEntry;
  static Timer? _activeTimer;

  static void show({
    required OverlayState overlayState,
    required String title,
    required String message,
    required Color backgroundColor,
    required IconData icon,
    Duration duration = const Duration(milliseconds: 3500),
  }) {
    _activeTimer?.cancel();
    _activeTimer = null;
    if (_activeEntry != null) {
      try {
        _activeEntry!.remove();
      } catch (_) {}
      _activeEntry = null;
    }

    late OverlayEntry entry;
    entry = OverlayEntry(
      builder: (BuildContext overlayContext) {
        return _ToastBanner(
          title: title,
          message: message,
          backgroundColor: backgroundColor,
          icon: icon,
          onDismiss: () {
            _activeTimer?.cancel();
            _activeTimer = null;
            if (_activeEntry == entry) {
              try {
                entry.remove();
              } catch (_) {}
              _activeEntry = null;
            }
          },
        );
      },
    );

    _activeEntry = entry;
    overlayState.insert(entry);

    _activeTimer = Timer(duration, () {
      if (_activeEntry == entry) {
        try {
          entry.remove();
        } catch (_) {}
        _activeEntry = null;
      }
    });
  }
}

class _ToastBanner extends StatefulWidget {
  final String title;
  final String message;
  final Color backgroundColor;
  final IconData icon;
  final VoidCallback onDismiss;

  const _ToastBanner({
    required this.title,
    required this.message,
    required this.backgroundColor,
    required this.icon,
    required this.onDismiss,
  });

  @override
  State<_ToastBanner> createState() => _ToastBannerState();
}

class _ToastBannerState extends State<_ToastBanner>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnim;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 260),
    );
    _offsetAnim = Tween<Offset>(
      begin: const Offset(0, -0.6),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
    _fadeAnim = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();
  }

  void _dismiss() async {
    if (!mounted) return;
    await _controller.reverse();
    widget.onDismiss();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimens.md,
            vertical: AppDimens.sm,
          ),
          child: SlideTransition(
            position: _offsetAnim,
            child: FadeTransition(
              opacity: _fadeAnim,
              child: GestureDetector(
                onTap: _dismiss,
                child: Material(
                  elevation: 8,
                  shadowColor: Colors.black26,
                  borderRadius: BorderRadius.circular(AppDimens.radiusInput),
                  color: widget.backgroundColor,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppDimens.lg,
                      vertical: AppDimens.md,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          widget.icon,
                          color: AppColors.textWhiteColor,
                          size: AppDimens.iconLg,
                        ),
                        const SizedBox(width: AppDimens.md),
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.title,
                                style: const TextStyle(
                                  fontSize: 14.5,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                              if (widget.message.isNotEmpty) ...[
                                const SizedBox(height: 3),
                                Text(
                                  widget.message,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                        const SizedBox(width: AppDimens.sm),
                        IconButton(
                          icon: const Icon(Icons.close,
                              color: Colors.white70, size: 18),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          onPressed: _dismiss,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _BlockingLoader extends StatelessWidget {
  const _BlockingLoader();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(AppDimens.xxl),
        decoration: BoxDecoration(
          color: AppColors.textWhiteColor,
          borderRadius: BorderRadius.circular(AppDimens.radiusCard),
        ),
        child: SizedBox(
          height: 34,
          width: 34,
          child: CircularProgressIndicator(
            strokeWidth: 2.6,
            color: AppColors.primaryColor,
          ),
        ),
      ),
    );
  }
}

class _OrderPlacementLoader extends StatelessWidget {
  const _OrderPlacementLoader();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 220,
        padding: const EdgeInsets.fromLTRB(
          AppDimens.xl,
          AppDimens.lg,
          AppDimens.xl,
          AppDimens.xl,
        ),
        decoration: BoxDecoration(
          color: AppColors.textWhiteColor,
          borderRadius: BorderRadius.circular(AppDimens.radiusCard),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 20,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              AppImages.loader,
              height: 126,
              width: 126,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: AppDimens.md),
            Text(
              'Placing your order',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.jetBlackColor,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: AppDimens.xs),
            Text(
              'Please wait a moment…',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.greyColor,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
