import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jigers_kitchen/core/apis/app_interface.dart';
import 'package:jigers_kitchen/utils/app_colors.dart';
import 'package:jigers_kitchen/utils/widget/app_bar.dart';
import 'package:jigers_kitchen/utils/widget/appwidgets.dart';
import 'package:jigers_kitchen/utils/widget/no_data.dart';
import 'package:jigers_kitchen/views/Dashboard_screen/admins/add_admin/add_admin.dart';
import 'package:jigers_kitchen/views/Dashboard_screen/admins/admin_controller.dart';

import '../../../../core/contstants.dart';
import '../../../../utils/app_images.dart';
import '../../../../utils/widget/custom_textfiled.dart';
import '../../../../utils/widget/delete_item_dialoug.dart';
import '../../../../utils/widget/success_dialoug.dart';
import '../../new_order_screens/new_order_widgets.dart';

class AdminList extends StatefulWidget {
  const AdminList({
    super.key,
  });

  @override
  State<AdminList> createState() => _AdminListState();
}

class _AdminListState extends State<AdminList> {
  AdminController controller = Get.put(AdminController());
  ScrollController _scrollController = ScrollController();

  Future<void> _scrollListener() async {
    print(_scrollController.position.extentAfter);
    if (_scrollController.position.extentAfter < 5) {
      if (controller.isMoreLoading.isFalse) {
        int Totalpage = controller.userList.value.data!.totalPages!;
        int currntPage = controller.userList.value.data!.currentPage!;
        int page = Totalpage > currntPage ? ++currntPage : 0;
        if (page != 0) {
          controller.getUser(true, page.toString(), true);
        }
      }
    }
  }

  @override
  void initState() {
    _scrollController = ScrollController()..addListener(_scrollListener);
    controller.textController.addListener(controller.onTextChanged);
    controller.getUser(false, "1", true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(
        text: "Sub-Admin",
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
        child: Obx(
          () => controller.isLoading.isTrue
              ? Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primaryColor,
                  ),
                )
              : RefreshIndicator(
                  onRefresh: controller.pullRefresh,
                  child: Column(
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
                              onTap: () async {
                                await Get.to(() => AddAdminScreen())!
                                    .then((value) {
                                  controller.getUser(false, "1", false);
                                });
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
                                    " Add Admin",
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
                          suffixIcon: controller.textController.text != ""
                              ? InkWell(
                                  onTap: () {
                                    controller.textController.clear();
                                  },
                                  child: const Icon(Icons.cancel))
                              : null,
                          hintText: "Search for Admin User"),
                      const SizedBox(
                        height: 15,
                      ),
                      Expanded(
                        child: controller.userList.value.data!.chefList!.isEmpty
                            ? Column(
                                children: [
                                  SizedBox(height: Get.height * 0.15),
                                  noData(null),
                                ],
                              )
                            : ListView.builder(
                                controller: _scrollController,
                                itemCount: controller
                                    .userList.value.data!.chefList!.length,
                                itemBuilder: (context, index) {
                                  return Card(
                                    color: AppColors.textGreyColor,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 17, vertical: 15),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              SizedBox(
                                                width: Get.width * 0.57,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      controller
                                                              .userList
                                                              .value
                                                              .data!
                                                              .chefList![index]
                                                              .name ??
                                                          "",
                                                      style: const TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    ),
                                                    const SizedBox(
                                                      height: 5,
                                                    ),
                                                    iconTextWidget(
                                                      icon:
                                                          Icons.phone_callback,
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
                                                      text: controller
                                                              .userList
                                                              .value
                                                              .data!
                                                              .chefList![index]
                                                              .email ??
                                                          "",
                                                    ),
                                                    const SizedBox(
                                                      height: 20,
                                                    ),
                                                  ],
                                                ),
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
                                                    ? NetworkImage(Constants
                                                            .webUrl +
                                                        controller
                                                            .userList
                                                            .value
                                                            .data!
                                                            .chefList![index]
                                                            .profileImage!)
                                                    : null,
                                              ),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  controller.selectedAdminId =
                                                      controller
                                                          .userList
                                                          .value
                                                          .data!
                                                          .chefList![index]
                                                          .id
                                                          .toString();
                                                  controller
                                                      .showCustomBottomSheet(
                                                          context, "subadmin");
                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15),
                                                      color: Colors.white),
                                                  child: const Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 8,
                                                            horizontal: 13),
                                                    child: Text(
                                                      "Print Orders",
                                                      style: TextStyle(
                                                          fontSize: 10,
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  NewOrderButtonWidget(
                                                    clr: AppColors.primaryColor,
                                                    ic: Icons.edit,
                                                    text: "",
                                                    ontap: () async {
                                                      await Get.to(
                                                              AddAdminScreen(
                                                        id: controller
                                                            .userList
                                                            .value
                                                            .data!
                                                            .chefList![index]
                                                            .id
                                                            .toString(),
                                                        isEdit: true,
                                                      ))!
                                                          .then((value) {
                                                        controller.getUser(
                                                            false,
                                                            controller
                                                                .userList
                                                                .value
                                                                .data!
                                                                .currentPage!
                                                                .toString(),
                                                            false);
                                                      });
                                                    },
                                                  ),
                                                  NewOrderButtonWidget(
                                                    clr: AppColors.redColor,
                                                    ic: Icons.delete,
                                                    text: "",
                                                    ontap: () async {
                                                      showDeleteItemDialoug(
                                                          description:
                                                              "Are you sure you want to DELETE the Admin User?",
                                                          context: context,
                                                          url: controller
                                                              .userList
                                                              .value
                                                              .data!
                                                              .chefList![index]
                                                              .profileImage,
                                                          onYes: () async {
                                                            Get.back();
                                                            appWidgets
                                                                .loadingDialog();
                                                            await AppInterface()
                                                                .deleteUser(
                                                              role: controller
                                                                  .role,
                                                              id: controller
                                                                  .userList
                                                                  .value
                                                                  .data!
                                                                  .chefList![
                                                                      index]
                                                                  .id
                                                                  .toString(),
                                                            )
                                                                .then((value) {
                                                              if (value !=
                                                                      null &&
                                                                  value ==
                                                                      200) {
                                                                appWidgets
                                                                    .hideDialog();
                                                                controller.getUser(
                                                                    false,
                                                                    controller
                                                                        .userList
                                                                        .value
                                                                        .data!
                                                                        .currentPage
                                                                        .toString(),
                                                                    false);
                                                                showDialogWithAutoDismiss(
                                                                    context: Get
                                                                        .context,
                                                                    doubleBack:
                                                                        false,
                                                                    img: AppImages
                                                                        .successDialougIcon,
                                                                    autoDismiss:
                                                                        true,
                                                                    heading:
                                                                        "Hurray!",
                                                                    text:
                                                                        "Admin User Deleted Successfully",
                                                                    headingStyle: TextStyle(
                                                                        fontSize:
                                                                            32,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w600,
                                                                        color: AppColors
                                                                            .textBlackColor));
                                                              }
                                                            });
                                                          });
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                      ),
                      controller.isMoreLoading.isTrue
                          ? Center(
                              child: CircularProgressIndicator(
                                color: AppColors.primaryColor,
                              ),
                            )
                          : const SizedBox()
                    ],
                  ),
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
      Expanded(
        child: Text(
          overflow: TextOverflow.ellipsis,
          text,
          style: TextStyle(
              fontSize: 11,
              color: AppColors.newOrderGrey,
              fontWeight: FontWeight.w600),
        ),
      ),
    ],
  );
}
