import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jigers_kitchen/common/common.dart';
import 'package:jigers_kitchen/utils/app_keys.dart';
import 'package:jigers_kitchen/utils/widget/app_bar.dart';
import 'package:jigers_kitchen/views/Dashboard_screen/Menu/add_menu/add_menu_screen.dart';
import 'package:jigers_kitchen/views/Dashboard_screen/Menu/menu_list/show_list.dart';

import '../../../../model/menu_tab_model.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/widget/appwidgets.dart';
import '../../../../utils/widget/custom_textfiled.dart';
import 'menu_list_controller.dart';

class MenuListScreen extends StatefulWidget {
  const MenuListScreen({
    super.key,
  });

  @override
  State<MenuListScreen> createState() => _MenuListScreenState();
}

class _MenuListScreenState extends State<MenuListScreen> {
  final MenuListController _controller = Get.put(MenuListController());
  @override
  void initState() {
    // TODO: implement initState

    _controller.textController.addListener(_controller.onTextChanged);
    _controller.getTabData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(
          text: Common.currentRole == AppKeys.roleAdmin
              ? "Menu"
              : "Request Item"),
      body: Obx(
        () => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          child: _controller.isLoading.isTrue
              ? Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primaryColor,
                  ),
                )
              : Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Obx(
                          () => Text(
                            _controller.menuItems.value.data == null
                                ? ""
                                : "Result: ${_controller.menuItems.value.data!.totalRecords.toString()}",
                            style: const TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w600),
                          ),
                        ),
                        Visibility(
                          visible: Common.currentRole == AppKeys.roleAdmin,
                          child: InkWell(
                            onTap: () async {
                              Get.to(AddMenuScreen())!.then((value) {
                                _controller.geteMenu(false, false, "1");
                                _controller.menuItems.refresh();
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
                                  " Add Menu",
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Obx(
                      () => CustomTextField(
                          fillColor: AppColors.lightGreyColor,
                          controller: _controller.textController,
                          prefixIcon: const Icon(Icons.search),
                          suffixIcon: _controller.showCrossBtn.isTrue
                              ? InkWell(
                                  onTap: () {
                                    _controller.textController.clear();
                                  },
                                  child: const Icon(Icons.cancel))
                              : null,
                          hintText: "Search for Menu"),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Padding(
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              child: tabContainer()),
                          Expanded(
                            child: ShowListScreen(
                              id: _controller.selectedMenuId.toString(),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
        ),
      ),
      // ${_controller.checkedIds.value.isEmpty ? "" : _controller.checkedIds.value.length}
      bottomNavigationBar: Common.currentRole != AppKeys.roleAdmin
          ? Visibility(
              child: Obx(
                () => BottomAppBar(
                    color: Colors.transparent,
                    child: GestureDetector(
                      onTap: () {
                        if (_controller.checkedIds.isNotEmpty) {
                          _controller.requestItems();
                        } else {
                          appWidgets().showToast(
                              "Sorry", "Please select atleast one item");
                        }
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor,
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Request Item",
                              style: TextStyle(
                                color: AppColors.textWhiteColor,
                                fontSize: 16.0,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            CircleAvatar(
                              radius: 20,
                              backgroundColor: AppColors.redColor,
                              child: Text(
                                "${_controller.checkedIds.value.isEmpty ? "0" : _controller.checkedIds.value.length}",
                                style: const TextStyle(color: Colors.white),
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                    // CustomButton(
                    //     text: "Request Items",
                    //     onPressed: () {
                    //       if (_controller.checkedIds.isNotEmpty) {
                    //         _controller.requestItems();
                    //       } else {
                    //         appWidgets().showToast(
                    //             "Sorry", "Please select atleast one item");
                    //       }
                    //     })
                    ),
              ),
            )
          : null,
    );
  }

  tabContainer() => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(
            _controller.tabData!.tabData!.length,
            (index) => tabButton(_controller.tabData!.tabData![index], index),
          ),
        ),
      );
  tabButton(
    TabData data,
    int value,
  ) =>
      Expanded(
        child: Obx(
          () => GestureDetector(
            onTap: () {
              _controller.selectedTabIndex.value = value;
              _controller.selectedMenuId.value = data.id!;
              _controller.geteMenu(false, true, "1");
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 100),
              height: 30,
              width: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: _controller.selectedTabIndex.value == value
                    ? AppColors.appColor
                    : AppColors.lightGreyColor,
              ),
              child: Center(
                child: Text(
                  data.name!.split(" ")[0],
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: _controller.selectedTabIndex.value == value
                        ? FontWeight.w600
                        : FontWeight.w400,
                    color: _controller.selectedTabIndex.value == value
                        ? AppColors.textGreyColor
                        : AppColors.textBlackColor,
                  ),
                ),
              ),
            ),
          ),
        ),
      );
}
