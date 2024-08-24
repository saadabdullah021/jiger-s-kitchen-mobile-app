import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jigers_kitchen/utils/helper.dart';
import 'package:jigers_kitchen/utils/widget/app_bar.dart';

import '../../../utils/app_colors.dart';
import '../../../utils/app_images.dart';
import '../../../utils/widget/app_button.dart';
import '../../../utils/widget/custom_radion_btn.dart';
import '../../../utils/widget/custom_textfiled.dart';
import 'signup_controller.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SignupController controller = Get.put(SignupController());
    final GlobalKey<FormState> key = GlobalKey();
    controller.dummyController.text = "--Select--";
    return Scaffold(
      appBar: appBar(text: "Jigar’s Kitchen"),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Form(
            key: key,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 30,
                ),
                const Text(
                  "Create Account",
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 21),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  "Hello there,lorem ipsum dolor",
                  style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 12,
                      color: AppColors.textFiledGrey),
                ),
                const SizedBox(
                  height: 14,
                ),
                CustomTextField(
                  controller: controller.nameController,
                  hintText: "First Name",
                  prefixIcon: Image.asset(
                    AppImages.user,
                  ),
                ),
                const SizedBox(
                  height: 14,
                ),
                CustomTextField(
                  controller: controller.lastNameController,
                  hintText: "Last Name",
                  prefixIcon: Image.asset(
                    AppImages.user,
                  ),
                ),
                const SizedBox(
                  height: 14,
                ),
                CustomTextField(
                  controller: controller.userNameController,
                  hintText: "Username/Business Name",
                  prefixIcon: Image.asset(
                    AppImages.user,
                  ),
                ),
                const SizedBox(
                  height: 14,
                ),
                CustomTextField(
                  controller: controller.invoiceEmailController,
                  hintText: "Enter Invoice Email",
                  validator: Helper.validateEmail,
                  prefixIcon: Image.asset(
                    AppImages.mailIcon,
                  ),
                ),
                const SizedBox(
                  height: 14,
                ),
                CustomTextField(
                  controller: controller.otherEmailController,
                  hintText: "Enter Multiple Order Email",
                  validator: Helper.validateEmail,
                  prefixIcon: Image.asset(
                    AppImages.mailIcon,
                  ),
                ),
                const SizedBox(
                  height: 14,
                ),
                Obx(
                  () => CustomTextField(
                    controller: controller.passwordController,
                    hintText: "Enter Password",
                    obscureText: !controller.showPassword.value,
                    prefixIcon: Icon(
                      Icons.password,
                      size: 16,
                      color: AppColors.textFiledGrey,
                    ),
                    suffixIcon: Icon(
                      controller.showPassword.isTrue
                          ? Icons.visibility
                          : Icons.visibility_off,
                      size: 20,
                      color: AppColors.textFiledGrey,
                    ),
                    onSuffixIconTap: () {
                      controller.showPassword.value =
                          !controller.showPassword.value;
                    },
                  ),
                ),
                const SizedBox(
                  height: 14,
                ),
                CustomTextField(
                  controller: controller.phoneController,
                  hintText: "Enter Phone Number",
                  validator: Helper.validateNumber,
                  prefixIcon: Icon(
                    Icons.phone,
                    size: 16,
                    color: AppColors.textFiledGrey,
                  ),
                ),
                const SizedBox(
                  height: 14,
                ),
                CustomTextField(
                  controller: controller.dummyController,
                  hintText: "--Select--",
                  readOnly: true,
                  suffixIcon: Icon(
                    Icons.arrow_drop_down,
                    size: 16,
                    color: AppColors.textFiledGrey,
                  ),
                ),
                const SizedBox(
                  height: 14,
                ),
                RadioButtonRow(
                  onValueChanged: controller.handleRadioValueChanged,
                ),
                const SizedBox(
                  height: 14,
                ),
                CustomTextField(
                  controller: controller.taxController,
                  hintText: "Enter Tax(%)",
                  validator: Helper.validateNumber,
                  prefixIcon: Icon(
                    Icons.percent,
                    size: 16,
                    color: AppColors.textFiledGrey,
                  ),
                ),
                const SizedBox(
                  height: 14,
                ),
                CustomTextField(
                  controller: controller.billingAddressController,
                  hintText: "Enter Billing Address",
                  prefixIcon: Icon(
                    Icons.location_city,
                    size: 16,
                    color: AppColors.textFiledGrey,
                  ),
                ),
                const SizedBox(
                  height: 14,
                ),
                CustomTextField(
                  controller: controller.shippingAddressController,
                  hintText: "Enter Shipping Address",
                  prefixIcon: Icon(
                    Icons.location_city,
                    size: 16,
                    color: AppColors.textFiledGrey,
                  ),
                ),
                const SizedBox(
                  height: 14,
                ),
                CustomTextField(
                  controller: controller.deliveryChargesController,
                  hintText: "Enter Delivery Charges (USD)",
                  validator: Helper.validateNumber,
                  prefixIcon: Icon(
                    Icons.currency_rupee,
                    size: 16,
                    color: AppColors.textFiledGrey,
                  ),
                ),
                const SizedBox(
                  height: 14,
                ),
                CustomButton(
                  text: "ADD VENDOR",
                  onPressed: () {
                    if (key.currentState?.validate() ?? false) {
                      if (controller.selectedRadioValue == null) {
                      } else {
                        controller.Register();
                      }
                    }
                  },
                ),
                const SizedBox(
                  height: 14,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
