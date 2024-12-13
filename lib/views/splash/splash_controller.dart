import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:jigers_kitchen/core/apis/app_interface.dart';
import 'package:jigers_kitchen/views/auth/login/login_screen.dart';
import 'package:jigers_kitchen/views/splash/splash_screen.dart';
import 'package:jigers_kitchen/views/welcome_page/welcome_page.dart';

import '../../common/common.dart';
import '../../utils/app_keys.dart';
import '../../utils/local_db_helper.dart';
import '../Dashboard_screen/dashboard_screen.dart';
import '../jigar_home_screen/jiagar_home.dart';
import '../jigar_home_screen/jigar_home_controller.dart';

class SplashController extends GetxController {
  @override
  Future<void> onInit() async {
    super.onInit();
    // await FirebaseMessaging.instance.getToken().then((value) {
    //   if (value != null) {
    //     Common.fcmToken = value;
    //   }
    // });
    bool? isFirstTime =
        SharedPref.getInstance().getBoolValuesSF(AppKeys.isFirstTime);
    String? token =
        SharedPref.getInstance().getLangStringValuesSF(AppKeys.accessToken);
    Future.delayed(const Duration(seconds: 3), () {
      isFirstTime == false
          ? handleNavigation(token)
          : Get.off(() => const OnBoardingScreen());
    });
  }

  handleNavigation(String? token) async {
    if (token == null || token == "") {
      Get.off(() => const LoginScreen());
    } else {
      await AppInterface().getUserByToken(token).then((value) async {
        if (value == 200) {
          await AppInterface().updateFcm();

          if (Common.currentRole == "chef" ||
              Common.currentRole == "delivery_user") {
            Get.put(HomeController());
            Get.off(const DashboardScreen());
          } else {
            Get.off(const JigarHome());
          }
        } else if (value == 400) {
          SharedPref.getInstance().addStringToSF(AppKeys.accessToken, "");
          Get.off(() => const LoginScreen());
        } else {
          Get.delete<SplashController>();
          Get.offAll(const SplashScreen());
        }
      });
    }
  }
}
