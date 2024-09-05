import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/apis/app_interface.dart';
import '../../../model/user_list_model.dart';
import '../../../utils/widget/appwidgets.dart';

class vendorListController extends GetxController {
  TextEditingController textController = TextEditingController();

  RxBool isLoading = false.obs;
  RxBool isMoreLoading = false.obs;
  Rx<userListModel> userList = userListModel().obs;
  Timer? _debounce;
  void onTextChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(seconds: 1), () {
      callApi(textController.text);
    });
  }

  Future<void> pullRefresh() async {
    getChef(false, "1", true);
  }

  Future<void> callApi(String query) async {
    if (query == "") {
      getChef(false, "1", false);
    } else {
      await AppInterface()
          .searchUser(role: "vendor", query: query)
          .then((value) {
        if (value != null && value is userListModel) {
          userList.value = value;
          userList.refresh();
        }
      });
    }
  }

  getChef(bool moreLoading, String page, bool showLoading) async {
    if (moreLoading) {
      isMoreLoading.value = true;
    } else {
      if (showLoading == true) {
        isLoading.value = true;
      }
    }
    await AppInterface().getUserList(role: "vendor", page: page).then((value) {
      if (value is userListModel) {
        if (moreLoading) {
          userList.value.data!.chefList!.addAll(value.data!.chefList!);
          userList.value.data!.currentPage = value.data!.currentPage!;
          userList.value.data!.totalPages = value.data!.totalPages!;
          userList.refresh();
        } else {
          userList.value = value;
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
