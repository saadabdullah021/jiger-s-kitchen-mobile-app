import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jigers_kitchen/core/contstants.dart';
import 'package:jigers_kitchen/utils/helper.dart';
import 'package:jigers_kitchen/utils/widget/app_bar.dart';
import 'package:jigers_kitchen/utils/widget/app_button.dart';
import 'package:jigers_kitchen/utils/widget/appwidgets.dart';
import 'package:jigers_kitchen/views/Dashboard_screen/admins/add_admin/add_admin_controller.dart';

import '../../../../utils/app_colors.dart';
import '../../../../utils/app_images.dart';
import '../../../../utils/widget/custom_drop_down_widget.dart';
import '../../../../utils/widget/custom_textfiled.dart';

class AddAdminScreen extends StatelessWidget {
  bool? isEdit;
  String? id;
  AddAdminScreen({
    super.key,
    this.isEdit,
    this.id,
  });

  @override
  Widget build(BuildContext context) {
    AddAdminController controller = Get.put(AddAdminController());

    if (isEdit == true) {
      controller.isEdit = true;
      controller.imagePath.value = "";
      controller.getData(id ?? "");
    } else {
      controller.clearAll();
      controller.getVendorGroups(true);
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
                          validator: Helper.validateEmpty,
                          hintText: "Enter user name",
                          prefixIcon: Image.asset(AppImages.user),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Obx(
                          () => CustomDropdownSearch(
                            showSearch: true,
                            height: Get.height * 0.25,
                            items: controller.groupList.value,
                            hintText: "Group",
                            onChanged: (value) {
                              if (value!.id == -1) {}

                              controller.selectedGroupList = value;
                            },
                            selectedItem: controller.selectedGroupList,
                          ),
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
                          validator: Helper.validateEmpty,
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
                            text: isEdit == true
                                ? "Edit Admin User"
                                : "Add Admin",
                            onPressed: () {
                              if (key.currentState?.validate() ?? false) {
                                if (controller.selectedGroupList!.id == -1) {
                                  appWidgets().showToast(
                                      "Sorry", "Please select a group");
                                } else {
                                  isEdit == true
                                      ? controller.editAdmin()
                                      : controller.addAdmin();
                                }

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
