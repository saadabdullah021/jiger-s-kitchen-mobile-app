import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jigers_kitchen/core/apis/app_interface.dart';
import 'package:jigers_kitchen/model/chef_drop_down_data_model.dart';
import 'package:jigers_kitchen/model/menu_item_model.dart';
import 'package:jigers_kitchen/utils/widget/appwidgets.dart';

import '../../../../core/contstants.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_images.dart';
import '../../../../utils/widget/success_dialoug.dart';

class AddMenuController extends GetxController {
  TextEditingController itemNameController = TextEditingController();
  TextEditingController liveStationController = TextEditingController();
  TextEditingController itemDescriptionController = TextEditingController();
  TextEditingController itemNotesController = TextEditingController();
  RxBool isLoading = true.obs;
  MenuItemModel? editItemData;
  List<ChefData> chefList = [];
  ChefData? selectedChef;
  ChefData? selectedMenu;
  ChefData? selectedMenuType;
  ChefData? selectedType1;
  RxBool isWholeseller = true.obs;
  RxBool isVeg = true.obs;
  ChefData? selectedQuantity;
  bool? isEdit = false;
  String? editId;
  List<ChefData> menuList = [];
  List<ChefData> menuTypeList = [
    ChefData(id: 0, name: "Starter", profileImage: null),
    ChefData(id: 1, name: "Main Course", profileImage: null),
  ];
  List<ChefData> quantityList = [
    ChefData(id: 0, name: "Qty In Slice", profileImage: null),
    ChefData(id: 1, name: "Qty In Pond (lb)", profileImage: null),
    ChefData(id: 2, name: "Qty In Piece", profileImage: null),
    ChefData(id: 3, name: "Price Per Plate", profileImage: null),
    ChefData(id: 3, name: "Price Per Person", profileImage: null)
  ];
  List<ChefData> typeList = [
    ChefData(id: 0, name: "Wholesaler", profileImage: null),
    ChefData(id: 1, name: "Catering", profileImage: null),
    ChefData(id: 2, name: "Veg", profileImage: null),
    ChefData(id: 3, name: "Non-Veg", profileImage: null)
  ];
  getAllData() async {
    isLoading.value = true;
    getDropDownData();
  }

  setData() {
    itemNameController.text = editItemData!.data!.itemName ?? "";
    itemDescriptionController.text = editItemData!.data!.itemDescription ?? "";
    itemNotesController.text = editItemData!.data!.itemNotes ?? "";
    liveStationController.text = editItemData!.data!.liveStationName ?? "";
    selectedChef = chefList.firstWhere(
      (chef) => chef.id == editItemData!.data!.chefId!,
    );
    selectedMenu = menuList.firstWhere(
      (chef) => chef.id == editItemData!.data!.menuId!,
    );
    selectedMenuType = editItemData!.data!.menuType == "main_course"
        ? menuTypeList[1]
        : menuTypeList[0];
    // isVeg.value = editItemData!.data!.isVeg == 1 ? true : false;
    // isc.value = editItemData!.data!.isVeg == 1 ? true : false;
    // selectedTypeIndex.value = editItemData!.data!.isWholesaler == 1
    //     ? 0
    //     : editItemData!.data!.isCatering == 1
    //         ? 1
    //         : editItemData!.data!.isVeg == 1
    //             ? 2
    //             : 3;
    isWholeseller.value = editItemData!.data!.isWholesaler == 1 ? true : false;
    isVeg.value = editItemData!.data!.isVeg == 1 ? true : false;
    // selectedType = editItemData!.data!.isWholesaler == 1
    //     ? typeList[0]
    //     : editItemData!.data!.isCatering == 1
    //         ? typeList[1]
    //         : editItemData!.data!.isVeg == 1
    //             ? typeList[2]
    //             : typeList[3];
    selectedQuantity = editItemData!.data!.itemQuantity == "qty_in_Slice"
        ? quantityList[0]
        : editItemData!.data!.itemQuantity == "qty_in_pound"
            ? quantityList[1]
            : editItemData!.data!.itemQuantity == "qty_in_piece"
                ? quantityList[2]
                : editItemData!.data!.itemQuantity == "price_per_plate"
                    ? quantityList[3]
                    : quantityList[4];
  }

