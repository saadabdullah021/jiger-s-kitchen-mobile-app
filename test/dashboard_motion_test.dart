import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:jigers_kitchen/common/common.dart';
import 'package:jigers_kitchen/utils/widget/animations.dart';
import 'package:jigers_kitchen/utils/widget/shimmer.dart';
import 'package:jigers_kitchen/utils/widget/skeletons.dart';
import 'package:jigers_kitchen/views/Dashboard_screen/dashboard_controller.dart';
import 'package:jigers_kitchen/views/Dashboard_screen/dashboard_screen.dart';

Widget host(Widget child, {bool reduceMotion = false, bool ticker = true}) =>
    MaterialApp(
      home: MediaQuery(
        data: MediaQueryData(disableAnimations: reduceMotion),
        child: TickerMode(enabled: ticker, child: Scaffold(body: child)),
      ),
    );

class LoadingDashboard extends DashboardController {
  @override
  Future<void> getCount(bool showLoading) async {
    isLoading.value = true;
  }
}

void main() {
  tearDown(() => Get.reset());

  testWidgets('large panels enter by twelve pixels and settle', (tester) async {
    const target = SizedBox(key: ValueKey('panel'), height: 500, width: 200);
    await tester.pumpWidget(host(const FadeSlideIn(child: target)));
    final start = tester.getTopLeft(find.byKey(const ValueKey('panel'))).dy;
    await tester.pumpAndSettle();
    final end = tester.getTopLeft(find.byKey(const ValueKey('panel'))).dy;
    expect(start - end, closeTo(12, .01));
    expect(tester.takeException(), isNull);
  });

  testWidgets('stagger cancels on disposal and reduced motion settles',
      (tester) async {
    const entrance = FadeSlideIn(index: 5, child: Text('Ready'));
    await tester.pumpWidget(host(entrance));
    await tester.pumpWidget(host(entrance, reduceMotion: true));
    await tester.pumpAndSettle();
    expect(find.text('Ready'), findsOneWidget);
    expect(tester.binding.hasScheduledFrame, isFalse);
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(milliseconds: 500));
    expect(tester.takeException(), isNull);

    await tester.pumpWidget(host(entrance));
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(milliseconds: 500));
    expect(tester.takeException(), isNull);
  });

  testWidgets('shimmer pauses offscreen and resumes when visible',
      (tester) async {
    const skeleton = Shimmer(child: ShimmerBox(height: 40));
    await tester.pumpWidget(host(skeleton));
    await tester.pump(const Duration(milliseconds: 100));
    expect(tester.binding.hasScheduledFrame, isTrue);
    await tester.pumpWidget(host(skeleton, ticker: false));
    await tester.pumpAndSettle();
    expect(tester.binding.hasScheduledFrame, isFalse);
    await tester.pumpWidget(host(skeleton));
    await tester.pump(const Duration(milliseconds: 100));
    expect(tester.binding.hasScheduledFrame, isTrue);
    await tester.pumpWidget(host(skeleton, reduceMotion: true));
    await tester.pumpAndSettle();
    expect(tester.binding.hasScheduledFrame, isFalse);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('form, document and pagination shimmers fit short phones',
      (tester) async {
    tester.view.physicalSize = const Size(320, 240);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    for (final skeleton in [
      const SkeletonForm(showAvatar: true),
      const SkeletonDocument(),
      const Column(children: [Spacer(), SkeletonLoadMore()]),
    ]) {
      await tester.pumpWidget(host(skeleton, reduceMotion: true));
      await tester.pumpAndSettle();
      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.byType(Shimmer), findsOneWidget);
      expect(tester.takeException(), isNull);
    }
  });

  testWidgets('dashboard transitions from shimmer to content and refreshes',
      (tester) async {
    Common.currentRole = 'admin';
    final controller = Get.put<DashboardController>(LoadingDashboard());
    await tester.pumpWidget(const GetMaterialApp(home: DashboardScreen()));
    expect(find.byType(SkeletonDashboard), findsOneWidget);
    controller.isLoading.value = false;
    await tester.pumpAndSettle();
    expect(find.byType(SkeletonDashboard), findsNothing);
    expect(find.text('View new orders'), findsOneWidget);
    await tester.tap(find.byTooltip('Refresh dashboard'));
    await tester.pump();
    expect(find.byType(SkeletonDashboard), findsOneWidget);
    controller.isLoading.value = false;
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox());
  });
}
