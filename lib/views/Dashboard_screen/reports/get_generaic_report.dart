import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/app_colors.dart';
import '../../../utils/widget/app_bar.dart';
import '../../../utils/widget/app_button.dart';
import '../../../utils/widget/appwidgets.dart';
import '../../../utils/widget/custom_textfiled.dart';
import 'report_controller.dart';

class SelectGenraicReportDate extends StatelessWidget {
  const SelectGenraicReportDate({super.key});

  @override
  Widget build(BuildContext context) {
    ReportController controller = Get.put(ReportController());
    controller.startController.clear();
    controller.endController.clear();
    return Scaffold(
      appBar: appBar(text: "Report"),
      body: Column(
        children: [
          const SizedBox(
            height: 40,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    suffixIcon: Icon(
                      Icons.calendar_month,
                      color: AppColors.greyColor,
                    ),
                    maxLines: 1,
                    readOnly: true,
                    ontap: () {
                      controller.showDatePickerOnly(true);
                    },
                    controller: controller.startController,
                    fillColor: AppColors.textGreyColor,
                    hintText: "Start Date",
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: CustomTextField(
                    suffixIcon: Icon(
                      Icons.calendar_month,
                      color: AppColors.greyColor,
                    ),
                    maxLines: 1,
                    readOnly: true,
                    ontap: () {
                      controller.showDatePickerOnly(false);
                    },
                    controller: controller.endController,
                    fillColor: AppColors.textGreyColor,
                    hintText: "End Date",
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Obx(
              () => DropdownButton<String>(
                hint: const Text(
                  'Select an option',
                  style: TextStyle(color: Colors.grey),
                ),
                value: controller.SelectedOrderReportType.value,
                isExpanded: true,
                underline: const SizedBox(), // Removes the underline
                onChanged: (String? newValue) {
                  controller.SelectedOrderReportType.value = newValue!;
                },
                items: controller.items
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: const TextStyle(fontSize: 12, color: Colors.black),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: CustomButton(
                text: "SUBMIT",
                onPressed: () {
                  if (controller.startController.text == "" ||
                      controller.endController.text == "") {
                    appWidgets().showToast("Sorry", "Please select both dates");
                  } else {
                    controller.SelectedOrderReportType.value !=
                            "CUSTOMER REPORT"
                        ? controller.getGeneraicReport(null)
                        : controller.showCustomBottomSheet(context);
                  }
                }),
          )
        ],
      ),
    );
  }
}
