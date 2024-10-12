import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jigers_kitchen/core/apis/app_interface.dart';
import 'package:jigers_kitchen/model/get_vendor_group.dart';
import 'package:jigers_kitchen/model/single_vendor_data.dart';
import 'package:jigers_kitchen/model/user_data_model.dart';
import 'package:jigers_kitchen/utils/helper.dart';

import '../../../core/contstants.dart';
import '../../../model/chef_drop_down_data_model.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_images.dart';
import '../../../utils/widget/app_button.dart';
import '../../../utils/widget/appwidgets.dart';
import '../../../utils/widget/custom_textfiled.dart';
import '../../../utils/widget/success_dialoug.dart';
import '../login/login_screen.dart';

class SignupController extends GetxController {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  TextEditingController otherEmailController = TextEditingController();
  TextEditingController invoiceEmailController = TextEditingController();
  TextEditingController phoneController =
      MaskedTextController(mask: '+1 (000) 000-0000');
  TextEditingController taxController = TextEditingController();
  TextEditingController billingAddressController = TextEditingController();
  TextEditingController shippingAddressController = TextEditingController();
  TextEditingController deliveryChargesController = TextEditingController();
  TextEditingController dummyController = TextEditingController();
  TextEditingController groupNameController = TextEditingController();
  RxBool showPassword = false.obs;
  RxBool checkedValue = false.obs;
  bool addVendor = false;
  bool isEdit = false;
  String urlImg = "";
  String vendorID = "";
  RxList<ChefData> groupList = <ChefData>[].obs;
  ChefData? selectedGroupList;
  RxString selectedValue = "--Select--".obs;
  RxString? selectedRadioValue = "Wholesaler".obs;
  RxString imagePath = ''.obs;
  final ImagePicker picker = ImagePicker();
  RxBool isloading = false.obs;
  Rx<getVendorGroupModel> vendorGroups = getVendorGroupModel().obs;
  getVendorGroupModel? selectedVendorGroup;
  List<String> list = ['Wholesaler', 'Catering'];

  getVendorGroups(bool showLoading) async {
    if (showLoading) {
      isloading.value = true;
    } else {
      groupList.value.clear();
    }
    await AppInterface().getVendorGroups().then((value) {
      if (value is getVendorGroupModel) {
        vendorGroups.value = value;
        groupList.clear();
        for (var data in vendorGroups.value.data!) {
          groupList.value.add(ChefData(id: data.id, name: data.name));
        }

        groupList.value.insert(0, ChefData(id: -1, name: "Add Group"));
        if (isEdit != true) {
          selectedGroupList = groupList.value[0];
        }
        groupList.refresh();
        isloading.value = false;
      } else {
        isloading.value = false;
        Get.back();
      }
    });
  }

  getData(String id) async {
    isloading.value = true;
    await AppInterface().getVendorByID(id).then((value) async {
      if (value != null && value is singleVendorData) {
        urlImg = value.data!.profileImage ?? "";
        nameController.text = value.data!.firstName ?? "";
        selectedRadioValue!.value = Helper.capitalizeFirstLetter(
                value.data!.vendorCategory ?? "Wholesaler") ??
            "Wholesaler";
        invoiceEmailController.text = value.data!.email ?? "";
        selectedGroupList = value.data!.groupId == null
            ? groupList[0]
            : groupList.firstWhere(
                (chef) => chef.id == value.data!.groupId,
              );
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
        await getVendorGroups(true);
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
            groupId: selectedGroupList!.id.toString(),
            profileImage: imagePath.value,
            lastName: lastNameController.text,
            userName: userNameController.text,
            phoneNumber: phoneController.text,
            invoiceEmail: invoiceEmailController.text,
            multipleOrderEmail: otherEmailController.text,
            vendorCategory: selectedRadioValue!.value.toLowerCase(),
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
            vendorCategory: selectedRadioValue!.value.toLowerCase(),
            password: passwordController.text,
            tax: taxController.text,
            groupId: selectedGroupList!.id.toString(),
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
            text: "Vendor Added Successfully",
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
            vendorCategory: selectedRadioValue!.value.toLowerCase(),
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
            text: "Vendor Added Successfully",
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

  void addVendorDialoug({
    BuildContext? context,
    String? description,
    VoidCallback? onYes,
    VoidCallback? onCancel,
    String? yesBtnText,
    String? url,
  }) {
    TextEditingController nameController = TextEditingController();
    showDialog(
      barrierColor: AppColors.primaryColor.withOpacity(0.6),
      context: context!,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          insetPadding: const EdgeInsets.symmetric(horizontal: 20),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 20,
                ),
                const SizedBox(height: 16.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      backgroundColor: AppColors.textGreyColor,
                      backgroundImage: NetworkImage(Constants.webUrl + url!),
                      radius: 40,
                    ),
                    const SizedBox(height: 14.0),
                    const Text(
                      "Add Group",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                        height: 8.0), // Space between title and subtitle
                    CustomTextField(
                      controller: groupNameController,
                      hintText: "Add Name",
                      prefixIcon: Image.asset(
                        AppImages.user,
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    CustomButton(
                      bgColor: AppColors.textGreyColor,
                      textColor: AppColors.greyColor,
                      text: "Cancel",
                      onPressed: () {
                        Get.back();
                      },
                    ),
                    const SizedBox(height: 20.0),
                    CustomButton(
                      text: yesBtnText ?? "Delete",
                      onPressed: onYes!,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
