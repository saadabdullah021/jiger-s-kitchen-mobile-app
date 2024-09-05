import 'dart:io';

import 'package:get/get_connect/http/src/multipart/multipart_file.dart';
import 'package:jigers_kitchen/common/common.dart';
import 'package:jigers_kitchen/model/login_model.dart';
import 'package:jigers_kitchen/model/single_user_data.dart';
import 'package:jigers_kitchen/model/user_data_model.dart';
import 'package:jigers_kitchen/model/user_list_model.dart';

import '../../model/single_vendor_data.dart';
import '../../utils/app_keys.dart';
import '../../utils/local_db_helper.dart';
import '../../utils/widget/appwidgets.dart';
import '../contstants.dart';
import 'base_api.dart';

class AppInterface extends BaseApi {
  Future<dynamic> register({
    String? firstName,
    String? lastName,
    String? userName,
    String? phoneNumber,
    String? invoiceEmail,
    String? multipleOrderEmail,
    String? password,
    String? vendorCategory,
    String? tax,
    String? billingAddress,
    String? shippingAddress,
    String? deliveryCharges,
  }) async {
    var data = {
      "first_name": firstName,
      "last_name": lastName,
      "user_name": userName,
      "phone_number": phoneNumber,
      "invoice_email": invoiceEmail,
      "multiple_order_email": multipleOrderEmail,
      "password": password,
      "vendor_category": vendorCategory!.toLowerCase(),
      "tax": tax,
      "billing_address": billingAddress,
      "shipping_address": shippingAddress,
      "delivery_charges": deliveryCharges,
    };
    // var headers = {
    //   'Accept': '/',
    //   'User-Agent': 'Thunder Client (https://www.thunderclient.com)'
    // };
    var response = await sendPost(
      "${Constants.API_BASE_URL}register-vendor",
      data,
    );
    if (response == null) return null;
    if (response.body['status'] == 200) {
      UserDataModel resposeData = UserDataModel.fromJson(response.body['data']);

      return resposeData;
    } else if (response.body['status'] == 400) {
      return response.body['message'];
    }
    return null;
  }

  Future<dynamic> addVendor({
    String? firstName,
    String? lastName,
    String? userName,
    String? phoneNumber,
    String? invoiceEmail,
    String? multipleOrderEmail,
    String? password,
    String? vendorCategory,
    String? tax,
    String? billingAddress,
    String? shippingAddress,
    String? deliveryCharges,
    String? profileImage,
  }) async {
    Map<String, Object?> data;
    profileImage == ""
        ? data = {
            "first_name": firstName,
            "last_name": lastName,
            "user_name": userName,
            "phone_number": phoneNumber,
            "invoice_email": invoiceEmail,
            "multiple_order_email": multipleOrderEmail,
            "password": password,
            "vendor_category": vendorCategory!.toLowerCase(),
            "tax": tax,
            "billing_address": billingAddress,
            "shipping_address": shippingAddress,
            "delivery_charges": deliveryCharges,
          }
        : data = {
            "first_name": firstName,
            "last_name": lastName,
            "user_name": userName,
            "phone_number": phoneNumber,
            "invoice_email": invoiceEmail,
            "multiple_order_email": multipleOrderEmail,
            "password": password,
            "vendor_category": vendorCategory!.toLowerCase(),
            "tax": tax,
            "billing_address": billingAddress,
            "shipping_address": shippingAddress,
            "delivery_charges": deliveryCharges,
            "profile_image": MultipartFile(File(profileImage!),
                filename: DateTime.now().microsecondsSinceEpoch.toString()),
          };
    var headers = {
      'Authorization': 'Bearer ${Common.loginReponse.value.data!.token!}'
    };
    var response = await sendPost(
        "${Constants.API_BASE_URL}add-new-vendor", data,
        headers: headers);
    if (response == null) return null;
    if (response.body['status'] == 200) {
      UserDataModel resposeData = UserDataModel.fromJson(response.body['data']);

      return resposeData;
    } else if (response.body['status'] == 400) {
      return response.body['message'];
    }
    return null;
  }

