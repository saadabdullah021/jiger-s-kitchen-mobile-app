import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:jigers_kitchen/common/common.dart';
import 'package:jigers_kitchen/model/login_model.dart';
import 'package:jigers_kitchen/utils/app_theme.dart';
import 'package:jigers_kitchen/views/Dashboard_screen/dashboard_controller.dart';
import 'package:jigers_kitchen/views/Dashboard_screen/dashboard_screen.dart';
import 'package:jigers_kitchen/views/jigar_home_screen/jiagar_home.dart';
import 'package:jigers_kitchen/views/jigar_home_screen/jigar_home_controller.dart';

class PreviewDashboard extends DashboardController {
  int? selected;
  @override
  Future<void> getCount(bool showLoading) async {}
  @override
  void onItemClick(int index) {
    selected = index;
  }
}

void main() {
  setUp(() {
    Common.currentRole = 'admin';
    Common.loginReponse.value =
        loginModel(data: Data(name: 'Suleman', email: '', role: 'admin'));
  });
  tearDown(() => Get.reset());

  testWidgets('home and dashboard render and remain usable at narrow widths',
      (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final fonts = FontLoader('Poppins')
      ..addFont(rootBundle.load('assets/fonts/Poppins/Poppins-Regular.ttf'))
      ..addFont(rootBundle.load('assets/fonts/Poppins/Poppins-SemiBold.ttf'));
    await fonts.load();
    final icons = FontLoader('MaterialIcons')
      ..addFont(rootBundle.load('fonts/MaterialIcons-Regular.otf'));
    await icons.load();
    Future<void> show(Widget screen, {double scale = 1}) =>
        tester.pumpWidget(GetMaterialApp(
            theme: AppTheme.light,
            builder: (context, child) => MediaQuery(
                data: MediaQuery.of(context)
                    .copyWith(textScaler: TextScaler.linear(scale)),
                child: child!),
            home: RepaintBoundary(
                key: const ValueKey('preview'), child: screen)));
    await show(const JigarHome());
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    await expectLater(find.byKey(const ValueKey('preview')),
        matchesGoldenFile('goldens/home.png'));
    final homeController = Get.find<HomeController>();
    final expected =
        homeController.homeItems.where((i) => i['show'] == true).length;
    expect(expected, greaterThan(0));
    await tester.pumpWidget(const SizedBox());
    final dashboard = PreviewDashboard();
    final counts = [12, 8, 5, 148, 3, 126, 9];
    for (var i = 0; i < counts.length; i++) {
      dashboard.DashBoardItems[i]['count'] = counts[i];
    }
    Get.put<DashboardController>(dashboard);
    await show(const DashboardScreen());
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    await expectLater(find.byKey(const ValueKey('preview')),
        matchesGoldenFile('goldens/dashboard.png'));
    await tester.tap(find.text('View new orders'));
    expect(dashboard.selected, 0);
    await tester.pumpWidget(const SizedBox());
    tester.view.physicalSize = const Size(320, 568);
    await show(const DashboardScreen(), scale: 1.8);
    await tester.pumpAndSettle();
    await tester.drag(find.byType(CustomScrollView), const Offset(0, -500));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox());
    await show(const JigarHome(), scale: 1.8);
    await tester.pumpAndSettle();
    await tester.drag(find.byType(GridView), const Offset(0, -500));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox());
  });
}
