import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:jigers_kitchen/common/common.dart';
import 'package:jigers_kitchen/utils/app_colors.dart';
import 'package:jigers_kitchen/utils/widget/app_bar.dart';
import 'package:jigers_kitchen/utils/widget/custom_textfiled.dart';

import '../../../utils/widget/app_button.dart';
import '../view_cart_controller.dart';

class OrderSummery extends StatefulWidget {
  const OrderSummery({super.key});

  @override
  State<OrderSummery> createState() => _OrderSummeryState();
}

class _OrderSummeryState extends State<OrderSummery> {
  final ViewCartController _controller = Get.find();
  @override
  void initState() {
    // TODO: implement initState
    _controller.calculteTotalValue();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(text: "Order Summery"),
      body: Obx(
        () => _controller.isLoading.isTrue
            ? Center(
                child: CircularProgressIndicator(
                  color: AppColors.primaryColor,
                ),
              )
            : Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Order Summery",
                        style: TextStyle(
                            color: AppColors.primaryColor,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Delivery Date & Time",
                            style: TextStyle(
                                color: AppColors.jetBlackColor,
                                fontWeight: FontWeight.normal),
                          ),
                          InkWell(
                            onTap: () async {
                              DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(1950),
                                lastDate: DateTime(3050),
                              );

                              if (pickedDate != null) {
                                String formattedDate =
                                    DateFormat('yyyy-MM-dd').format(pickedDate);

                                _controller.deliveryDate.value = formattedDate;
                              }
                            },
                            child: Row(
                              children: [
                                Icon(
                                  Icons.calendar_month,
                                  color: AppColors.redColor,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Obx(() => Text(_controller.deliveryDate.value))
                              ],
                            ),
                          )
                        ],
                      ),
                      Obx(
                        () => CheckboxListTile(
                          checkColor: AppColors.textWhiteColor,
                          activeColor: AppColors.primaryColor,
                          title: Text(
                            "Self Pickup",
                            style: TextStyle(
                                color: AppColors.redColor,
                                fontWeight: FontWeight.bold),
                          ),
                          value: _controller.checkedValue.value,
                          onChanged: (newValue) {
                            _controller.checkedValue.value = newValue!;
                          },
                          controlAffinity: ListTileControlAffinity.leading,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: AppColors.primaryColor,
                            // border: Border.all(
                            //   width: 1,
                            //   color: AppColors.jetBlackColor,
                            // ),
                            borderRadius: BorderRadius.circular(5)),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              itemRow("Total Amount",
                                  _controller.totalPrice.toString()),
                              const SizedBox(
                                height: 10,
                              ),
                              itemRow("Tax ${_controller.taxPercentage} %",
                                  _controller.taxPrice.toStringAsFixed(2)),
                              const SizedBox(
                                height: 10,
                              ),
                              itemRow(
                                  "Standard Shipping Charges",
                                  double.parse(_controller.shippingPrice)
                                      .toStringAsFixed(2)),
                              const SizedBox(
                                height: 10,
                              ),
                              itemRow("Payable Amount",
                                  _controller.finalPrice.toStringAsFixed(2)),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                              border: Border.all(
                                width: 1,
                                color: AppColors.jetBlackColor,
                              ),
                              borderRadius: BorderRadius.circular(5)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Contact:",
                                  style: TextStyle(fontSize: 15),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 70),
                                  child: Text(
                                    Common
                                        .loginReponse.value.data!.phoneNumber!,
                                    style: const TextStyle(fontSize: 15),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      "Ship to:",
                                      style: TextStyle(fontSize: 15),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        _controller.ChnageAddress(
                                          context: context,
                                          heading: "Change Address",
                                          img: Common.loginReponse.value.data!
                                              .profileImage,
                                          text:
                                              _controller.shippingAddress.value,
                                        );
                                      },
                                      child: Text(
                                        "Change",
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.redColor),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Obx(
                                  () => Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 70),
                                    child: Text(
                                      _controller.shippingAddress.value,
                                      style: const TextStyle(fontSize: 15),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        "Note:",
                        style: TextStyle(fontSize: 15),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      CustomTextField(
                          controller: _controller.noteController,
                          hintText: "Add Notes")
                    ],
                  ),
                ),
              ),
      ),
      bottomNavigationBar: BottomAppBar(
          color: Colors.transparent,
          child: CustomButton(
              text: "Place Order",
              onPressed: () async {
                if (_controller.isPlacingOrder == false) {
                  _controller.PlaceOrder(context);
                }
              })),
    );
  }
}

Widget itemRow(String leading, String detail) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(leading,
          style: TextStyle(
              color: AppColors.textWhiteColor, fontWeight: FontWeight.w600)),
      Text(detail,
          style: TextStyle(color: AppColors.textWhiteColor, fontSize: 16))
    ],
  );
}
