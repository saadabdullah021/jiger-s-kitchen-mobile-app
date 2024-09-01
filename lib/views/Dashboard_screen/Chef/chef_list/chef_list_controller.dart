import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jigers_kitchen/core/apis/app_interface.dart';
import 'package:jigers_kitchen/model/user_list_model.dart';
import 'package:jigers_kitchen/utils/widget/appwidgets.dart';

class ChefListController extends GetxController {
  TextEditingController textController = TextEditingController();
  ScrollController scrollController = ScrollController();

  RxBool isLoading = false.obs;
  RxBool isMoreLoading = false.obs;
  @override
  void onInit() {
    scrollController = ScrollController()..addListener(_scrollListener);
    super.onInit();
  }

  Future<void> _scrollListener() async {
    print(scrollController.position.extentAfter);
    if (scrollController.position.extentAfter < 5) {}
  }

  Rx<userListModel> userList = userListModel().obs;
  getChef(bool moreLoading, String page) async {
    if (moreLoading) {
      isMoreLoading.value = true;
    } else {
      isLoading.value = true;
    }
    await AppInterface().getUserList(role: "chef", page: page).then((value) {
      if (value is userListModel) {
        if (moreLoading) {
          userList.value.data!.chefList!.addAll(value.data!.chefList!);
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
