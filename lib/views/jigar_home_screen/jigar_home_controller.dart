import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:jigers_kitchen/common/common.dart';
import 'package:jigers_kitchen/utils/app_images.dart';
import 'package:jigers_kitchen/utils/app_keys.dart';
import 'package:jigers_kitchen/utils/local_db_helper.dart';
import 'package:jigers_kitchen/views/Dashboard_screen/Menu/menu_list/menu_list.dart';
import 'package:jigers_kitchen/views/Dashboard_screen/admins/admin_list.dart';
import 'package:jigers_kitchen/views/Dashboard_screen/dashboard_screen.dart';

import '../../core/apis/app_interface.dart';
import '../../utils/widget/appwidgets.dart';
import '../../utils/widget/delete_item_dialoug.dart';
import '../Dashboard_screen/Vendor/all_vendor_screen.dart';
import '../Dashboard_screen/chef_and_delivery_boy/chef_list/chef_list_screen.dart';
import '../Dashboard_screen/order_list/view_order_list.dart';
import '../Dashboard_screen/reports/select_date.dart';
import '../Dashboard_screen/vendor_requested_item/vender_vendor_list.dart';
import '../auth/login/login_screen.dart';

class HomeController extends GetxController {
  List<Map<String, dynamic>> drawerExtraItems = [
    {"img": AppImages.home6Image, "name": "My Profile", "show": true},
    {
      "img": AppImages.home6Image,
      "name": "Delete Account",
    },
    {"img": AppImages.logout, "name": "Logout", "show": true},
  ];
  List<Map<String, dynamic>> homeItems = [
    {
      "img": AppImages.home1Image,
      "name": "Dashboard",
      "show": Common.currentRole == AppKeys.roleAdmin ||
              Common.currentRole == "chef"
          ? true
          : false,
      "show_drawer": true
    },
    {
      "img": AppImages.home2Image,
      "name": "Menu",
      "show": Common.currentRole == AppKeys.roleAdmin ? true : false,
      "show_drawer": true
    },
    {
      "img": AppImages.home3Image,
      "name": "Vendor Request\nItem",
      "show": Common.currentRole == AppKeys.roleAdmin ? true : false,
      "show_drawer": false
    },
    {
      "img": AppImages.home4Image,
      "name": "Chef",
      "show": Common.currentRole == AppKeys.roleAdmin ? true : false,
      "show_drawer": false
    },
    {
      "img": AppImages.home5Image,
      "name": "Vendors",
      "show": Common.currentRole == AppKeys.roleAdmin ? true : false,
      "show_drawer": true
    },
    {
      "img": AppImages.home6Image,
      "name": "Admin User",
      "show": Common.currentRole == AppKeys.roleAdmin ? true : false,
      "show_drawer": true
    },
    {
      "img": AppImages.home7Image,
      "name": "Delivery",
      "show": Common.currentRole == AppKeys.roleAdmin ? true : false,
      "show_drawer": true
    },
    {
      "img": AppImages.home8Image,
      "name": "Order History",
      "show": Common.currentRole == AppKeys.roleAdmin ? true : false,
      "show_drawer": true
    },
    {
      "img": AppImages.home9Image,
      "name": "Reports",
      "show": Common.currentRole == AppKeys.roleAdmin ? true : false,
      "show_drawer": false
    },
    {
      "img": AppImages.home10Image,
      "name": "Purchase Order\nReport",
      "show": Common.currentRole == AppKeys.roleAdmin ? true : false,
      "show_drawer": false
    },

    ///..
    {
      "img": AppImages.home2Image,
      "name": "New Order",
      "show": Common.currentRole == "vendor" ? true : false,
      "show_drawer": true
    },
    {
      "img": AppImages.clock,
      "name": "Live Station",
      "show": Common.currentRole == AppKeys.roleAdmin
          ? false
          : Common.loginReponse.value.data!.vendorCategory ==
                  AppKeys.vendorTypeCatring
              ? true
              : false,
      "show_drawer": true
    },
    {
      "img": AppImages.home2Image,
      "name": "Order List",
      "show": Common.currentRole == AppKeys.roleAdmin ||
              Common.currentRole == "chef" ||
              Common.currentRole == "delivery_user"
          ? false
          : true,
      "show_drawer": true
    },
    {
      "img": AppImages.home2Image,
      "name": "Request Item",
      "show": Common.currentRole == AppKeys.roleAdmin
          ? false
          : Common.currentRole == AppKeys.roleAdmin
              ? false
              : Common.loginReponse.value.data!.vendorCategory ==
                      AppKeys.vendorTypeWholeSeller
                  ? true
                  : false,
      "show_drawer": true
    },
  ];
  void onItemTap(int index) {
    switch (index) {
      case 0:
        Get.to(() => const DashboardScreen());
        break;
      case 1:
        Get.to(() => MenuListScreen(
              screenType: "",
            ));
        break;
      case 2:
        Get.to(() => const VenderRequestItem());
        break;
      case 3:
        Get.to(() => AllChefListScreen());
        break;
      case 4:
        Get.to(() => const AllVendorListScreen());
        break;
      case 5:
        Get.to(() => const AdminList());
        break;
      case 6:
        Get.to(() => AllChefListScreen(
              type: AppKeys.userTypeDelivery,
            ));
        break;
      case 7:
        Get.to(() => OrderListScreen());
        break;
      case 9:
        Get.to(() => SelectReportDate());
        break;
      case 10:
        Get.to(() => MenuListScreen(
              addToCard: true,
              screenType: "new_order",
            ));
      case 12:
        Get.to(() => OrderListScreen(
              status: "",
            ));
        break;
      case 13:
        Get.to(() => MenuListScreen(
              screenType: "request_item",
            ));
        break;
    }
  }

  deleteAccount(BuildContext context) async {
    showDeleteItemDialoug(
        description: "Are you sure you want to DELETE the Account?",
        context: context,
        url: Common.loginReponse.value.data!.profileImage!,
        onYes: () async {
          Get.back();
          appWidgets.loadingDialog();
          await AppInterface().deleteAccount().then((value) {
            if (value == 200) {
              appWidgets.hideDialog();
              Get.back();
              SharedPref.getInstance().clearSF();
              SharedPref.getInstance().addBoolToSF(AppKeys.isFirstTime, false);
              Get.offAll(const LoginScreen());
            }
          });
        });
  }
}
