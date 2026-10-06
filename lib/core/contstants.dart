import '../utils/widget/appwidgets.dart';

class Constants {
  // static String API_BASE_URL = 'https://portal.jigarskitchen.com/api/v1/';
  static String API_BASE_URL = 'https://jigars.guku.ai/api/v1/';
  // static String API_BASE_URL =
  //     'https://jigars.kitchen.alphadevelopers.co.uk/api/v1/';

  static String webUrl = 'https://jigars.guku.ai/';
  // static String webUrl = 'https://portal.jigarskitchen.com/';
  static String INTERNET_PING = 'https://www.google.com';

  static String APP_NAME = "Jigar’s Kitchens";

  static soryyTryAgainToast([String? message]) {
    appWidgets.hideDialog();
    appWidgets().showToast("Sorry", message ?? "Please Try again");
  }

  static internalServerErrorToast([String? message]) {
    appWidgets.hideDialog();
    appWidgets().showToast("Sorry", message ?? "Internal server error");
  }
}
