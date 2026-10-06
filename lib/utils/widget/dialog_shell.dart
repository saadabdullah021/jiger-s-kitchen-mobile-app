import 'package:flutter/material.dart';

import '../app_colors.dart';
import '../app_dimens.dart';

/// Shared chrome + entrance animation for the app's dialogs.
///
/// Keeps the three existing dialog helpers visually consistent without
/// changing how they are called.
class DialogShell extends StatelessWidget {
  const DialogShell({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: AppDimens.xl),
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: _DialogEntrance(
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.textWhiteColor,
            borderRadius: BorderRadius.circular(AppDimens.radiusSheet),
          ),
          clipBehavior: Clip.antiAlias,
          child: SingleChildScrollView(child: child),
        ),
      ),
    );
  }
}

/// Short fade + scale so dialogs do not pop in abruptly.
class _DialogEntrance extends StatefulWidget {
  const _DialogEntrance({required this.child});

  final Widget child;

  @override
  State<_DialogEntrance> createState() => _DialogEntranceState();
}

class _DialogEntranceState extends State<_DialogEntrance>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: AppDurations.fast,
  )..forward();

  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeOutCubic,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: ScaleTransition(
        scale: Tween<double>(begin: 0.96, end: 1).animate(_animation),
        child: widget.child,
      ),
    );
  }
}
