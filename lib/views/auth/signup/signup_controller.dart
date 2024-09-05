import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jigers_kitchen/core/apis/app_interface.dart';
import 'package:jigers_kitchen/model/single_vendor_data.dart';
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
  String urlImg = "";
  String vendorID = "";
  RxString selectedValue = "--Select--".obs;
  RxString? selectedRadioValue = "".obs;
  RxString imagePath = ''.obs;
  final ImagePicker picker = ImagePicker();
  RxBool isloading = false.obs;
  getData(String id) async {
    isloading.value = true;
    await AppInterface().getVendorByID(id).then((value) {
      if (value != null && value is singleVendorData) {
        urlImg = value.data!.profileImage ?? "";
        nameController.text = value.data!.firstName ?? "";
        selectedRadioValue!.value = value.data!.vendorCategory ?? "Wholesaler";
        invoiceEmailController.text = value.data!.email ?? "";
        taxController.text = value.data!.tax ?? "";
        shippingAddressController.text = value.data!.shippingAddress ?? "";
        billingAddressController.text = value.data!.billingAddress ?? "";
        deliveryChargesController.text = value.data!.deliveryCharges ?? "";
        otherEmailController.text = value.data!.multipleOrderEmail ?? "";
        vendorID = value.data!.id!.toString();
        billingAddressController.text = value.data!.billingAddress ?? "";
        userNameController.text = value.data!.userName ?? "";
        passwordController.text = value.data!.decodedPassword ?? "";
        lastNameController.text = value.data!.lastName ?? "";
        phoneController.text = value.data!.phoneNumber ?? "";
        isloading.value = false;
      }
    });
  }

  takePicture() async {
    XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      imagePath.value = image.path;
    } else {}
  }

  UpdateVendor() async {
    appWidgets.loadingDialog();
    await AppInterface()
        .updateVendor(
            vendorID: vendorID,
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
      if (value == 200) {
        showDialogWithAutoDismiss(
            doubleBack: true,
            context: Get.context,
            img: AppImages.successDialougIcon,
            autoDismiss: true,
            heading: "Hurray!",
            text: "Vendor Updated Successfully",
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
            doubleBack: true,
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
