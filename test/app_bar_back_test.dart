import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:jigers_kitchen/utils/widget/app_bar.dart';

void main() {
  tearDown(() => Get.reset());

  testWidgets('appBar back button pops current route via Navigator', (tester) async {
    await tester.pumpWidget(
      GetMaterialApp(
        home: Scaffold(
          body: Center(
            child: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => Scaffold(
                        appBar: appBar(text: 'Sub Screen'),
                        body: const Text('Sub Page Content'),
                      ),
                    ),
                  );
                },
                child: const Text('Open Sub Screen'),
              ),
            ),
          ),
        ),
      ),
    );

    // Open sub screen
    await tester.tap(find.text('Open Sub Screen'));
    await tester.pumpAndSettle();
    expect(find.text('Sub Page Content'), findsOneWidget);

    // Tap back button
    final backBtn = find.byTooltip('Back');
    expect(backBtn, findsOneWidget);
    await tester.tap(backBtn);
    await tester.pumpAndSettle();

    // Verify sub screen is popped
    expect(find.text('Sub Page Content'), findsNothing);
    expect(find.text('Open Sub Screen'), findsOneWidget);
  });

  testWidgets('appBar back button calls custom onPressed if provided', (tester) async {
    bool customPressed = false;

    await tester.pumpWidget(
      GetMaterialApp(
        home: Scaffold(
          appBar: appBar(
            text: 'Custom Action',
            onPressed: () {
              customPressed = true;
            },
          ),
        ),
      ),
    );

    final backBtn = find.byTooltip('Back');
    expect(backBtn, findsOneWidget);
    await tester.tap(backBtn);
    await tester.pumpAndSettle();

    expect(customPressed, isTrue);
  });

  testWidgets('appBar hides back button when showback is false or back is false', (tester) async {
    await tester.pumpWidget(
      GetMaterialApp(
        home: Scaffold(
          appBar: appBar(
            text: 'No Back Button',
            showback: false,
          ),
        ),
      ),
    );

    expect(find.byTooltip('Back'), findsNothing);

    await tester.pumpWidget(
      GetMaterialApp(
        home: Scaffold(
          appBar: appBar(
            text: 'No Back Button Either',
            back: false,
          ),
        ),
      ),
    );

    expect(find.byTooltip('Back'), findsNothing);
  });
}
