import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jigers_kitchen/utils/app_colors.dart';
import 'package:jigers_kitchen/utils/helper.dart';
import 'package:jigers_kitchen/utils/widget/app_bar.dart';
import 'package:jigers_kitchen/views/Dashboard_screen/Vendor/all_vendor_controller.dart';
import 'package:jigers_kitchen/views/auth/signup/signup_screen.dart';

import '../../../../utils/widget/custom_textfiled.dart';
import '../../../core/apis/app_interface.dart';
import '../../../core/contstants.dart';
import '../../../model/user_list_model.dart';
import '../../../utils/app_images.dart';
import '../../../utils/widget/appwidgets.dart';
import '../../../utils/widget/delete_item_dialoug.dart';
import '../../../utils/widget/no_data.dart';
import '../../../utils/widget/success_dialoug.dart';
import '../../new_order_screens/new_order_widgets.dart';
import 'vendor_approved_item/vendor_approved_item.dart';

class AllVendorListScreen extends StatefulWidget {
  bool? isBottomSheet;
  Function(ChefList)? onChefSelected;
  AllVendorListScreen({super.key, this.isBottomSheet, this.onChefSelected});

  @override
  State<AllVendorListScreen> createState() => _AllVendorListScreenState();
}

class _AllVendorListScreenState extends State<AllVendorListScreen> {
  vendorListController controller = vendorListController();
  ScrollController _scrollController = ScrollController();
  Future<void> _scrollListener() async {
    print(_scrollController.position.extentAfter);
    if (_scrollController.position.extentAfter < 5) {
      if (controller.isMoreLoading.isFalse) {
        int Totalpage = controller.userList.value.data!.totalPages!;
        int currntPage = controller.userList.value.data!.currentPage!;
        int page = Totalpage > currntPage ? ++currntPage : 0;
        if (page != 0) {
          controller.getChef(true, page.toString(), true);
        }
      }
    }
  }

