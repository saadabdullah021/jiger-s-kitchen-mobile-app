import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jigers_kitchen/utils/app_colors.dart';
import 'package:jigers_kitchen/utils/helper.dart';
import 'package:jigers_kitchen/utils/widget/app_bar.dart';
import 'package:jigers_kitchen/views/Dashboard_screen/order_list/view_order_list_controller.dart';

import '../../../../utils/widget/custom_textfiled.dart';
import '../../../common/common.dart';
import '../../../utils/widget/no_data.dart';
import '../../new_order_screens/new_order_widgets.dart';
import '../invoice/view_invoices.dart';

class OrderListScreen extends StatefulWidget {
  String? status;
  String? vendorId;
  OrderListScreen({super.key, this.status, this.vendorId});

  @override
  State<OrderListScreen> createState() => _OrderListScreenState();
}

class _OrderListScreenState extends State<OrderListScreen> {
  ORderListController controller = ORderListController();
  ScrollController _scrollController = ScrollController();

  Future<void> _scrollListener() async {
    print(_scrollController.position.extentAfter);
    if (_scrollController.position.extentAfter < 5) {
      if (controller.isMoreLoading.isFalse) {
        int Totalpage = controller.orderList.value.data!.totalPages!;
        int currntPage =
            int.parse(controller.orderList.value.data!.currentPage!);
        int page = Totalpage > currntPage ? ++currntPage : 0;
        if (page != 0) {
          controller.getOrder(true, page.toString(), false, false, "");
        }
      }
    }
  }

