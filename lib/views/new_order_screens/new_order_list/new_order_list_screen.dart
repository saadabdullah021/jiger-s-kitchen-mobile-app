import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jigers_kitchen/utils/app_colors.dart';
import 'package:jigers_kitchen/utils/widget/app_bar.dart';
import 'package:jigers_kitchen/views/Dashboard_screen/invoice/view_invoices.dart';
import 'package:jigers_kitchen/views/new_order_screens/new_order_list/assign_order.dart';
import 'package:jigers_kitchen/views/new_order_screens/new_order_list/new_order_list_controller.dart';

import '../../../../utils/widget/custom_textfiled.dart';
import '../../../utils/widget/no_data.dart';
import '../edit_order/edit_order_screen.dart';
import '../new_order_widgets.dart';

class newOrderListScreen extends StatefulWidget {
  const newOrderListScreen({super.key});
  @override
  State<newOrderListScreen> createState() => _newOrderListScreenState();
}

class _newOrderListScreenState extends State<newOrderListScreen> {
  newORderListController controller = Get.put(newORderListController());
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
    _scrollController = ScrollController()..addListener(_scrollListener);
    controller.textController.addListener(controller.onTextChanged);
    controller.getOrder(false, "1", true, false, "");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(text: "Order List"),
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
                                  return InkWell(
                                    onTap: () async {
                                      await Get.to(AssignOrder(
                                        orderData: controller.orderList.value
                                            .data!.ordersList![index],
                                      ))!
                                          .then((value) {
                                        controller.getOrder(
                                            false, "1", false, false, "");
                                      });
                                    },
                                    child: Card(
                                        color: Colors.white,
                                        child: Padding(
                                          padding: const EdgeInsets.all(13),
                                          child: ExpandablePanel(
                                              theme: ExpandableThemeData(
                                                  iconColor:
                                                      AppColors.primaryColor),
                                              header: Text.rich(
                                                  style: const TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 15),
                                                  TextSpan(
                                                      text: 'Order No. ',
                                                      children: <InlineSpan>[
                                                        TextSpan(
                                                          text: controller
                                                              .orderList
                                                              .value
                                                              .data!
                                                              .ordersList![
                                                                  index]
                                                              .orderIdentifier,
                                                          style: TextStyle(
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal,
                                                              color: AppColors
                                                                  .primaryColor),
                                                        )
                                                      ])),
                                              collapsed: ExpandedData(
                                                  data: controller
                                                      .orderList
                                                      .value
                                                      .data!
                                                      .ordersList![index]),
                                              expanded: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  ExpandedData(
                                                      data: controller
                                                          .orderList
                                                          .value
                                                          .data!
                                                          .ordersList![index]),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  for (int i = 1;
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
                                                              bottom: 4),
                                                      child:
                                                          ExpandedItemColmnRow(
                                                        leadingText: "Item:",
                                                        leadingDesc: controller
                                                            .orderList
                                                            .value
                                                            .data!
                                                            .ordersList![index]
                                                            .ordersItems![i]
                                                            .menuItemInfo!
                                                            .itemName!,
                                                        leadingText1: "Qty.",
                                                        leadingDesc1: controller
                                                            .orderList
                                                            .value
                                                            .data!
                                                            .ordersList![index]
                                                            .ordersItems![i]
                                                            .itemQuantity,
                                                      ),
                                                    ),
                                                  Divider(
                                                    height: 2,
                                                    thickness: 1,
                                                    color: AppColors
                                                        .dividerGreyColor,
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        "Tax (${controller.orderList.value.data!.ordersList![index].vendorInfo!.tax!}%)",
                                                        style: const TextStyle(
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600),
                                                      ),
                                                      Text(
                                                        controller
                                                            .orderList
                                                            .value
                                                            .data!
                                                            .ordersList![index]
                                                            .tax!,
                                                        style: const TextStyle(
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(
                                                    height: 20,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      const Text(
                                                        "Total Amount",
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600),
                                                      ),
                                                      Text(
                                                        controller
                                                            .orderList
                                                            .value
                                                            .data!
                                                            .ordersList![index]
                                                            .totalAmount!,
                                                        style: const TextStyle(
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  Divider(
                                                    height: 2,
                                                    thickness: 1,
                                                    color: AppColors
                                                        .dividerGreyColor,
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    children: [
                                                      NewOrderButtonWidget(
                                                        ic: Icons.edit,
                                                        text: "Edit",
                                                        clr: AppColors
                                                            .primaryColor,
                                                        ontap: () {
                                                          Get.to(() =>
                                                              EditOrderScreen(
                                                                
                                                                orderID: controller
                                                                    .orderList
                                                                    .value
                                                                    .data!
                                                                    .ordersList![
                                                                        index]
                                                                    .id
                                                                    .toString(),
                                                              ));
                                                        },
                                                      ),
                                                      NewOrderButtonWidget(
                                                        ic: Icons.delete,
                                                        text: "Delete",
                                                        ontap: () {
                                                          controller.deleteOrder(
                                                              controller
                                                                      .orderList
                                                                      .value
                                                                      .data!
                                                                      .ordersList![
                                                                  index],
                                                              context);
                                                        },
                                                        clr: AppColors.redColor,
                                                      ),
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
                                                ],
                                              )),
                                        )),
                                  );
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
