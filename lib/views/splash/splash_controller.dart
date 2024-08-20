import 'package:get/get.dart';
import 'package:jigers_kitchen/views/welcome_page/welcome_page.dart';

class SplashController extends GetxController {
  @override
  Future<void> onInit() async {
    super.onInit();

    Future.delayed(const Duration(seconds: 3), () {
      Get.off(() => OnBoardingScreen());
    });
  }
}
