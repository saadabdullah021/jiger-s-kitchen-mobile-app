import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jigers_kitchen/core/apis/app_interface.dart';
import 'package:jigers_kitchen/model/user_data_model.dart';

import '../../../utils/app_colors.dart';
import '../../../utils/app_images.dart';
import '../../../utils/widget/appwidgets.dart';
import '../../../utils/widget/success_dialoug.dart';
import '../login/login_screen.dart';

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
  RxBool showPassword = false.obs;
  RxBool checkedValue = false.obs;
  RxString selectedValue = "--Select--".obs;
  RxString? selectedRadioValue = "Wholesaler".obs;
  RxString imagePath = ''.obs;
  final ImagePicker picker = ImagePicker();
  takePicture() async {
    XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      imagePath.value = image.path;
    } else {}
  }

  AddVendor() async {
    appWidgets.loadingDialog();
    await AppInterface()
        .addVendor(
            firstName: nameController.text,
            profileImage: imagePath.value,
            lastName: lastNameController.text,
            userName: userNameController.text,
            phoneNumber: phoneController.text,
            invoiceEmail: invoiceEmailController.text,
            multipleOrderEmail: otherEmailController.text,
            vendorCategory: selectedRadioValue!.value,
            password: passwordController.text,
            tax: taxController.text,
            billingAddress: billingAddressController.text,
            shippingAddress: shippingAddressController.text,
            deliveryCharges: deliveryChargesController.text)
        .then((value) {
      appWidgets.hideDialog();
      if (value is UserDataModel) {
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
      } else if (value is String) {
        appWidgets().showToast("Sorry", value);
      } else {
        appWidgets().showToast("Sorry", "Internal server error");
      }
    });
  }

  Register() async {
    appWidgets.loadingDialog();
    await AppInterface()
        .register(
            firstName: nameController.text,
            lastName: lastNameController.text,
            userName: userNameController.text,
            phoneNumber: phoneController.text,
            invoiceEmail: invoiceEmailController.text,
            multipleOrderEmail: otherEmailController.text,
            vendorCategory: selectedRadioValue!.value,
            password: passwordController.text,
            tax: taxController.text,
            billingAddress: billingAddressController.text,
            shippingAddress: shippingAddressController.text,
            deliveryCharges: deliveryChargesController.text)
        .then((value) {
      appWidgets.hideDialog();
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
      } else if (value is String) {
        appWidgets().showToast("Sorry", value);
      } else {
        appWidgets().showToast("Sorry", "Internal server error");
      }
    });
  }
}
