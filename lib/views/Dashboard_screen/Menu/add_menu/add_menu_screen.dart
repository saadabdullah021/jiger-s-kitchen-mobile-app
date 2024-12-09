import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jigers_kitchen/utils/app_colors.dart';
import 'package:jigers_kitchen/utils/helper.dart';
import 'package:jigers_kitchen/utils/widget/app_bar.dart';
import 'package:jigers_kitchen/views/Dashboard_screen/Menu/add_menu/add_menu_controller.dart';

import '../../../../utils/widget/app_button.dart';
import '../../../../utils/widget/custom_drop_down_widget.dart';
import '../../../../utils/widget/custom_textfiled.dart';

class AddMenuScreen extends StatefulWidget {
  bool? isEdit;
  String? id;
  AddMenuScreen({super.key, this.isEdit, this.id});

  @override
  State<AddMenuScreen> createState() => _AddMenuScreenState();
}

class _AddMenuScreenState extends State<AddMenuScreen> {
  final AddMenuController _controller = Get.put(AddMenuController());
  final GlobalKey<FormState> key = GlobalKey();
  @override
  void initState() {
    _controller.isEdit = widget.isEdit;
    _controller.editId = widget.id;
    _controller.getAllData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(text: "Menu"),
      body: Obx(
        () => _controller.isLoading.isTrue
            ? Center(
                child: CircularProgressIndicator(
                  color: AppColors.primaryColor,
                ),
              )
            : SingleChildScrollView(
                child: Form(
                  key: key,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Add New Item",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        CustomTextField(
                            validator: Helper.validateEmpty,
                            controller: _controller.itemNameController,
                            hintText: "Enter Item Name"),
                        const SizedBox(
                          height: 20,
                        ),
                        CustomDropdownSearch(
                            showSearch: true,
                            height: Get.height * 0.4,
                            items: _controller.chefList,
                            hintText: "Chef",
                            onChanged: (value) {
                              _controller.selectedChef = value;
                              // _controller.chefNameController.text = value!;
                            },
                            selectedItem: _controller.selectedChef),
                        const SizedBox(
                          height: 20,
                        ),
                        CustomDropdownSearch(
                          showSearch: true,
                          height: Get.height * 0.25,
                          items: _controller.menuList,
                          hintText: "Menu",
                          onChanged: (value) {
                            setState(() {
                              _controller.selectedMenu = value!;
                            });
                          },
                          selectedItem: _controller.selectedMenu,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        CustomDropdownSearch(
                          showSearch: false,
                          items: _controller.menuTypeList,
                          height: Get.height * 0.1,
                          hintText: "Menu Type",
                          onChanged: (value) {
                            setState(() {
                              _controller.selectedMenuType = value!;
                            });
                          },
                          selectedItem: _controller.selectedMenuType,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Visibility(
                          visible: _controller.selectedMenu!.id == 8,
                          child: CustomTextField(
                              validator: _controller.selectedMenu!.id == 8
                                  ? Helper.validateEmpty
                                  : null,
                              controller: _controller.liveStationController,
                              hintText: "Live Station Name"),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          height: 30,
                          width: Get.width,
                          child: ListView.separated(
                              separatorBuilder: (context, index) {
                                return const SizedBox(
                                  width: 5,
                                );
                              },
                              scrollDirection: Axis.horizontal,
                              itemCount: _controller.typeList.length,
                              itemBuilder: (context, index) {
                                return Obx(
                                  () => InkWell(
                                    onTap: () {
                                      if (index == 0) {
                                        _controller.isWholeseller.value = true;
                                      } else if (index == 1) {
                                        _controller.isWholeseller.value = false;
                                      } else if (index == 2) {
                                        _controller.isVeg.value = true;
                                      } else if (index == 3) {
                                        _controller.isVeg.value = false;
                                      }
                                    },
                                    child: Container(
                                      height: 30,
                                      width: 92,
                                      padding: const EdgeInsets.all(2),
                                      decoration: BoxDecoration(
                                          color: _controller.isWholeseller
                                                          .isTrue &&
                                                      index == 0 ||
                                                  _controller.isWholeseller
                                                          .isFalse &&
                                                      index == 1 ||
                                                  _controller.isVeg.isTrue &&
                                                      index == 2 ||
                                                  _controller.isVeg.isFalse &&
                                                      index == 3
                                              ? AppColors.primaryColor
                                              : AppColors.textGreyColor,
                                          borderRadius:
                                              BorderRadius.circular(30)),
                                      child: Center(
                                          child: Text(
                                        maxLines: 1,
                                        _controller.typeList[index].name!,
                                        style: TextStyle(
                                            color: _controller.isWholeseller
                                                            .isTrue &&
                                                        index == 0 ||
                                                    _controller.isWholeseller
                                                            .isFalse &&
                                                        index == 1 ||
                                                    _controller.isVeg.isTrue &&
                                                        index == 2 ||
                                                    _controller.isVeg.isFalse &&
                                                        index == 3
                                                ? Colors.white
                                                : Colors.black,
                                            fontSize: 12),
                                      )),
                                    ),
                                  ),
                                );
                              }),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        CustomDropdownSearch(
                          showSearch: false,
                          items: _controller.quantityList,
                          hintText: "Quantity",
                          height: Get.height * 0.25,
                          onChanged: (value) {
                            _controller.selectedQuantity = value!;
                          },
                          selectedItem: _controller.selectedQuantity,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        CustomTextField(
                            validator: Helper.validateEmpty,
                            controller: _controller.itemDescriptionController,
                            hintText: "Enter Item Description"),
                        const SizedBox(
                          height: 20,
                        ),
                        CustomTextField(
                            validator: Helper.validateEmpty,
                            controller: _controller.itemNotesController,
                            hintText: "Enter Item Notes"),
                        const SizedBox(
                          height: 20,
                        ),
                        CustomButton(
                            text: widget.isEdit == true
                                ? "Update Item"
                                : "Add Item",
                            onPressed: () {
                              if (key.currentState?.validate() ?? false) {
                                widget.isEdit == true
                                    ? _controller.editMenu()
                                    : _controller.addMEnu();
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
