import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jigers_kitchen/utils/app_colors.dart';
import 'package:jigers_kitchen/utils/app_keys.dart';
import 'package:jigers_kitchen/utils/helper.dart';
import 'package:jigers_kitchen/utils/widget/app_bar.dart';
import 'package:jigers_kitchen/utils/widget/app_button.dart';
import 'package:rotated_corner_decoration/rotated_corner_decoration.dart';

import '../../../core/contstants.dart';
import '../../../model/order_list_model.dart';
import '../edit_order/edit_order_screen.dart';
import 'new_order_list_controller.dart';

class AssignOrder extends StatefulWidget {
  OrdersList orderData;
  AssignOrder({super.key, required this.orderData});

  @override
  State<AssignOrder> createState() => _AssignOrderState();
}

class _AssignOrderState extends State<AssignOrder> {
  final newORderListController _controller = Get.find();
  @override
  void initState() {
    // TODO: implement initState

    _controller.selectedOrder.value = widget.orderData;
    _controller.checkAllStatus();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(text: "Jigar's Kitchen"),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _controller.selectedOrder.value.orderIdentifier!,
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryColor),
                ),
                Text(_controller.selectedOrder.value.orderCreatedAt!),
                Container(
                  width: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: AppColors.primaryColor,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Center(
                      child: Text(
                        Helper.capitalizeFirstLetter(
                          _controller.selectedOrder.value.orderStatus
                              .toString()
                              .replaceAll("_", " "),
                        ).toUpperCase(),
                        style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textWhiteColor),
                      ),
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: Obx(
                () => ListView.separated(
                    separatorBuilder: (context, index) {
                      return const SizedBox(
                        height: 10,
                      );
                    },
                    itemCount:
                        _controller.selectedOrder.value.ordersItems!.length,
                    itemBuilder: (context, index) {
                      return Card(
                        elevation: 1,
                        child: Container(
                          foregroundDecoration:
                              RotatedCornerDecoration.withColor(
                            color: _controller.selectedOrder.value
                                        .ordersItems![index].chefId ==
                                    null
                                ? AppColors.redColor
                                : AppColors.appColor,
                            badgeSize: const Size(64, 64),
                            textSpan: TextSpan(
                              text: _controller.selectedOrder.value
                                          .ordersItems![index].chefId ==
                                      null
                                  ? "Not Assigned"
                                  : "Assigned",
                              style: const TextStyle(
                                  fontSize: 10, fontWeight: FontWeight.w600),
                            ),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 20),
                          decoration: BoxDecoration(
                              color: AppColors.textWhiteColor,
                              // border: Border.all(
                              //     width: 1, color: AppColors.newOrderGrey),
                              borderRadius: BorderRadius.circular(2)),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 40,
                                backgroundImage: NetworkImage(Constants.webUrl +
                                    _controller
                                        .selectedOrder
                                        .value
                                        .ordersItems![index]
                                        .menuItemInfo!
                                        .profileImage!),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _controller
                                              .selectedOrder
                                              .value
                                              .ordersItems![index]
                                              .menuItemInfo!
                                              .itemName ??
                                          "",
                                      style: TextStyle(
                                          color: AppColors.appColor,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 17),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    ItemRow(
                                        leftText: "Quantity",
                                        rightText: double.parse(_controller
                                                .selectedOrder
                                                .value
                                                .ordersItems![index]
                                                .itemQuantity
                                                .toString())
                                            .toStringAsFixed(1)),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Visibility(
                                      visible: _controller.selectedOrder.value
                                              .ordersItems![index].chefId !=
                                          null,
                                      child: ItemRow(
                                        leftText: "Chef Name",
                                        rightText: Helper.capitalizeFirstLetter(
                                            _controller
                                                    .selectedOrder
                                                    .value
                                                    .ordersItems![index]
                                                    .chefName ??
                                                ""
                                                    .replaceAll("_", " ")
                                                    .toUpperCase()),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Visibility(
                                      visible: _controller.selectedOrder.value
                                              .ordersItems![index].chefId !=
                                          null,
                                      child: ItemRow(
                                        leftText: "Chef Status",
                                        rightText: Helper.capitalizeFirstLetter(
                                            _controller.selectedOrder.value
                                                .ordersItems![index].chefStatus!
                                                .replaceAll("_", " ")
                                                .toUpperCase()),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Visibility(
                                      visible: _controller.selectedOrder.value
                                              .ordersItems![index].chefId ==
                                          null,
                                      child: CustomButton(
                                          padding: 8,
                                          text: "Assign to chef",
                                          onPressed: () {
                                            _controller.selectedItemIndex =
                                                index;
                                            _controller.showCustomBottomSheet(
                                                context, null);
                                          }),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    }),
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: Obx(
        () => Visibility(
            visible: _controller.isAllCompleted.isTrue,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: Get.height * 0.07,
                child: CustomButton(
                    text:
                        _controller.selectedOrder.value.deliveryUserForOrder !=
                                    null &&
                                widget.orderData.isSelfPickup != 1
                            ? "Already Assigned to Delivery User"
                            : "Assign to Delivery User",
                    onPressed: () {
                      _controller.selectedOrder.value.deliveryUserForOrder ==
                              null
                          ? _controller.showCustomBottomSheet(
                              context, AppKeys.userTypeDelivery)
                          : null;
                    }),
              ),
            )),
      ),
    );
  }
}
