import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jigers_kitchen/common/common.dart';
import 'package:jigers_kitchen/core/apis/app_interface.dart';
import 'package:jigers_kitchen/core/contstants.dart';
import 'package:jigers_kitchen/utils/app_colors.dart';
import 'package:jigers_kitchen/utils/app_keys.dart';
import 'package:jigers_kitchen/utils/widget/appwidgets.dart';

import '../../../../utils/app_images.dart';
import '../../../../utils/widget/delete_item_dialoug.dart';
import '../../../../utils/widget/no_data.dart';
import '../../../../utils/widget/success_dialoug.dart';
import '../add_menu/add_menu_screen.dart';
import 'menu_list_controller.dart';

class ShowListScreen extends StatefulWidget {
  String id;
  ShowListScreen({super.key, required this.id});

  @override
  State<ShowListScreen> createState() => _ShowListScreenState();
}

class _ShowListScreenState extends State<ShowListScreen> {
  final MenuListController _controller = Get.find();
  ScrollController _scrollController = ScrollController();
  Future<void> _scrollListener() async {
    print(_scrollController.position.extentAfter);
    if (_scrollController.position.extentAfter < 5) {
      if (_controller.isMoreLoading.isFalse) {
        int Totalpage = _controller.menuItems.value.data!.totalPages!;
        int currntPage = _controller.menuItems.value.data!.currentPage!;
        int page = Totalpage > currntPage ? ++currntPage : 0;
        if (page != 0) {
          _controller.geteMenu(
            true,
            true,
            page.toString(),
          );
        }
      }
    }
  }

