import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/apis/app_interface.dart';
import '../../../model/order_list_model.dart';
import '../../../utils/widget/appwidgets.dart';

class ORderListController extends GetxController {
  TextEditingController textController = TextEditingController();

  RxBool isLoading = false.obs;
  RxBool isMoreLoading = false.obs;
  Rx<OrderListModel> orderList = OrderListModel().obs;
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
