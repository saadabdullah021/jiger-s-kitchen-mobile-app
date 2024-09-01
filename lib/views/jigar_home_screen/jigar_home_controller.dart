import 'package:get/get.dart';
import 'package:jigers_kitchen/utils/app_images.dart';
import 'package:jigers_kitchen/views/Dashboard_screen/dashboard_screen.dart';

import '../Dashboard_screen/Chef/chef_list/chef_list_screen.dart';
import '../Dashboard_screen/Vendor/all_vendor_screen.dart';

class HomeController extends GetxController {
  List<Map<String, dynamic>> homeItems = [
    {"img": AppImages.home1Image, "name": "Dashboard"},
    {"img": AppImages.home2Image, "name": "Menu"},
    {"img": AppImages.home3Image, "name": "Vendor Request\nItem"},
    {"img": AppImages.home4Image, "name": "Chef"},
    {"img": AppImages.home5Image, "name": "Vendors"},
    {"img": AppImages.home6Image, "name": "Admin User"},
    {"img": AppImages.home7Image, "name": "Delivery"},
    {"img": AppImages.home8Image, "name": "Order History"},
    {"img": AppImages.home9Image, "name": "Reports"},
    {"img": AppImages.home10Image, "name": "Purchase Order\nReport"},
  ];
  void onItemTap(int index) {
    switch (index) {
      case 0:
        Get.to(() => const DashboardScreen());
        break;
      case 3:
        Get.to(() => const AllChefListScreen());
        break;
      case 4:
        Get.to(() => const AllVendorListScreen());
        break;
      default:
    }
  }
}
