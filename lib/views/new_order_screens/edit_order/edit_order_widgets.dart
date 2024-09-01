import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/app_colors.dart';
import '../../../utils/widget/app_button.dart';
import '../../../utils/widget/custom_textfiled.dart';

Widget ItemRow({
  required String leftText,
  required String rightText,
}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        leftText,
        style: TextStyle(fontSize: 15, color: AppColors.newOrderGrey),
        softWrap: true,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      Text(
        rightText,
        softWrap: true,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 15,
            color: AppColors.textBlackColor),
      ),
    ],
  );
}

void showBottomSheet(BuildContext context) {
  showModalBottomSheet(
    backgroundColor: Colors.transparent,
    barrierColor: AppColors.primaryColor.withOpacity(0.6),
    context: context,
    isScrollControlled: true,
    builder: (BuildContext context) {
      return const BottomSheetWithTabs();
    },
  );
}

class BottomSheetWithTabs extends StatelessWidget {
  const BottomSheetWithTabs({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController textController = TextEditingController();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 13),
      child: Material(
        borderRadius: BorderRadius.circular(14),
        color: Colors.white,
        child: SizedBox(
          height: Get.height * 0.51,
          child: DefaultTabController(
            length: 3,
            child: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                Text(
                  "Select Product",
                  style: TextStyle(
                      color: AppColors.textBlackColor,
                      fontSize: 18,
                      fontWeight: FontWeight.w600),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CustomTextField(
                      fillColor: AppColors.lightGreyColor,
                      controller: textController,
                      prefixIcon: const Icon(Icons.search),
                      hintText: "Search"),
                ),
                Container(
                  color: Colors.white,
                  child: TabBar(
                    dividerHeight: 0,
                    indicatorWeight: 4,
                    tabs: const [
                      Tab(text: 'Appetizer'),
                      Tab(text: 'Main Courses '),
                      Tab(text: 'Desserts'),
                    ],
                    labelColor: AppColors.primaryColor,
                    indicatorColor: AppColors.primaryColor,
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 13),
                    child: TabBarView(
                      children: [
                        Column(
                          children: [
                            customAddItemRow(
                              title: 'Marinated Halal Chicken',
                              subtitle: '20 LBS Case',
                              buttonLabel: 'Add',
                              leftIcon: null,
                              rightIcon: Icons.add,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Divider(
                              color: AppColors.dividerGreyColor,
                              height: 1,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            customAddItemRow(
                              title: 'Marinated Paneer',
                              subtitle: '16 LBS Case',
                              buttonLabel: '2',
                              leftIcon: Icons.remove,
                              rightIcon: Icons.add,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Divider(
                              color: AppColors.dividerGreyColor,
                              height: 1,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            customAddItemRow(
                              title: 'Tikka Masala Sauce',
                              subtitle: '20 LBS Case',
                              buttonLabel: 'Add',
                              leftIcon: null,
                              rightIcon: Icons.add,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            CustomButton(
                              padding: 10,
                              text: "Add Item",
                              onPressed: () {},
                            ),
                          ],
                        ),
                        const Center(child: Text('Content for Tab 2')),
                        const Center(child: Text('Content for Tab 3')),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget customAddItemRow({
  required String title,
  required String subtitle,
  required String buttonLabel,
  required IconData? leftIcon,
  required IconData rightIcon,
}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.black, // Replace with AppColors.textBlackColor
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            subtitle,
            style: const TextStyle(
              color: Colors.grey, // Replace with AppColors.newOrderGrey
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
      Container(
        height: 30,
        width: 90,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(7),
          border: Border.all(
            width: 1,
            color: Colors.grey, // Replace with AppColors.newOrderGrey
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            leftIcon == null
                ? const SizedBox()
                : Icon(
                    leftIcon,
                    size: 18,
                    color: Colors.grey, // Replace with AppColors.textBlackColor
                  ),
            Text(
              buttonLabel,
              style: const TextStyle(
                fontSize: 13,
                color: Colors.black, // Replace with AppColors.textBlackColor
                fontWeight: FontWeight.w600,
              ),
            ),
            Icon(
              rightIcon,
              size: 18,
              color: Colors.grey, // Replace with AppColors.textBlackColor
            ),
          ],
        ),
      ),
    ],
  );
}
