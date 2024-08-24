import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:jigers_kitchen/views/Dashboard_screen/dashboard_controller.dart';

import '../../utils/app_colors.dart';
import '../../utils/widget/app_bar.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    DashboardController controller = Get.put(DashboardController());
    return Scaffold(
      appBar: appBar(text: "Dashboard", actions: [
        Container(
          height: 35,
          width: 35,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(11),
            color: AppColors.textWhiteColor,
          ),
          child: Icon(
            Icons.more_vert,
            color: AppColors.redColor,
          ),
        ),
      ]),
      body: Padding(
        padding: const EdgeInsets.only(top: 20, left: 15, right: 15),
        child: Column(
          children: [
            Container(
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
                        controller.DashBoardItems[0]["count"].toString(),
                        maxLines: 2,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: controller.DashBoardItems[0]['color'],
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
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: GridView.builder(
                itemCount: controller.DashBoardItems.length - 1,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  childAspectRatio: 7 / 6,
                  crossAxisSpacing: 40,
                  mainAxisSpacing: 20,
                  crossAxisCount: 2,
                ),
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {},
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: controller.DashBoardItems[index + 1]
                              ['bgColor']),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 40,
                            backgroundColor: AppColors.textWhiteColor,
                            child: Center(
                              child: SvgPicture.asset(
                                controller.DashBoardItems[index + 1]['img'],
                                color: controller.DashBoardItems[index + 1]
                                    ['color'],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  controller.DashBoardItems[index + 1]["name"]!,
                                  maxLines: 2,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: AppColors.homeblack,
                                      fontSize: 12,
                                      fontWeight: FontWeight.normal),
                                ),
                                Text(
                                  controller.DashBoardItems[index + 1]["count"]
                                      .toString(),
                                  maxLines: 2,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: controller
                                          .DashBoardItems[index + 1]['color'],
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
    );
  }
}
