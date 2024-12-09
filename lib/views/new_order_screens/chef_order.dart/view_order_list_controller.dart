import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jigers_kitchen/model/chef_order_model.dart';

import '../../../core/apis/app_interface.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_images.dart';
import '../../../utils/widget/appwidgets.dart';
import '../../../utils/widget/success_dialoug.dart';

class ChefORderListController extends GetxController {
  TextEditingController textController = TextEditingController();
  final List<String> items = [
    'NEW ORDER',
    'IN PREPARATION',
    'COMPLETED',
    'CANCELLED'
  ];
  RxBool isLoading = false.obs;
  RxBool isMoreLoading = false.obs;
  Rx<GetChefOrderListModel> orderList = GetChefOrderListModel().obs;
  Timer? _debounce;
  String? status;
  void onTextChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(seconds: 1), () {
      callApi(textController.text);
    });
  }

  Future<void> pullRefresh() async {
    getOrder(false, "1", true, false, "");
  }

  Future<void> callApi(String query) async {
    if (query == "") {
      getOrder(false, "1", false, false, "");
    } else {
      getOrder(false, "1", false, true, query);
    }
  }

  updateStatus(String orderID, String orderStatus) async {
    appWidgets.loadingDialog();
    String status = orderStatus.toLowerCase().replaceAll(" ", "_");
    await AppInterface()
        .updateOrderStatusByChef(orderID: orderID, orderStatus: status)
        .then((value) {
      appWidgets.hideDialog();
      if (value == 200) {
        showDialogWithAutoDismiss(
            context: Get.context,
            doubleBack: false,
            img: AppImages.successDialougIcon,
            autoDismiss: true,
            heading: "Hurray!",
            text: "Status Updated Successfully",
            headingStyle: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w600,
                color: AppColors.textBlackColor));
        getOrder(false, "1", false, false, "");
      }
    });
  }

  getOrder(bool moreLoading, String page, bool showLoading, bool isSearching,
      String? searchKeyWord) async {
    if (moreLoading) {
      isMoreLoading.value = true;
    } else {
      if (showLoading == true) {
        isLoading.value = true;
      }
    }
    await AppInterface()
        .getChefOrderList(
            page: page,
            isSearch: isSearching,
            searchKey: searchKeyWord,
            status: status)
        .then((value) {
      if (value is GetChefOrderListModel) {
        if (moreLoading) {
          orderList.value.data!.items!.data!.addAll(value.data!.items!.data!);
          orderList.value.data!.currentPage = value.data!.currentPage!;
          orderList.value.data!.lastPage = value.data!.lastPage!;
          orderList.refresh();
        } else {
          orderList.value = value;
          orderList.refresh();
        }
        if (moreLoading) {
          isMoreLoading.value = false;
        } else {
          isLoading.value = false;
        }
      } else {
        appWidgets().showToast("Sorry", "Please try again");
      }
    });
  }
}
