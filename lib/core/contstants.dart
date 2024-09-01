import '../utils/widget/appwidgets.dart';

class Constants {
  static String API_BASE_URL =
      'https://jigars.kitchen.alphadevelopers.co.uk/api/v1/';
  static String webUrl = 'https://jigars.kitchen.alphadevelopers.co.uk/';
  static String INTERNET_PING = 'https://www.google.com';

  static String APP_NAME = "Jigar’s Kitchen";

  static soryyTryAgainToast() {
    appWidgets().showToast("Sorry", "Please Try again");
  }

  static internalServerErrorToast() {
    appWidgets().showToast("Sorry", "Internal server error");
  }
}