  @override
  void initState() {
    _scrollController = ScrollController()..addListener(_scrollListener);
    // _controller.geteMenu(
    //   false,
    //   widget.id,
    // );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => _controller.isMenuLoading.isTrue
          ? Center(
              child: CircularProgressIndicator(
                color: AppColors.primaryColor,
              ),
            )
          : _controller.menuItems.value.data!.menuItemsList!.isEmpty
              ? Column(
                  children: [
                    SizedBox(height: Get.height * 0.15),
                    noData(),
                  ],
                )
              : Column(
                  children: [
                    Expanded(
                      child: ListView.separated(
                          controller: _scrollController,
                          separatorBuilder: (context, index) {
                            return const SizedBox(
                              height: 15,
                            );
                          },
                          itemCount: _controller
                              .menuItems.value.data!.menuItemsList!.length,
                          itemBuilder: (context, index) {
                            return Visibility(
                              visible: Common.currentRole == AppKeys.roleAdmin
                                  ? true
                                  : _controller.menuItems.value.data!
                                          .menuItemsList![index].showInMenu ==
                                      1,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 20),
                                decoration: BoxDecoration(
                                    color: AppColors.textWhiteColor,
                                    border: Border.all(
                                        width: 1,
                                        color: AppColors.newOrderGrey),
                                    borderRadius: BorderRadius.circular(22)),
                                child: Row(
                                  crossAxisAlignment:
                                      Common.currentRole == AppKeys.roleAdmin
                                          ? CrossAxisAlignment.start
                                          : CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                          color: AppColors.lightGreyColor,
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                      height: 100,
                                      width: 95,
                                      child: Image.network(Constants.webUrl +
                                          _controller
                                              .menuItems
                                              .value
                                              .data!
                                              .menuItemsList![index]
                                              .profileImage!),
                                    ),
                                    const SizedBox(
                                      width: 15,
                                    ),
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            _controller
                                                .menuItems
                                                .value
                                                .data!
                                                .menuItemsList![index]
                                                .itemName!,
                                            maxLines: 1,
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 20,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            _controller
                                                    .menuItems
                                                    .value
                                                    .data!
                                                    .menuItemsList![index]
                                                    .description ??
                                                "",
                                            maxLines: 3,
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 14,
                                                fontWeight: FontWeight.normal),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            children: [
                                              Visibility(
                                                visible: Common.currentRole ==
                                                    AppKeys.roleAdmin,
                                                child: smallBtn(
                                                    AppColors.textWhiteColor,
                                                    _controller
                                                                .menuItems
                                                                .value
                                                                .data!
                                                                .menuItemsList![
                                                                    index]
                                                                .showInMenu ==
                                                            1
                                                        ? AppColors.primaryColor
                                                        : AppColors
                                                            .textFiledGrey,
                                                    "Show In Menu", () async {
                                                  appWidgets.loadingDialog();
                                                  await AppInterface()
                                                      .chnageMenuStatus(
                                                          columnName:
                                                              "show_in_menu",
                                                          id: _controller
                                                              .menuItems
                                                              .value
                                                              .data!
                                                              .menuItemsList![
                                                                  index]
                                                              .id!
                                                              .toString(),
                                                          value: _controller
                                                                      .menuItems
                                                                      .value
                                                                      .data!
                                                                      .menuItemsList![
                                                                          index]
                                                                      .showInMenu ==
                                                                  1
                                                              ? 0
                                                              : 1)
                                                      .then((value) {
                                                    if (value == 200) {
                                                      appWidgets.hideDialog();
                                                      _controller
                                                                  .menuItems
                                                                  .value
                                                                  .data!
                                                                  .menuItemsList![
                                                                      index]
                                                                  .showInMenu ==
                                                              1
                                                          ? _controller
                                                              .menuItems
                                                              .value
                                                              .data!
                                                              .menuItemsList![
                                                                  index]
                                                              .showInMenu = 0
                                                          : _controller
                                                              .menuItems
                                                              .value
                                                              .data!
                                                              .menuItemsList![
                                                                  index]
                                                              .showInMenu = 1;
                                                      _controller.menuItems
                                                          .refresh();
                                                      appWidgets().showToast(
                                                          "Sucess",
                                                          "Successfully Updated");
                                                    }
                                                  });
                                                }),
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              smallBtn(
                                                  AppColors.textWhiteColor,
                                                  _controller
                                                              .menuItems
                                                              .value
                                                              .data!
                                                              .menuItemsList![
                                                                  index]
                                                              .isChefSpecial ==
                                                          1
                                                      ? AppColors.primaryColor
                                                      : AppColors.textFiledGrey,
                                                  "Chef Special", () async {
                                                if (Common.currentRole ==
                                                    AppKeys.roleAdmin) {
                                                  appWidgets.loadingDialog();
                                                  await AppInterface()
                                                      .chnageMenuStatus(
                                                          columnName:
                                                              "is_chef_special",
                                                          id: _controller
                                                              .menuItems
                                                              .value
                                                              .data!
                                                              .menuItemsList![
                                                                  index]
                                                              .id!
                                                              .toString(),
                                                          value: _controller
                                                                      .menuItems
                                                                      .value
                                                                      .data!
                                                                      .menuItemsList![
                                                                          index]
                                                                      .isChefSpecial ==
                                                                  1
                                                              ? 0
                                                              : 1)
                                                      .then((value) {
                                                    if (value == 200) {
                                                      appWidgets.hideDialog();
                                                      _controller
                                                                  .menuItems
                                                                  .value
                                                                  .data!
                                                                  .menuItemsList![
                                                                      index]
                                                                  .isChefSpecial ==
                                                              1
                                                          ? _controller
                                                              .menuItems
                                                              .value
                                                              .data!
                                                              .menuItemsList![
                                                                  index]
                                                              .isChefSpecial = 0
                                                          : _controller
                                                              .menuItems
                                                              .value
                                                              .data!
                                                              .menuItemsList![
                                                                  index]
                                                              .isChefSpecial = 1;
                                                      _controller.menuItems
                                                          .refresh();
                                                      appWidgets().showToast(
                                                          "Sucess",
                                                          "Successfully Updated");
                                                    }
                                                  });
                                                }
                                              }),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          Visibility(
                                            visible: Common.currentRole ==
                                                AppKeys.roleAdmin,
                                            child: Align(
                                              alignment: Alignment.bottomRight,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  InkWell(
                                                    onTap: () async {
                                                      await Get.to(
                                                              AddMenuScreen(
                                                        id: _controller
                                                            .menuItems
                                                            .value
                                                            .data!
                                                            .menuItemsList![
                                                                index]
                                                            .id!
                                                            .toString(),
                                                        isEdit: true,
                                                      ))!
                                                          .then((value) {
                                                        _controller.geteMenu(
                                                          false,
                                                          false,
                                                          _controller
                                                              .menuItems
                                                              .value
                                                              .data!
                                                              .currentPage
                                                              .toString(),
                                                        );
                                                      });
                                                    },
                                                    child: CircleAvatar(
                                                      backgroundColor: AppColors
                                                          .dividerGreyColor,
                                                      radius: 15,
                                                      child: const Icon(
                                                        Icons.edit,
                                                        size: 20,
                                                        color: Colors.grey,
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 5,
                                                  ),
                                                  InkWell(
                                                    onTap: () {
                                                      showDeleteItemDialoug(
                                                          description:
                                                              "Are you sure you want to DELETE the Item?",
                                                          context: context,
                                                          url: _controller
                                                              .menuItems
                                                              .value
                                                              .data!
                                                              .menuItemsList![
                                                                  index]
                                                              .profileImage,
                                                          onYes: () async {
                                                            Get.back();
                                                            appWidgets
                                                                .loadingDialog();
                                                            await AppInterface()
                                                                .deleteMenuItem(
                                                              id: _controller
                                                                  .menuItems
                                                                  .value
                                                                  .data!
                                                                  .menuItemsList![
                                                                      index]
                                                                  .id
                                                                  .toString(),
                                                            )
                                                                .then((value) {
                                                              if (value !=
                                                                      null &&
                                                                  value ==
                                                                      200) {
                                                                _controller
                                                                    .geteMenu(
                                                                  false,
                                                                  false,
                                                                  _controller
                                                                      .menuItems
                                                                      .value
                                                                      .data!
                                                                      .currentPage
                                                                      .toString(),
                                                                );
                                                                appWidgets
                                                                    .hideDialog();
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
                                                                        "Item Deleted Successfully",
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
                                                    child: CircleAvatar(
                                                      backgroundColor: AppColors
                                                          .dividerGreyColor,
                                                      radius: 15,
                                                      child: const Icon(
                                                        Icons.delete,
                                                        size: 20,
                                                        color: Colors.grey,
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    Visibility(
                                      visible: Common.currentRole !=
                                          AppKeys.roleAdmin,
                                      child: Obx(
                                        () => Checkbox(
                                          activeColor: AppColors.appColor,
                                          value: _controller.checkedIds
                                              .contains(_controller
                                                  .menuItems
                                                  .value
                                                  .data!
                                                  .menuItemsList![index]
                                                  .id),
                                          onChanged: (bool? value) {
                                            if (value == true) {
                                              _controller.checkedIds.value.add(
                                                  _controller
                                                      .menuItems
                                                      .value
                                                      .data!
                                                      .menuItemsList![index]
                                                      .id!);
                                              _controller.checkedIds.refresh();
                                            } else {
                                              _controller.checkedIds.value
                                                  .remove(_controller
                                                      .menuItems
                                                      .value
                                                      .data!
                                                      .menuItemsList![index]
                                                      .id!);
                                              _controller.checkedIds.refresh();
                                            }
                                          },
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          }),
                    ),
                    Obx(
                      () => _controller.isMoreLoading.isTrue
                          ? SizedBox(
                              height: 50,
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: AppColors.primaryColor,
                                ),
                              ),
                            )
                          : const SizedBox(),
                    )
                  ],
                ),
    );
  }
}

Widget smallBtn(
    Color textColor, Color btnColor, String text, VoidCallback onTap) {
  return InkWell(
    onTap: onTap,
    child: Container(
      height: 25,
      width: 92,
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30), color: btnColor),
      child: Center(
        child: Text(
          text,
          style: TextStyle(fontSize: 10, color: textColor),
        ),
      ),
    ),
  );
}
