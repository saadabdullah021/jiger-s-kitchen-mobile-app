import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jigers_kitchen/core/apis/app_interface.dart';
import 'package:jigers_kitchen/model/user_list_model.dart';
import 'package:jigers_kitchen/utils/widget/appwidgets.dart';

import '../../../utils/app_colors.dart';
import '../chef_and_delivery_boy/chef_list/chef_list_controller.dart';
import '../reports/select_date.dart';

class AdminController extends GetxController {
  TextEditingController textController = TextEditingController();
  String? selectedAdminId;
  RxBool isLoading = false.obs;
  RxBool isMoreLoading = false.obs;
  Timer? _debounce;
  String role = "subadmin";
  Rx<userListModel> userList = userListModel().obs;
  void onTextChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(seconds: 1), () {
      callApi(textController.text);
    });
  }

  Future<void> pullRefresh() async {
    getUser(false, "1", true);
  }

  Future<void> callApi(String query) async {
    if (query == "") {
      getUser(false, "1", false);
    } else {
      await AppInterface().searchUser(role: role, query: query).then((value) {
        if (value != null && value is userListModel) {
          userList.value = value;
          userList.refresh();
        }
      });
    }
  }
Future<void> showCustomBottomSheet(
      BuildContext context, String userType) async {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      barrierColor: AppColors.primaryColor.withOpacity(0.6),
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return BottomSheetWithTabs(
          Usertype: userType,
        );
      },
    );
  }
  getUser(
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
    await AppInterface().getUserList(role: role, page: page).then((value) {
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

class BottomSheetWithTabs extends StatelessWidget {
  AdminController controller = Get.find();
  String? Usertype;
  BottomSheetWithTabs({super.key, this.Usertype});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Material(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
          child: SizedBox(
              height: Get.height * 0.4,
              child: SelectReportDate(
                userType: Usertype,
                isBottomBar: true,
                chefID: controller.selectedAdminId,
              ))),
    );
  }
}