  getDropDownData() async {
    await AppInterface().getAllChefDropDown().then((value) async {
      if (value is ChefDropDownData) {
        if (value.data!.isEmpty) {
          Get.back();
          appWidgets().showToast("No chef found", "Please Add chef first");
        } else {
          chefList = value.data!;
          selectedChef = chefList[0];
          await AppInterface().getAllMenuDropDown().then((value) {
            if (value is ChefDropDownData) {
              menuList = value.data!;
              selectedMenu = menuList[0];
            }
          });
          if (isEdit == true) {
            await AppInterface()
                .getMenuItemFromID(id: editId.toString())
                .then((value) {
              if (value is MenuItemModel) {
                editItemData = value;
                setData();
              }
            });
          } else {
            // selectedType = typeList[0];
            selectedQuantity = quantityList[0];
            selectedMenuType = menuTypeList[0];
          }
          isLoading.value = false;
        }
      }
      if (value == null) {
        Get.back();
        Constants.soryyTryAgainToast();
      }
    });
  }

  addMEnu() {
    appWidgets.loadingDialog();
    AppInterface()
        .addMenu(
      itemName: itemNameController.text,
      chefId: selectedChef!.id!.toString(),
      menuId: selectedMenu!.id.toString(),
      menuType: selectedMenuType!.name!.toLowerCase().replaceAll(" ", "_"),
      isWholesaler: isWholeseller.isTrue ? "1" : "0",
      isCatering: isWholeseller.isFalse ? "1" : "0",
      isVeg: isVeg.isTrue ? "1" : "0",
      isNonVeg: isVeg.isFalse ? "1" : "0",
      itemQuantity: selectedQuantity!.id == 1
          ? "qty_in_pound"
          : selectedQuantity!.name!
              .toLowerCase()
              .replaceAll(" ", "_")
              .split("_(")[0],
      itemDescription: itemDescriptionController.text,
      itemNotes: itemNotesController.text,
      liveStationName: liveStationController.text,
    )
        .then((value) {
      appWidgets.hideDialog();
      if (value == 200) {
        showDialogWithAutoDismiss(
            context: Get.context,
            doubleBack: true,
            img: AppImages.successDialougIcon,
            autoDismiss: true,
            heading: "Hurray!",
            text: "Item Added Successfully",
            headingStyle: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w600,
                color: AppColors.textBlackColor));
      }
    });
  }

  editMenu() {
    appWidgets.loadingDialog();
    AppInterface()
        .editMenu(
      itemId: editId,
      itemName: itemNameController.text,
      chefId: selectedChef!.id!.toString(),
      menuId: selectedMenu!.id.toString(),
      menuType: selectedMenuType!.name!.toLowerCase().replaceAll(" ", "_"),
      isWholesaler: isWholeseller.isTrue ? "1" : "0",
      isCatering: isWholeseller.isFalse ? "1" : "0",
      isVeg: isVeg.isTrue ? "1" : "0",
      isNonVeg: isVeg.isFalse ? "1" : "0",
      itemQuantity: selectedQuantity!.id == 1
          ? "qty_in_pound"
          : selectedQuantity!.name!
              .toLowerCase()
              .replaceAll(" ", "_")
              .split("_(")[0],
      itemDescription: itemDescriptionController.text,
      itemNotes: itemNotesController.text,
      liveStationName: liveStationController.text,
    )
        .then((value) {
      appWidgets.hideDialog();
      if (value == 200) {
        showDialogWithAutoDismiss(
            context: Get.context,
            doubleBack: true,
            img: AppImages.successDialougIcon,
            autoDismiss: true,
            heading: "Hurray!",
            text: "Item Updated Successfully",
            headingStyle: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w600,
                color: AppColors.textBlackColor));
      }
    });
  }
}
