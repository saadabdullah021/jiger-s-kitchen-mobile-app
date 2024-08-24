import 'package:get/get.dart';
import 'package:jigers_kitchen/utils/app_colors.dart';

import '../../utils/app_images.dart';

class DashboardController extends GetxController {
  List<Map<String, dynamic>> DashBoardItems = [
    {
      "img": AppImages.dashboard1,
      "name": "New Orders",
      "color": AppColors.dashBoardText1,
      "bgColor": AppColors.dashBoardBg1,
      "count": 235,
    },
    {
      "img": AppImages.dashboard2,
      "name": "Pick Up",
      "color": AppColors.dashBoardText2,
      "bgColor": AppColors.dashBoardBg2,
      "count": 12,
    },
    {
      "img": AppImages.dashboard3,
      "name": "Out for delivery",
      "color": AppColors.dashBoardText3,
      "bgColor": AppColors.dashBoardBg3,
      "count": 3,
    },
    {
      "img": AppImages.dashboard4,
      "name": "Delivered",
      "color": AppColors.dashBoardText4,
      "bgColor": AppColors.dashBoardBg4,
      "count": 20,
    },
    {
      "img": AppImages.dashboard5,
      "name": "Cancelled",
      "color": AppColors.dashBoardText5,
      "bgColor": AppColors.dashBoardBg5,
      "count": 8,
    },
    {
      "img": AppImages.dashboard6,
      "name": "Paid",
      "color": AppColors.dashBoardText6,
      "bgColor": AppColors.dashBoardBg6,
      "count": 15,
    },
    {
      "img": AppImages.dashboard7,
      "name": "In-Progress",
      "color": AppColors.dashBoardText7,
      "bgColor": AppColors.dashBoardBg7,
      "count": 7,
    },
  ];
}
