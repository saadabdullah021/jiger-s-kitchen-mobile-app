import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jigers_kitchen/model/single_user_data.dart';
import 'package:jigers_kitchen/utils/widget/appwidgets.dart';

import '../../../../core/apis/app_interface.dart';
import '../../../../model/chef_drop_down_data_model.dart';
import '../../../../model/get_vendor_group.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_images.dart';
import '../../../../utils/widget/success_dialoug.dart';

class AddAdminController extends GetxController {
  RxBool showPassword = false.obs;
  RxString imagePath = ''.obs;
  RxBool isloading = false.obs;
  String urlImg = "";
  int? chefId;
  ChefData? selectedGroupList;
  Rx<getVendorGroupModel> vendorGroups = getVendorGroupModel().obs;
  final ImagePicker picker = ImagePicker();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  RxList<ChefData> groupList = <ChefData>[].obs;
  bool isEdit = false;
  getData(String id) async {
    isloading.value = true;
    await AppInterface().getVendorGroups().then((value) async {
      if (value is getVendorGroupModel) {
        vendorGroups.value = value;
        groupList.clear();
        for (var data in vendorGroups.value.data!) {
          groupList.value.add(ChefData(id: data.id, name: data.name));
        }
        groupList.value.insert(0, ChefData(id: -1, name: "Choose Group"));
        groupList.refresh();
        await AppInterface().getUserByID(id).then((value) {
          if (value != null && value is singleUserModel) {
            urlImg = value.data!.profileImage ?? "";
            selectedGroupList = value.data!.groupId == null
                ? groupList[0]
                : groupList.firstWhere(
                    (chef) => chef.id == value.data!.groupId,
                  );
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
      } else {
        isloading.value = false;
        Get.back();
      }
    });
  }

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

        groupList.value.insert(0, ChefData(id: -1, name: "Choose Group"));
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

  addAdmin() async {
    appWidgets.loadingDialog();
    await AppInterface()
        .createAdmin(
            firstName: nameController.text,
            lastName: lastNameController.text,
            phoneNumber: phoneController.text,
            userName: userNameController.text,
            password: passwordController.text,
            email: emailController.text,
            groupId: selectedGroupList!.id.toString(),
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
            text: "Admin Added Successfully",
            headingStyle: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w600,
                color: AppColors.textBlackColor));
      }
    });
  }

  editAdmin() async {
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

  takePicture() async {
    XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      imagePath.value = image.path;
    } else {}
  }
}
