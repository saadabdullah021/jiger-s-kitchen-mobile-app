import 'dart:io';

import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jigers_kitchen/core/apis/app_interface.dart';
import 'package:jigers_kitchen/utils/helper.dart';
import 'package:jigers_kitchen/utils/widget/app_bar.dart';
import 'package:jigers_kitchen/utils/widget/appwidgets.dart';

import '../../../common/common.dart';
import '../../../core/contstants.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_images.dart';
import '../../../utils/widget/app_button.dart';
import '../../../utils/widget/custom_drop_down_widget.dart';
import '../../../utils/widget/custom_textfiled.dart';
import 'signup_controller.dart';

class SignUpScreen extends StatefulWidget {
  bool? addVendor;
  bool? isEdit;
  String? chefID;
  SignUpScreen({super.key, this.addVendor, this.isEdit, this.chefID});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  SignupController controller = Get.put(SignupController());
  final GlobalKey<FormState> key = GlobalKey();
  @override
  void initState() {
    // TODO: implement initState
    controller.vendorID = widget.chefID ?? "";
    if (widget.addVendor == true || widget.isEdit == true) {
      controller.addVendor = true;
      controller.getVendorGroups(true);
    }
    if (widget.isEdit == true) {
      controller.isEdit = true;
      controller.getVendorGroups(true);
      controller.getData(widget.chefID!);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(
          text: widget.isEdit == true
              ? "Edit Vendor"
              : widget.addVendor == true
                  ? "Add Vendor"
                  : "Jigar’s Kitchen"),
      body: Obx(
        () => controller.isloading.isTrue
            ? Center(
                child: CircularProgressIndicator(
                  color: AppColors.primaryColor,
                ),
              )
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Form(
                    key: key,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 30,
                        ),

                        Visibility(
                          visible: widget.addVendor == null,
                          child: const Text(
                            "Create Account",
                            style: TextStyle(
                                fontWeight: FontWeight.w700, fontSize: 21),
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Visibility(
                          visible: widget.addVendor == null,
                          child: Text(
                            "Hello there,lorem ipsum dolor",
                            style: TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 12,
                                color: AppColors.textFiledGrey),
                          ),
                        ),
                        Visibility(
                          visible: widget.addVendor == true,
                          child: Center(
                            child: InkWell(
                              onTap: () {
                                controller.takePicture();
                              },
                              child: Obx(
                                () => CircleAvatar(
                                  radius: 50,
                                  backgroundColor: Colors.grey.withOpacity(0.4),
                                  backgroundImage:
                                      controller.imagePath.value != ""
                                          ? FileImage(
                                              File(controller.imagePath.value))
                                          : widget.isEdit == true &&
                                                  controller.urlImg != ""
                                              ? NetworkImage(Constants.webUrl +
                                                  controller.urlImg)
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
                          ),
                        ),
                        const SizedBox(
                          height: 10,
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
                          validator: Helper.validateEmail,
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
                          validator: Helper.validateEmail,
                          prefixIcon: Image.asset(
                            AppImages.mailIcon,
                          ),
                        ),
                        const SizedBox(
                          height: 14,
                        ),
                        Obx(
                          () => CustomTextField(
                            controller: controller.passwordController,
                            hintText: "Enter Password",
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
                          height: 14,
                        ),
                        CustomTextField(
                          controller: controller.phoneController,
                          hintText: "Enter Phone Number",
                          validator: Helper.validateEmpty,
                          keyboardType: TextInputType.number,
                          prefixIcon: Icon(
                            Icons.phone,
                            size: 16,
                            color: AppColors.textFiledGrey,
                          ),
                        ),
                        const SizedBox(
                          height: 14,
                        ),

                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 5),
                          decoration: BoxDecoration(
                            color: AppColors.lightGreyColor,
                            borderRadius: BorderRadius.circular(23.0),
                          ),
                          child: CustomDropdown<String>(
                            initialItem:
                                controller.selectedRadioValue!.value.isEmpty
                                    ? controller.list[0]
                                    : controller.selectedRadioValue!.value,
                            decoration: CustomDropdownDecoration(
                                expandedFillColor: AppColors.lightGreyColor,
                                closedFillColor: Colors.transparent,
                                listItemStyle: const TextStyle(fontSize: 14),
                                headerStyle: const TextStyle(fontSize: 14),
                                hintStyle: TextStyle(
                                    color: AppColors.greyColor, fontSize: 14),
                                closedBorder: null),
                            hintText: 'Select Service Type',
                            items: controller.list,
                            onChanged: (value) {
                              controller.selectedRadioValue!.value = value!;
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 14,
                        ),
                        Visibility(
                          visible:
                              widget.addVendor == true || widget.isEdit == true,
                          child: Obx(
                            () => CustomDropdownSearch(
                              showSearch: true,
                              height: Get.height * 0.25,
                              items: controller.groupList.value,
                              hintText: "Group",
                              onChanged: (value) {
                                if (value!.id == -1) {
                                  controller.addVendorDialoug(
                                      description:
                                          "Are you sure you want to LOGOUT?",
                                      yesBtnText: "Add",
                                      context: context,
                                      url: Common.loginReponse.value.data!
                                              .profileImage ??
                                          "",
                                      onYes: () async {
                                        if (controller
                                            .groupNameController.text.isEmpty) {
                                          appWidgets().showToast(
                                              "Sorry", "Please add group name");
                                        } else {
                                          Get.back();
                                          appWidgets.loadingDialog();
                                          await AppInterface()
                                              .createVendorGroup(controller
                                                  .groupNameController.text)
                                              .then((value) {
                                            appWidgets.hideDialog();
                                            if (value == 200) {
                                              controller.getVendorGroups(false);
                                              appWidgets().showToast("Added",
                                                  "Group Successfully Added");
                                            }
                                          });
                                        }
                                      });
                                }
                                setState(() {
                                  controller.selectedGroupList = value;
                                });
                              },
                              selectedItem: controller.selectedGroupList,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 14,
                        ),
                        // Container(
                        //   padding: const EdgeInsets.symmetric(
                        //       horizontal: 20, vertical: 5),
                        //   decoration: BoxDecoration(
                        //     color: AppColors.lightGreyColor,
                        //     borderRadius: BorderRadius.circular(23.0),
                        //   ),
                        //   child: DropdownButton<String>(
                        //     icon: Icon(
                        //       Icons.arrow_drop_down,
                        //       size: 16,
                        //       color: AppColors.textFiledGrey,
                        //     ),
                        //     isExpanded: true,
                        //     value:
                        //         controller.selectedRadioValue!.value.isEmpty
                        //             ? null
                        //             : controller.selectedRadioValue!.value,
                        //     style: TextStyle(
                        //         color: AppColors.greyColor,
                        //         fontSize: 16,
                        //         fontWeight: FontWeight.w500),
                        //     hint: Text(
                        //       "--select--",
                        //       style: TextStyle(
                        //           color: AppColors.greyColor, fontSize: 17),
                        //     ),
                        //     underline: const SizedBox(),
                        //     items: <String>[
                        //       'wholesaler',
                        //       'catering',
                        //     ].map((String value) {
                        //       return DropdownMenuItem<String>(
                        //         value: value,
                        //         child: Text(value),
                        //       );
                        //     }).toList(),
                        //     onChanged: (newValue) {
                        //       controller.selectedRadioValue!.value =
                        //           newValue!;
                        //     },
                        //   ),
                        // ),

                        // CustomTextField(
                        //   controller: controller.dummyController,
                        //   hintText: "--Select--",
                        //   readOnly: true,
                        //   suffixIcon: Icon(
                        //     Icons.arrow_drop_down,
                        //     size: 16,
                        //     color: AppColors.textFiledGrey,
                        //   ),
                        // ),

                        // RadioButtonRow(
                        //   onValueChanged: controller.handleRadioValueChanged,
                        // ),
                        const SizedBox(
                          height: 14,
                        ),
                        CustomTextField(
                          controller: controller.taxController,
                          hintText: "Enter Tax(%)",
                          keyboardType: TextInputType.number,
                          validator: Helper.validateFloat,
                          prefixIcon: Icon(
                            Icons.percent,
                            size: 16,
                            color: AppColors.textFiledGrey,
                          ),
                        ),
                        const SizedBox(
                          height: 14,
                        ),
                        CustomTextField(
                          controller: controller.billingAddressController,
                          hintText: "Enter Billing Address",
                          prefixIcon: Icon(
                            Icons.location_city,
                            size: 16,
                            color: AppColors.textFiledGrey,
                          ),
                        ),
                        const SizedBox(
                          height: 14,
                        ),
                        CustomTextField(
                          controller: controller.shippingAddressController,
                          hintText: "Enter Shipping Address",
                          prefixIcon: Icon(
                            Icons.location_city,
                            size: 16,
                            color: AppColors.textFiledGrey,
                          ),
                        ),
                        const SizedBox(
                          height: 14,
                        ),
                        CustomTextField(
                          controller: controller.deliveryChargesController,
                          hintText: "Enter Delivery Charges (USD)",
                          validator: Helper.validateFloat,
                          keyboardType: TextInputType.number,
                          prefixIcon: Icon(
                            Icons.currency_rupee,
                            size: 16,
                            color: AppColors.textFiledGrey,
                          ),
                        ),
                        const SizedBox(
                          height: 14,
                        ),
                        CustomButton(
                          text: widget.isEdit == true
                              ? "Update Vendor"
                              : "ADD VENDOR",
                          onPressed: () {
                            if (key.currentState?.validate() ?? false) {
                              if (controller.selectedRadioValue!.value == "") {
                                appWidgets().showToast(
                                    "Sorry", "Please Select Category");
                              } else {
                                if (widget.isEdit == true) {
                                  controller.UpdateVendor();
                                } else if (widget.addVendor == true) {
                                  controller.AddVendor();
                                } else {
                                  controller.Register();
                                }
                              }
                            }
                          },
                        ),
                        const SizedBox(
                          height: 14,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
