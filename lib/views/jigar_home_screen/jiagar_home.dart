import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:jigers_kitchen/common/common.dart';
import 'package:jigers_kitchen/utils/app_colors.dart';
import 'package:jigers_kitchen/utils/widget/app_bar.dart';
import 'package:jigers_kitchen/views/jigar_home_screen/jigar_home_controller.dart';

import '../../utils/widget/drawer.dart';

class JigarHome extends StatelessWidget {
  const JigarHome({super.key});

  @override
  Widget build(BuildContext context) {
    // print(Common.loginReponse.value.data!.vendorCategory!);
    HomeController controller = Get.put(HomeController());
    final List<int> visibleIndices = [];
    final List<Map<String, dynamic>> visibleItems = [];

    for (int i = 0; i < controller.homeItems.length; i++) {
      if (controller.homeItems[i]["show"] == true) {
        visibleIndices.add(i);
        visibleItems.add(controller.homeItems[i]);
      }
    }
    return Scaffold(
        drawer: const NavDrawer(),
        backgroundColor: AppColors.textGreyColor,
        appBar: appBar(
            showDrawer: true,
            showback: false,
            text: "Jigar’s Kitchen",
            actions: [
              InkWell(
                onTap: () {
                  Common.logout(context);
                },
                child: Icon(
                  Icons.logout,
                  color: AppColors.textWhiteColor,
                ),
              ),
            ]),
        body: Padding(
          padding: const EdgeInsets.only(top: 30),
          child: GridView.builder(
            itemCount: visibleItems.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              childAspectRatio: 1.6,
              crossAxisSpacing: 5,
              mainAxisSpacing: 20,
              crossAxisCount: 2,
            ),
            itemBuilder: (context, index) {
              final item = visibleItems[index];
              final originalIndex = visibleIndices[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: InkWell(
                  onTap: () => controller.onItemTap(originalIndex),
                  child: Stack(
                    alignment: Alignment.topCenter,
                    clipBehavior: Clip.none,
                    children: [
                      Positioned(
                        top: 30,
                        left: 0,
                        right: 0,
                        bottom: 0,
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.textWhiteColor,
                            borderRadius: BorderRadius.circular(7),
                          ),
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: Text(
                                item["name"]!,
                                maxLines: 2,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: AppColors.homeblack,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 0,
                        child: Container(
                          width: 55,
                          height: 55,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24),
                            color: AppColors.redColor,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.redColor.withOpacity(0.6),
                                offset: const Offset(0, 4),
                                blurRadius: 6,
                              ),
                            ],
                          ),
                          child: Center(
                            child: Container(
                              width: 24,
                              height: 23,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(7),
                                color: Colors.transparent,
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(7),
                                child: SvgPicture.asset(
                                  item["img"]!,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ));
  }
}
