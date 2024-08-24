import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:jigers_kitchen/utils/app_colors.dart';
import 'package:jigers_kitchen/utils/widget/app_bar.dart';
import 'package:jigers_kitchen/views/jigar_home_screen/jigar_home_controller.dart';

class JigarHome extends StatelessWidget {
  const JigarHome({super.key});

  @override
  Widget build(BuildContext context) {
    HomeController controller = Get.put(HomeController());
    return Scaffold(
        backgroundColor: AppColors.textGreyColor,
        appBar: appBar(showback: false, text: "Jigar’s Kitchen", actions: [
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
          padding: const EdgeInsets.only(top: 30),
          child: GridView.builder(
            itemCount: controller.homeItems.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              childAspectRatio: 1.6,
              crossAxisSpacing: 5,
              mainAxisSpacing: 20,
              crossAxisCount: 2,
            ),
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: InkWell(
                  onTap: () => controller.onItemTap(index),
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
                                controller.homeItems[index]["name"]!,
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
                                  controller.homeItems[index]["img"]!,
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
