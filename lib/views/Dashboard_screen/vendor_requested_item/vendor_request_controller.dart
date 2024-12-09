import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/apis/app_interface.dart';
import '../../../model/requested_item_list_model.dart';
import '../../../model/user_list_model.dart';
import '../../../utils/widget/appwidgets.dart';

class vendorRequestController extends GetxController {
  TextEditingController textController = TextEditingController();
  TextEditingController itemtextController = TextEditingController();

  RxBool isLoading = false.obs;
  RxBool isMoreLoading = false.obs;
  String? vendorID;
  Rx<userListModel> userList = userListModel().obs;
  Rx<RequestedItemListModel> requestedItemList = RequestedItemListModel().obs;
  Timer? _debounce;
  void onTextChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(seconds: 1), () {
      callApi(textController.text);
    });
  }

  void onTextChangedList() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(seconds: 1), () {
      callSearchApiForList(itemtextController.text);
    });
  }

  Future<void> pullRefresh() async {
    getList(false, "1", true);
  }

  Future<void> callApi(String query) async {
    if (query == "") {
      getList(false, "1", false);
    } else {
      await AppInterface()
          .getRequestUserList(searchKey: query, isSearch: true)
          .then((value) {
        if (value != null && value is userListModel) {
          userList.value = value;
          userList.refresh();
        }
      });
    }
  }

  Future<void> callSearchApiForList(String query) async {
    if (query == "") {
      getItemList(false, "1", false, vendorID!);
    } else {
      await AppInterface()
          .getRequestedItemListById(
              searchKey: query, isSearch: true, vendorID: vendorID)
          .then((value) {
        if (value != null && value is RequestedItemListModel) {
          requestedItemList.value = value;
          requestedItemList.refresh();
        }
      });
    }
  }

  Future<void> callItemApi(String query) async {
    if (query == "") {
      getList(false, "1", false);
    } else {
      await AppInterface()
          .getRequestedItemListById(searchKey: query, isSearch: true)
          .then((value) {
        if (value != null && value is userListModel) {
          userList.value = value;
          userList.refresh();
        }
      });
    }
  }

  getList(bool moreLoading, String page, bool showLoading) async {
    if (moreLoading) {
      isMoreLoading.value = true;
    } else {
      if (showLoading == true) {
        isLoading.value = true;
      }
    }
    await AppInterface().getRequestUserList(page: page).then((value) {
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

  getItemList(
      bool moreLoading, String page, bool showLoading, String id) async {
    if (moreLoading) {
      isMoreLoading.value = true;
    } else {
      if (showLoading == true) {
        isLoading.value = true;
      }
    }
    await AppInterface()
        .getRequestedItemListById(page: page, vendorID: vendorID)
        .then((value) {
      if (value is RequestedItemListModel) {
        if (moreLoading) {
          requestedItemList.value.data!.itemsList!
              .addAll(value.data!.itemsList!);
          requestedItemList.value.data!.currentPage = value.data!.currentPage!;
          requestedItemList.value.data!.totalPages = value.data!.totalPages!;
          requestedItemList.refresh();
        } else {
          requestedItemList.value = value;
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
