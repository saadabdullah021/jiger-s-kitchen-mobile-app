import 'dart:convert';

import 'package:get/get.dart';

class BaseApi extends GetConnect {
  // late SharedPreferences prefs;
  @override
  void onInit() {
    // allowAutoSignedCert = true;
    super.onInit();
    // httpClient.baseUrl = Constants.API_BASE_URL;
    httpClient.timeout = const Duration(seconds: 60);
  }

  Future<Response?> sendPost(String? url, dynamic body,
      {String? contentType,
      Map<String, String>? headers,
      Map<String, dynamic>? query}) async {
    var response = await post(url, FormData(body),
        contentType: contentType, headers: headers, query: query);

    if (response.statusCode != 200) {
      print(response.statusCode.toString());
      print(response.bodyBytes.toString());
      print(response.bodyString.toString());
      return null;
    }
    return response;
  }

  Future<Response?> sendPostRaw(String? url, dynamic body,
      {String? contentType,
      Map<String, String>? headers,
      Map<String, dynamic>? query}) async {
    var response = await post(url, json.encode(body),
        contentType: contentType, headers: headers, query: query);

    if (response.statusCode != 200) {
      print(response.statusCode.toString());
      print(response.bodyBytes.toString());
      print(response.bodyString.toString());
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
      return null;
    }

    return response;
  }

  BaseApi() : super(timeout: const Duration(seconds: 60));
}
