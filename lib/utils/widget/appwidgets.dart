import 'dart:async';
import 'dart:ui' as ui;
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
  /// This mirrors the checkout animation used on the web checkout.
  static void orderPlacementLoadingDialog() {
    if (_isLoading) return;
    _isLoading = true;
    Get.dialog(
      const _OrderPlacementLoader(),
      barrierDismissible: false,
      // The loader owns the exact dimmed/blurred backdrop.
      barrierColor: Colors.transparent,
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

class _OrderPlacementLoader extends StatefulWidget {
  const _OrderPlacementLoader();

  @override
  State<_OrderPlacementLoader> createState() => _OrderPlacementLoaderState();
}

class _OrderPlacementLoaderState extends State<_OrderPlacementLoader>
    with TickerProviderStateMixin {
  late final AnimationController _riderController;
  late final AnimationController _dashController;

  @override
  void initState() {
    super.initState();
    _riderController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1350),
    )..repeat();
    _dashController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    )..repeat();
  }

  @override
  void dispose() {
    _riderController.dispose();
    _dashController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope<void>(
      // The order request owns this route. Back, system back, and Android
      // back gestures must not dismiss it while the request is pending.
      canPop: false,
      child: Material(
        type: MaterialType.transparency,
        child: Stack(
          fit: StackFit.expand,
          children: [
            BackdropFilter(
              filter: ui.ImageFilter.blur(sigmaX: 2, sigmaY: 2),
              child: Container(color: const Color(0x730F172A)),
            ),
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 352),
                child: Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: const Color(0xFFE9ECEF)),
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x2E0F172A),
                        blurRadius: 40,
                        offset: Offset(0, 12),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _MotorcycleTrack(
                        riderAnimation: _riderController,
                        dashAnimation: _dashController,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Placing your order...',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFF2A3042),
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          height: 1.25,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Please wait — do not refresh this page.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFF74788D),
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          height: 1.25,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MotorcycleTrack extends StatelessWidget {
  const _MotorcycleTrack({
    required this.riderAnimation,
    required this.dashAnimation,
  });

  final Animation<double> riderAnimation;
  final Animation<double> dashAnimation;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 224,
      height: 48,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: DecoratedBox(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFFF8F9FC), Color(0xFFEEF1F5)],
            ),
          ),
          child: AnimatedBuilder(
            animation: Listenable.merge([riderAnimation, dashAnimation]),
            builder: (context, child) => Stack(
              clipBehavior: Clip.hardEdge,
              children: [
                _RoadDash(left: 27, progress: dashAnimation.value, delay: 0),
                _RoadDash(
                  left: 94,
                  progress: dashAnimation.value,
                  delay: 0.35,
                ),
                _RoadDash(
                  left: 161,
                  progress: dashAnimation.value,
                  delay: 0.7,
                ),
                Positioned(
                  left: 0,
                  top: 24,
                  child: Transform.translate(
                    offset: _riderOffset(riderAnimation.value),
                    child: const SizedBox(
                      width: 56,
                      height: 35,
                      child: CustomPaint(painter: _MotorcyclePainter()),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Offset _riderOffset(double progress) {
    final double horizontalFactor = progress < 0.5
        ? _lerp(-0.30, 0.58, progress * 2)
        : _lerp(0.58, 1.18, (progress - 0.5) * 2);
    final double verticalFactor = _lerp(-0.55, -0.58, progress);
    return Offset(horizontalFactor * 56, verticalFactor * 35);
  }

  double _lerp(double begin, double end, double amount) =>
      begin + (end - begin) * amount;
}

class _RoadDash extends StatelessWidget {
  const _RoadDash({
    required this.left,
    required this.progress,
    required this.delay,
  });

  final double left;
  final double progress;
  final double delay;

  @override
  Widget build(BuildContext context) {
    final double localProgress = (progress - delay) % 1;
    final double opacity = localProgress < 0.5
        ? _lerp(0.35, 0.9, localProgress * 2)
        : _lerp(0.9, 0.2, (localProgress - 0.5) * 2);
    return Positioned(
      left: left,
      bottom: 10,
      child: Opacity(
        opacity: opacity,
        child: Transform.translate(
          offset: Offset(-28 * localProgress, 0),
          child: Container(
            width: 20,
            height: 2,
            decoration: BoxDecoration(
              color: const Color(0xFFC5CAD3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
      ),
    );
  }

  double _lerp(double begin, double end, double amount) =>
      begin + (end - begin) * amount;
}

class _MotorcyclePainter extends CustomPainter {
  const _MotorcyclePainter();

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.scale(size.width / 64, size.height / 40);
    final stroke = Paint()
      ..color = const Color(0xFF556EE6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    canvas.drawCircle(const Offset(14, 30), 7, stroke);
    canvas.drawCircle(const Offset(50, 30), 7, stroke);
    canvas.drawPath(
      Path()
        ..moveTo(21, 29)
        ..lineTo(33, 29)
        ..lineTo(39, 19)
        ..lineTo(47, 19),
      stroke,
    );
    canvas.drawPath(
      Path()
        ..moveTo(33, 19)
        ..lineTo(27, 29),
      stroke,
    );
    canvas.drawPath(
      Path()
        ..moveTo(39, 19)
        ..lineTo(46, 19)
        ..lineTo(50, 25),
      stroke,
    );
    final rider = Paint()
      ..color = const Color(0xFF556EE6)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(const Offset(42, 12), 3.5, rider);
    canvas.drawPath(
      Path()
        ..moveTo(42, 15)
        ..lineTo(42, 19),
      stroke,
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _LegacyOrderPlacementLoader extends StatelessWidget {
  const _LegacyOrderPlacementLoader();

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
