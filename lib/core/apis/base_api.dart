import 'package:get/get.dart';
import 'package:jigers_kitchen/core/contstants.dart';
import 'package:jigers_kitchen/utils/widget/appwidgets.dart';

class BaseApi extends GetConnect {
  // late SharedPreferences prefs;
  @override
  void onInit() {
    // allowAutoSignedCert = true;
    super.onInit();
    httpClient.baseUrl = Constants.API_BASE_URL;
    httpClient.timeout = const Duration(seconds: 60);
  }

  Future<Response?> sendPost(String? url, dynamic body,
      {String? contentType,
      Map<String, String>? headers,
      Map<String, dynamic>? query}) async {
    appWidgets.loadingDialog();
    var response = await post(url, FormData(body),
        contentType: contentType, headers: headers, query: query);
    appWidgets.hideDialog();
    if (response.statusCode != 200) {
      return null;
    }
    return response;
  }

  Future<Response?> sendGet(String url,
      {String? contentType,
      Map<String, String>? headers,
      Map<String, dynamic>? query}) async {
    var response = await get(url,
        contentType: contentType, headers: headers, query: query);
    if (response.statusCode != 200) {
      appWidgets().showToast("Sorry", "Internal server error");
      return null;
    }

    return response;
  }

  BaseApi() : super(timeout: const Duration(seconds: 60));
}
