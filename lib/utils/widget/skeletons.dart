import 'package:flutter/material.dart';

import '../app_colors.dart';
import '../app_dimens.dart';
import 'shimmer.dart';

/// Skeleton placeholders shaped like the real content they stand in for, so
/// there is minimal layout shift when data arrives.
///
/// Each list/grid skeleton wraps its items in a single [Shimmer] so the whole
/// screen shares one animation controller.

/// Card skeleton used by the order/vendor/admin style lists.
class SkeletonCard extends StatelessWidget {
  const SkeletonCard({super.key, this.showAvatar = true, this.lines = 3});

  final bool showAvatar;
  final int lines;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimens.lg),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(AppDimens.radiusCard),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const ShimmerBox(width: 120, height: 15),
                const SizedBox(height: AppDimens.md),
                for (int i = 0; i < lines; i++)
                  Padding(
                    padding: const EdgeInsets.only(bottom: AppDimens.sm),
                    child: ShimmerBox(
                      width: i.isEven ? 180 : 140,
                      height: 12,
                    ),
                  ),
              ],
            ),
          ),
          if (showAvatar) ...[
            const SizedBox(width: AppDimens.md),
            const ShimmerBox.circle(size: 56),
          ],
        ],
      ),
    );
  }
}

/// Vertical list of [SkeletonCard]s.
class SkeletonList extends StatelessWidget {
  const SkeletonList({
    super.key,
    this.itemCount = 5,
    this.showAvatar = true,
    this.lines = 3,
    this.padding = const EdgeInsets.symmetric(
      horizontal: AppDimens.screenH,
      vertical: AppDimens.screenV,
    ),
  });

  final int itemCount;
  final bool showAvatar;
  final int lines;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      child: ListView.separated(
        padding: padding,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: itemCount,
        separatorBuilder: (_, __) => const SizedBox(height: AppDimens.md),
        itemBuilder: (_, __) =>
            SkeletonCard(showAvatar: showAvatar, lines: lines),
      ),
    );
  }
}

/// Compact row skeleton for tighter lists (menu items, dropdown results).
class SkeletonRowList extends StatelessWidget {
  const SkeletonRowList({super.key, this.itemCount = 6});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimens.screenH,
          vertical: AppDimens.screenV,
        ),
        physics: const NeverScrollableScrollPhysics(),
        itemCount: itemCount,
        separatorBuilder: (_, __) => const SizedBox(height: AppDimens.md),
        itemBuilder: (_, __) => const Row(
          children: [
            ShimmerBox(width: 56, height: 56, radius: AppDimens.md),
            SizedBox(width: AppDimens.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShimmerBox(width: 140, height: 14),
                  SizedBox(height: AppDimens.sm),
                  ShimmerBox(width: 90, height: 12),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Dashboard skeleton: one wide hero tile above a two-column grid.
class SkeletonDashboard extends StatelessWidget {
  const SkeletonDashboard({super.key, this.tileCount = 6});

  final int tileCount;

  @override
  Widget build(BuildContext context) {
    final scale = MediaQuery.textScalerOf(context).scale(1);
    final width = MediaQuery.sizeOf(context).width;
    return Shimmer(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        children: [
          const ShimmerBox(width: 180, height: 32),
          const SizedBox(height: 8),
          const ShimmerBox(height: 18),
          const SizedBox(height: 24),
          const ShimmerBox(height: 220, radius: 24),
          const SizedBox(height: 28),
          const ShimmerBox(height: 24),
          const SizedBox(height: 12),
          const ShimmerBox(height: 16),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: tileCount,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: width < 350 || scale > 1.5
                  ? 1
                  : width >= 700
                      ? 3
                      : 2,
              mainAxisExtent: 176 + (scale - 1).clamp(0, 4) * 55,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemBuilder: (_, __) => const ShimmerBox(radius: 20),
          ),
        ],
      ),
    );
  }
}

/// Skeleton for profile-style detail headers.
class SkeletonProfile extends StatelessWidget {
  const SkeletonProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return const Shimmer(
      child: Padding(
        padding: EdgeInsets.all(AppDimens.screenH),
        child: Column(
          children: [
            ShimmerBox.circle(size: 88),
            SizedBox(height: AppDimens.lg),
            ShimmerBox(width: 160, height: 16),
            SizedBox(height: AppDimens.sm),
            ShimmerBox(width: 110, height: 12),
            SizedBox(height: AppDimens.xxl),
            ShimmerBox(
                width: double.infinity,
                height: 48,
                radius: AppDimens.radiusInput),
            SizedBox(height: AppDimens.md),
            ShimmerBox(
                width: double.infinity,
                height: 48,
                radius: AppDimens.radiusInput),
            SizedBox(height: AppDimens.md),
            ShimmerBox(
                width: double.infinity,
                height: 48,
                radius: AppDimens.radiusInput),
          ],
        ),
      ),
    );
  }
}

/// Small inline skeleton for a single async value (counts, totals).
class SkeletonText extends StatelessWidget {
  const SkeletonText({super.key, this.width = 60, this.height = 14});

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) =>
      Shimmer(child: ShimmerBox(width: width, height: height));
}

/// Scrollable placeholders for add/edit screens, including short viewports.
class SkeletonForm extends StatelessWidget {
  const SkeletonForm({super.key, this.showAvatar = false});

  final bool showAvatar;

  @override
  Widget build(BuildContext context) => Shimmer(
        child: ListView(
          padding: const EdgeInsets.all(AppDimens.lg),
          children: [
            if (showAvatar) ...[
              const Center(child: ShimmerBox.circle(size: 88)),
              const SizedBox(height: 24),
            ],
            const Align(
              alignment: Alignment.centerLeft,
              child: ShimmerBox(width: 160, height: 22),
            ),
            const SizedBox(height: 24),
            for (var i = 0; i < 5; i++) ...[
              const ShimmerBox(height: 48, radius: AppDimens.radiusInput),
              const SizedBox(height: 20),
            ],
            const ShimmerBox(height: 48, radius: AppDimens.radiusButton),
          ],
        ),
      );
}

/// A bounded placeholder for the next page; never inserts a nested viewport.
class SkeletonLoadMore extends StatelessWidget {
  const SkeletonLoadMore({super.key});

  @override
  Widget build(BuildContext context) => const Shimmer(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              ShimmerBox(width: 40, height: 40, radius: 10),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ShimmerBox(height: 12),
                    SizedBox(height: 8),
                    ShimmerBox(width: 100, height: 10),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
}

/// Document-shaped loading state used throughout invoice/report previews.
class SkeletonDocument extends StatelessWidget {
  const SkeletonDocument({super.key});

  @override
  Widget build(BuildContext context) => Shimmer(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            const Align(
              alignment: Alignment.centerLeft,
              child: ShimmerBox(width: 140, height: 28),
            ),
            const SizedBox(height: 24),
            const ShimmerBox(height: 14),
            const SizedBox(height: 12),
            const ShimmerBox(height: 14, width: 180),
            const SizedBox(height: 36),
            for (var i = 0; i < 8; i++) ...[
              const ShimmerBox(height: 32),
              const SizedBox(height: 12),
            ],
          ],
        ),
      );
}
