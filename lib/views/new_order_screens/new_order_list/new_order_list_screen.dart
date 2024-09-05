import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jigers_kitchen/utils/widget/app_bar.dart';
import 'package:jigers_kitchen/views/new_order_screens/edit_order/edit_order_screen.dart';

import '../../../utils/app_colors.dart';
import '../../../utils/widget/delete_item_dialoug.dart';
import '../new_order_widgets.dart';

class NewOrderListScreen extends StatelessWidget {
  const NewOrderListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGreyColor,
      appBar: appBar(
        text: "New Order",
        actions: [
          Container(
            height: 35,
            width: 35,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(11),
              color: AppColors.textWhiteColor,
            ),
            child: Icon(
              Icons.more_vert,
              color: AppColors.redColor,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: ListView.builder(
            itemCount: 5,
            itemBuilder: (context, index) {
              return Card(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(13),
                  child: ExpandablePanel(
                      theme: ExpandableThemeData(
                          iconColor: AppColors.primaryColor),
                      header: Text.rich(
                          style: const TextStyle(
                              color: Colors.black, fontSize: 15),
                          TextSpan(text: 'Order No. ', children: <InlineSpan>[
                            TextSpan(
                              text: 'J01579',
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.normal,
                                  color: AppColors.primaryColor),
                            )
                          ])),
                      collapsed: const ExpandedData(),
                      expanded: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const ExpandedData(),
                          const SizedBox(
                            height: 10,
                          ),
                          Divider(
                            height: 2,
                            thickness: 2,
                            color: AppColors.dividerGreyColor,
                          ),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ItemColmn(
                                leading: "Item:",
                                desc: "Smosa",
                              ),
                              ItemColmn(
                                leading: "Qty",
                                desc: "150",
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Divider(
                            height: 2,
                            thickness: 1,
                            color: AppColors.dividerGreyColor,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          ExpandedItemColmnRow(
                            leadingText: "Item:",
                            leadingDesc: "Vegetable Biryani",
                            leadingText1: "Qty.",
                            leadingDesc1: "12",
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Divider(
                            height: 2,
                            thickness: 1,
                            color: AppColors.dividerGreyColor,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          ExpandedItemColmnRow(
                            leadingText: "Item:",
                            leadingDesc: "Butter Chicken",
                            leadingText1: "Qty.",
                            leadingDesc1: "15",
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Divider(
                            height: 2,
                            thickness: 1,
                            color: AppColors.dividerGreyColor,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Tax (0.0%)",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600),
                              ),
                              Text(
                                "0.0",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Total Amount",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600),
                              ),
                              Text(
                                "530.39",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Divider(
                            height: 2,
                            thickness: 1,
                            color: AppColors.dividerGreyColor,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              NewOrderButtonWidget(
                                ic: Icons.edit,
                                text: "Edit",
                                clr: AppColors.primaryColor,
                                ontap: () {
                                  Get.to(() => const EditOrderScreen());
                                },
                              ),
                              NewOrderButtonWidget(
                                ic: Icons.delete,
                                text: "Delete",
                                ontap: () {
                                  showDeleteItemDialoug(
                                      context: context,
                                      description:
                                          "Are you sure you want to DELETE the order?");
                                },
                                clr: AppColors.redColor,
                              ),
                              NewOrderButtonWidget(
                                ic: Icons.receipt,
                                text: "Invoice",
                                ontap: () {},
                                clr: AppColors.orangeColor,
                              ),
                            ],
                          ),
                        ],
                      )),
                ),
              );
            }),
      ),
    );
  }
}
