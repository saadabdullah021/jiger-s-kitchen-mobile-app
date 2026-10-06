import 'package:jigers_kitchen/utils/widget/animations.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:jigers_kitchen/utils/app_colors.dart';
import 'package:jigers_kitchen/utils/helper.dart';
import 'package:jigers_kitchen/utils/widget/app_bar.dart';
import 'package:jigers_kitchen/views/Dashboard_screen/order_list/view_order_list_controller.dart';

import '../../../../utils/widget/custom_textfiled.dart';
import '../../../common/common.dart';
import '../../../utils/app_images.dart';
import '../../../utils/widget/app_states.dart';
import '../../../utils/widget/skeletons.dart';
import '../../new_order_screens/new_order_widgets.dart';
import '../invoice/view_invoices.dart';

Color orderStatusColor(String status) {
  switch (status.toLowerCase()) {
    case 'delivered':
      return AppColors.primaryColor;
    case 'cancelled':
    case 'rejected':
      return AppColors.redColor;
    case 'pending':
      return AppColors.orangeColor;
    case 'out for delivery':
    case 'out_for_delivery':
      return AppColors.lightBlue;
    default:
      return AppColors.secondaryColor;
  }
}

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
              ? const SkeletonList(showAvatar: false, lines: 4)
              : FadeSlideIn(
                  child: Column(
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
                        ? Expanded(
                            child: const AppEmptyState(
                            title: 'No orders found',
                            description:
                                'Try another search or check back later.',
                            icon: Icons.receipt_long_outlined,
                          ))
                        : Expanded(
                            child: ListView.builder(
                                controller: _scrollController,
                                itemCount: controller
                                    .orderList.value.data!.ordersList!.length,
                                itemBuilder: (context, index) {
                                  return FadeSlideIn(
                                      index: index,
                                      child: Card(
                                          margin:
                                              const EdgeInsets.only(bottom: 12),
                                          elevation: 0,
                                          color: AppColors.textWhiteColor,
                                          shadowColor: Colors.black12,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(18),
                                            side: BorderSide(
                                              color: AppColors.borderColor,
                                            ),
                                          ),
                                          child: Padding(
                                              padding: const EdgeInsets.all(16),
                                              child: ExpandablePanel(
                                                  theme: ExpandableThemeData(
                                                      iconColor: AppColors
                                                          .primaryColor),
                                                  header: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Expanded(
                                                        child: Row(
                                                          children: [
                                                            Container(
                                                              height: 40,
                                                              width: 40,
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: AppColors
                                                                    .primaryColor
                                                                    .withOpacity(
                                                                        0.12),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            12),
                                                              ),
                                                              child: Icon(
                                                                Icons
                                                                    .receipt_long_rounded,
                                                                color: AppColors
                                                                    .primaryColor,
                                                                size: 21,
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                                width: 12),
                                                            Expanded(
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Text(
                                                                    '#${controller.orderList.value.data!.ordersList![index].orderIdentifier}',
                                                                    maxLines: 1,
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          15,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w700,
                                                                      color: AppColors
                                                                          .textBlackColor,
                                                                    ),
                                                                  ),
                                                                  const SizedBox(
                                                                      height:
                                                                          4),
                                                                  Text(
                                                                    controller
                                                                            .orderList
                                                                            .value
                                                                            .data!
                                                                            .ordersList![index]
                                                                            .vendorInfo!
                                                                            .name ??
                                                                        'Kitchen order',
                                                                    maxLines: 1,
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          12,
                                                                      color: AppColors
                                                                          .newOrderGrey,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      const SizedBox(width: 8),
                                                      Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      999),
                                                          color:
                                                              orderStatusColor(
                                                            controller
                                                                .orderList
                                                                .value
                                                                .data!
                                                                .ordersList![
                                                                    index]
                                                                .orderStatus
                                                                .toString(),
                                                          ).withOpacity(0.12),
                                                        ),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  horizontal:
                                                                      10,
                                                                  vertical: 6),
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
                                                                        "_",
                                                                        " "),
                                                              ).toUpperCase(),
                                                              style: TextStyle(
                                                                fontSize: 10,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                                color:
                                                                    orderStatusColor(
                                                                  controller
                                                                      .orderList
                                                                      .value
                                                                      .data!
                                                                      .ordersList![
                                                                          index]
                                                                      .orderStatus
                                                                      .toString(),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                  collapsed: const SizedBox(),
                                                  expanded: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
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
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        height: 5,
                                                      ),
                                                      Center(
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            SvgPicture.asset(
                                                              AppImages.clock,
                                                              height: 15,
                                                            ),
                                                            const SizedBox(
                                                              width: 5,
                                                            ),
                                                            Text(
                                                              controller
                                                                      .orderList
                                                                      .value
                                                                      .data!
                                                                      .ordersList![
                                                                          index]
                                                                      .orderCreatedAt! ??
                                                                  "",
                                                              style: const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal),
                                                            ),
                                                          ],
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
                                                              const EdgeInsets
                                                                  .only(
                                                                  bottom: 20),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              itemColumn(
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
                                                              itemColumn(
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
                                                                            .ordersList![index]
                                                                            .ordersItems![i]
                                                                            .itemNote !=
                                                                        "",
                                                                child: itemColumn(
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
                                                          child:
                                                              const Divider()),
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
                                                        child: itemColumn(
                                                            "Order Notes:",
                                                            controller
                                                                .orderList
                                                                .value
                                                                .data!
                                                                .ordersList![
                                                                    index]
                                                                .orderNote
                                                                .toString()),
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
                                                              .toStringAsFixed(
                                                                  2))),
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
                                                              .toStringAsFixed(
                                                                  2))),
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
                                                              .toStringAsFixed(
                                                                  2))),
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
                                                              .toStringAsFixed(
                                                                  2))),
                                                      const Divider(),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        children: [
                                                          Visibility(
                                                            visible: Common
                                                                    .currentRole ==
                                                                "admin",
                                                            child:
                                                                NewOrderButtonWidget(
                                                              ic: Icons.edit,
                                                              text:
                                                                  "Update Notes",
                                                              ontap: () {
                                                                controller
                                                                    .chnageOrderNotes(
                                                                  context:
                                                                      context,
                                                                  orderId: controller
                                                                      .orderList
                                                                      .value
                                                                      .data!
                                                                      .ordersList![
                                                                          index]
                                                                      .id!
                                                                      .toString(),
                                                                  intitalNotes: controller
                                                                          .orderList
                                                                          .value
                                                                          .data!
                                                                          .ordersList![
                                                                              index]
                                                                          .orderNote ??
                                                                      "",
                                                                  onBtnTap:
                                                                      () {},
                                                                );
                                                              },
                                                              clr: AppColors
                                                                  .orangeColor,
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            width: 10,
                                                          ),
                                                          NewOrderButtonWidget(
                                                            ic: Icons.receipt,
                                                            text: "Invoice",
                                                            ontap: () {
                                                              Get.to(
                                                                  InvoiceScreen(
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
                                                              (
                                                                  // controller
                                                                  //           .orderList
                                                                  //           .value
                                                                  //           .data!
                                                                  //           .ordersList![
                                                                  //               index]
                                                                  //           .orderStatus !=
                                                                  //       "delivered" &&
                                                                  controller
                                                                          .orderList
                                                                          .value
                                                                          .data!
                                                                          .ordersList![
                                                                              index]
                                                                          .deliveryStatus !=
                                                                      "delivered") &&
                                                              controller
                                                                      .status !=
                                                                  null,
                                                          child:
                                                              const Divider()),
                                                      (Common.currentRole ==
                                                                      "delivery_user" ||
                                                                  Common.currentRole ==
                                                                      "admin") &&
                                                              (
                                                                  // controller
                                                                  //           .orderList
                                                                  //           .value
                                                                  //           .data!
                                                                  //           .ordersList![
                                                                  //               index]
                                                                  //           .orderStatus !=
                                                                  //       "delivered" &&
                                                                  controller
                                                                          .orderList
                                                                          .value
                                                                          .data!
                                                                          .ordersList![
                                                                              index]
                                                                          .deliveryStatus !=
                                                                      "delivered") &&
                                                              controller
                                                                      .status !=
                                                                  null
                                                          ? Container(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .symmetric(
                                                                      horizontal:
                                                                          16.0),
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: Colors
                                                                    .white,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            15),
                                                              ),
                                                              child:
                                                                  DropdownButton<
                                                                      String>(
                                                                hint:
                                                                    const Text(
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
                                                                isExpanded:
                                                                    true,
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
                                                                items: controller
                                                                    .items
                                                                    .map<
                                                                        DropdownMenuItem<
                                                                            String>>((String
                                                                        value) {
                                                                  return DropdownMenuItem<
                                                                      String>(
                                                                    value:
                                                                        value,
                                                                    child: Text(
                                                                      value,
                                                                      style: const TextStyle(
                                                                          fontSize:
                                                                              12,
                                                                          color:
                                                                              Colors.black),
                                                                    ),
                                                                  );
                                                                }).toList(),
                                                              ),
                                                            )
                                                          : const SizedBox(),
                                                    ],
                                                  )))));
                                }),
                          ),
                    controller.isMoreLoading.isTrue
                        ? const SkeletonLoadMore()
                        : const SizedBox()
                  ],
                )),
        ),
      ),
    );
  }
}

Widget itemRow(String t1, String t2) {
  return Container(
    width: double.infinity,
    margin: const EdgeInsets.only(bottom: 6),
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
    decoration: BoxDecoration(
      color: AppColors.lightGreyColor,
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: AppColors.borderColor),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          t1,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.newOrderGrey,
          ),
        ),
        const SizedBox(width: 12),
        Flexible(
          child: Text(
            t2,
            textAlign: TextAlign.end,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppColors.textBlackColor,
            ),
          ),
        ),
      ],
    ),
  );
}

Widget itemColumn(String t1, String t2) {
  return Container(
    width: double.infinity,
    margin: const EdgeInsets.only(bottom: 6),
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: AppColors.lightGreyColor,
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: AppColors.borderColor),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          t1,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: AppColors.newOrderGrey,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          t2,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.textBlackColor,
          ),
        ),
      ],
    ),
  );
}