  Future<dynamic> updateVendor({
    String? firstName,
    String? vendorID,
    String? lastName,
    String? userName,
    String? phoneNumber,
    String? invoiceEmail,
    String? multipleOrderEmail,
    String? password,
    String? vendorCategory,
    String? tax,
    String? billingAddress,
    String? shippingAddress,
    String? deliveryCharges,
    String? profileImage,
  }) async {
    Map<String, Object?> data;
    profileImage == ""
        ? data = {
            "first_name": firstName,
            "last_name": lastName,
            "vendor_id": vendorID,
            "user_name": userName,
            "phone_number": phoneNumber,
            "email": invoiceEmail,
            "multiple_order_email": multipleOrderEmail,
            "password": password,
            "vendor_category": vendorCategory!.toLowerCase(),
            "tax": tax,
            "billing_address": billingAddress,
            "shipping_address": shippingAddress,
            "delivery_charges": deliveryCharges,
          }
        : data = {
            "first_name": firstName,
            "last_name": lastName,
            "user_name": userName,
            "vendor_id": vendorID,
            "phone_number": phoneNumber,
            "email": invoiceEmail,
            "multiple_order_email": multipleOrderEmail,
            "password": password,
            "vendor_category": vendorCategory!.toLowerCase(),
            "tax": tax,
            "billing_address": billingAddress,
            "shipping_address": shippingAddress,
            "delivery_charges": deliveryCharges,
            "profile_image": MultipartFile(File(profileImage!),
                filename: DateTime.now().microsecondsSinceEpoch.toString()),
          };
    var headers = {
      'Authorization': 'Bearer ${Common.loginReponse.value.data!.token!}'
    };
    var response = await sendPost(
        "${Constants.API_BASE_URL}update-vendor", data,
        headers: headers);
    if (response == null) return null;
    if (response.body['status'] == 200) {
      return 200;
    } else if (response.body['status'] == 400) {
      return response.body['message'];
    }
    return null;
  }

  Future<dynamic> login({
    String? userName,
    String? password,
    bool? remeber,
  }) async {
    var data = {
      "user_name": userName,
      "password": password,
      "fcm_token": Common.fcmToken
    };
    var response = await sendPost(
      "${Constants.API_BASE_URL}user-login",
      data,
    );
    if (response == null) return null;
    try {
      if (response.body['status'] == 200) {
        loginModel resposeData = loginModel.fromJson(response.body);
        Common.loginReponse.value = resposeData;
        if (remeber == true) {
          SharedPref.getInstance().addStringToSF(
              AppKeys.accessToken, resposeData.data!.token ?? "");
        } else {
          SharedPref.getInstance().addStringToSF(AppKeys.accessToken, "");
        }

        return 200;
      } else if (response.body['status'] == 400) {
        appWidgets.hideDialog();
        appWidgets().showToast("Sorry", response.body['message']);
        return 400;
      } else {
        appWidgets.hideDialog();
        Constants.internalServerErrorToast();
      }
      return null;
    } catch (e) {
      appWidgets.hideDialog();
      Constants.soryyTryAgainToast();
    }
  }

  Future<dynamic> createChef({
    String? firstName,
    String? lastName,
    String? userName,
    String? phoneNumber,
    String? password,
    String? email,
    String? profileImage,
  }) async {
    Map<String, Object?> data;
    profileImage != ""
        ? data = {
            "first_name": firstName,
            "last_name": lastName,
            "user_name": userName,
            "phone_number": phoneNumber,
            "password": password,
            "email": email,
            "profile_image": MultipartFile(File(profileImage!),
                filename: DateTime.now().microsecondsSinceEpoch.toString()),
          }
        : data = {
            "first_name": firstName,
            "last_name": lastName,
            "user_name": userName,
            "phone_number": phoneNumber,
            "password": password,
            "email": email,
          };
    var headers = {
      'Authorization': 'Bearer ${Common.loginReponse.value.data!.token!}'
    };
    var response = await sendPost(
      "${Constants.API_BASE_URL}register-chef",
      headers: headers,
      data,
    );
    if (response == null) return null;
    if (response.body['status'] == 200) {
      print(response.body['profile_image']);
      return 200;
    } else if (response.body['status'] == 400) {
      appWidgets.hideDialog();
      appWidgets().showToast("Sorry", response.body['message']);
    } else {
      appWidgets.hideDialog();
      Constants.internalServerErrorToast();
    }
    return null;
  }

  Future<dynamic> editChef({
    String? firstName,
    String? lastName,
    String? userName,
    String? phoneNumber,
    String? password,
    String? email,
    String? profileImage,
    String? id,
  }) async {
    Map<String, Object?> data;
    profileImage != ""
        ? data = {
            "first_name": firstName,
            "last_name": lastName,
            "user_name": userName,
            "phone_number": phoneNumber,
            "password": password,
            "email": email,
            'chef_id': id,
            "profile_image": MultipartFile(File(profileImage!),
                filename: DateTime.now().microsecondsSinceEpoch.toString()),
          }
        : data = {
            "first_name": firstName,
            "last_name": lastName,
            "user_name": userName,
            'chef_id': id,
            "phone_number": phoneNumber,
            "password": password,
            "email": email,
          };
    var headers = {
      'Authorization': 'Bearer ${Common.loginReponse.value.data!.token!}'
    };
    var response = await sendPost(
      "${Constants.API_BASE_URL}update-chef",
      headers: headers,
      data,
    );
    if (response == null) return null;
    if (response.body['status'] == 200) {
      print(response.body['profile_image']);
      return 200;
    } else if (response.body['status'] == 400) {
      appWidgets.hideDialog();
      appWidgets().showToast("Sorry", response.body['message']);
    } else {
      appWidgets.hideDialog();
      Constants.internalServerErrorToast();
    }
    return null;
  }