  @override
  void initState() {
    _scrollController = ScrollController()..addListener(_scrollListener);
    controller.textController.addListener(controller.onTextChanged);
    controller.getChef(false, "1", true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.isBottomSheet != true ? appBar(text: "Vendor List") : null,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
        child: Obx(
          () => controller.isLoading.isTrue
              ? Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primaryColor,
                  ),
                )
              : Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 13),
                      child: Visibility(
                        visible: widget.isBottomSheet != true,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Result: ${controller.userList.value.data!.totalRecords.toString()}",
                              style: const TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w600),
                            ),
                            InkWell(
                              onTap: () async {
                                await Get.to(() => SignUpScreen(
                                          addVendor: true,
                                        ))!
                                    .then((value) {
                                  controller.getChef(false, "1", false);
                                });
                              },
                              child: Row(
                                children: [
                                  Container(
                                      height: 15,
                                      width: 15,
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 1,
                                              color: AppColors.jetBlackColor),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: const Center(
                                          child: Icon(
                                        Icons.add,
                                        size: 12,
                                      ))),
                                  const SizedBox(
                                    width: 2,
                                  ),
                                  const Text(
                                    " Add Vendor",
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    CustomTextField(
                        fillColor: AppColors.lightGreyColor,
                        controller: controller.textController,
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: controller.textController.text != ""
                            ? InkWell(
                                onTap: () {
                                  controller.textController.clear();
                                },
                                child: const Icon(Icons.cancel))
                            : null,
                        hintText: "Search for Vendor"),
                    const SizedBox(
                      height: 15,
                    ),
                    controller.userList.value.data!.chefList!.isEmpty
                        ? Column(
                            children: [
                              SizedBox(height: Get.height * 0.15),
                              noData(null),
                            ],
                          )
                        : Expanded(
                            child: ListView.builder(
                                controller: _scrollController,
                                itemCount: controller
                                    .userList.value.data!.chefList!.length,
                                itemBuilder: (context, index) {
                                  return InkWell(
                                    onTap: () {
                                      widget.onChefSelected != null
                                          ? widget.onChefSelected!(controller
                                              .userList
                                              .value
                                              .data!
                                              .chefList![index])
                                          : Get.to(() => VenderApprovedItemList(
                                                id: controller.userList.value
                                                    .data!.chefList![index].id
                                                    .toString(),
                                              ));
                                    },
                                    child: Card(
                                      color: AppColors.textGreyColor,
                                      child: Padding(
                                        padding: const EdgeInsets.all(13),
                                        child: ExpandablePanel(
                                            theme: ExpandableThemeData(
                                                iconColor:
                                                    AppColors.primaryColor),
                                            header: Text(
                                              controller.userList.value.data!
                                                      .chefList![index].name ??
                                                  "",
                                              style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            collapsed: vendorListDataWidget(
                                              data: controller.userList.value
                                                  .data!.chefList![index],
                                            ),
                                            expanded: Column(
                                              children: [
                                                vendorListDataWidget(
                                                  data: controller
                                                      .userList
                                                      .value
                                                      .data!
                                                      .chefList![index],
                                                ),
                                                const SizedBox(
                                                  height: 20,
                                                ),
                                                Visibility(
                                                  visible:
                                                      widget.isBottomSheet !=
                                                          true,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    children: [
                                                      NewOrderButtonWidget(
                                                        ic: Icons.edit,
                                                        text: "Edit",
                                                        clr: AppColors
                                                            .primaryColor,
                                                        ontap: () async {
                                                          await Get.to(
                                                                  SignUpScreen(
                                                            isEdit: true,
                                                            chefID: controller
                                                                .userList
                                                                .value
                                                                .data!
                                                                .chefList![
                                                                    index]
                                                                .id
                                                                .toString(),
                                                            addVendor: true,
                                                          ))!
                                                              .then((value) {
                                                            controller.getChef(
                                                                false,
                                                                controller
                                                                    .userList
                                                                    .value
                                                                    .data!
                                                                    .currentPage!
                                                                    .toString(),
                                                                false);
                                                          });
                                                        },
                                                      ),
                                                      NewOrderButtonWidget(
                                                        ic: Icons.delete,
                                                        text: "Delete",
                                                        ontap: () {
                                                          showDeleteItemDialoug(
                                                              description:
                                                                  "Are you sure you want to DELETE the Vendor?",
                                                              context: context,
                                                              url: controller
                                                                  .userList
                                                                  .value
                                                                  .data!
                                                                  .chefList![
                                                                      index]
                                                                  .profileImage,
                                                              onYes: () async {
                                                                Get.back();
                                                                appWidgets
                                                                    .loadingDialog();
                                                                await AppInterface()
                                                                    .deleteUser(
                                                                  role:
                                                                      "vendor",
                                                                  id: controller
                                                                      .userList
                                                                      .value
                                                                      .data!
                                                                      .chefList![
                                                                          index]
                                                                      .id
                                                                      .toString(),
                                                                )
                                                                    .then(
                                                                        (value) {
                                                                  if (value !=
                                                                          null &&
                                                                      value ==
                                                                          200) {
                                                                    controller.getChef(
                                                                        false,
                                                                        controller
                                                                            .userList
                                                                            .value
                                                                            .data!
                                                                            .currentPage
                                                                            .toString(),
                                                                        false);
                                                                    appWidgets
                                                                        .hideDialog();
                                                                    showDialogWithAutoDismiss(
                                                                        context: Get
                                                                            .context,
                                                                        doubleBack:
                                                                            false,
                                                                        img: AppImages
                                                                            .successDialougIcon,
                                                                        autoDismiss:
                                                                            true,
                                                                        heading:
                                                                            "Hurray!",
                                                                        text:
                                                                            "Vendor Deleted Successfully",
                                                                        headingStyle: TextStyle(
                                                                            fontSize:
                                                                                32,
                                                                            fontWeight:
                                                                                FontWeight.w600,
                                                                            color: AppColors.textBlackColor));
                                                                  }
                                                                });
                                                              });
                                                        },
                                                        clr: AppColors.redColor,
                                                      ),
                                                      NewOrderButtonWidget(
                                                        ic: Icons.receipt,
                                                        text: "Orders",
                                                        ontap: () {},
                                                        clr: AppColors
                                                            .orangeColor,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            )),
                                      ),
                                    ),
                                  );
                                }),
                          ),
                    controller.isMoreLoading.isTrue
                        ? Center(
                            child: CircularProgressIndicator(
                              color: AppColors.primaryColor,
                            ),
                          )
                        : const SizedBox()
                  ],
                ),
        ),
      ),
    );
  }
}

class vendorListDataWidget extends StatelessWidget {
  vendorListDataWidget({super.key, required this.data});

  ChefList data;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              iconTextWidget(
                icon: Icons.email,
                text: data.email ?? "",
              ),
              const SizedBox(
                height: 10,
              ),
              iconTextWidget(
                icon: Icons.phone_callback,
                text: data.phoneNumber ?? "",
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.white),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 13),
                    child: Text(
                      Helper.capitalizeFirstLetter(data.vendorType ?? ""),
                      style: const TextStyle(
                          fontSize: 10,
                          color: Colors.black,
                          fontWeight: FontWeight.w600),
                    ),
                  )),
            ],
          ),
        ),
        CircleAvatar(
          radius: 30,
          backgroundColor: Colors.white,
          backgroundImage: data.profileImage != null
              ? NetworkImage(Constants.webUrl + data.profileImage!)
              : null,
        )
      ],
    );
  }
}

Widget iconTextWidget({
  required String text,
  required IconData icon,
}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      CircleAvatar(
          radius: 12,
          backgroundColor: Colors.white,
          child: Icon(icon, size: 12, color: AppColors.newOrderGrey)),
      const SizedBox(width: 5),
      Expanded(
        child: Text(
          text,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
              fontSize: 11,
              color: AppColors.newOrderGrey,
              fontWeight: FontWeight.w600),
        ),
      ),
    ],
  );
}
