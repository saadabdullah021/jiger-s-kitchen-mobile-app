import 'package:get/get.dart';
import 'package:jigers_kitchen/model/login_model.dart';

class Common {
  static Rx<loginModel> loginReponse = loginModel().obs;
  static String fcmToken = "";
}
