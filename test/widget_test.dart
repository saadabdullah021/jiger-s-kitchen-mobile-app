import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:jigers_kitchen/utils/app_theme.dart';
import 'package:jigers_kitchen/utils/widget/app_button.dart';
import 'package:jigers_kitchen/utils/widget/custom_textfiled.dart';
import 'package:jigers_kitchen/utils/widget/dialog_shell.dart';
import 'package:jigers_kitchen/utils/widget/skeletons.dart';
import 'package:jigers_kitchen/views/auth/login/login_screen.dart';

Widget host(Widget child, {bool reduceMotion = false}) => MaterialApp(
      theme: AppTheme.light,
      home: MediaQuery(
        data: MediaQueryData(disableAnimations: reduceMotion),
        child: Scaffold(body: child),
      ),
    );

void main() {
  tearDown(() => Get.reset());

  testWidgets('loading and disabled buttons prevent submissions',
      (tester) async {
    var taps = 0;
    for (final state in [0, 1, 2]) {
      await tester.pumpWidget(host(CustomButton(
        text: 'Save',
        isLoading: state == 1,
        enabled: state != 2,
        onPressed: () => taps++,
      )));
      await tester.pump(const Duration(milliseconds: 300));
      await tester.tap(find.byType(CustomButton));
      await tester.pump();
    }
    expect(taps, 1);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('clear action follows programmatic edits and focus replacement',
      (tester) async {
    final first = FocusNode();
    final second = FocusNode();
    final controller = TextEditingController();
    Future<void> show(FocusNode node) => tester.pumpWidget(host(CustomTextField(
          controller: controller,
          focusNode: node,
          hintText: 'Search',
          showClearButton: true,
        )));
    await show(first);
    first.requestFocus();
    await tester.pump();
    controller.text = 'Order 123';
    await tester.pump();
    expect(find.byTooltip('Clear text'), findsOneWidget);
    await show(second);
    second.requestFocus();
    await tester.pump();
    await tester.tap(find.byTooltip('Clear text'));
    expect(controller.text, isEmpty);
    await tester.pumpWidget(const SizedBox());
    first.dispose();
    second.dispose();
    controller.dispose();
    expect(tester.takeException(), isNull);
  });

  testWidgets('reduced-motion skeleton settles and disposes', (tester) async {
    await tester.pumpWidget(host(const SkeletonList(), reduceMotion: true));
    await tester.pumpAndSettle();
    expect(tester.binding.hasScheduledFrame, isFalse);
    await tester.pumpWidget(const SizedBox());
    expect(tester.takeException(), isNull);
  });

  testWidgets('dialog content scrolls on a short viewport', (tester) async {
    tester.view.physicalSize = const Size(320, 300);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(host(DialogShell(
      child: Column(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(15,
              (i) => Text('Detail $i', style: const TextStyle(fontSize: 24)))),
    )));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    await tester.drag(
        find.byType(SingleChildScrollView), const Offset(0, -400));
    await tester.pumpAndSettle();
    expect(find.text('Detail 14').hitTestable(), findsOneWidget);
  });

  testWidgets('login fits small phones with large text and keyboard',
      (tester) async {
    tester.view.physicalSize = const Size(320, 568);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(GetMaterialApp(
      theme: AppTheme.light,
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(
          textScaler: TextScaler.linear(1.6),
          viewInsets: const EdgeInsets.only(bottom: 220),
        ),
        child: child!,
      ),
      home: const LoginScreen(),
    ));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    await tester.ensureVisible(find.text('LOGIN'));
    await tester.tap(find.text('LOGIN'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(find.byType(TextFormField), findsNWidgets(2));
    await tester.pumpWidget(const SizedBox());
  });
}
