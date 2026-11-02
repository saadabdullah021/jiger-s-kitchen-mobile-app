import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';
import 'package:get/get.dart';
import '../../common/common.dart';
import '../../utils/widget/animations.dart';
import '../../utils/widget/app_states.dart';
import '../../utils/widget/app_bar.dart';
import '../../utils/widget/drawer.dart';
import '../../utils/widget/skeletons.dart';
import '../../utils/widget/workspace_widgets.dart';
import '../jigar_home_screen/jigar_home_controller.dart';
import 'dashboard_controller.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final controller = Get.put(DashboardController());
  @override
  void initState() {
    super.initState();
    if (Common.currentRole == 'chef' || Common.currentRole == 'delivery_user') {
      Get.put(HomeController());
    }
    controller.getCount(true);
  }

  @override
  Widget build(BuildContext context) {
    final hasDrawer =
        Common.currentRole == 'chef' || Common.currentRole == 'delivery_user';
    // Dashboard can be opened as the root screen (after login/splash) or
    // pushed from the home screen. Only show Back when this route can really
    // return to a previous screen.
    final canGoBack = Navigator.of(context).canPop();
    return Scaffold(
      backgroundColor: AppColors.textWhiteColor,
      drawer: hasDrawer ? const NavDrawer() : null,
      appBar: appBar(
        text: 'Dashboard',
        showDrawer: hasDrawer && !canGoBack,
        showback: canGoBack ? null : false,
        actions: [
          AppBarAction(
            tooltip: 'Refresh dashboard',
            icon: Icons.refresh_rounded,
            color: AppColors.primaryColor,
            onTap: () => controller.getCount(true),
          ),
        ],
      ),
      body: SafeArea(child: Obx(() {
        if (controller.isLoading.value) return const SkeletonDashboard();
        if (controller.hasError.value) {
          return AppErrorState(onRetry: () => controller.getCount(true));
        }
        final indices = [
          for (int i = 1; i < controller.DashBoardItems.length; i++)
            if (controller.DashBoardItems[i]['show'] == true) i,
        ];
        return LayoutBuilder(builder: (context, constraints) {
          final scale = MediaQuery.textScalerOf(context).scale(1);
          final columns = constraints.maxWidth < 350 || scale > 1.5
              ? 1
              : constraints.maxWidth >= 700
                  ? 3
                  : 2;
          return RefreshIndicator(
            onRefresh: () => controller.getCount(true),
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                  sliver: SliverToBoxAdapter(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Order overview',
                          style: TextStyle(
                              fontSize: 27,
                              height: 1.2,
                              fontWeight: FontWeight.w600,
                              color: AppColors.homeblack,
                              letterSpacing: -.7)),
                      const SizedBox(height: 8),
                      Text('A clear view of your kitchen operations.',
                          style: TextStyle(
                              color: AppColors.newOrderGrey, fontSize: 13)),
                      const SizedBox(height: 24),
                      FadeSlideIn(
                          child: _NewOrdersCard(
                              count: controller.DashBoardItems[0]['count']
                                  .toString(),
                              onTap: () => controller.onItemClick(0))),
                      const WorkspaceSection(
                          title: 'Across your kitchen',
                          subtitle: 'Select a status to explore its orders.'),
                    ],
                  )),
                ),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                  sliver: SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: columns,
                        mainAxisExtent: 176 + (scale - 1).clamp(0, 4) * 55,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12),
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final original = indices[index];
                      return FadeSlideIn(
                          index: index + 1,
                          child: _OrderStatusCard(
                              item: controller.DashBoardItems[original],
                              onTap: () => controller.onItemClick(original)));
                    }, childCount: indices.length),
                  ),
                ),
              ],
            ),
          );
        });
      })),
    );
  }
}

class _NewOrdersCard extends StatelessWidget {
  const _NewOrdersCard({required this.count, required this.onTap});
  final String count;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => PressableScale(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
              color: AppColors.dashBoardBg1,
              boxShadow: const [
                BoxShadow(
                    color: Color(0x180F172A),
                    offset: Offset(0, 5),
                    blurRadius: 14)
              ],
              borderRadius: BorderRadius.circular(24)),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Expanded(
                  child: Text('NEW ORDERS',
                      style: TextStyle(
                          color: AppColors.dashBoardText1,
                          letterSpacing: 1.6,
                          fontSize: 11,
                          fontWeight: FontWeight.w600))),
              Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: .12),
                      borderRadius: BorderRadius.circular(14)),
                  child: Icon(Icons.receipt_long_outlined,
                      color: AppColors.dashBoardText1, size: 24)),
            ]),
            const SizedBox(height: 12),
            FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(count,
                    style: TextStyle(
                        color: AppColors.dashBoardText1,
                        fontSize: 56,
                        height: 1.1,
                        fontWeight: FontWeight.w600,
                        letterSpacing: -2))),
            const SizedBox(height: 20),
            Divider(
                color: AppColors.dashBoardText1.withValues(alpha: .2),
                height: 1),
            const SizedBox(height: 16),
            Row(children: [
              Expanded(
                  child: Text('View new orders',
                      style: TextStyle(
                          color: AppColors.dashBoardText1,
                          fontSize: 13,
                          fontWeight: FontWeight.w500))),
              Icon(Icons.arrow_forward_rounded,
                  color: AppColors.dashBoardText1, size: 20),
            ]),
          ]),
        ),
      );
}

class _OrderStatusCard extends StatelessWidget {
  const _OrderStatusCard({required this.item, required this.onTap});
  final Map<String, dynamic> item;
  final VoidCallback onTap;
  static const _icons = {
    'pickup_orders': Icons.inventory_2_outlined,
    'out_of_delivery': Icons.local_shipping_outlined,
    'delivered_orders': Icons.task_alt_rounded,
    'cancelled_orders': Icons.cancel_outlined,
    'paid_orders': Icons.account_balance_wallet_outlined,
    'in_progress_orders': Icons.soup_kitchen_outlined,
  };
  @override
  Widget build(BuildContext context) => PressableScale(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
              color: item['bgColor'] as Color,
              boxShadow: const [
                BoxShadow(
                    color: Color(0x0D0F172A),
                    offset: Offset(0, 4),
                    blurRadius: 12)
              ],
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.borderColor)),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              WorkspaceIcon(
                  icon: _icons[item['key']] ?? Icons.receipt_long_outlined,
                  color: item['color'] as Color,
                  backgroundColor: AppColors.textWhiteColor),
              const Spacer(),
              Icon(Icons.north_east_rounded,
                  size: 17, color: AppColors.appIconColor),
            ]),
            const Spacer(),
            FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(item['count'].toString(),
                    style: TextStyle(
                        color: item['color'] as Color,
                        fontSize: 32,
                        height: 1.1,
                        fontWeight: FontWeight.w600,
                        letterSpacing: -1))),
            const SizedBox(height: 8),
            Text(item['name'] as String,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: AppColors.newOrderGrey, fontSize: 12, height: 1.3)),
          ]),
        ),
      );
}
