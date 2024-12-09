import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jigers_kitchen/utils/helper.dart';
import 'package:jigers_kitchen/utils/widget/app_bar.dart';
import 'package:jigers_kitchen/utils/widget/app_button.dart';

import '../../utils/app_colors.dart';
import '../../utils/widget/no_data.dart';
import 'check_out_screen/check_out_screen.dart';
import 'view_cart_controller.dart';

class ViewCart extends StatefulWidget {
  const ViewCart({super.key});

  @override
  State<ViewCart> createState() => _ViewCartState();
}

class _ViewCartState extends State<ViewCart> {
  final ViewCartController _controller = Get.put(ViewCartController());
  @override
  void initState() {
    // TODO: implement initState
    _controller.getCartItem(true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBar(text: "Cart"),
        body: Obx(
          () => _controller.isLoading.isTrue
              ? Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primaryColor,
                  ),
                )
              : _controller.cartData.value.data!.isEmpty
                  ? Column(
                      children: [
                        SizedBox(height: Get.height * 0.15),
                        noData(null),
                      ],
                    )
                  : Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 5),
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              InkWell(
                                onTap: () {
                                  Get.back();
                                },
                                child: Container(
                                    height: 15,
                                    width: 15,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            width: 1,
                                            color: AppColors.jetBlackColor),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: const Center(
                                        child: Icon(
                                      Icons.add,
                                      size: 12,
                                    ))),
                              ),
                              const SizedBox(
                                width: 2,
                              ),
                              InkWell(
                                onTap: () {
                                  Get.back();
                                },
                                child: const Text(
                                  " Add Item",
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Expanded(
                            child: Obx(
                              () => ListView.separated(
                                  separatorBuilder: (context, index) {
                                    return const SizedBox(
                                      height: 15,
                                    );
                                  },
                                  itemCount:
                                      _controller.cartData.value.data!.length,
                                  itemBuilder: (context, index) {
                                    return _controller.cartData.value
                                            .data![index].priceSlabs!.isEmpty
                                        ? const SizedBox()
                                        : Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 15, vertical: 10),
                                            decoration: BoxDecoration(
                                                color: AppColors.textWhiteColor,
                                                border: Border.all(
                                                    width: 1,
                                                    color:
                                                        AppColors.newOrderGrey),
                                                borderRadius:
                                                    BorderRadius.circular(22)),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  _controller
                                                          .cartData
                                                          .value
                                                          .data![index]
                                                          .menuItem!
                                                          .itemName ??
                                                      "",
                                                  style: const TextStyle(
                                                      fontSize: 17,
                                                      fontWeight:
                                                          FontWeight.bold),
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
                                                      Helper.capitalizeFirstLetter(
                                                          _controller
                                                                  .cartData
                                                                  .value
                                                                  .data![index]
                                                                  .menuItem!
                                                                  .itemQuantity!
                                                                  .replaceAll(
                                                                      "_",
                                                                      " ") ??
                                                              ""),
                                                      style: const TextStyle(
                                                          fontSize: 15,
                                                          fontWeight: FontWeight
                                                              .normal),
                                                    ),
                                                    const SizedBox(
                                                      width: 10,
                                                    ),
                                                    Row(
                                                      children: [
                                                        const Text(
                                                          "Base Price:",
                                                          style: TextStyle(
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                        ),
                                                        const SizedBox(
                                                          width: 5,
                                                        ),
                                                        Text(
                                                          _controller
                                                              .cartData
                                                              .value
                                                              .data![index]
                                                              .menuItem!
                                                              .basePrice!
                                                              .toString(),
                                                          style: const TextStyle(
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal),
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(
                                                      width: 5,
                                                    ),
                                                    InkWell(
                                                      onTap: () {
                                                        _controller.addNotesDialog(
                                                            index: index,
                                                            text: _controller
                                                                .cartData
                                                                .value
                                                                .data![index]
                                                                .menuItem!
                                                                .notes!,
                                                            heading: "Add Note",
                                                            context: context,
                                                            img: _controller
                                                                .cartData
                                                                .value
                                                                .data![index]
                                                                .menuItem!
                                                                .profileImage!);
                                                      },
                                                      child: Icon(
                                                        Icons.edit,
                                                        color:
                                                            AppColors.greyColor,
                                                        size: 20,
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        InkWell(
                                                          onTap: () {
                                                            _controller
                                                                .decreasePrice(
                                                                    index);
                                                          },
                                                          child: Container(
                                                            decoration: BoxDecoration(
                                                                color: AppColors
                                                                    .primaryColor,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            15)),
                                                            child:
                                                                const Padding(
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(2.0),
                                                              child: Icon(
                                                                  color: Colors
                                                                      .white,
                                                                  Icons.remove),
                                                            ),
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          width: 5,
                                                        ),
                                                        Text(
                                                          _controller
                                                              .cartData
                                                              .value
                                                              .data![index]
                                                              .menuItem!
                                                              .totalCount
                                                              .toString(),
                                                          style: const TextStyle(
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        const SizedBox(
                                                          width: 5,
                                                        ),
                                                        InkWell(
                                                          onTap: () {
                                                            _controller
                                                                .increaseQuantity(
                                                                    index);
                                                          },
                                                          child: Container(
                                                            decoration: BoxDecoration(
                                                                color: AppColors
                                                                    .primaryColor,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            15)),
                                                            child:
                                                                const Padding(
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(2.0),
                                                              child: Icon(
                                                                Icons.add,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    InkWell(
                                                      onTap: () {
                                                        _controller.deleteCart(
                                                            _controller
                                                                .cartData
                                                                .value
                                                                .data![index]
                                                                .menuItem!
                                                                .id!
                                                                .toString(),
                                                            context,
                                                            _controller
                                                                .cartData
                                                                .value
                                                                .data![index]
                                                                .menuItem!
                                                                .profileImage!
                                                                .toString());
                                                      },
                                                      child: Icon(
                                                        Icons.delete,
                                                        color:
                                                            AppColors.redColor,
                                                        size: 20,
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    const Text(
                                                      "Desc:",
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    ),
                                                    const SizedBox(
                                                      width: 5,
                                                    ),
                                                    Expanded(
                                                      child: Text(
                                                        _controller
                                                                .cartData
                                                                .value
                                                                .data![index]
                                                                .menuItem!
                                                                .itemDescription ??
                                                            "",
                                                        maxLines: 2,
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                Visibility(
                                                  visible: _controller
                                                          .cartData
                                                          .value
                                                          .data![index]
                                                          .menuItem!
                                                          .notes !=
                                                      "",
                                                  child: const Text(
                                                    "Note:",
                                                    style: TextStyle(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                ),
                                                Text(_controller
                                                        .cartData
                                                        .value
                                                        .data![index]
                                                        .menuItem!
                                                        .notes ??
                                                    "")
                                              ],
                                            ));
                                  }),
                            ),
                          ),
                        ],
                      ),
                    ),
        ),
        bottomNavigationBar: BottomAppBar(
            color: Colors.transparent,
            child: CustomButton(
                text: "Place Order",
                onPressed: () {
                  Get.to(() => const PlaceOrder());
                })));
  }
}
