import 'package:get/get.dart';
import 'package:jigers_kitchen/common/common.dart';
import 'package:jigers_kitchen/core/apis/app_interface.dart';
import 'package:jigers_kitchen/model/dashboad_counter_model.dart';
import 'package:jigers_kitchen/utils/app_colors.dart';
import 'package:jigers_kitchen/views/new_order_screens/new_order_list/new_order_list_screen.dart';

import '../../utils/app_images.dart';
import '../new_order_screens/chef_order.dart/view_chef_order_list.dart';
import 'order_list/view_order_list.dart';

class DashboardController extends GetxController {
  RxBool isLoading = false.obs;
  @override
  getCount(bool showLoading) async {
    if (showLoading) {
      isLoading.value = true;
    }

    await AppInterface().getDashBoardCounter().then((dashboardCounter) {
      if (dashboardCounter is dashBoardCounterModel) {
        if (dashboardCounter.data != null) {
          // Update each item based on the API response
          for (var item in DashBoardItems) {
            switch (item['key']) {
              case 'new_orders':
                item['count'] = dashboardCounter.data!.newOrders ?? 0;
                break;
              case 'pickup_orders':
                item['count'] = dashboardCounter.data!.pickupOrders ?? 0;
                break;
              case 'out_of_delivery':
                item['count'] = dashboardCounter.data!.outOfDelivery ?? 0;
                break;
              case 'delivered_orders':
                item['count'] = dashboardCounter.data!.deliveredOrders ?? 0;
                break;
              case 'cancelled_orders':
                item['count'] = dashboardCounter.data!.cancelledOrders ?? 0;
                break;
              case 'paid_orders':
                item['count'] = dashboardCounter.data!.paidOrders ?? 0;
                break;
              case 'in_progress_orders':
                item['count'] = dashboardCounter.data!.inProgressOrders ?? 0;
                break;
            }
          }
          isLoading.value = false;
        }
      }
    });
  }

  onItemClick(int index) {
    switch (index) {
      case 0:
        Common.currentRole == "chef"
            ? Get.to(() => ChefOrderListScreen(
                  status: "new_order",
                ))
            : Common.currentRole == "delivery_user"
                ? Get.to(OrderListScreen(
                    status: "new_order",
                  ))
                : Get.to(() => const newOrderListScreen());
        break;
      case 1:
        Get.to(OrderListScreen(
          status: "pick_up",
        ));
        break;
      case 2:
        Get.to(OrderListScreen(
          status: "out_for_delivery",
        ));
        break;
      case 3:
        Common.currentRole == "chef"
            ? Get.to(() => ChefOrderListScreen(
                  status: "completed",
                ))
            : Get.to(OrderListScreen(
                status: "delivered",
              ));
        break;
      case 4:
        Common.currentRole == "chef"
            ? Get.to(() => ChefOrderListScreen(
                  status: "cancelled",
                ))
            : Get.to(OrderListScreen(
                status: "cancelled",
              ));
        break;
      case 5:
        Get.to(OrderListScreen(
          status: "paid",
        ));
        break;
      case 6:
        Common.currentRole == "chef"
            ? Get.to(() => ChefOrderListScreen(
                  status: "in_preparation",
                ))
            : Get.to(OrderListScreen(
                status: "in_progress",
              ));
        break;

      default:
    }
  }

  List<Map<String, dynamic>> DashBoardItems = [
    {
      "img": AppImages.dashboard1,
      "name": "New Orders",
      "key": "new_orders",
      "color": AppColors.dashBoardText1,
      "bgColor": AppColors.dashBoardBg1,
      "count": 0,
      "show": true,
      "onTap": () {
        Get.to(() => const newOrderListScreen());
      }
    },
    {
      "img": AppImages.dashboard2,
      "name": "Pick Up",
      "key": "pickup_orders",
      "show": Common.currentRole == "admin" ||
          Common.currentRole == "delivery_user" ||
          Common.currentRole == "subadmin",
      "color": AppColors.dashBoardText2,
      "bgColor": AppColors.dashBoardBg2,
      "count": 0,
      "onTap": () {}
    },
    {
      "img": AppImages.dashboard3,
      "name": "Out for Delivery",
      "color": AppColors.dashBoardText3,
      "show": Common.currentRole == "admin" ||
          Common.currentRole == "delivery_user" ||
          Common.currentRole == "subadmin",
      "bgColor": AppColors.dashBoardBg3,
      "count": 0,
      "key": "out_of_delivery",
      "onTap": () {}
    },
    {
      "img": AppImages.dashboard4,
      "name": Common.currentRole == "chef" ? "Completed" : "Delivered",
      "color": AppColors.dashBoardText4,
      "show": true,
      "bgColor": AppColors.dashBoardBg4,
      "count": 0,
      "key": "delivered_orders",
      "onTap": () {}
    },
    {
      "img": AppImages.dashboard5,
      "name": "Cancelled",
      "show": true,
      "color": AppColors.dashBoardText5,
      "bgColor": AppColors.dashBoardBg5,
      "count": 0,
      "key": "cancelled_orders",
      "onTap": () {}
    },
    {
      "img": AppImages.dashboard6,
      "name": "Paid",
      "color": AppColors.dashBoardText6,
      "bgColor": AppColors.dashBoardBg6,
      "show": Common.currentRole == "admin" || Common.currentRole == "subadmin",
      "count": 0,
      "key": "paid_orders",
      "onTap": () {}
    },
    {
      "img": AppImages.dashboard7,
      "name": Common.currentRole == "delivery_user" ? "Pick Up" : "In-Progress",
      "color": AppColors.dashBoardText7,
      "show": Common.currentRole != "delivery_user",
      "bgColor": AppColors.dashBoardBg7,
      "count": 0,
      "key": "in_progress_orders",
      "onTap": () {}
    },
  ];
}
