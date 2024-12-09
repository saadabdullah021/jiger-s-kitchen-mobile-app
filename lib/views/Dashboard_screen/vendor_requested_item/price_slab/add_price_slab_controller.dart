import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jigers_kitchen/core/apis/app_interface.dart';
import 'package:jigers_kitchen/model/chef_drop_down_data_model.dart';
import 'package:jigers_kitchen/model/get_price_slab.dart';
import 'package:jigers_kitchen/utils/helper.dart';
import 'package:jigers_kitchen/utils/widget/success_dialoug.dart';

import '../../../../model/get_other_vemdor_item_detail.dart';
import '../../../../model/get_other_vendor_for_approved_item.dart';
import '../../../../model/get_price_slab_list_model.dart';
import '../../../../model/requested_item_list_model.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_images.dart';
import '../../../../utils/widget/appwidgets.dart';
import '../../../../utils/widget/delete_item_dialoug.dart';

class AddPriceSlabController extends GetxController {
  RxBool isloading = false.obs;
  RxBool isEditing = false.obs;
  String? selectedEditItemId;
  ItemsList? requestedData;
  List<ChefData> vendorList = [];
  RxList<ChefData> otherPriceList = <ChefData>[].obs;
  GetOtherVendorItemDetailModel? otherVendorItemDetail;
  Rx<getPriceSlabModel> itemData = getPriceSlabModel().obs;
  Rx<GetOtherVendorForApprovedItemModel> otherVendorItemData =
      GetOtherVendorForApprovedItemModel().obs;
  Rx<getPriceSlabItemListModel> listData = getPriceSlabItemListModel().obs;
  Rx<ChefData> selectedVendor = ChefData().obs;
  Rx<ChefData> selectedOtherPrice = ChefData().obs;
  Rx<ChefData> deleteVendor = ChefData().obs;
  RxBool isListLoading = true.obs;
  TextEditingController quantityController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController unitController = TextEditingController();
  setNewPrice(int id) {
    OtherPriceDetail? selectedGroupItem =
        otherVendorItemDetail!.data!.firstWhere((data) => data.id == id);
    priceController.text = selectedGroupItem.price ?? "";
    quantityController.text = selectedGroupItem.quantity ?? "";
  }

  getAllPriceSlabs(showLoading) async {
    if (showLoading) {
      isListLoading.value = true;
    } else {}
    await AppInterface()
        .getPriceSlabListData(
            menuID: requestedData!.itemId.toString(),
            vendorID: requestedData!.vendorId!.toString())
        .then((value) {
      isListLoading.value = false;
      if (value is getPriceSlabItemListModel) {
        if (listData.value.data != null) {
          listData.value.data!.clear();
        }

        listData.value = value;
        listData.refresh();
      }
    });
  }

  Future<void> getOtherVendorItemData() async {
    await AppInterface()
        .getOtherVendorItemDetail(
            vendorID: selectedVendor.value.id!.toString(),
            menuID: requestedData!.itemId!.toString())
        .then((value) {
      if (value is GetOtherVendorItemDetailModel) {
        otherVendorItemDetail = value;
        otherPriceList.value.clear();

        for (int i = 0; i < otherVendorItemDetail!.data!.length; i++) {
          otherPriceList.value.add(ChefData(
              id: otherVendorItemDetail!.data![i].id,
              name:
                  "${Helper.capitalizeFirstLetter(unitController.text)} - ${otherVendorItemDetail!.data![i].quantity}"));
        }
        otherPriceList.refresh();
      }
    });
  }

