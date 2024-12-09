import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/apis/app_interface.dart';
import '../../../model/order_list_model.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_images.dart';
import '../../../utils/widget/appwidgets.dart';
import '../../../utils/widget/success_dialoug.dart';
import '../dashboard_controller.dart';

class ORderListController extends GetxController {
  TextEditingController textController = TextEditingController();

  RxBool isLoading = false.obs;
  RxBool isMoreLoading = false.obs;
  Rx<OrderListModel> orderList = OrderListModel().obs;
  Timer? _debounce;
  String? vendorID;
  String? status;
  final List<String> items = [
    'NEW ORDER',
    'PICK UP',
    'OUT FOR DELIVERY',
    'DELIVERED',
    "CANCELLED",
    "PAID"
  ];
  updateStatus(String orderID, String orderStatus) async {
    DashboardController dashboardController = Get.find();
    appWidgets.loadingDialog();
    String status = orderStatus.toLowerCase().replaceAll(" ", "_");
    await AppInterface()
        .updateOrderStatusByAdminUuser(orderID: orderID, orderStatus: status)
        .then((value) {
      appWidgets.hideDialog();
      if (value == 200) {
        dashboardController.getCount(true);
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
        .getOrderList(
            page: page,
            isSearch: isSearching,
            vendorID: vendorID ?? "",
            searchKey: searchKeyWord,
            status: status)
        .then((value) {
      if (value is OrderListModel) {
        if (moreLoading) {
          orderList.value.data!.ordersList!.addAll(value.data!.ordersList!);
          orderList.value.data!.currentPage = value.data!.currentPage!;
          orderList.value.data!.totalPages = value.data!.totalPages!;
          orderList.refresh();
        } else {
          orderList.value = value;
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
