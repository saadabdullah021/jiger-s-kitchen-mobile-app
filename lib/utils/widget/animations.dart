import 'dart:async';

import 'package:flutter/material.dart';

import '../app_dimens.dart';

/// Subtle entrance: fade plus a short upward slide.
///
/// Runs once on mount. [index] staggers list items; the stagger is capped so a
/// long list never makes the user wait on the tail items.
class FadeSlideIn extends StatefulWidget {
  const FadeSlideIn({
    super.key,
    required this.child,
    this.index = 0,
    this.offset = 12,
    this.duration = AppDurations.cardEntrance,
  });

  final Widget child;
  final int index;
  final double offset;
  final Duration duration;

  @override
  State<FadeSlideIn> createState() => _FadeSlideInState();
}

class _FadeSlideInState extends State<FadeSlideIn>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller =
      AnimationController(vsync: this, duration: widget.duration);

  late final CurvedAnimation _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeOutCubic,
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _timer?.cancel();
    if (MediaQuery.disableAnimationsOf(context)) {
      _controller.value = 1;
    } else if (TickerMode.valuesOf(context).enabled &&
        !_controller.isCompleted) {
      final step = widget.index.clamp(0, 5);
      _timer = Timer(
          Duration(milliseconds: AppDurations.cardStaggerStepMs * step), () {
        if (mounted) _controller.forward();
      });
    } else {
      _controller.stop();
    }
  }

  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    _animation.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.disableAnimationsOf(context)) return widget.child;
    return FadeTransition(
      opacity: _animation,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) => Transform.translate(
          offset: Offset(0, widget.offset * (1 - _animation.value)),
          child: child,
        ),
        child: widget.child,
      ),
    );
  }
}

/// Press feedback: scales down slightly while held.
///
/// The tap fires immediately on release; the animation never gates the action.
class PressableScale extends StatefulWidget {
  const PressableScale({
    super.key,
    required this.child,
    this.onTap,
    this.scale = 0.97,
  });

  final Widget child;
  final VoidCallback? onTap;
  final double scale;

  @override
  State<PressableScale> createState() => _PressableScaleState();
}

class _PressableScaleState extends State<PressableScale> {
  bool _pressed = false;

  void _setPressed(bool value) {
    if ((value && widget.onTap == null) || _pressed == value) return;
    setState(() => _pressed = value);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      onHighlightChanged: _setPressed,
      child: AnimatedScale(
        scale: _pressed && widget.onTap != null ? widget.scale : 1,
        duration: MediaQuery.disableAnimationsOf(context)
            ? Duration.zero
            : AppDurations.fast,
        curve: Curves.easeOut,
        child: widget.child,
      ),
    );
  }
}
