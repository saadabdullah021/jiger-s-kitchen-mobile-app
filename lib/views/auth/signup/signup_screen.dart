import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jigers_kitchen/utils/widget/app_bar.dart';

import '../../../utils/app_colors.dart';
import '../../../utils/app_images.dart';
import '../../../utils/widget/app_button.dart';
import '../../../utils/widget/custom_dropdown.dart';
import '../../../utils/widget/custom_radion_btn.dart';
import '../../../utils/widget/custom_textfiled.dart';
import '../../../utils/widget/success_dialoug.dart';
import 'signup_controller.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SignupController controller = Get.put(SignupController());
    return Scaffold(
      appBar: appBar(text: "Jigar’s Kitchen"),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
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
                prefixIcon: Image.asset(
                  AppImages.mailIcon,
                ),
              ),
              const SizedBox(
                height: 14,
              ),
              CustomTextField(
                controller: controller.passwordController,
                hintText: "Enter Password",
                prefixIcon: Image.asset(
                  AppImages.mailIcon,
                ),
              ),
              const SizedBox(
                height: 14,
              ),
              CustomTextField(
                controller: controller.phoneController,
                hintText: "Enter Phone Number",
                prefixIcon: Image.asset(
                  AppImages.mailIcon,
                ),
              ),
              const SizedBox(
                height: 14,
              ),
              Obx(
                () => CustomDropdown<String>(
                  items: const [
                    DropdownMenuItem(
                        value: '--Select--', child: Text('--Select--')),
                    DropdownMenuItem(
                        value: 'Option 1', child: Text('Option 1')),
                    DropdownMenuItem(
                        value: 'Option 2', child: Text('Option 2')),
                    DropdownMenuItem(
                        value: 'Option 3', child: Text('Option 3')),
                  ],
                  value: controller.selectedValue.value,
                  hintText: 'Select an option',
                  onChanged: (value) {
                    controller.selectedValue.value = value!;
                  },
                  prefixIcon: Image.asset(
                    AppImages.mailIcon,
                  ),
                  suffixIcon: Icon(
                    Icons.arrow_drop_down,
                    color: AppColors.textFiledGrey,
                  ),
                ),
              ),
              const SizedBox(
                height: 14,
              ),
              const RadioButtonRow(),
              const SizedBox(
                height: 14,
              ),
              CustomTextField(
                controller: controller.taxController,
                hintText: "Enter Tax(%)",
                prefixIcon: Image.asset(
                  AppImages.mailIcon,
                ),
              ),
              const SizedBox(
                height: 14,
              ),
              CustomTextField(
                controller: controller.billingAddressController,
                hintText: "Enter Billing Address",
                prefixIcon: Image.asset(
                  AppImages.mailIcon,
                ),
              ),
              const SizedBox(
                height: 14,
              ),
              CustomTextField(
                controller: controller.nameController,
                hintText: "Enter Shipping Address",
                prefixIcon: Image.asset(
                  AppImages.mailIcon,
                ),
              ),
              const SizedBox(
                height: 14,
              ),
              CustomTextField(
                controller: controller.nameController,
                hintText: "Enter Delivery Charges (USD)",
                prefixIcon: Image.asset(
                  AppImages.mailIcon,
                ),
              ),
              const SizedBox(
                height: 14,
              ),
              CustomButton(
                text: "ADD VENDOR",
                onPressed: () {
                  showDialogWithAutoDismiss(
                      context: context,
                      img: AppImages.successDialougIcon,
                      autoDismiss: true,
                      heading: "Hurray!",
                      text: "Vendor Successfully Added",
                      headingStyle: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textBlackColor));
                },
              ),
              const SizedBox(
                height: 14,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
