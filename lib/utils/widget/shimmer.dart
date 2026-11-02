import 'package:flutter/material.dart';

import '../app_dimens.dart';

/// Lightweight shimmer, implemented with a single [AnimationController] driving
/// a [ShaderMask]. Deliberately hand-rolled to avoid adding a dependency.
///
/// Wrap a skeleton subtree in one [Shimmer] rather than shimmering each box
/// individually: that keeps it to one controller and one repaint per frame.
class Shimmer extends StatefulWidget {
  const Shimmer({super.key, required this.child, this.enabled = true});

  final Widget child;
  final bool enabled;

  @override
  State<Shimmer> createState() => _ShimmerState();
}

class _ShimmerState extends State<Shimmer> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: AppDurations.shimmer,
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _syncAnimation();
  }

  void _syncAnimation() {
    final animate = widget.enabled &&
        !MediaQuery.disableAnimationsOf(context) &&
        TickerMode.valuesOf(context).enabled;
    if (animate && !_controller.isAnimating) {
      _controller.repeat();
    } else if (!animate) {
      _controller.stop();
    }
  }

  @override
  void didUpdateWidget(Shimmer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.enabled != oldWidget.enabled) {
      _syncAnimation();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled || MediaQuery.disableAnimationsOf(context)) {
      return ColorFiltered(
        colorFilter:
            const ColorFilter.mode(Color(0xFFEDEDED), BlendMode.srcATop),
        child: widget.child,
      );
    }

    return AnimatedBuilder(
      animation: _controller,
      // The skeleton subtree is passed as `child` so it is built once and only
      // the mask repaints each frame.
      child: widget.child,
      builder: (context, child) {
        return ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (bounds) {
            // Slide a highlight band from left to right across the subtree.
            final double slide =
                (_controller.value * 2 - 1) * bounds.width * 1.5;
            return LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: const [
                Color(0xFFEDEDED),
                Color(0xFFF7F7F7),
                Color(0xFFEDEDED),
              ],
              stops: const [0.35, 0.5, 0.65],
              transform: _SlideGradient(slide),
            ).createShader(bounds);
          },
          child: child,
        );
      },
    );
  }
}

class _SlideGradient extends GradientTransform {
  const _SlideGradient(this.dx);

  final double dx;

  @override
  Matrix4 transform(Rect bounds, {TextDirection? textDirection}) =>
      Matrix4.identity()..translateByDouble(dx, 0, 0, 1);
}

/// A single skeleton block. Only meaningful inside a [Shimmer].
class ShimmerBox extends StatelessWidget {
  const ShimmerBox({
    super.key,
    this.width,
    this.height = 14,
    this.radius = AppDimens.xs,
    this.shape = BoxShape.rectangle,
  });

  /// Circular skeleton, e.g. for an avatar placeholder.
  const ShimmerBox.circle({super.key, required double size})
      : width = size,
        height = size,
        radius = 0,
        shape = BoxShape.circle;

  final double? width;
  final double height;
  final double radius;
  final BoxShape shape;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        // Any opaque colour works; the ShaderMask paints over it.
        color: Colors.white,
        shape: shape,
        borderRadius:
            shape == BoxShape.circle ? null : BorderRadius.circular(radius),
      ),
    );
  }
}
