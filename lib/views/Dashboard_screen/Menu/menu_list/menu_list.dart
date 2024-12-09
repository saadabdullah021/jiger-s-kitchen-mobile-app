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
import '../../../cart/view_cart.dart';
import 'menu_list_controller.dart';

class MenuListScreen extends StatefulWidget {
  bool? isBottomBar;
  String? vendorId;
  bool? addToCard;
  String? screenType;
  Function(bool)? onCompleted;
  MenuListScreen(
      {super.key,
      this.isBottomBar,
      this.vendorId,
      this.onCompleted,
      this.addToCard,
      required this.screenType});

  @override
  State<MenuListScreen> createState() => _MenuListScreenState();
}

class _MenuListScreenState extends State<MenuListScreen> {
  final MenuListController _controller = Get.put(MenuListController());
  @override
  void initState() {
    // TODO: implement initState
    _controller.ScreenType = widget.screenType ?? "";
    _controller.checkedIds.clear();
    _controller.addToCart = widget.addToCard ?? false;
    _controller.isFromBottomBar = widget.isBottomBar ?? false;
    _controller.currentVendorID = widget.vendorId;
    _controller.textController.addListener(_controller.onTextChanged);
    // if (widget.isBottomBar == true) {
    //   _controller.approvedController = Get.lazyPut();
    // }
    _controller.getTabData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius:
          BorderRadius.circular(widget.isBottomBar == true ? 20.0 : 0),
      child: Scaffold(
        appBar: widget.isBottomBar == true
            ? null
            : appBar(
                text: Common.currentRole == AppKeys.roleAdmin ||
                        widget.addToCard == true
                    ? "Menu"
                    : "Request Item",
                actions: [
                    widget.addToCard == true
                        ? InkWell(
                            onTap: () {
                              Get.to(() => const ViewCart());
                            },
                            child: Container(
                              height: 40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(11),
                                color: AppColors.textWhiteColor,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 3),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.shopping_cart,
                                      size: 25,
                                      color: AppColors.redColor,
                                    ),
                                    Center(
                                      child: Obx(
                                        () => Padding(
                                          padding:
                                              const EdgeInsets.only(bottom: 20),
                                          child: Text(
                                            Common.loginReponse.value.data!
                                                    .cartConter
                                                    .toString() ??
                                                "",
                                            style: TextStyle(
                                                color: AppColors.redColor,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        : const SizedBox(),
                  ]),
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
                            visible: Common.currentRole == AppKeys.roleAdmin &&
                                widget.isBottomBar == null,
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
                                padding:
                                    const EdgeInsets.symmetric(vertical: 15),
                                child: tabContainer()),
                            Expanded(
                              child: ShowListScreen(
                                addToCart: widget.addToCard,
                                isBottomBar: widget.isBottomBar,
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
        bottomNavigationBar: Common.currentRole != AppKeys.roleAdmin ||
                widget.isBottomBar == true
            ? Visibility(
                child: BottomAppBar(
                    color: Colors.transparent,
                    child: GestureDetector(
                      onTap: () async {
                        if (widget.addToCard == true) {
                          Get.to(() => const ViewCart());
                          //
                        } else {
                          widget.onCompleted != null
                              ? widget.onCompleted!(true)
                              : null;
                          if (_controller.checkedIds.isNotEmpty) {
                            widget.isBottomBar == true &&
                                    widget.screenType == "edit_item" &&
                                    widget.vendorId == null
                                ? _controller.addItemToAnOrder()
                                : widget.isBottomBar == true
                                    ? _controller.addItemByAdminItems()
                                    : _controller.requestItems();
                          } else {
                            appWidgets().showToast(
                                "Sorry", "Please select at least one item");
                          }
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
                              widget.isBottomBar == true
                                  ? "Add Item"
                                  : widget.addToCard == true
                                      ? "Proceed"
                                      : "Request Item",
                              style: TextStyle(
                                color: AppColors.textWhiteColor,
                                fontSize: 16.0,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            widget.addToCard == true
                                ? const SizedBox()
                                : Obx(
                                    () => CircleAvatar(
                                      radius: 20,
                                      backgroundColor: AppColors.redColor,
                                      child: Text(
                                        "${_controller.checkedIds.value.isEmpty ? "0" : _controller.checkedIds.value.length}",
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
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
              )
            : null,
      ),
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
