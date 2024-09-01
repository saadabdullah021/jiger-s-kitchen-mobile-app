import 'package:get/get.dart';
import 'package:jigers_kitchen/utils/app_colors.dart';
import 'package:jigers_kitchen/views/new_order_screens/new_order_list/new_order_list_screen.dart';

import '../../utils/app_images.dart';

class DashboardController extends GetxController {
  onItemClick(int index) {
    switch (index) {
      case 0:
        Get.to(() => const NewOrderListScreen());
        break;

      default:
    }
  }

  List<Map<String, dynamic>> DashBoardItems = [
    {
      "img": AppImages.dashboard1,
      "name": "New Orders",
      "color": AppColors.dashBoardText1,
      "bgColor": AppColors.dashBoardBg1,
      "count": 235,
      "onTap": () {
        Get.to(() => const NewOrderListScreen());
      }
    },
    {
      "img": AppImages.dashboard2,
      "name": "Pick Up",
      "color": AppColors.dashBoardText2,
      "bgColor": AppColors.dashBoardBg2,
      "count": 12,
      "onTap": () {}
    },
    {
      "img": AppImages.dashboard3,
      "name": "Out for delivery",
      "color": AppColors.dashBoardText3,
      "bgColor": AppColors.dashBoardBg3,
      "count": 3,
      "onTap": () {}
    },
    {
      "img": AppImages.dashboard4,
      "name": "Delivered",
      "color": AppColors.dashBoardText4,
      "bgColor": AppColors.dashBoardBg4,
      "count": 20,
      "onTap": () {}
    },
    {
      "img": AppImages.dashboard5,
      "name": "Cancelled",
      "color": AppColors.dashBoardText5,
      "bgColor": AppColors.dashBoardBg5,
      "count": 8,
      "onTap": () {}
    },
    {
      "img": AppImages.dashboard6,
      "name": "Paid",
      "color": AppColors.dashBoardText6,
      "bgColor": AppColors.dashBoardBg6,
      "count": 15,
      "onTap": () {}
    },
    {
      "img": AppImages.dashboard7,
      "name": "In-Progress",
      "color": AppColors.dashBoardText7,
      "bgColor": AppColors.dashBoardBg7,
      "count": 7,
      "onTap": () {}
    },
  ];
}
