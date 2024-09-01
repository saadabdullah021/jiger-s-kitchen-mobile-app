import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jigers_kitchen/utils/app_colors.dart';
import 'package:jigers_kitchen/utils/widget/app_bar.dart';
import 'package:jigers_kitchen/views/Dashboard_screen/Chef/chef_list/chef_list_controller.dart';

import '../../../../core/contstants.dart';
import '../../../../utils/widget/custom_textfiled.dart';
import '../add_chef/add_chef_screen.dart';

class AllChefListScreen extends StatelessWidget {
  const AllChefListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ChefListController controller = ChefListController();
    controller.getChef(false, "1");
    return Scaffold(
      appBar: appBar(text: "Chef List"),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
        child: Obx(
          () => controller.isLoading.isTrue
              ? Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primaryColor,
                  ),
                )
              : Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 13),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Result: ${controller.userList.value.data!.totalRecords.toString()}",
                            style: const TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w600),
                          ),
                          InkWell(
                            onTap: () {
                              Get.to(() => const AddChefScreen());
                            },
                            child: Row(
                              children: [
                                Container(
                                    height: 15,
                                    width: 15,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            width: 1,
                                            color: AppColors.jetBlackColor),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: const Center(
                                        child: Icon(
                                      Icons.add,
                                      size: 12,
                                    ))),
                                const SizedBox(
                                  width: 2,
                                ),
                                const Text(
                                  "Add chef",
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    CustomTextField(
                        fillColor: AppColors.lightGreyColor,
                        controller: controller.textController,
                        prefixIcon: const Icon(Icons.search),
                        hintText: "Search for chef"),
                    const SizedBox(
                      height: 15,
                    ),
                    Expanded(
                      child: ListView.builder(
                          controller: controller.scrollController,
                          itemCount:
                              controller.userList.value.data!.chefList!.length,
                          itemBuilder: (context, index) {
                            return Card(
                              color: AppColors.textGreyColor,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 15),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          controller.userList.value.data!
                                                  .chefList![index].name ??
                                              "",
                                          style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        iconTextWidget(
                                          icon: Icons.phone_callback,
                                          text: controller
                                                  .userList
                                                  .value
                                                  .data!
                                                  .chefList![index]
                                                  .phoneNumber ??
                                              "",
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        iconTextWidget(
                                          icon: Icons.email,
                                          text: controller.userList.value.data!
                                                  .chefList![index].email ??
                                              "",
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              color: Colors.white),
                                          child: const Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 8, horizontal: 13),
                                            child: Text(
                                              "Print Orders",
                                              style: TextStyle(
                                                  fontSize: 10,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                    CircleAvatar(
                                      radius: 30,
                                      backgroundColor: Colors.white,
                                      backgroundImage: controller
                                                  .userList
                                                  .value
                                                  .data!
                                                  .chefList![index]
                                                  .profileImage !=
                                              null
                                          ? NetworkImage(Constants.webUrl +
                                              controller
                                                  .userList
                                                  .value
                                                  .data!
                                                  .chefList![index]
                                                  .profileImage!)
                                          : null,
                                    )
                                  ],
                                ),
                              ),
                            );
                          }),
                    )
                  ],
                ),
        ),
      ),
    );
  }
}

Widget iconTextWidget({
  required String text,
  required IconData icon,
}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      CircleAvatar(
          radius: 12,
          backgroundColor: Colors.white,
          child: Icon(icon, size: 12, color: AppColors.newOrderGrey)),
      const SizedBox(width: 5),
      Text(
        text,
        style: TextStyle(
            fontSize: 11,
            color: AppColors.newOrderGrey,
            fontWeight: FontWeight.w600),
      ),
    ],
  );
}
