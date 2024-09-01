import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jigers_kitchen/utils/widget/appwidgets.dart';

import '../../../../core/apis/app_interface.dart';

class AddChefController {
  RxBool showPassword = false.obs;
  RxString imagePath = ''.obs;
  final ImagePicker picker = ImagePicker();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
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
        appWidgets().showToast("Success", "Chef added Successfully");
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
