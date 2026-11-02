import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../common/common.dart';
import '../../utils/app_colors.dart';
import '../../utils/widget/animations.dart';
import '../../utils/widget/app_bar.dart';
import '../../utils/widget/drawer.dart';
import 'jigar_home_controller.dart';

class JigarHome extends StatelessWidget {
  const JigarHome({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeController());
    final indices = [
      for (int i = 0; i < controller.homeItems.length; i++)
        if (controller.homeItems[i]['show'] == true) i,
    ];
    return Scaffold(
      drawer: const NavDrawer(),
      backgroundColor: AppColors.textGreyColor,
      appBar: appBar(
        showDrawer: true,
        showback: false,
        text: 'Jigar’s Kitchen',
        actions: [
          IconButton(
            tooltip: 'Log out',
            onPressed: () => Common.logout(context),
            icon: Icon(Icons.logout, color: AppColors.textWhiteColor),
          ),
        ],
      ),
      body: SafeArea(
        child: LayoutBuilder(builder: (context, constraints) {
          final scale = MediaQuery.textScalerOf(context).scale(1);
          final columns = constraints.maxWidth < 350 || scale > 1.5 ? 1 : 2;
          final tileWidth =
              (constraints.maxWidth - 30 - (columns - 1) * 30) / columns;
          return GridView.builder(
            padding: const EdgeInsets.fromLTRB(15, 30, 15, 24),
            itemCount: indices.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: columns,
              crossAxisSpacing: 30,
              mainAxisSpacing: 20,
              mainAxisExtent: (tileWidth / 1.6).clamp(120, 180) +
                  (scale - 1).clamp(0, 4) * 44,
            ),
            itemBuilder: (context, index) {
              final original = indices[index];
              final item = controller.homeItems[original];
              return FadeSlideIn(
                index: index,
                child: PressableScale(
                  onTap: () => controller.onItemTap(original),
                  child: Stack(
                    alignment: Alignment.topCenter,
                    clipBehavior: Clip.none,
                    children: [
                      Positioned(
                        top: 28,
                        left: 0,
                        right: 0,
                        bottom: 0,
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(10, 30, 10, 10),
                          decoration: BoxDecoration(
                            color: AppColors.textWhiteColor,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: const Color(0xFFEDEFF2)),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x100F172A),
                                offset: Offset(0, 5),
                                blurRadius: 14,
                              ),
                              BoxShadow(
                                color: Color(0x050F172A),
                                offset: Offset(0, 1),
                                blurRadius: 3,
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              item['name'] as String,
                              maxLines: 2,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: AppColors.homeblack,
                                fontSize: 13,
                                height: 1.3,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: 55,
                        height: 55,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          color: AppColors.redColor,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.redColor.withValues(alpha: .22),
                              offset: const Offset(0, 4),
                              blurRadius: 10,
                            ),
                          ],
                        ),
                        child: Center(
                          child: SvgPicture.asset(
                            item['img'] as String,
                            width: 24,
                            height: 23,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}