  @override
  void initState() {
    controller.status = widget.status;
    controller.vendorID = widget.vendorId;
    _scrollController = ScrollController()..addListener(_scrollListener);
    controller.textController.addListener(controller.onTextChanged);
    controller.getOrder(
      false,
      "1",
      true,
      false,
      "",
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(
        text: "Order List",
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
        child: Obx(
          () => controller.isLoading.isTrue
              ? Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primaryColor,
                  ),
                )
              : Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 13),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Result: ${controller.orderList.value.data!.totalRecords.toString()}",
                            style: const TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    CustomTextField(
                        fillColor: AppColors.lightGreyColor,
                        controller: controller.textController,
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: controller.textController.text != ""
                            ? InkWell(
                                onTap: () {
                                  controller.textController.clear();
                                },
                                child: const Icon(Icons.cancel))
                            : null,
                        hintText: "Search for Order"),
                    const SizedBox(
                      height: 15,
                    ),
                    controller.orderList.value.data!.ordersList!.isEmpty
                        ? Column(
                            children: [
                              SizedBox(height: Get.height * 0.15),
                              noData(null),
                            ],
                          )
                        : Expanded(
                            child: ListView.builder(
                                controller: _scrollController,
                                itemCount: controller
                                    .orderList.value.data!.ordersList!.length,
                                itemBuilder: (context, index) {
                                  return Card(
                                      color: Colors.white,
                                      child: Padding(
                                          padding: const EdgeInsets.all(13),
                                          child: ExpandablePanel(
                                              theme: ExpandableThemeData(
                                                  iconColor:
                                                      AppColors.primaryColor),
                                              header: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    controller
                                                        .orderList
                                                        .value
                                                        .data!
                                                        .ordersList![index]
                                                        .orderIdentifier
                                                        .toString(),
                                                    style: TextStyle(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: AppColors
                                                            .primaryColor),
                                                  ),
                                                  Container(
                                                    // width: 80,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15),
                                                      color: AppColors
                                                          .primaryColor,
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              4.0),
                                                      child: Center(
                                                        child: Text(
                                                          Helper
                                                              .capitalizeFirstLetter(
                                                            controller
                                                                .orderList
                                                                .value
                                                                .data!
                                                                .ordersList![
                                                                    index]
                                                                .orderStatus
                                                                .toString()
                                                                .replaceAll(
                                                                    "_", " "),
                                                          ).toUpperCase(),
                                                          style: TextStyle(
                                                              fontSize: 10,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: AppColors
                                                                  .textWhiteColor),
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                              collapsed: const SizedBox(),
                                              expanded: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Center(
                                                    child: Text(
                                                      controller
                                                              .orderList
                                                              .value
                                                              .data!
                                                              .ordersList![
                                                                  index]
                                                              .vendorInfo!
                                                              .name ??
                                                          "",
                                                      style: const TextStyle(
                                                          fontWeight: FontWeight
                                                              .normal),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  Center(
                                                    child: Text(
                                                      controller
                                                              .orderList
                                                              .value
                                                              .data!
                                                              .ordersList![
                                                                  index]
                                                              .orderCreatedAt! ??
                                                          "",
                                                      style: const TextStyle(
                                                          fontWeight: FontWeight
                                                              .normal),
                                                    ),
                                                  ),
                                                  const Divider(),
                                                  for (int i = 0;
                                                      i <
                                                          controller
                                                              .orderList
                                                              .value
                                                              .data!
                                                              .ordersList![
                                                                  index]
                                                              .ordersItems!
                                                              .length;
                                                      i++)
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              bottom: 20),
                                                      child: Column(
                                                        children: [
                                                          itemRow(
                                                              "Product Name:",
                                                              controller
                                                                  .orderList
                                                                  .value
                                                                  .data!
                                                                  .ordersList![
                                                                      index]
                                                                  .ordersItems![
                                                                      i]
                                                                  .menuItemInfo!
                                                                  .itemName!),
                                                          itemRow(
                                                              "Description:",
                                                              controller
                                                                  .orderList
                                                                  .value
                                                                  .data!
                                                                  .ordersList![
                                                                      index]
                                                                  .ordersItems![
                                                                      i]
                                                                  .menuItemInfo!
                                                                  .itemDescription!),
                                                          itemRow(
                                                              "Quantity:",
                                                              (double.parse(controller
                                                                      .orderList
                                                                      .value
                                                                      .data!
                                                                      .ordersList![
                                                                          index]
                                                                      .ordersItems![
                                                                          i]
                                                                      .itemQuantity!)
                                                                  .toStringAsFixed(
                                                                      2))),
                                                          itemRow(
                                                              "Unit Price:",
                                                              (double.parse(controller
                                                                      .orderList
                                                                      .value
                                                                      .data!
                                                                      .ordersList![
                                                                          index]
                                                                      .ordersItems![
                                                                          i]
                                                                      .itemBasePrice!)
                                                                  .toStringAsFixed(
                                                                      2))),
                                                          Visibility(
                                                            visible: controller
                                                                        .orderList
                                                                        .value
                                                                        .data!
                                                                        .ordersList![
                                                                            index]
                                                                        .ordersItems![
                                                                            i]
                                                                        .itemNote !=
                                                                    null &&
                                                                controller
                                                                        .orderList
                                                                        .value
                                                                        .data!
                                                                        .ordersList![
                                                                            index]
                                                                        .ordersItems![
                                                                            i]
                                                                        .itemNote !=
                                                                    "",
                                                            child: itemRow(
                                                                "Item Notes:",
                                                                controller
                                                                    .orderList
                                                                    .value
                                                                    .data!
                                                                    .ordersList![
                                                                        index]
                                                                    .ordersItems![
                                                                        i]
                                                                    .itemNote
                                                                    .toString()),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  const Divider(),
                                                  itemRow(
                                                      "Sub Total:",
                                                      (double.parse(controller
                                                              .orderList
                                                              .value
                                                              .data!
                                                              .ordersList![
                                                                  index]
                                                              .subTotal
                                                              .toString())
                                                          .toStringAsFixed(2))),
                                                  itemRow(
                                                      "Tax:",
                                                      (double.parse(controller
                                                              .orderList
                                                              .value
                                                              .data!
                                                              .ordersList![
                                                                  index]
                                                              .tax
                                                              .toString())
                                                          .toStringAsFixed(2))),
                                                  itemRow(
                                                      "Delivery Chargers:",
                                                      (double.parse(controller
                                                              .orderList
                                                              .value
                                                              .data!
                                                              .ordersList![
                                                                  index]
                                                              .shippingCharges
                                                              .toString())
                                                          .toStringAsFixed(2))),
                                                  itemRow(
                                                      "Total Price:",
                                                      (double.parse(controller
                                                              .orderList
                                                              .value
                                                              .data!
                                                              .ordersList![
                                                                  index]
                                                              .totalAmount
                                                              .toString())
                                                          .toStringAsFixed(2))),
                                                  Visibility(
                                                    visible: controller
                                                                .orderList
                                                                .value
                                                                .data!
                                                                .ordersList![
                                                                    index]
                                                                .orderNote !=
                                                            null &&
                                                        controller
                                                                .orderList
                                                                .value
                                                                .data!
                                                                .ordersList![
                                                                    index]
                                                                .orderNote !=
                                                            "",
                                                    child: itemRow(
                                                        "Order Notes:",
                                                        controller
                                                            .orderList
                                                            .value
                                                            .data!
                                                            .ordersList![index]
                                                            .orderNote
                                                            .toString()),
                                                  ),
                                                  const Divider(),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: [
                                                      NewOrderButtonWidget(
                                                        ic: Icons.receipt,
                                                        text: "Invoice",
                                                        ontap: () {
                                                          Get.to(InvoiceScreen(
                                                            id: controller
                                                                .orderList
                                                                .value
                                                                .data!
                                                                .ordersList![
                                                                    index]
                                                                .id
                                                                .toString(),
                                                            OrderIden: controller
                                                                .orderList
                                                                .value
                                                                .data!
                                                                .ordersList![
                                                                    index]
                                                                .orderIdentifier
                                                                .toString(),
                                                          ));
                                                        },
                                                        clr: AppColors
                                                            .orangeColor,
                                                      ),
                                                    ],
                                                  ),
                                                  Visibility(
                                                      visible: (Common.currentRole ==
                                                                  "delivery_user" ||
                                                              Common.currentRole ==
                                                                  "admin") &&
                                                          (controller
                                                                      .orderList
                                                                      .value
                                                                      .data!
                                                                      .ordersList![
                                                                          index]
                                                                      .orderStatus !=
                                                                  "delivered" &&
                                                              controller
                                                                      .orderList
                                                                      .value
                                                                      .data!
                                                                      .ordersList![
                                                                          index]
                                                                      .deliveryStatus !=
                                                                  "delivered") &&
                                                          controller.status !=
                                                              null,
                                                      child: const Divider()),
                                                  (Common.currentRole ==
                                                                  "delivery_user" ||
                                                              Common.currentRole ==
                                                                  "admin") &&
                                                          (controller
                                                                      .orderList
                                                                      .value
                                                                      .data!
                                                                      .ordersList![
                                                                          index]
                                                                      .orderStatus !=
                                                                  "delivered" &&
                                                              controller
                                                                      .orderList
                                                                      .value
                                                                      .data!
                                                                      .ordersList![
                                                                          index]
                                                                      .deliveryStatus !=
                                                                  "delivered") &&
                                                          controller.status !=
                                                              null
                                                      ? Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  horizontal:
                                                                      16.0),
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Colors.white,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        15),
                                                          ),
                                                          child: DropdownButton<
                                                              String>(
                                                            hint: const Text(
                                                              'Select an option',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .grey),
                                                            ),
                                                            value: Helper
                                                                .capitalizeFirstLetter(
                                                              Common.currentRole ==
                                                                      "admin"
                                                                  ? controller
                                                                      .orderList
                                                                      .value
                                                                      .data!
                                                                      .ordersList![
                                                                          index]
                                                                      .orderStatus
                                                                      .toString()
                                                                      .replaceAll(
                                                                          "_",
                                                                          " ")
                                                                  : controller
                                                                      .orderList
                                                                      .value
                                                                      .data!
                                                                      .ordersList![
                                                                          index]
                                                                      .deliveryStatus
                                                                      .toString()
                                                                      .replaceAll(
                                                                          "_",
                                                                          " "),
                                                            ).toUpperCase(),
                                                            isExpanded: true,
                                                            underline:
                                                                const SizedBox(), // Removes the underline
                                                            onChanged: (String?
                                                                newValue) {
                                                              controller.updateStatus(
                                                                  controller
                                                                      .orderList
                                                                      .value
                                                                      .data!
                                                                      .ordersList![
                                                                          index]
                                                                      .id
                                                                      .toString(),
                                                                  newValue!);
                                                            },
                                                            items: controller.items.map<
                                                                DropdownMenuItem<
                                                                    String>>((String
                                                                value) {
                                                              return DropdownMenuItem<
                                                                  String>(
                                                                value: value,
                                                                child: Text(
                                                                  value,
                                                                  style: const TextStyle(
                                                                      fontSize:
                                                                          12,
                                                                      color: Colors
                                                                          .black),
                                                                ),
                                                              );
                                                            }).toList(),
                                                          ),
                                                        )
                                                      : const SizedBox(),
                                                ],
                                              ))));
                                }),
                          ),
                    controller.isMoreLoading.isTrue
                        ? Center(
                            child: CircularProgressIndicator(
                              color: AppColors.primaryColor,
                            ),
                          )
                        : const SizedBox()
                  ],
                ),
        ),
      ),
    );
  }
}

Widget itemRow(String t1, String t2) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 3),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          t1,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        Flexible(
          child: Text(
            t2,
            style: const TextStyle(fontWeight: FontWeight.normal),
          ),
        ),
      ],
    ),
  );
}
