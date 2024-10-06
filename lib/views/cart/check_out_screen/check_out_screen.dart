import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jigers_kitchen/common/common.dart';
import 'package:jigers_kitchen/utils/app_colors.dart';
import 'package:jigers_kitchen/utils/app_images.dart';
import 'package:jigers_kitchen/utils/widget/app_bar.dart';

import '../../../utils/widget/app_button.dart';
import '../view_cart_controller.dart';
import 'order_summery.dart';

class PlaceOrder extends StatefulWidget {
  const PlaceOrder({super.key});

  @override
  State<PlaceOrder> createState() => _PlaceOrderState();
}

class _PlaceOrderState extends State<PlaceOrder> {
  final ViewCartController _controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(text: "Place Order"),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Payment:",
              style: TextStyle(
                  color: AppColors.redColor, fontWeight: FontWeight.w600),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              "All transactions are secure and encrypted",
              style: TextStyle(
                  color: AppColors.jetBlackColor,
                  fontWeight: FontWeight.normal,
                  fontSize: 14),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                border: Border.all(width: 1, color: AppColors.jetBlackColor),
              ),
              child: Column(
                children: [
                  Obx(
                    () => ListTile(
                      title: const Text(
                        'Debit Card,Credit Card,Paypal',
                        style: TextStyle(fontSize: 14),
                      ),
                      leading: Radio(
                        activeColor: AppColors.appColor,
                        value: 1,
                        groupValue: _controller.selectedPayment.value,
                        onChanged: (v) {
                          _controller.selectedPayment.value = v!;
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 60),
                    child: Row(
                      children: [
                        Image.asset(
                          AppImages.visa,
                          height: 30,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Image.asset(
                          AppImages.payPal,
                          height: 30,
                        ),
                      ],
                    ),
                  ),
                  Image.asset(
                    AppImages.atm,
                    height: 150,
                  ),
                  Obx(
                    () => ListTile(
                      title: const Text(
                        'Cash on delivery (COD)',
                        style: TextStyle(fontSize: 14),
                      ),
                      leading: Radio(
                        activeColor: AppColors.primaryColor,
                        value: 2,
                        groupValue: _controller.selectedPayment.value,
                        onChanged: (v) {
                          _controller.selectedPayment.value = v!;
                        },
                      ),
                    ),
                  ),
                  Obx(
                    () => ListTile(
                      title: const Text(
                        'Payment by cheque',
                        style: TextStyle(fontSize: 14),
                      ),
                      leading: Radio(
                        activeColor: AppColors.primaryColor,
                        value: 3,
                        groupValue: _controller.selectedPayment.value,
                        onChanged: (v) {
                          _controller.selectedPayment.value = v!;
                        },
                      ),
                    ),
                  ),
                  Obx(
                    () => ListTile(
                      title: const Text(
                        'ACH',
                        style: TextStyle(fontSize: 14),
                      ),
                      leading: Radio(
                        activeColor: AppColors.primaryColor,
                        value: 4,
                        groupValue: _controller.selectedPayment.value,
                        onChanged: (v) {
                          _controller.selectedPayment.value = v!;
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              "Billing Address:",
              style: TextStyle(
                  color: AppColors.jetBlackColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 14),
            ),
            const SizedBox(
              height: 10,
            ),
            Center(
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border:
                        Border.all(width: 1, color: AppColors.jetBlackColor)),
                child:
                    Text(Common.loginReponse.value.data!.billingAddress ?? ""),
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
          color: Colors.transparent,
          child: CustomButton(
              text: "Place Order",
              onPressed: () {
                Get.to(() => const OrderSummery());
              })),
    );
  }
}
