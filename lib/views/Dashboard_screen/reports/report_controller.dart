import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:jigers_kitchen/core/apis/app_interface.dart';
import 'package:jigers_kitchen/utils/widget/appwidgets.dart';
import 'package:jigers_kitchen/views/Dashboard_screen/invoice/invoice_with_link.dart';

class ReportController extends GetxController {
  TextEditingController startController = TextEditingController();
  TextEditingController endController = TextEditingController();
  String chefID = "";
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
