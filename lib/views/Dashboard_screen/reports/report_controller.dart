import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:jigers_kitchen/core/apis/app_interface.dart';
import 'package:jigers_kitchen/utils/widget/appwidgets.dart';
import 'package:jigers_kitchen/views/Dashboard_screen/invoice/invoice_with_link.dart';

import '../../../model/user_list_model.dart';
import '../../../utils/app_colors.dart';
import '../Vendor/all_vendor_screen.dart';

class ReportController extends GetxController {
  TextEditingController startController = TextEditingController();
  TextEditingController endController = TextEditingController();
  String chefID = "";
  RxString SelectedOrderReportType = "ITEM SUMMARY".obs;
  final List<String> items = [
    'CUSTOMER REPORT',
    'ITEM SUMMARY',
    'DATE RANGE SALES REPORT',
  ];
  void showDatePickerOnly(bool isStart) {
    showDatePicker(
      context: Get.context!,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2101),
    ).then((selectedDate) {
      // Handle the selected date here.
      if (selectedDate != null) {
        String formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);
        isStart
            ? startController.text = formattedDate
            : endController.text = formattedDate;
      }
    });
  }

  Future<void> _onChefSelected(ChefList chef) async {
    Get.back();
    getGeneraicReport(chef.id.toString());
  }

  getGeneraicReport(String? chefId) async {
    appWidgets.loadingDialog();
    await AppInterface()
        .getGeneraicInvoiceLink(startController.text, endController.text,
            chefId, SelectedOrderReportType.value)
        .then((value) {
      appWidgets.hideDialog();
      if (value is String) {
        Get.to(InvoiceWithScreen(url: value));
      }
    });
  }

  getChefReport() async {
    appWidgets.loadingDialog();
    await AppInterface()
        .getChefInvoiceLink(startController.text, endController.text, chefID)
        .then((value) {
      appWidgets.hideDialog();
      if (value is String) {
        Get.to(InvoiceWithScreen(url: value));
      }
    });
  }

  Future<void> showCustomBottomSheet(
    BuildContext context,
  ) async {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      barrierColor: AppColors.primaryColor.withOpacity(0.6),
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return const OpenChefBottomSheet();
      },
    );
  }

  getReport() async {
    appWidgets.loadingDialog();
    await AppInterface()
        .getInvoiceLink(startController.text, endController.text)
        .then((value) {
      appWidgets.hideDialog();
      if (value is String) {
        Get.to(InvoiceWithScreen(url: value));
      }
    });
  }
}

class OpenChefBottomSheet extends StatelessWidget {
  const OpenChefBottomSheet({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    ReportController controller = Get.find();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Material(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
          child: SizedBox(
              height: Get.height * 0.7,
              child: AllVendorListScreen(
                onChefSelected: controller._onChefSelected,
                isBottomSheet: true,
              ))),
    );
  }
}
