import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jigers_kitchen/common/common.dart';
import 'package:jigers_kitchen/core/apis/app_interface.dart';
import 'package:jigers_kitchen/model/get_menu_item_model.dart';
import 'package:jigers_kitchen/model/menu_tab_model.dart';
import 'package:jigers_kitchen/utils/widget/appwidgets.dart';

import '../../../../utils/app_colors.dart';
import '../../../../utils/app_images.dart';
import '../../../../utils/widget/success_dialoug.dart';
import '../../../new_order_screens/new_order_list/new_order_list_controller.dart';

class MenuListController extends GetxController {
  RxBool isLoading = true.obs;
  bool isFromBottomBar = false;
  RxBool isMoreLoading = false.obs;
  RxBool isMenuLoading = false.obs;
  bool addToCart = false;
  String? editOrderId;
  String? editVendorId;
  String? currentVendorID;
  String ScreenType = '';
  Rx<GetMenuItemModel> menuItems = GetMenuItemModel().obs;
  TextEditingController textController = TextEditingController();
  menuTabModel? tabData;
  Timer? _debounce;
  RxBool showCrossBtn = false.obs;
  RxInt selectedTabIndex = 0.obs;
  RxInt selectedMenuId = 0.obs;
  RxList<int> checkedIds = <int>[].obs;
  requestItems() async {
    appWidgets.loadingDialog();
    await AppInterface()
        .requestItem(ids: checkedIds.value, addedByVendor: false)
        .then((value) {
      appWidgets.hideDialog();
      if (value == 200) {
        showDialogWithAutoDismiss(
            context: Get.context,
            doubleBack: true,
            img: AppImages.successDialougIcon,
            autoDismiss: true,
            heading: "Hurray!",
            text: "Item Added Successfully",
            headingStyle: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w600,
                color: AppColors.textBlackColor));
      }
    });
  }

  AddToCart(String id) async {
    appWidgets.loadingDialog();
    await AppInterface().addToCart(id: id).then((value) async {
      appWidgets.hideDialog();
      if (value == 200) {
        await AppInterface()
            .getUserByToken(Common.loginReponse.value.data!.token!)
            .then((value) {
          if (value == 200) {
            Common.loginReponse.refresh();
          }
        });
        appWidgets().showToast("Success", "Added to cart");
      }
    });
  }

  addItemByAdminItems() async {
    appWidgets.loadingDialog();
    await AppInterface()
        .requestItem(
            ids: checkedIds.value,
            addedByVendor: true,
            vendorID: currentVendorID)
        .then((value) {
      appWidgets.hideDialog();
      if (value == 200) {
        showDialogWithAutoDismiss(
            context: Get.context,
            doubleBack: true,
            img: AppImages.successDialougIcon,
            autoDismiss: true,
            heading: "Hurray!",
            text: "Item Added Successfully",
            headingStyle: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w600,
                color: AppColors.textBlackColor));
      }
    });
  }

  addItemToAnOrder() async {
    appWidgets.loadingDialog();
    newORderListController controller = Get.find();
    await AppInterface()
        .AddItemToAnOrder(
      ids: checkedIds.value,
      orderId: controller.editOrderDetail.value.data!.id.toString(),
      vendorID:
          controller.editOrderDetail.value.data!.vendorInfo!.id.toString(),
    )
        .then((value) async {
      appWidgets.hideDialog();
      if (value == 200) {
        controller.getEditOrder(false);
        showDialogWithAutoDismiss(
            context: Get.context,
            doubleBack: true,
            img: AppImages.successDialougIcon,
            autoDismiss: true,
            heading: "Hurray!",
            text: "Items Added Successfully",
            headingStyle: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w600,
                color: AppColors.textBlackColor));
      }
    });
  }

  getTabData() {
    isLoading.value = true;
    AppInterface().getMenuTab().then((value) {
      if (value is menuTabModel) {
        tabData = value;
        isLoading.value = false;
        selectedMenuId.value = tabData!.tabData![0].id!;
        geteMenu(
          false,
          true,
          "1",
        );
      }
    });
  }

  Future<void> callSearchApi(String query) async {
    if (query == "") {
      showCrossBtn.value = false;
      geteMenu(
        false,
        false,
        "1",
      );
    } else {
      showCrossBtn.value = true;
      await AppInterface()
          .searchMenuItems(
              page: "1", id: selectedMenuId.toString(), keyWord: query)
          .then((value) {
        if (value != null && value is GetMenuItemModel) {
          menuItems.value = value;
          menuItems.refresh();
        }
      });
    }
  }

  void onTextChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(seconds: 1), () {
      callSearchApi(textController.text);
    });
  }

  geteMenu(
    bool moreLoading,
    bool showLoading,
    String page,
  ) async {
    if (moreLoading) {
      isMoreLoading.value = true;
    } else {
      if (showLoading == true) {
        isMenuLoading.value = true;
      }
    }
    await AppInterface()
        .getMenuItems(
            page: page,
            isPriceSlabAdded: addToCart,
            id: selectedMenuId.toString(),
            isApproved: ScreenType == "request_item" ? false : true)
        .then((value) {
      if (value is GetMenuItemModel) {
        if (moreLoading) {
          menuItems.value.data!.menuItemsList!
              .addAll(value.data!.menuItemsList!);
          menuItems.value.data!.currentPage = value.data!.currentPage!;
          menuItems.value.data!.totalPages = value.data!.totalPages!;
          menuItems.refresh();
          isMoreLoading.value = false;
        } else {
          menuItems.value = value;
          isMenuLoading.value = false;
          menuItems.refresh();
        }
      }
    });
  }
}