  Future<dynamic> getUserList({
    String? role,
    String? page,
  }) async {
    var headers = {
      'Authorization': 'Bearer ${Common.loginReponse.value.data!.token!}'
    };
    var response = await sendGet(
      "${Constants.API_BASE_URL}get-users-list",
      query: {
        "role": role,
        "page": page,
        "limit": "4",
      },
      headers: headers,
    );
    if (response == null) return null;
    if (response.body['status'] == 200) {
      userListModel userData = userListModel.fromJson(response.body);
      return userData;
    } else if (response.body['status'] == 400) {
      appWidgets.hideDialog();
      appWidgets().showToast("Sorry", response.body['message']);
    } else {
      appWidgets.hideDialog();
      Constants.internalServerErrorToast();
    }
    return null;
  }

  Future<dynamic> searchUser({
    String? role,
    String? query,
  }) async {
    var headers = {
      'Authorization': 'Bearer ${Common.loginReponse.value.data!.token!}'
    };
    var response = await sendGet(
      "${Constants.API_BASE_URL}search-users",
      query: {"role": role, "search_keyword": query},
      headers: headers,
    );
    if (response == null) return null;
    if (response.body['status'] == 200) {
      userListModel userData = userListModel.fromJson(response.body);
      return userData;
    } else if (response.body['status'] == 400) {
      appWidgets.hideDialog();
      appWidgets().showToast("Sorry", response.body['message']);
    } else {
      appWidgets.hideDialog();
      Constants.internalServerErrorToast();
    }
    return null;
  }

  Future<dynamic> getUserByToken(String token) async {
    var headers = {'Authorization': 'Bearer $token'};
    var response = await sendGet(
      "${Constants.API_BASE_URL}login-with-token",
      headers: headers,
    );
    if (response == null) return null;
    try {
      if (response.body['status'] == 200) {
        loginModel resposeData = loginModel.fromJson(response.body);
        Common.loginReponse.value = resposeData;
        return 200;
      } else if (response.body['status'] == 400) {
        appWidgets.hideDialog();
        appWidgets().showToast("Sorry", response.body['message']);
        return 400;
      } else {
        appWidgets.hideDialog();
        Constants.internalServerErrorToast();
        return null;
      }
    } catch (e) {
      appWidgets.hideDialog();
      Constants.soryyTryAgainToast();
    }
  }

  Future<dynamic> getUserByID(String id) async {
    var headers = {
      'Authorization': 'Bearer ${Common.loginReponse.value.data!.token!}'
    };
    var response = await sendGet("${Constants.API_BASE_URL}get-user-info",
        headers: headers, query: {"user_id": id});
    if (response == null) return null;
    try {
      if (response.body['status'] == 200) {
        singleUserModel resposeData = singleUserModel.fromJson(response.body);
        return resposeData;
      } else if (response.body['status'] == 400) {
        appWidgets.hideDialog();
        appWidgets().showToast("Sorry", response.body['message']);
        return 400;
      } else {
        appWidgets.hideDialog();
        Constants.internalServerErrorToast();
        return null;
      }
    } catch (e) {
      appWidgets.hideDialog();
      Constants.soryyTryAgainToast();
    }
  }

  Future<dynamic> getVendorByID(String id) async {
    var headers = {
      'Authorization': 'Bearer ${Common.loginReponse.value.data!.token!}'
    };
    var response = await sendGet("${Constants.API_BASE_URL}get-vendor",
        headers: headers, query: {"user_id": id});
    if (response == null) return null;
    try {
      if (response.body['status'] == 200) {
        singleVendorData resposeData = singleVendorData.fromJson(response.body);
        return resposeData;
      } else if (response.body['status'] == 400) {
        appWidgets.hideDialog();
        appWidgets().showToast("Sorry", response.body['message']);
        return 400;
      } else {
        appWidgets.hideDialog();
        Constants.internalServerErrorToast();
        return null;
      }
    } catch (e) {
      appWidgets.hideDialog();
      Constants.soryyTryAgainToast();
    }
  }

  Future<dynamic> deleteUser({
    String? role,
    String? id,
  }) async {
    var data = {
      "user_id": id,
      "role": role,
    };
    var headers = {
      'Authorization': 'Bearer ${Common.loginReponse.value.data!.token!}'
    };
    var response = await sendPost(
      "${Constants.API_BASE_URL}delete-user",
      headers: headers,
      data,
    );
    if (response == null) return null;
    if (response.body['status'] == 200) {
      return 200;
    } else if (response.body['status'] == 400) {
      appWidgets.hideDialog();
      appWidgets().showToast("Sorry", response.body['message']);
    } else {
      appWidgets.hideDialog();
      Constants.internalServerErrorToast();
    }
    return null;
  }
}
