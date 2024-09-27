import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/contstants.dart';
import '../../../../model/requested_item_list_model.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/helper.dart';
import '../../../../utils/widget/app_bar.dart';
import '../../../../utils/widget/custom_textfiled.dart';
import '../../../../utils/widget/no_data.dart';
import '../../vendor_requested_item/price_slab/add_price_slab.dart';
import 'vendor_approved_item_controller.dart';

class VenderApprovedItemList extends StatefulWidget {
  String id;
  VenderApprovedItemList({super.key, required this.id});

  @override
  State<VenderApprovedItemList> createState() => _VenderApprovedItemListState();
}

class _VenderApprovedItemListState extends State<VenderApprovedItemList> {
  vendorApprovedController controller = vendorApprovedController();
  ScrollController _scrollController = ScrollController();
  Future<void> _scrollListener() async {
    print(_scrollController.position.extentAfter);
    if (_scrollController.position.extentAfter < 5) {
      if (controller.isMoreLoading.isFalse) {
        int Totalpage = int.parse(
            controller.requestedItemList.value.data!.totalPages!.toString());
        int currntPage = int.parse(
            controller.requestedItemList.value.data!.currentPage!.toString());
        int page = Totalpage > currntPage ? ++currntPage : 0;
        if (page != 0) {
          controller.getItemList(
            true,
            page.toString(),
            true,
          );
        }
      }
    }
  }

  @override
  void initState() {
    controller.vendorID = widget.id;
    _scrollController = ScrollController()..addListener(_scrollListener);
    controller.itemtextController.addListener(controller.onTextChangedList);
    controller.getItemList(
      false,
      "1",
      true,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(text: "Approved Item List"),
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 13),
                      child: Text(
                        "Result: ${controller.requestedItemList.value.data!.totalRecords.toString()}",
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w600),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    CustomTextField(
                        fillColor: AppColors.lightGreyColor,
                        controller: controller.itemtextController,
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: controller.itemtextController.text != ""
                            ? InkWell(
                                onTap: () {
                                  controller.itemtextController.clear();
                                },
                                child: const Icon(Icons.cancel))
                            : null,
                        hintText: "Search for Item"),
                    const SizedBox(
                      height: 15,
                    ),
                    controller.requestedItemList.value.data!.itemsList!.isEmpty
                        ? Column(
                            children: [
                              SizedBox(height: Get.height * 0.15),
                              noData(),
                            ],
                          )
                        : Expanded(
                            child: ListView.separated(
                                separatorBuilder: (context, index) {
                                  return const SizedBox(
                                    height: 10,
                                  );
                                },
                                controller: _scrollController,
                                itemCount: controller.requestedItemList.value
                                    .data!.itemsList!.length,
                                itemBuilder: (context, index) {
                                  return InkWell(
                                    onTap: () async {
                                      await Get.to(() => AddPriceSlabScreen(
                                                requestedData: controller
                                                    .requestedItemList
                                                    .value
                                                    .data!
                                                    .itemsList![index],
                                                    fromApproved: true,
                                              ))!
                                          .then((value) {
                                        controller.getItemList(
                                          false,
                                          "1",
                                          false,
                                        );
                                      });
                                    },
                                    child: vendorListDataWidget(
                                      data: controller.requestedItemList.value
                                          .data!.itemsList![index],
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

  ItemsList data;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      decoration: BoxDecoration(
          color: AppColors.textWhiteColor,
          border: Border.all(width: 1, color: AppColors.newOrderGrey),
          borderRadius: BorderRadius.circular(22)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
                color: AppColors.lightGreyColor,
                borderRadius: BorderRadius.circular(15)),
            height: 100,
            width: 95,
            child: Image.network(Constants.webUrl + data.profileImage!),
          ),
          const SizedBox(
            width: 15,
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.itemName!,
                  maxLines: 1,
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w600),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  data.description ?? "",
                  maxLines: 3,
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.normal),
                ),
                const SizedBox(
                  height: 10,
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: AppColors.appColor),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 13),
                      child: Text(
                        Helper.capitalizeFirstLetter("View Price Slab"),
                        style: const TextStyle(
                            fontSize: 10,
                            color: Colors.white,
                            fontWeight: FontWeight.w600),
                      ),
                    )),
              ],
            ),
          ),
        ],
      ),
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
