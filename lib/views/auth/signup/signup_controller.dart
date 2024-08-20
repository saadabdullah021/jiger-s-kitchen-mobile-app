import 'package:flutter/material.dart';
import 'package:get/get.dart';

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

  RxBool showPassword = true.obs;
  RxBool checkedValue = false.obs;
  RxString selectedValue = "--Select--".obs;
}
