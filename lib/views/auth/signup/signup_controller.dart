import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jigers_kitchen/core/apis/app_interface.dart';
import 'package:jigers_kitchen/model/user_data_model.dart';
import 'package:jigers_kitchen/views/auth/login/login_screen.dart';

import '../../../utils/app_colors.dart';
import '../../../utils/app_images.dart';
import '../../../utils/widget/success_dialoug.dart';

class SignupController extends GetxController {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  TextEditingController otherEmailController = TextEditingController();
  TextEditingController invoiceEmailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  TextEditingController taxController = TextEditingController();
  TextEditingController billingAddressController = TextEditingController();
  TextEditingController shippingAddressController = TextEditingController();
  TextEditingController deliveryChargesController = TextEditingController();
  TextEditingController dummyController = TextEditingController();
  RxBool showPassword = true.obs;
  RxBool checkedValue = false.obs;
  RxString selectedValue = "--Select--".obs;
  String? selectedRadioValue = "Wholesaler";

  void handleRadioValueChanged(String? value) {
    selectedRadioValue = value;
  }

  Register() async {
    await AppInterface()
        .register(
            firstName: nameController.text,
            lastName: lastNameController.text,
            userName: userNameController.text,
            phoneNumber: phoneController.text,
            invoiceEmail: invoiceEmailController.text,
            multipleOrderEmail: otherEmailController.text,
            vendorCategory: selectedRadioValue,
            password: passwordController.text,
            tax: taxController.text,
            billingAddress: billingAddressController.text,
            shippingAddress: shippingAddressController.text,
            deliveryCharges: deliveryChargesController.text)
        .then((value) {
      if (value is UserDataModel) {
        Get.off(() => const LoginScreen());
        showDialogWithAutoDismiss(
            context: Get.context,
            img: AppImages.successDialougIcon,
            autoDismiss: true,
            heading: "Hurray!",
            text: "Vendor Successfully Added",
            headingStyle: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w600,
                color: AppColors.textBlackColor));
      }
    });
  }
}
