import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../core/apis/app_interface.dart';
import '../../../model/order_list_model.dart';
import '../../../model/user_list_model.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_images.dart';
import '../../../utils/widget/app_button.dart';
import '../../../utils/widget/appwidgets.dart';
import '../../../utils/widget/custom_textfiled.dart';
import '../../../utils/widget/delete_item_dialoug.dart';
import '../../../utils/widget/success_dialoug.dart';
import '../../Dashboard_screen/chef_and_delivery_boy/chef_list/chef_list_screen.dart';
import '../../Dashboard_screen/dashboard_controller.dart';

class newORderListController extends GetxController {
  TextEditingController textController = TextEditingController();
  DashboardController dashboardController = Get.find();
  RxBool isLoading = false.obs;
  RxBool isAllCompleted = false.obs;
  RxBool isMoreLoading = false.obs;
  Rx<OrderListModel> orderList = OrderListModel().obs;
  Rx<OrdersList> selectedOrder = OrdersList().obs;
  int? selectedItemIndex;
  Timer? _debounce;
  checkAllStatus() {
    bool isCompleted = false;
    for (int i = 0; i < selectedOrder.value.ordersItems!.length; i++) {
      if (selectedOrder.value.ordersItems![i].chefStatus == "completed") {
        isCompleted = true;
      } else {
        isCompleted = false;
        return;
      }
      isAllCompleted.value = isCompleted;
    }
  }

