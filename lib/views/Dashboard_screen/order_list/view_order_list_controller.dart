import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/apis/app_interface.dart';
import '../../../model/order_list_model.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_images.dart';
import '../../../utils/helper.dart';
import '../../../utils/widget/app_button.dart';
import '../../../utils/widget/appwidgets.dart';
import '../../../utils/widget/custom_textfiled.dart';
import '../../../utils/widget/success_dialoug.dart';
import '../dashboard_controller.dart';

class ORderListController extends GetxController {
  TextEditingController textController = TextEditingController();
  TextEditingController orderNotesController = TextEditingController();
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
  void chnageOrderNotes({
    BuildContext? context,
    String? orderId,
    String? intitalNotes,
    VoidCallback? onBtnTap,
    TextStyle? headingStyle = const TextStyle(
        fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black),
    TextStyle? textStyle = const TextStyle(
        fontSize: 13, fontWeight: FontWeight.normal, color: Colors.black),
    String? btnText,
  }) {
    final GlobalKey<FormState> key = GlobalKey();
    orderNotesController.text = intitalNotes ?? "";
    showDialog(
      barrierColor: AppColors.primaryColor.withOpacity(0.6),
      context: context!,
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
            child: Form(
              key: key,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Edit Order Notes",
                        textAlign: TextAlign.center,
                        style: headingStyle,
                      ),
                      const SizedBox(height: 8.0),
                      const Align(
                        alignment: Alignment.bottomLeft,
                        child: Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          child: Text(
                            "Order Notes",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CustomTextField(
                          maxLines: 20,
                          controller: orderNotesController,
                          validator: Helper.noValidation,
                          keyboardType: TextInputType.text,
                          fillColor: AppColors.textWhiteColor,
                          hintText: "Order Notes",
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5.0),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CustomButton(
                      text: "SUBMIT",
                      onPressed: () {
                        Get.back();
                        editSelectedOrderNotes(orderId!);
                      },
                      padding: 10,
                    ),
                  ),
                  const SizedBox(height: 35.0),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  editSelectedOrderNotes(String orderId) async {
    appWidgets.loadingDialog();
    await AppInterface()
        .editOrderNotes(
      orderId: orderId.toString(),
      itemNotes: orderNotesController.text,
    )
        .then((value) {
      textController.clear();
      appWidgets.hideDialog();
      if (value == 200) {
        getOrder(
          false,
          "1",
          false,
          false,
          "",
        );
        showDialogWithAutoDismiss(
            context: Get.context,
            doubleBack: false,
            img: AppImages.successDialougIcon,
            autoDismiss: true,
            heading: "Hurray!",
            text: "Notes Updated Successfully",
            headingStyle: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w600,
                color: AppColors.textBlackColor));
      }
    });
  }

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
