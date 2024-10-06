import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jigers_kitchen/utils/widget/app_bar.dart';
import 'package:jigers_kitchen/utils/widget/app_button.dart';
import 'package:jigers_kitchen/utils/widget/appwidgets.dart';

import '../../../utils/app_colors.dart';
import '../../../utils/widget/custom_textfiled.dart';
import 'report_controller.dart';

class SelectReportDate extends StatelessWidget {
  bool? isBottomBar;
  String? chefID;
  SelectReportDate({super.key, this.isBottomBar, this.chefID});

  @override
  Widget build(BuildContext context) {
    ReportController controller = Get.put(ReportController());
    controller.chefID = chefID ?? "";
    return Scaffold(
      appBar:
          isBottomBar == true ? null : appBar(text: "Purchase Order Report"),
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
                    hintText: "Select Start Date",
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
                    hintText: "Select End Date",
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
            child: CustomButton(
                text: "SUBMIT",
                onPressed: () {
                  if (controller.startController.text == "" ||
                      controller.endController.text == "") {
                    appWidgets().showToast("Sorry", "Please select both dates");
                  } else {
                    isBottomBar == true
                        ? controller.getChefReport()
                        : controller.getReport();
                  }
                }),
          )
        ],
      ),
    );
  }
}
