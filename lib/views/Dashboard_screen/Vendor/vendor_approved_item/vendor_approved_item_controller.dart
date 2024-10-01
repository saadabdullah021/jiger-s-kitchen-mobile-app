import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../../../core/apis/app_interface.dart';
import '../../../../model/get_vemdor_approved_item.dart';
import '../../../../model/user_list_model.dart';
import '../../../../utils/widget/appwidgets.dart';

class vendorApprovedController extends GetxController {
  TextEditingController textController = TextEditingController();
  TextEditingController itemtextController = TextEditingController();

  RxBool isLoading = false.obs;
  RxBool isMoreLoading = false.obs;
  String? vendorID;
  Rx<userListModel> userList = userListModel().obs;
  Rx<GetVendorApprovedItemModel> requestedItemList =
      GetVendorApprovedItemModel().obs;
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

  Future<void> callApi(String query) async {
    if (query == "") {
      getItemList(false, "1", false);
    } else {
      await AppInterface()
          .getVendorApprovedItem(
              searchKey: query, isSearch: true, vendorId: vendorID!)
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
      getItemList(
        false,
        "1",
        false,
      );
    } else {
      await AppInterface()
          .getVendorApprovedItem(
              searchKey: query, isSearch: true, vendorId: vendorID!)
          .then((value) {
        if (value != null && value is GetVendorApprovedItemModel) {
          requestedItemList.value = value;
          requestedItemList.refresh();
        }
      });
    }
  }

  // getList(bool moreLoading, String page, bool showLoading) async {
  //   if (moreLoading) {
  //     isMoreLoading.value = true;
  //   } else {
  //     if (showLoading == true) {
  //       isLoading.value = true;
  //     }
  //   }
  //   await AppInterface()
  //       .getVendorApprovedItem(page: page, vendorId: vendorID!)
  //       .then((value) {
  //     if (value is userListModel) {
  //       if (moreLoading) {
  //         userList.value.data!.chefList!.addAll(value.data!.chefList!);
  //         userList.value.data!.currentPage = value.data!.currentPage!;
  //         userList.value.data!.totalPages = value.data!.totalPages!;
  //         userList.refresh();
  //       } else {
  //         userList.value = value;
  //       }
  //       if (moreLoading) {
  //         isMoreLoading.value = false;
  //       } else {
  //         isLoading.value = false;
  //       }
  //     } else {
  //       appWidgets().showToast("Sorry", "Please try again");
  //     }
  //   });
  // }

  getItemList(
    bool moreLoading,
    String page,
    bool showLoading,
  ) async {
    if (moreLoading) {
      isMoreLoading.value = true;
    } else {
      if (showLoading == true) {
        isLoading.value = true;
      }
    }
    await AppInterface()
        .getVendorApprovedItem(
      page: page,
      vendorId: vendorID!,
      isSearch: false,
    )
        .then((value) {
      if (value is GetVendorApprovedItemModel) {
        if (moreLoading) {
          requestedItemList.value.data!.itemsList!
              .addAll(value.data!.itemsList!);
          requestedItemList.value.data!.currentPage = value.data!.currentPage!;
          requestedItemList.value.data!.totalPages = value.data!.totalPages!;
          requestedItemList.refresh();
        } else {
          requestedItemList.value = value;
          requestedItemList.refresh();
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
