import '../utils/widget/appwidgets.dart';

class Constants {
  static String API_BASE_URL = 'https://portal.jigarskitchen.com/api/v1/';
  static String webUrl = 'https://portal.jigarskitchen.com/';
  static String INTERNET_PING = 'https://www.google.com';

  static String APP_NAME = "Jigar’s Kitchens";

  static soryyTryAgainToast() {
    appWidgets().showToast("Sorry", "Please Try again");
  }

  static internalServerErrorToast() {
    appWidgets().showToast("Sorry", "Internal server error");
  }
}
