import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jigers_kitchen/utils/app_colors.dart';
import 'package:jigers_kitchen/utils/widget/custom_drop_down_widget.dart';
import 'package:jigers_kitchen/views/Dashboard_screen/vendor_requested_item/price_slab/add_price_slab_controller.dart';

import '../../../../model/requested_item_list_model.dart';
import '../../../../utils/helper.dart';
import '../../../../utils/widget/app_bar.dart';
import '../../../../utils/widget/app_button.dart';
import '../../../../utils/widget/custom_textfiled.dart';

class AddPriceSlabScreen extends StatelessWidget {
  ItemsList requestedData;
  bool fromApproved;
  AddPriceSlabScreen(
      {super.key, required this.requestedData, required this.fromApproved});

  @override
  Widget build(BuildContext context) {
    AddPriceSlabController controller = Get.put(AddPriceSlabController());
    controller.requestedData = requestedData;
    controller.isEditing.value = false;
    if (fromApproved) {
      controller.getApprovedItemData();
    } else {
      controller.getData();
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
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 15,
                      ),
                      Text(
                        controller
                                .itemData.value.data!.menuItemInfo!.itemName ??
                            "",
                        style: const TextStyle(
                            fontSize: 19, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      CustomDropdownSearch(
                        showSearch: true,
                        height: Get.height * 0.25,
                        items: controller.vendorList,
                        hintText: "Vendor",
                        onChanged: (value) {
                          controller.selectedVendor.value = value!;
                          controller.getOtherVendorItemData();
                        },
                        selectedItem: controller.selectedVendor.value,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Visibility(
                        visible: fromApproved,
                        child: Obx(
                          () => CustomDropdownSearch(
                            showSearch: true,
                            height: Get.height * 0.25,
                            items: controller.otherPriceList.value,
                            hintText: "Item",
                            onChanged: (value) {
                              controller.setNewPrice(value!.id!);
                            },
                            selectedItem: controller.selectedOtherPrice.value,
                          ),
                        ),
                      ),
                      Visibility(
                        visible: fromApproved,
                        child: const SizedBox(
                          height: 15,
                        ),
                      ),
                      CustomTextField(
                        controller: controller.quantityController,
                        keyboardType: TextInputType.number,
                        validator: Helper.validateNumber,
                        hintText: "Enter Quantity",
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      CustomTextField(
                        controller: controller.priceController,
                        validator: Helper.validateFloat,
                        keyboardType: TextInputType.number,
                        hintText: "Write Price (USD)",
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      CustomTextField(
                        controller: controller.unitController,
                        validator: Helper.validateEmpty,
                        readOnly: true,
                        hintText: "Enter Quantity",
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      CustomButton(
                          text: "Add Price Slab",
                          onPressed: () {
                            if (key.currentState?.validate() ?? false) {
                              controller.isEditing.isTrue
                                  ? controller.EditPriceSlab()
                                  : controller.addPriceSlab();
                            }
                          }),
                      const SizedBox(
                        height: 20,
                      ),
                      Expanded(
                        child: Obx(
                          () => controller.isListLoading.isFalse
                              ? ListView(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("Qty",
                                            style: TextStyle(
                                                color: AppColors.primaryColor,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 15)),
                                        Text("Unit",
                                            style: TextStyle(
                                                color: AppColors.primaryColor,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 15)),
                                        Text("Price (USD)",
                                            style: TextStyle(
                                                color: AppColors.primaryColor,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 15)),
                                        Text("Action",
                                            style: TextStyle(
                                                color: AppColors.primaryColor,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 15)),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    for (int i = 0;
                                        i <
                                            controller
                                                .listData.value.data!.length;
                                        i++) ...{
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                              controller.listData.value.data![i]
                                                  .quantity!,
                                              style: TextStyle(
                                                  color:
                                                      AppColors.jetBlackColor,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 15)),
                                          Text(
                                              Helper.capitalizeFirstLetter(
                                                  controller
                                                      .itemData
                                                      .value
                                                      .data!
                                                      .menuItemInfo!
                                                      .itemQuantity!
                                                      .replaceAll("_", " ")),
                                              style: TextStyle(
                                                  color:
                                                      AppColors.jetBlackColor,
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: 15)),
                                          Text(
                                              controller.listData.value.data![i]
                                                  .price!,
                                              style: TextStyle(
                                                  color:
                                                      AppColors.jetBlackColor,
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: 15)),
                                          Row(
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  controller.isEditing.value =
                                                      true;
                                                  controller
                                                          .selectedEditItemId =
                                                      controller
                                                              .quantityController
                                                              .text =
                                                          controller.listData
                                                              .value.data![i].id
                                                              .toString();
                                                  controller.quantityController
                                                      .text = controller
                                                          .listData
                                                          .value
                                                          .data![i]
                                                          .quantity ??
                                                      "";
                                                  controller.priceController
                                                      .text = controller
                                                          .listData
                                                          .value
                                                          .data![i]
                                                          .price ??
                                                      "";
                                                  controller.selectedVendor
                                                          .value =
                                                      controller.vendorList
                                                          .firstWhere(
                                                    (chef) =>
                                                        chef.id ==
                                                        controller
                                                            .listData
                                                            .value
                                                            .data![i]
                                                            .vendorId,
                                                  );
                                                },
                                                child: Icon(
                                                  Icons.edit,
                                                  size: 20,
                                                  color: AppColors.newOrderGrey,
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  controller
                                                          .deleteVendor.value =
                                                      controller.vendorList
                                                          .firstWhere((chef) =>
                                                              chef.id ==
                                                              controller
                                                                  .listData
                                                                  .value
                                                                  .data![i]
                                                                  .vendorId);
                                                  controller.deletePriceSlab(
                                                    controller.listData.value
                                                        .data![i].id
                                                        .toString(),
                                                    context,
                                                  );
                                                },
                                                child: Icon(
                                                  Icons.delete,
                                                  size: 20,
                                                  color: AppColors.newOrderGrey,
                                                ),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      )
                                    }
                                  ],
                                )
                              : const SizedBox(),
                        ),
                      )
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
