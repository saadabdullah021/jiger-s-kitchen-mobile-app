import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jigers_kitchen/core/contstants.dart';
import 'package:jigers_kitchen/utils/helper.dart';
import 'package:jigers_kitchen/utils/widget/app_bar.dart';
import 'package:jigers_kitchen/utils/widget/app_button.dart';
import 'package:jigers_kitchen/views/Dashboard_screen/chef_and_delivery_boy/add_chef/add_chef_controller.dart';

import '../../../../utils/app_colors.dart';
import '../../../../utils/app_images.dart';
import '../../../../utils/app_keys.dart';
import '../../../../utils/widget/custom_textfiled.dart';

class AddChefScreen extends StatelessWidget {
  bool? isEdit;
  String? id;
  String? type;
  AddChefScreen({super.key, this.isEdit, this.id, this.type});

  @override
  Widget build(BuildContext context) {
    AddChefController controller = Get.put(AddChefController());
    if (isEdit == true) {
      controller.imagePath.value = "";
      controller.getData(id ?? "");
    } else {
      controller.clearAll();
      controller.isloading.value = false;
    }
    final GlobalKey<FormState> key = GlobalKey();
    return Scaffold(
      appBar: appBar(text: "Jigar’s Kitchen"),
      body: Form(
        key: key,
        child: Obx(
          () => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: controller.isloading.isTrue
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(
                          height: 15,
                        ),
                        InkWell(
                          onTap: () {
                            controller.takePicture();
                          },
                          child: Obx(
                            () => CircleAvatar(
                              radius: 50,
                              backgroundColor: Colors.grey.withOpacity(0.4),
                              backgroundImage: controller.imagePath.value != ""
                                  ? FileImage(File(controller.imagePath.value))
                                  : isEdit == true && controller.urlImg != ""
                                      ? NetworkImage(
                                          Constants.webUrl + controller.urlImg)
                                      : null,
                              child: Center(
                                  child: controller.imagePath.value == "" &&
                                          controller.urlImg == ""
                                      ? Image.asset(
                                          AppImages.images,
                                          height: 20,
                                        )
                                      : null),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        CustomTextField(
                          controller: controller.nameController,
                          validator: Helper.validateName,
                          hintText: "First Name",
                          prefixIcon: Image.asset(AppImages.user),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        CustomTextField(
                          controller: controller.lastNameController,
                          validator: Helper.validateName,
                          hintText: "Last Name",
                          prefixIcon: Image.asset(AppImages.user),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        CustomTextField(
                          controller: controller.emailController,
                          validator: Helper.validateEmail,
                          hintText: "Enter email",
                          prefixIcon: Image.asset(AppImages.mailIcon),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        CustomTextField(
                          controller: controller.userNameController,
                          validator: Helper.validateName,
                          hintText: "Enter user name",
                          prefixIcon: Image.asset(AppImages.user),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Obx(
                          () => CustomTextField(
                            controller: controller.passwordController,
                            hintText: "Enter Password",
                            validator: Helper.validateEmpty,
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
                          height: 15,
                        ),
                        CustomTextField(
                          controller: controller.phoneController,
                          validator: Helper.validateNumber,
                          hintText: "Enter Phone Number",
                          keyboardType: TextInputType.number,
                          prefixIcon: Icon(
                            Icons.phone,
                            color: AppColors.containerBg,
                            size: 20,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        CustomButton(
                            text: isEdit == true &&
                                    type == AppKeys.userTypeDelivery
                                ? "Update Delivery User"
                                : isEdit == true && type == null
                                    ? "Update Chef"
                                    : isEdit == true && type != null
                                        ? "Update Profile"
                                        : isEdit == null &&
                                                type == AppKeys.userTypeDelivery
                                            ? "Add Delivery User"
                                            : "Add chef",
                            onPressed: () {
                              if (key.currentState?.validate() ?? false) {
                                isEdit == true &&
                                        type == AppKeys.userTypeDelivery
                                    ? controller.editDeliveryUser()
                                    : isEdit == true && type == null
                                        ? controller.editChef()
                                        : isEdit == true && type != null
                                            ? controller.editChef()
                                            : isEdit == null &&
                                                    type ==
                                                        AppKeys.userTypeDelivery
                                                ? controller.addDelivery()
                                                : controller.addChef();

                                // isEdit == true
                                //     ? controller.editChef()
                                //     : controller.addChef();
                              }
                            })
                      ],
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
