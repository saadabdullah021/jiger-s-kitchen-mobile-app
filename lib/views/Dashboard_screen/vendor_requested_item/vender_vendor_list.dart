import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jigers_kitchen/utils/app_colors.dart';
import 'package:jigers_kitchen/utils/widget/app_bar.dart';
import 'package:jigers_kitchen/views/Dashboard_screen/vendor_requested_item/vendor_request_controller.dart';
import 'package:jigers_kitchen/views/Dashboard_screen/vendor_requested_item/view_request_list.dart';

import '../../../../utils/widget/custom_textfiled.dart';
import '../../../core/contstants.dart';
import '../../../model/user_list_model.dart';
import '../../../utils/helper.dart';
import '../../../utils/widget/no_data.dart';

class VenderRequestItem extends StatefulWidget {
  const VenderRequestItem({super.key});

  @override
  State<VenderRequestItem> createState() => _VenderRequestItemState();
}

class _VenderRequestItemState extends State<VenderRequestItem> {
  vendorRequestController controller = vendorRequestController();
  ScrollController _scrollController = ScrollController();
  Future<void> _scrollListener() async {
    print(_scrollController.position.extentAfter);
    if (_scrollController.position.extentAfter < 5) {
      if (controller.isMoreLoading.isFalse) {
        int Totalpage = controller.userList.value.data!.totalPages!;
        int currntPage = controller.userList.value.data!.currentPage!;
        int page = Totalpage > currntPage ? ++currntPage : 0;
        if (page != 0) {
          controller.getList(true, page.toString(), true);
        }
      }
    }
  }

  @override
  void initState() {
    _scrollController = ScrollController()..addListener(_scrollListener);
    controller.textController.addListener(controller.onTextChanged);
    controller.getList(false, "1", true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(text: "Requested Vendor List"),
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
                        "Result: ${controller.userList.value.data!.totalRecords.toString()}",
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w600),
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
                                  return Card(
                                    color: AppColors.textGreyColor,
                                    child: Padding(
                                      padding: const EdgeInsets.all(13),
                                      child: vendorListDataWidget(
                                        data: controller.userList.value.data!
                                            .chefList![index],
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
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  iconTextWidget(
                    icon: null,
                    text: data.name ?? "",
                  ),
                  const SizedBox(
                    height: 10,
                  ),
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
        ),
        const SizedBox(
          height: 10,
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: InkWell(
            onTap: () {
              Get.to(VenderRequestItemList(
                id: data.id.toString(),
              ));
            },
            child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: AppColors.appColor),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 13),
                  child: Text(
                    Helper.capitalizeFirstLetter("View Request" ""),
                    style: const TextStyle(
                        fontSize: 10,
                        color: Colors.white,
                        fontWeight: FontWeight.w600),
                  ),
                )),
          ),
        ),
      ],
    );
  }
}

Widget iconTextWidget({
  required String text,
  IconData? icon,
}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      Visibility(
        visible: icon != null,
        child: CircleAvatar(
            radius: 12,
            backgroundColor: Colors.white,
            child: Icon(icon, size: 12, color: AppColors.newOrderGrey)),
      ),
      const SizedBox(width: 5),
      Expanded(
        child: Text(
          text,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
              fontSize: 13,
              color: AppColors.newOrderGrey,
              fontWeight: FontWeight.w600),
        ),
      ),
    ],
  );
}
