import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:jigers_kitchen/common/common.dart';
import 'package:jigers_kitchen/views/Dashboard_screen/dashboard_controller.dart';

import '../../utils/app_colors.dart';
import '../../utils/widget/app_bar.dart';
import '../../utils/widget/drawer.dart';
import '../jigar_home_screen/jigar_home_controller.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  DashboardController controller = Get.put(DashboardController());
  @override
  void initState() {
    if (Common.currentRole == "chef") {
      Get.put(HomeController());
    }
    // TODO: implement initState
    controller.getCount();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final List<int> visibleIndices = [];
    final List<Map<String, dynamic>> visibleItems = [];

    for (int i = 0; i < controller.DashBoardItems.length; i++) {
      if (controller.DashBoardItems[i]["show"] == true) {
        visibleIndices.add(i);
        visibleItems.add(controller.DashBoardItems[i]);
      }
    }
    return Scaffold(
      drawer: Common.currentRole == "chef" ? const NavDrawer() : null,
      appBar: appBar(
          showDrawer: Common.currentRole == "chef" ? true : false,
          text: "Dashboard",
          actions: [
            Container(
              height: 35,
              width: 35,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(11),
                color: AppColors.textWhiteColor,
              ),
              child: InkWell(
                onTap: () {
                  controller.getCount();
                },
                child: Icon(
                  Icons.refresh,
                  color: AppColors.redColor,
                ),
              ),
            ),
          ]),
      body: Obx(
        () => controller.isLoading.isTrue
            ? Center(
                child: CircularProgressIndicator(
                  color: AppColors.appColor,
                ),
              )
            : Padding(
                padding: const EdgeInsets.only(top: 20, left: 15, right: 15),
                child: Column(
                  children: [
                    InkWell(
                      onTap: () {
                        controller.onItemClick(0);
                      },
                      child: Container(
                        height: Get.height * 0.18,
                        decoration: BoxDecoration(
                            color: controller.DashBoardItems[0]['bgColor'],
                            borderRadius: BorderRadius.circular(6)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  controller.DashBoardItems[0]["name"]!,
                                  maxLines: 2,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: AppColors.homeblack,
                                      fontSize: 15,
                                      fontWeight: FontWeight.normal),
                                ),
                                Text(
                                  controller.DashBoardItems[0]["count"]
                                      .toString(),
                                  maxLines: 2,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: controller.DashBoardItems[0]
                                          ['color'],
                                      fontSize: 39,
                                      fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                            CircleAvatar(
                              radius: 40,
                              backgroundColor: AppColors.textWhiteColor,
                              child: Center(
                                child: SvgPicture.asset(
                                  controller.DashBoardItems[0]['img'],
                                  color: controller.DashBoardItems[0]['color'],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Expanded(
                      child: GridView.builder(
                        itemCount: visibleItems.length - 1,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          childAspectRatio: 7 / 6,
                          crossAxisSpacing: 40,
                          mainAxisSpacing: 20,
                          crossAxisCount: 2,
                        ),
                        itemBuilder: (context, index) {
                          final originalIndex = visibleIndices[index + 1];
                          return InkWell(
                            onTap: () {
                              controller.onItemClick(originalIndex);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color:
                                      controller.DashBoardItems[originalIndex]
                                          ['bgColor']),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  CircleAvatar(
                                    radius: 40,
                                    backgroundColor: AppColors.textWhiteColor,
                                    child: Center(
                                      child: SvgPicture.asset(
                                        controller.DashBoardItems[originalIndex]
                                            ['img'],
                                        color: controller
                                                .DashBoardItems[originalIndex]
                                            ['color'],
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          controller
                                                  .DashBoardItems[originalIndex]
                                              ["name"]!,
                                          maxLines: 2,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: AppColors.homeblack,
                                              fontSize: 12,
                                              fontWeight: FontWeight.normal),
                                        ),
                                        Text(
                                          controller
                                              .DashBoardItems[originalIndex]
                                                  ["count"]
                                              .toString(),
                                          maxLines: 2,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: controller.DashBoardItems[
                                                  originalIndex]['color'],
                                              fontSize: 24,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