  void onTextChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(seconds: 1), () {
      callApi(textController.text);
    });
  }

  Future<void> showCustomBottomSheet(BuildContext context, String? type) async {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      barrierColor: AppColors.primaryColor.withOpacity(0.6),
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return OpenChefBottomSheet(
          type: type,
        );
      },
    );
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

  deleteOrder(OrdersList data, BuildContext context) async {
    showDeleteItemDialoug(
        description: "Are you sure you want to DELETE the Order?",
        context: context,
        url: data.ordersItems![0].menuItemInfo!.profileImage!,
        onYes: () async {
          Get.back();
          appWidgets.loadingDialog();

          await AppInterface()
              .deleteOrder(id: data.id!.toString())
              .then((value) {
            if (value == 200) {
              appWidgets.hideDialog();
              getOrder(false, "1", false, false, "");
              showDialogWithAutoDismiss(
                  context: Get.context,
                  doubleBack: false,
                  img: AppImages.successDialougIcon,
                  autoDismiss: true,
                  heading: "Hurray!",
                  text: "Order Deleted Successfully",
                  headingStyle: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textBlackColor));
              dashboardController.getCount();
            }
          });
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
        .getOrderList(
            page: page,
            isSearch: isSearching,
            searchKey: searchKeyWord,
            status: "new_order")
        .then((value) {
      if (value is OrderListModel) {
        if (moreLoading) {
          orderList.value.data!.ordersList!.addAll(value.data!.ordersList!);
          orderList.value.data!.currentPage = value.data!.currentPage!;
          orderList.value.data!.totalPages = value.data!.totalPages!;
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

  ChefList? Selectedchef;
  TextEditingController preprationDate = TextEditingController();
  void addTimeDialog({
    String? heading,
    String? text,
    VoidCallback? onBtnTap,
    TextStyle? headingStyle = const TextStyle(
        fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black),
    TextStyle? textStyle = const TextStyle(
        fontSize: 13, fontWeight: FontWeight.normal, color: Colors.black),
    String? btnText,
  }) {
    showDialog(
      barrierColor: AppColors.primaryColor.withOpacity(0.6),
      context: Get.context!,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: const EdgeInsets.symmetric(
              horizontal: 20), // Adjust horizontal padding here
          child: Container(
            width: double.infinity, // Full width of the screen
            decoration: BoxDecoration(
              color: AppColors.dialougBG,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 5.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      heading!,
                      textAlign: TextAlign.center,
                      style: headingStyle,
                    ),
                    const SizedBox(height: 8.0),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CustomTextField(
                        maxLines: 1,
                        readOnly: true,
                        ontap: () {
                          showTImePicker();
                        },
                        controller: preprationDate,
                        fillColor: AppColors.textWhiteColor,
                        hintText: "Select Preparation Date",
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5.0),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CustomButton(
                    text: "Assign",
                    onPressed: () async {
                      if (preprationDate.text == "") {
                        appWidgets().showToast("Sorry", "Please Select a date");
                      } else {
                        Get.back();
                        appWidgets.loadingDialog();
                        await AppInterface()
                            .assignOrderToChef(
                                chefId: Selectedchef!.id!.toString(),
                                date: preprationDate.text,
                                orderID: selectedOrder.value.id!.toString(),
                                itemId: selectedOrder.value
                                    .ordersItems![selectedItemIndex!].itemId!
                                    .toString())
                            .then((value) {
                          if (value == 200) {
                            selectedOrder.value.ordersItems![selectedItemIndex!]
                                .chefId = Selectedchef!.id;
                            selectedOrder.refresh();
                            appWidgets.hideDialog;
                            showDialogWithAutoDismiss(
                                context: Get.context,
                                doubleBack: true,
                                img: AppImages.successDialougIcon,
                                autoDismiss: true,
                                heading: "Hurray!",
                                text: "Item Assigned Successfully",
                                headingStyle: TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textBlackColor));
                          }
                        });
                      }
                    },
                    padding: 10,
                  ),
                ),
                const SizedBox(height: 35.0),
              ],
            ),
          ),
        );
      },
    );
  }

  void _onChefSelected(ChefList chef) {
    Get.back();
    print('Selected chef: ${chef.name}');
    Selectedchef = chef;
    preprationDate.text = "";
    addTimeDialog(
        heading: "Set Preparation Date",
        headingStyle: TextStyle(color: AppColors.greyColor));
  }

  Future<void> _onDeliverSelected(ChefList chef) async {
    Get.back();
    appWidgets.loadingDialog();
    await AppInterface()
        .assignOrderToDeliveryUSer(
            orderID: selectedOrder.value.id.toString(),
            deliveryUserId: chef.id.toString())
        .then((value) {
      if (value == 200) {
        appWidgets.hideDialog;
        Get.back();
        getOrder(false, "1", false, false, "");
        showDialogWithAutoDismiss(
            context: Get.context,
            doubleBack: true,
            img: AppImages.successDialougIcon,
            autoDismiss: true,
            heading: "Hurray!",
            text: "Item Assigned Successfully",
            headingStyle: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w600,
                color: AppColors.textBlackColor));
      }
    });

    print('Selected BOY: ${chef.name}');
  }

  showTImePicker() {
    showDatePicker(
      context: Get.context!,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    ).then((selectedDate) {
      // After selecting the date, display the time picker.
      if (selectedDate != null) {
        showTimePicker(
          context: Get.context!,
          initialTime: TimeOfDay.now(),
        ).then((selectedTime) {
          // Handle the selected date and time here.
          if (selectedTime != null) {
            DateTime selectedDateTime = DateTime(
              selectedDate.year,
              selectedDate.month,
              selectedDate.day,
              selectedTime.hour,
              selectedTime.minute,
            );
            String formattedDateTime =
                DateFormat('yyyy-MM-ddhh:mm a').format(selectedDateTime);
            preprationDate.text = formattedDateTime;
          }
        });
      }
    });
  }
}

class OpenChefBottomSheet extends StatelessWidget {
  String? type;
  OpenChefBottomSheet({
    this.type,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    newORderListController controller = Get.find();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Material(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
          child: SizedBox(
              height: Get.height * 0.7,
              child: AllChefListScreen(
                type: type,
                onChefSelected: type != null
                    ? controller._onDeliverSelected
                    : controller._onChefSelected,
                isBottombar: true,
              ))),
    );
  }
}
