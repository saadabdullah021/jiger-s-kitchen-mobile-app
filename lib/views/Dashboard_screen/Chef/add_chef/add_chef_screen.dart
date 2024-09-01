import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jigers_kitchen/utils/helper.dart';
import 'package:jigers_kitchen/utils/widget/app_bar.dart';
import 'package:jigers_kitchen/utils/widget/app_button.dart';
import 'package:jigers_kitchen/views/Dashboard_screen/Chef/add_chef/add_chef_controller.dart';

import '../../../../utils/app_colors.dart';
import '../../../../utils/app_images.dart';
import '../../../../utils/widget/appwidgets.dart';
import '../../../../utils/widget/custom_textfiled.dart';

class AddChefScreen extends StatelessWidget {
  const AddChefScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AddChefController controller = Get.put(AddChefController());
    final GlobalKey<FormState> key = GlobalKey();
    return Scaffold(
      appBar: appBar(text: "Jigar’s Kitchen"),
      body: Form(
        key: key,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: SingleChildScrollView(
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
                          : null,
                      child: Center(
                          child: controller.imagePath.value == ""
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
                  prefixIcon: Image.asset(AppImages.user),
                ),
                const SizedBox(
                  height: 20,
                ),
                CustomButton(
                    text: "Add chef",
                    onPressed: () {
                      if (key.currentState?.validate() ?? false) {
                        if (controller.imagePath.value == "") {
                          appWidgets().showToast("Sorry", "Please Add image");
                        }
                        controller.addChef();
                      }
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