  deletePriceSlab(String id, BuildContext context) async {
    showDeleteItemDialoug(
        description: "Are you sure you want to DELETE the Price Slab?",
        context: context,
        url: deleteVendor.value.profileImage,
        onYes: () async {
          Get.back();
          appWidgets.loadingDialog();

          await AppInterface().deletePriceSlab(id: id).then((value) {
            if (value == 200) {
              appWidgets.hideDialog();
              getAllPriceSlabs(false);
              showDialogWithAutoDismiss(
                  context: Get.context,
                  doubleBack: false,
                  img: AppImages.successDialougIcon,
                  autoDismiss: true,
                  heading: "Hurray!",
                  text: "Slab Deleted Successfully",
                  headingStyle: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textBlackColor));
            }
          });
        });
  }

  getApprovedItemData() async {
    isloading.value = true;
    await AppInterface()
        .getPriceSlabData(
            menuID: requestedData!.itemId.toString(),
            vendorID: requestedData!.vendorId.toString())
        .then((value) async {
      if (value is getPriceSlabModel) {
        itemData.value = value;
        unitController.text = Helper.capitalizeFirstLetter(
            value.data!.menuItemInfo!.itemQuantity!.replaceAll("_", " "));
        getAllPriceSlabs(true);
        await AppInterface()
            .getSameItemVendors(
          menuID: requestedData!.itemId.toString(),
        )
            .then((value) async {
          if (value is GetOtherVendorForApprovedItemModel) {
            otherVendorItemData.value = value;
            vendorList.clear();
            for (int i = 0; i < otherVendorItemData.value.data!.length; i++) {
              vendorList.add(ChefData(
                name: otherVendorItemData.value.data![i].getVendors!.name!,
                profileImage: otherVendorItemData
                    .value.data![i].getVendors!.profileImage!,
                id: otherVendorItemData.value.data![i].getVendors!.id!,
              ));
            }
            if (vendorList.isNotEmpty) {
              selectedVendor.value = vendorList[0];
            }
            if (vendorList.isNotEmpty) {
              await getOtherVendorItemData();
            }

            isloading.value = false;
          }
        });
        isloading.value = false;
      }
    });
  }

  getData() async {
    isloading.value = true;
    await AppInterface()
        .getPriceSlabData(
            menuID: requestedData!.itemId.toString(),
            vendorID: requestedData!.vendorId.toString())
        .then((value) {
      if (value is getPriceSlabModel) {
        itemData.value = value;
        vendorList = value.data!.vendors ?? [];
        selectedVendor.value = value.data!.vendors![0];
        unitController.text = Helper.capitalizeFirstLetter(
            value.data!.menuItemInfo!.itemQuantity!.replaceAll("_", " "));
        getAllPriceSlabs(true);
        isloading.value = false;
      }
    });
  }

  EditPriceSlab() async {
    appWidgets.loadingDialog();
    await AppInterface()
        .editPriceSlabData(
            slabId: selectedEditItemId,
            vendorID: selectedVendor.value.id.toString(),
            quantity: quantityController.text,
            price: priceController.text)
        .then((value) {
      appWidgets.hideDialog;
      if (value == 200) {
        isEditing.value = false;
        quantityController.text = "";
        priceController.text = "";

        getAllPriceSlabs(false);
        showDialogWithAutoDismiss(
            context: Get.context,
            doubleBack: true,
            img: AppImages.successDialougIcon,
            autoDismiss: true,
            heading: "Hurray!",
            text: "Slab Updated Successfully",
            headingStyle: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w600,
                color: AppColors.textBlackColor));
      }
    });
  }

  addPriceSlab() async {
    appWidgets.loadingDialog();
    await AppInterface()
        .addPriceSlabData(
            menuID: requestedData!.itemId.toString(),
            vendorID: selectedVendor.value.id == null
                ? requestedData!.vendorId.toString()
                : selectedVendor.value.id.toString(),
            userId: requestedData!.vendorId.toString(),
            quantity: quantityController.text,
            price: priceController.text)
        .then((value) {
      appWidgets.hideDialog;
      if (value == 200) {
        getAllPriceSlabs(false);
        Get.back();
        showDialogWithAutoDismiss(
            context: Get.context,
            doubleBack: true,
            img: AppImages.successDialougIcon,
            autoDismiss: true,
            heading: "Hurray!",
            text: "Slab Added Successfully",
            headingStyle: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w600,
                color: AppColors.textBlackColor));
      }
    });
  }
}
