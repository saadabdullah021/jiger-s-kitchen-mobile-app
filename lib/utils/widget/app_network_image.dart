import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../app_colors.dart';
import '../app_dimens.dart';
import 'shimmer.dart';

/// Network image with a skeleton placeholder, an error fallback and decode-size
/// capping.
///
/// [width]/[height] are the layout size. When known, they are also used as
/// `cacheWidth`/`cacheHeight` (scaled by device pixel ratio) so a large remote
/// image is not decoded at full resolution into a small box.
class AppNetworkImage extends StatelessWidget {
  const AppNetworkImage({
    super.key,
    required this.url,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.radius = 0,
    this.errorIcon = Icons.image_not_supported_outlined,
  });

  final String? url;
  final double? width;
  final double? height;
  final BoxFit fit;
  final double radius;
  final IconData errorIcon;

  @override
  Widget build(BuildContext context) {
    final Widget content =
        (url == null || url!.trim().isEmpty) ? _fallback() : _image(context);

    if (radius <= 0) return content;
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: content,
    );
  }

  Widget _image(BuildContext context) {
    final double dpr = MediaQuery.maybeDevicePixelRatioOf(context) ?? 2;

    return Image.network(
      url!,
      width: width,
      height: height,
      fit: fit,
      cacheWidth: width == null || !width!.isFinite
          ? null
          : math.max(1, (width! * dpr).round()),
      cacheHeight: height == null || !height!.isFinite
          ? null
          : math.max(1, (height! * dpr).round()),
      // Fade in once decoded so the swap from skeleton is not a hard cut.
      frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
        if (wasSynchronouslyLoaded) return child;
        return AnimatedOpacity(
          opacity: frame == null ? 0 : 1,
          duration: AppDurations.normal,
          curve: Curves.easeOut,
          child: child,
        );
      },
      loadingBuilder: (context, child, progress) =>
          progress == null ? child : _placeholder(),
      errorBuilder: (context, error, stack) => _fallback(),
    );
  }

  Widget _placeholder() => Shimmer(
        child: Container(
          width: width,
          height: height,
          color: Colors.white,
        ),
      );

  Widget _fallback() => Container(
        width: width,
        height: height,
        color: AppColors.lightGreyColor,
        alignment: Alignment.center,
        child: Icon(
          errorIcon,
          size: AppDimens.iconMd,
          color: AppColors.appIconColor,
        ),
      );
}

/// Circular variant, for avatars.
class AppNetworkAvatar extends StatelessWidget {
  const AppNetworkAvatar({
    super.key,
    required this.url,
    required this.radius,
    this.fallbackIcon = Icons.person_outline_rounded,
  });

  final String? url;
  final double radius;
  final IconData fallbackIcon;

  @override
  Widget build(BuildContext context) {
    final double size = radius * 2;
    return ClipOval(
      child: AppNetworkImage(
        url: url,
        width: size,
        height: size,
        errorIcon: fallbackIcon,
      ),
    );
  }
}
