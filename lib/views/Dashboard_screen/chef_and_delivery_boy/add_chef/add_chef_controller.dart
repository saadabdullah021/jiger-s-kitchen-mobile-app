import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jigers_kitchen/model/single_user_data.dart';
import 'package:jigers_kitchen/utils/widget/appwidgets.dart';

import '../../../../core/apis/app_interface.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_images.dart';
import '../../../../utils/widget/success_dialoug.dart';

class AddChefController extends GetxController {
  RxBool showPassword = false.obs;
  RxString imagePath = ''.obs;
  RxBool isloading = false.obs;
  String urlImg = "";
  int? chefId;
  final ImagePicker picker = ImagePicker();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  TextEditingController phoneController =
      MaskedTextController(mask: '+1 (000) 000-0000');
  getData(String id) async {
    isloading.value = true;
    await AppInterface().getUserByID(id).then((value) {
      if (value != null && value is singleUserModel) {
        urlImg = value.data!.profileImage ?? "";
        nameController.text = value.data!.name ?? "";
        emailController.text = value.data!.email ?? "";
        chefId = value.data!.id!;
        userNameController.text = value.data!.userName ?? "";
        passwordController.text = value.data!.decodedPassword ?? "";
        lastNameController.text = value.data!.lastName ?? "";
        phoneController.text = value.data!.phoneNumber ?? "";
        isloading.value = false;
      }
    });
  }

  clearAll() {
    urlImg = "";
    nameController.text = "";
    emailController.text = "";
    userNameController.text = "";
    passwordController.text = "";
    lastNameController.text = "";
    passwordController.text = "";
    phoneController.text = "";
    isloading.value = false;
  }

  addChef() async {
    appWidgets.loadingDialog();
    await AppInterface()
        .createChef(
            firstName: nameController.text,
            lastName: lastNameController.text,
            phoneNumber: phoneController.text,
            userName: userNameController.text,
            password: passwordController.text,
            email: emailController.text,
            profileImage: imagePath.value)
        .then((value) {
      if (value == 200) {
        appWidgets.hideDialog;
        Get.back();
        showDialogWithAutoDismiss(
            context: Get.context,
            doubleBack: true,
            img: AppImages.successDialougIcon,
            autoDismiss: true,
            heading: "Hurray!",
            text: "Chef Added Successfully",
            headingStyle: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w600,
                color: AppColors.textBlackColor));
      }
    });
  }

  addDelivery() async {
    appWidgets.loadingDialog();
    await AppInterface()
        .createDeliveryUser(
            firstName: nameController.text,
            lastName: lastNameController.text,
            phoneNumber: phoneController.text,
            userName: userNameController.text,
            password: passwordController.text,
            email: emailController.text,
            profileImage: imagePath.value)
        .then((value) {
      if (value == 200) {
        appWidgets.hideDialog;
        Get.back();
        showDialogWithAutoDismiss(
            context: Get.context,
            doubleBack: true,
            img: AppImages.successDialougIcon,
            autoDismiss: true,
            heading: "Hurray!",
            text: "Delivery User Added Successfully",
            headingStyle: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w600,
                color: AppColors.textBlackColor));
      }
    });
  }

  editChef() async {
    appWidgets.loadingDialog();
    await AppInterface()
        .editChef(
            firstName: nameController.text,
            lastName: lastNameController.text,
            phoneNumber: phoneController.text,
            userName: userNameController.text,
            password: passwordController.text,
            email: emailController.text,
            id: chefId.toString(),
            profileImage: imagePath.value)
        .then((value) {
      if (value == 200) {
        appWidgets.hideDialog;
        Get.back();
        showDialogWithAutoDismiss(
            context: Get.context,
            doubleBack: true,
            img: AppImages.successDialougIcon,
            autoDismiss: true,
            heading: "Hurray!",
            text: "Profile Updated Successfully",
            headingStyle: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w600,
                color: AppColors.textBlackColor));
      }
    });
  }

  editDeliveryUser() async {
    appWidgets.loadingDialog();
    await AppInterface()
        .editDeliveryUser(
            firstName: nameController.text,
            lastName: lastNameController.text,
            phoneNumber: phoneController.text,
            userName: userNameController.text,
            password: passwordController.text,
            email: emailController.text,
            id: chefId.toString(),
            profileImage: imagePath.value)
        .then((value) {
      if (value == 200) {
        appWidgets.hideDialog;
        Get.back();

        showDialogWithAutoDismiss(
            context: Get.context,
            doubleBack: true,
            img: AppImages.successDialougIcon,
            autoDismiss: true,
            heading: "Hurray!",
            text: "Delivery User Updated Successfully",
            headingStyle: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w600,
                color: AppColors.textBlackColor));
      }
    });
  }

  takePicture() async {
    XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      imagePath.value = image.path;
    } else {}
  }
}
