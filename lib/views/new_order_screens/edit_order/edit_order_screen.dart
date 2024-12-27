import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:jigers_kitchen/utils/app_colors.dart';
import 'package:jigers_kitchen/utils/widget/app_bar.dart';

import '../../../utils/app_images.dart';
import '../../../utils/widget/app_button.dart';
import '../../Dashboard_screen/Menu/menu_list/menu_list.dart';
import '../../Dashboard_screen/Vendor/vendor_approved_item/vendor_approved_item_controller.dart';
import '../new_order_list/new_order_list_controller.dart';
import '../new_order_widgets.dart';

class EditOrderScreen extends StatefulWidget {
  String? orderID;
  EditOrderScreen({super.key, this.orderID});

  @override
  State<EditOrderScreen> createState() => _EditOrderScreenState();
}

class _EditOrderScreenState extends State<EditOrderScreen> {
  newORderListController controller = Get.find();
  @override
  void initState() {
    controller.EditorderID = widget.orderID!;
    controller.getEditOrder(true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGreyColor,
      appBar: appBar(text: "Edit Order"),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
        child: Obx(
          () => controller.isEditOrderLoading.isTrue
              ? Center(
                  child: CircularProgressIndicator(
                    color: AppColors.appColor,
                  ),
                )
              : ListView(
                  children: [
                    Card(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Order NO.",
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: AppColors.newOrderGrey,
                                      ),
                                    ),
                                    Text(
                                      controller.editOrderDetail.value.data!
                                              .orderIdentifier ??
                                          "",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.primaryColor,
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Row(
                                      children: [
                                        SvgPicture.asset(
                                          AppImages.clock,
                                          height: 15,
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          controller.editOrderDetail.value.data!
                                                  .orderCreatedAt!
                                                  .split(" ")[0] ??
                                              "",
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: AppColors.newOrderGrey),
                                          softWrap: true,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                    Align(
                                      alignment: Alignment.bottomRight,
                                      child: Text(
                                        controller.editOrderDetail.value.data!
                                                .orderCreatedAt!
                                                .split(" ")[1] ??
                                            "",
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: AppColors.newOrderGrey),
                                        softWrap: true,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            DottedDivider(
                              height: 2.0,
                              color: AppColors.newOrderGrey,
                              dotSize: 2.0,
                              dotSpacing: 3.0,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            for (int i = 0;
                                i <
                                    controller.editOrderDetail.value.data!
                                        .ordersItems!.length;
                                i++) ...{
                              const SizedBox(
                                height: 10,
                              ),
                              ItemRow(
                                  leftText: "Item:",
                                  rightText: controller
                                          .editOrderDetail
                                          .value
                                          .data!
                                          .ordersItems![i]
                                          .menuItemInfo!
                                          .itemName ??
                                      ""),
                              const SizedBox(
                                height: 10,
                              ),
                              ItemRow(
                                  leftText: "Qty:",
                                  rightText: controller
                                          .editOrderDetail
                                          .value
                                          .data!
                                          .ordersItems![i]
                                          .itemQuantity! ??
                                      ""),
                              const SizedBox(
                                height: 10,
                              ),
                              ItemRow(
                                  leftText: "Price",
                                  rightText: controller
                                          .editOrderDetail
                                          .value
                                          .data!
                                          .ordersItems![i]
                                          .itemBasePrice! ??
                                      ""),
                              const SizedBox(
                                height: 10,
                              ),
                              if (controller.editOrderDetail.value.data!
                                      .ordersItems![i].itemNote !=
                                  "")
                                ItemRow(
                                    leftText: "Item Notes",
                                    rightText:
                                        // "hdjsfghads fajsdhf asdhj jaghsdjka sgdkajs dagjksd ajksdgajksdga "
                                        controller.editOrderDetail.value.data!
                                                .ordersItems![i].itemNote! ??
                                            ""),
                              const SizedBox(
                                height: 20,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  NewOrderButtonWidget(
                                    text: "Edit",
                                    clr: AppColors.primaryColor,
                                    ic: Icons.edit,
                                    ontap: () {
                                      controller.selectedOrderItem = controller
                                          .editOrderDetail
                                          .value
                                          .data!
                                          .ordersItems![i];
                                      controller.PriceController.text =
                                          controller.editOrderDetail.value.data!
                                              .ordersItems![i].itemBasePrice!
                                              .toString();
                                      controller.quantityController.text =
                                          controller.editOrderDetail.value.data!
                                              .ordersItems![i].itemQuantity!
                                              .toString();
                                      controller.notesController.text =
                                          controller.editOrderDetail.value.data!
                                              .ordersItems![i].itemNote!
                                              .toString();
                                      controller.chnagePriceAndQty(
                                        context: context,
                                        onBtnTap: () {},
                                      );
                                    },
                                  ),
                                ],
                              ),
                              DottedDivider(
                                height: 2.0,
                                color: AppColors.newOrderGrey,
                                dotSize: 2.0,
                                dotSpacing: 3.0,
                              ),
                            },
                            const SizedBox(
                              height: 20,
                            ),
                            ItemRow(
                                leftText: "Total Amount:",
                                rightText: controller
                                    .editOrderDetail.value.data!.totalAmount!),
                            const SizedBox(
                              height: 20,
                            ),
                            Visibility(
                              visible: controller
                                      .editOrderDetail.value.data!.orderNote !=
                                  null,
                              child: ItemRow(
                                  leftText: "Order Notes:", rightText: ""),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              controller
                                      .editOrderDetail.value.data!.orderNote ??
                                  "",
                              softWrap: true,
                              textAlign: TextAlign.start,
                              maxLines: 10,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15,
                                  color: AppColors.textBlackColor),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const SizedBox(),
                                NewOrderButtonWidget(
                                  text: "Edit Order Notes",
                                  clr: AppColors.primaryColor,
                                  ic: Icons.edit,
                                  ontap: () {
                                    controller.orderNotesController.text =
                                        controller.editOrderDetail.value.data!
                                            .orderNote
                                            .toString();
                                    controller.chnageOrderNotes(
                                      context: context,
                                      onBtnTap: () {},
                                    );
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    CustomButton(
                      padding: 10,
                      text: "Update Order",
                      onPressed: () {},
                    ),
                  ],
                ),
        ),
      ),
      floatingActionButton: InkWell(
        onTap: () {
          showCustomBottomSheet(context, null, false);
        },
        child: CircleAvatar(
          backgroundColor: AppColors.redColor,
          radius: 25,
          child: Icon(
            Icons.add,
            color: AppColors.textWhiteColor,
            size: 30,
          ),
        ),
      ),
    );
  }
}

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
      Flexible(
        child: Text(
          rightText,
          softWrap: true,
          textAlign: TextAlign.right,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 15,
              color: AppColors.textBlackColor),
        ),
      ),
    ],
  );
}

void _onSelected(
  bool value,
) {
  vendorApprovedController controller = Get.find();
  controller.getItemList(false, "1", false);
}

Future<void> showCustomBottomSheet(
  BuildContext context,
  String? vednorID,
  bool? isVendor,
) async {
  showModalBottomSheet(
    backgroundColor: Colors.transparent,
    barrierColor: AppColors.primaryColor.withOpacity(0.6),
    context: context,
    isScrollControlled: true,
    builder: (BuildContext context) {
      return BottomSheetWithTabs(
        vendorId: vednorID,
      );
    },
  );
}

class BottomSheetWithTabs extends StatelessWidget {
  String? vendorId;
  BottomSheetWithTabs({super.key, this.vendorId});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Material(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
          child: SizedBox(
              height: Get.height * 0.7,
              child: MenuListScreen(
                onCompleted: vendorId != null ? _onSelected : null,
                isBottomBar: true,
                vendorId: vendorId,
                screenType: "edit_item",
              ))),
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
