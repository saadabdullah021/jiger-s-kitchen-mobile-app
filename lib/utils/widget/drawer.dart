import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:jigers_kitchen/core/contstants.dart';

import '../../common/common.dart';
import '../../views/Dashboard_screen/chef_and_delivery_boy/add_chef/add_chef_screen.dart';
import '../../views/jigar_home_screen/jigar_home_controller.dart';
import '../app_colors.dart';

class NavDrawer extends StatefulWidget {
  const NavDrawer({super.key});

  @override
  State<NavDrawer> createState() => _NavDrawerState();
}

class _NavDrawerState extends State<NavDrawer> {
  HomeController controller = Get.find();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final List<int> visibleIndices = [];
    final List<Map<String, dynamic>> visibleItems = [];

    for (int i = 0; i < controller.homeItems.length; i++) {
      if (controller.homeItems[i]["show"] == true &&
          controller.homeItems[i]["show_drawer"] == true) {
        visibleIndices.add(i);
        visibleItems.add(controller.homeItems[i]);
      }
    }
    return SizedBox(
      child: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 65,
                    backgroundColor: Colors.grey,
                    child: ClipOval(
                      child: Container(
                        width: 140,
                        height: 140,
                        color: AppColors.primaryColor,
                        child:
                            Common.loginReponse.value.data!.profileImage != null
                                ? Image.network(
                                    Constants.webUrl +
                                        Common.loginReponse.value.data!
                                            .profileImage!,
                                    fit: BoxFit.cover,
                                  )
                                : const SizedBox(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              maxLines: 1,
              textAlign: TextAlign.center,
              Common.loginReponse != null
                  ? Common.loginReponse.value.data!.name!
                  : "",
              style: const TextStyle(color: Colors.black, fontSize: 17),
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              maxLines: 1,
              textAlign: TextAlign.center,
              Common.loginReponse != null
                  ? Common.loginReponse.value.data!.email!
                  : "",
              style: const TextStyle(color: Colors.black, fontSize: 12),
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(
              height: 20,
            ),
            ListView.separated(
                separatorBuilder: (context, index) {
                  return const SizedBox(
                    height: 20,
                  );
                },
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: visibleItems.length,
                padding: const EdgeInsets.symmetric(vertical: 10),
                itemBuilder: (context, index) {
                  final item = visibleItems[index];
                  final originalIndex = visibleIndices[index];
                  return InkWell(
                    onTap: () => controller.onItemTap(originalIndex),
                    child: DraweRow(item: item),
                  );
                }),
            const SizedBox(
              height: 10,
            ),
            InkWell(
              onTap: () {
                Get.to(AddChefScreen(
                  id: Common.loginReponse.value.data!.id!.toString(),
                  isEdit: true,
                  type: Common.loginReponse.value.data!.role!.toString(),
                ));
              },
              child: DraweRow(item: controller.drawerExtraItems[0]),
            ),
            const SizedBox(
              height: 20,
            ),
            InkWell(
              onTap: () {
                Common.logout(context);
              },
              child: DraweRow(item: controller.drawerExtraItems[1]),
            ),
            const SizedBox(
              height: 20,
            ),
            InkWell(
              onTap: () {
                Common.logout(context);
              },
              child: DraweRow(item: controller.drawerExtraItems[2]),
            ),
          ],
        ),
      ),
    );
  }
}

class DraweRow extends StatelessWidget {
  const DraweRow({
    super.key,
    required this.item,
  });

  final Map<String, dynamic> item;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(
          width: 10,
        ),
        Container(
          padding: const EdgeInsets.all(8),
          height: 40,
          width: 40,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: AppColors.redColor),
          child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: SvgPicture.asset(
              item["img"],
              color: AppColors.textWhiteColor,
            ),
          ),
        ),
        const SizedBox(width: 15),
        Text(
          item["name"],
          maxLines: 1,
          style: TextStyle(
              fontSize: 14,
              color: AppColors.textBlackColor,
              fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
