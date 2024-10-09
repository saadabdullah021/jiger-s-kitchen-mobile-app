import 'dart:io';

import 'package:get/get.dart';
import 'package:jigers_kitchen/common/common.dart';
import 'package:jigers_kitchen/model/chef_drop_down_data_model.dart';
import 'package:jigers_kitchen/model/chef_order_model.dart';
import 'package:jigers_kitchen/model/dashboad_counter_model.dart';
import 'package:jigers_kitchen/model/get_cart_item_model.dart';
import 'package:jigers_kitchen/model/get_menu_item_model.dart';
import 'package:jigers_kitchen/model/get_price_slab.dart';
import 'package:jigers_kitchen/model/get_vemdor_approved_item.dart';
import 'package:jigers_kitchen/model/login_model.dart';
import 'package:jigers_kitchen/model/menu_tab_model.dart';
import 'package:jigers_kitchen/model/single_user_data.dart';
import 'package:jigers_kitchen/model/user_data_model.dart';
import 'package:jigers_kitchen/model/user_list_model.dart';

import '../../model/edit_order_model.dart';
import '../../model/get_other_vemdor_item_detail.dart';
import '../../model/get_other_vendor_for_approved_item.dart';
import '../../model/get_price_slab_list_model.dart';
import '../../model/get_vendor_group.dart';
import '../../model/menu_item_model.dart';
import '../../model/order_list_model.dart';
import '../../model/requested_item_list_model.dart';
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

  Future<dynamic> addVendor(
      {String? firstName,
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
      String? groupId}) async {
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
            "group_id": groupId == "-1" ? "" : groupId ?? ""
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
            "group_id": groupId == "-1" ? "" : groupId ?? "",
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
    String? groupId,
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
            "group_id": groupId == "-1" ? "" : groupId ?? "",
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
            "group_id": groupId == "-1" ? "" : groupId ?? "",
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
        Common.currentRole = resposeData.data!.role!;
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

  Future<dynamic> createAdmin({
    String? firstName,
    String? lastName,
    String? groupId,
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
            "group_id": groupId,
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
            "group_id": groupId,
            "phone_number": phoneNumber,
            "password": password,
            "email": email,
          };
    var headers = {
      'Authorization': 'Bearer ${Common.loginReponse.value.data!.token!}'
    };
    var response = await sendPost(
      "${Constants.API_BASE_URL}add-subadmin",
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

  Future<dynamic> createDeliveryUser({
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
      "${Constants.API_BASE_URL}register-delivery-user",
      headers: headers,
      data,
    );
    if (response == null) {
      appWidgets.hideDialog();
      Constants.internalServerErrorToast();
      return null;
    }
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
            'user_id': id,
            "profile_image": MultipartFile(File(profileImage!),
                filename: DateTime.now().microsecondsSinceEpoch.toString()),
          }
        : data = {
            "first_name": firstName,
            "last_name": lastName,
            "user_name": userName,
            'user_id': id,
            "phone_number": phoneNumber,
            "password": password,
            "email": email,
          };
    var headers = {
      'Authorization': 'Bearer ${Common.loginReponse.value.data!.token!}'
    };
    var response = await sendPost(
      "${Constants.API_BASE_URL}update-user-info",
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

  Future<dynamic> editAdmin({
    String? firstName,
    String? lastName,
    String? userName,
    String? phoneNumber,
    String? password,
    String? email,
    String? profileImage,
    String? groupId,
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
            'user_id': id,
            "group_id": groupId,
            "profile_image": MultipartFile(File(profileImage!),
                filename: DateTime.now().microsecondsSinceEpoch.toString()),
          }
        : data = {
            "first_name": firstName,
            "last_name": lastName,
            "user_name": userName,
            'user_id': id,
            "group_id": groupId,
            "phone_number": phoneNumber,
            "password": password,
            "email": email,
          };
    var headers = {
      'Authorization': 'Bearer ${Common.loginReponse.value.data!.token!}'
    };
    var response = await sendPost(
      "${Constants.API_BASE_URL}update-subadmin",
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

  Future<dynamic> editDeliveryUser({
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
            'delivery_user_id': id,
            "profile_image": MultipartFile(File(profileImage!),
                filename: DateTime.now().microsecondsSinceEpoch.toString()),
          }
        : data = {
            "first_name": firstName,
            "last_name": lastName,
            "user_name": userName,
            'delivery_user_id': id,
            "phone_number": phoneNumber,
            "password": password,
            "email": email,
          };
    var headers = {
      'Authorization': 'Bearer ${Common.loginReponse.value.data!.token!}'
    };
    var response = await sendPost(
      "${Constants.API_BASE_URL}update-delivery-user",
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

  Future<dynamic> updateFcm() async {
    Map<String, Object?> data = {"fcm_token": Common.fcmToken};
    var headers = {
      'Authorization': 'Bearer ${Common.loginReponse.value.data!.token!}'
    };
    var response = await sendPost(
      "${Constants.API_BASE_URL}update-fcm",
      headers: headers,
      data,
    );
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

  Future<dynamic> getOrderList(
      {String? searchKey, String? page, bool? isSearch, String? status}) async {
    var headers = {
      'Authorization': 'Bearer ${Common.loginReponse.value.data!.token!}'
    };
    var response = await sendGet(
      "${Constants.API_BASE_URL}get-orders-list",
      query: isSearch == true
          ? {
              "search_keyword": searchKey,
              "role": Common.currentRole,
              "order_status": status ?? ""
            }
          : {
              "page": page,
              "limit": "20",
              "role": Common.currentRole,
              "order_status": status ?? ""
            },
      headers: headers,
    );
    if (response == null) return null;
    if (response.body['status'] == 200) {
      OrderListModel userData = OrderListModel.fromJson(response.body);
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

  Future<dynamic> getSingleOrder({String? id}) async {
    var headers = {
      'Authorization': 'Bearer ${Common.loginReponse.value.data!.token!}'
    };
    var response = await sendGet(
      "${Constants.API_BASE_URL}get-single-order",
      query: {"order_id": id},
      headers: headers,
    );
    if (response == null) return null;
    if (response.body['status'] == 200) {
      editItemModel userData = editItemModel.fromJson(response.body);
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

  Future<dynamic> getChefOrderList(
      {String? searchKey, String? page, bool? isSearch, String? status}) async {
    var headers = {
      'Authorization': 'Bearer ${Common.loginReponse.value.data!.token!}'
    };
    var response = await sendGet(
      "${Constants.API_BASE_URL}get-chef-order-list",
      query: isSearch == true
          ? {
              "search_keyword": searchKey,
              // "role": Common.currentRole,
              "order_status": status ?? ""
            }
          : {
              "page": page,
              "limit": "20",
              // "role": Common.currentRole,
              "order_status": status ?? ""
            },
      headers: headers,
    );
    if (response == null) return null;
    if (response.body['status'] == 200) {
      GetChefOrderListModel userData =
          GetChefOrderListModel.fromJson(response.body);
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

  Future<dynamic> getRequestUserList(
      {String? searchKey, String? page, bool? isSearch}) async {
    var headers = {
      'Authorization': 'Bearer ${Common.loginReponse.value.data!.token!}'
    };
    var response = await sendGet(
      "${Constants.API_BASE_URL}get-vendors-for-requested-items",
      query: isSearch == true
          ? {"search_keyword": searchKey}
          : {
              "page": page,
              "limit": "20",
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

  Future<dynamic> getPriceSlabData({String? menuID, String? vendorID}) async {
    var headers = {
      'Authorization': 'Bearer ${Common.loginReponse.value.data!.token!}'
    };
    var response = await sendGet(
      "${Constants.API_BASE_URL}get-menu-item-for-price-slab",
      query: {
        "menu_item_id": menuID,
        "vendor_id": vendorID,
      },
      headers: headers,
    );
    if (response == null) {
      Constants.internalServerErrorToast();
      return null;
    }
    if (response.body['status'] == 200) {
      getPriceSlabModel Data = getPriceSlabModel.fromJson(response.body);
      return Data;
    } else if (response.body['status'] == 400) {
      appWidgets.hideDialog();
      appWidgets().showToast("Sorry", response.body['message']);
    } else {
      appWidgets.hideDialog();
      Constants.internalServerErrorToast();
    }
    return null;
  }

  Future<dynamic> getSameItemVendors({
    String? menuID,
  }) async {
    var headers = {
      'Authorization': 'Bearer ${Common.loginReponse.value.data!.token!}'
    };
    var response = await sendGet(
      "${Constants.API_BASE_URL}get-same-items-vendor",
      query: {
        "item_id": menuID,
      },
      headers: headers,
    );
    if (response == null) {
      Constants.internalServerErrorToast();
      return null;
    }
    if (response.body['status'] == 200) {
      GetOtherVendorForApprovedItemModel Data =
          GetOtherVendorForApprovedItemModel.fromJson(response.body);
      return Data;
    } else if (response.body['status'] == 400) {
      appWidgets.hideDialog();
      appWidgets().showToast("Sorry", response.body['message']);
    } else {
      appWidgets.hideDialog();
      Constants.internalServerErrorToast();
    }
    return null;
  }

  Future<dynamic> getOtherVendorItemDetail({
    String? menuID,
    String? vendorID,
  }) async {
    var headers = {
      'Authorization': 'Bearer ${Common.loginReponse.value.data!.token!}'
    };
    var response = await sendGet(
      "${Constants.API_BASE_URL}get-item-info-by-vendor",
      query: {"item_id": menuID, "vendor_id": vendorID},
      headers: headers,
    );
    if (response == null) {
      Constants.internalServerErrorToast();
      return null;
    }
    if (response.body['status'] == 200) {
      GetOtherVendorItemDetailModel Data =
          GetOtherVendorItemDetailModel.fromJson(response.body);
      return Data;
    } else if (response.body['status'] == 400) {
      appWidgets.hideDialog();
      appWidgets().showToast("Sorry", response.body['message']);
    } else {
      appWidgets.hideDialog();
      Constants.internalServerErrorToast();
    }
    return null;
  }

  Future<dynamic> deletePriceSlab({
    String? id,
  }) async {
    Map<String, Object?> data = {
      "slab_id": id,
    };
    var headers = {
      'Authorization': 'Bearer ${Common.loginReponse.value.data!.token!}'
    };
    var response = await sendPost(
      "${Constants.API_BASE_URL}delete-price-slab",
      headers: headers,
      data,
    );
    if (response == null) {
      Constants.internalServerErrorToast();
      return null;
    }
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

  Future<dynamic> deleteAccount() async {
    var headers = {
      'Authorization': 'Bearer ${Common.loginReponse.value.data!.token!}'
    };
    var response = await sendGet(
      "${Constants.API_BASE_URL}delete-user-account",
      headers: headers,
    );
    if (response == null) {
      Constants.internalServerErrorToast();
      return null;
    }
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

  Future<dynamic> deleteOrder({
    String? id,
  }) async {
    Map<String, Object?> data = {
      "order_id": id,
    };
    var headers = {
      'Authorization': 'Bearer ${Common.loginReponse.value.data!.token!}'
    };
    var response = await sendGet(
      "${Constants.API_BASE_URL}delete-order",
      headers: headers,
      query: data,
    );
    if (response == null) {
      Constants.internalServerErrorToast();
      return null;
    }
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

  Future<dynamic> deleteCartItem({
    String? id,
  }) async {
    var headers = {
      'Authorization': 'Bearer ${Common.loginReponse.value.data!.token!}'
    };
    var response = await sendGet(
      "${Constants.API_BASE_URL}delete-cart-item",
      headers: headers,
      query: {
        "item_id": id,
      },
    );
    if (response == null) {
      appWidgets.hideDialog();
      Constants.internalServerErrorToast();
      return null;
    }
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

  Future<dynamic> getPriceSlabListData(
      {String? menuID, String? vendorID}) async {
    var headers = {
      'Authorization': 'Bearer ${Common.loginReponse.value.data!.token!}'
    };
    var response = await sendGet(
      "${Constants.API_BASE_URL}get-price-slabs-for-menu-item",
      query: {
        "menu_item_id": menuID,
        "user_id": vendorID,
      },
      headers: headers,
    );
    if (response == null) {
      Constants.internalServerErrorToast();
      return null;
    }
    if (response.body['status'] == 200) {
      getPriceSlabItemListModel Data =
          getPriceSlabItemListModel.fromJson(response.body);
      return Data;
    } else if (response.body['status'] == 400) {
      appWidgets.hideDialog();
      appWidgets().showToast("Sorry", response.body['message']);
    } else {
      appWidgets.hideDialog();
      Constants.internalServerErrorToast();
    }
    return null;
  }

  Future<dynamic> addPriceSlabData(
      {String? menuID,
      String? vendorID,
      String? userId,
      quantity,
      price}) async {
    var headers = {
      'Authorization': 'Bearer ${Common.loginReponse.value.data!.token!}'
    };
    var data = {
      "menu_item_id": menuID,
      "vendor_id": vendorID,
      'user_id': userId,
      'quantity': quantity,
      'price': price,
    };
    var response = await sendPost(
      "${Constants.API_BASE_URL}add-price-slab",
      data,
      headers: headers,
    );
    if (response == null) {
      Constants.internalServerErrorToast();
      return null;
    }
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

  Future<dynamic> updateOrderStatusByChef(
      {String? orderID, String? orderStatus}) async {
    var headers = {
      'Authorization': 'Bearer ${Common.loginReponse.value.data!.token!}'
    };
    var data = {
      'order_status': orderStatus,
      'order_id': orderID,
    };
    var response = await sendPost(
      "${Constants.API_BASE_URL}change-order-status-by-chef",
      data,
      headers: headers,
    );
    if (response == null) {
      Constants.internalServerErrorToast();
      return null;
    }
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

  Future<dynamic> updateOrderStatusByDeliveryUuser(
      {String? orderID, String? orderStatus}) async {
    var headers = {
      'Authorization': 'Bearer ${Common.loginReponse.value.data!.token!}'
    };
    var data = {
      'order_status': orderStatus,
      'order_id': orderID,
    };
    var response = await sendPost(
      "${Constants.API_BASE_URL}change-order-status",
      data,
      headers: headers,
    );
    if (response == null) {
      Constants.internalServerErrorToast();
      return null;
    }
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

  Future<dynamic> editPriceSlabData(
      {String? vendorID, String? slabId, quantity, price}) async {
    var headers = {
      'Authorization': 'Bearer ${Common.loginReponse.value.data!.token!}'
    };
    var data = {
      'slab_id': slabId,
      "vendor_id": vendorID,
      'quantity': quantity,
      'price': price,
    };
    var response = await sendPost(
      "${Constants.API_BASE_URL}update-price-slab",
      data,
      headers: headers,
    );
    if (response == null) {
      Constants.internalServerErrorToast();
      return null;
    }
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

  Future<dynamic> createVendorGroup(String name) async {
    Map<String, Object?> data = {"group_name": name};
    var headers = {
      'Authorization': 'Bearer ${Common.loginReponse.value.data!.token!}'
    };
    var response = await sendPost(
      "${Constants.API_BASE_URL}add-vendor-group",
      headers: headers,
      data,
    );
    if (response!.body['status'] == 200) {
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

  Future<dynamic> getVendorGroups() async {
    var headers = {
      'Authorization': 'Bearer ${Common.loginReponse.value.data!.token!}'
    };
    var response = await sendGet(
      "${Constants.API_BASE_URL}get-vendor-groups",
      headers: headers,
    );
    if (response == null) return null;
    if (response.body['status'] == 200) {
      getVendorGroupModel data = getVendorGroupModel.fromJson(response.body);
      return data;
    } else if (response.body['status'] == 400) {
      appWidgets.hideDialog();
      appWidgets().showToast("Sorry", response.body['message']);
    } else {
      appWidgets.hideDialog();
      Constants.internalServerErrorToast();
    }
    return null;
  }

  Future<dynamic> getRequestedItemListById(
      {String? searchKey,
      String? page,
      bool? isSearch,
      String? vendorID}) async {
    var headers = {
      'Authorization': 'Bearer ${Common.loginReponse.value.data!.token!}'
    };
    var response = await sendGet(
      "${Constants.API_BASE_URL}get-requested-items-by-vendor-id",
      query: isSearch == true
          ? {"search_keyword": searchKey, "vendor_id": vendorID}
          : {"page": page, "limit": "4", "vendor_id": vendorID},
      headers: headers,
    );
    if (response == null) return null;
    if (response.body['status'] == 200) {
      RequestedItemListModel userData =
          RequestedItemListModel.fromJson(response.body);
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
        Common.currentRole = resposeData.data!.role!;
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

  Future<dynamic> getAllChefDropDown() async {
    var headers = {
      'Authorization': 'Bearer ${Common.loginReponse.value.data!.token!}'
    };
    var response = await sendGet(
      "${Constants.API_BASE_URL}get-all-chefs",
      headers: headers,
    );
    if (response == null) return null;
    if (response.body['status'] == 200) {
      ChefDropDownData userData = ChefDropDownData.fromJson(response.body);
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

  Future<dynamic> getAllMenuDropDown() async {
    var headers = {
      'Authorization': 'Bearer ${Common.loginReponse.value.data!.token!}'
    };
    var response = await sendGet(
      "${Constants.API_BASE_URL}get-menu-for-menu-item",
      headers: headers,
    );
    if (response == null) return null;
    if (response.body['status'] == 200) {
      ChefDropDownData userData = ChefDropDownData.fromJson(response.body);
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

  Future<dynamic> getMenuTab() async {
    var headers = {
      'Authorization': 'Bearer ${Common.loginReponse.value.data!.token!}'
    };
    var response = await sendGet(
      "${Constants.API_BASE_URL}get-menu",
      headers: headers,
    );
    if (response == null) {
      Constants.internalServerErrorToast();
      return null;
    }
    if (response.body['status'] == 200) {
      menuTabModel menuData = menuTabModel.fromJson(response.body);
      return menuData;
    } else if (response.body['status'] == 400) {
      appWidgets.hideDialog();
      appWidgets().showToast("Sorry", response.body['message']);
    } else {
      appWidgets.hideDialog();
      Constants.internalServerErrorToast();
    }
    return null;
  }

  Future<dynamic> getMenuItems({
    required String page,
    required String id,
    required bool isApproved,
  }) async {
    var headers = {
      'Authorization': 'Bearer ${Common.loginReponse.value.data!.token!}'
    };
    var response = await sendGet(
      "${Constants.API_BASE_URL}get-menu-items?menu_id=$id&page=$page&limit=10&role=${Common.loginReponse.value.data!.role!}&is_approved=${isApproved == true ? "1" : "0"}",
      headers: headers,
    );
    if (response == null) {
      Constants.internalServerErrorToast();
      return null;
    }
    if (response.body['status'] == 200) {
      GetMenuItemModel menuData = GetMenuItemModel.fromJson(response.body);
      return menuData;
    } else if (response.body['status'] == 400) {
      appWidgets.hideDialog();
      appWidgets().showToast("Sorry", response.body['message']);
    } else {
      appWidgets.hideDialog();
      Constants.internalServerErrorToast();
    }
    return null;
  }

  Future<dynamic> getVendorApprovedItem(
      {required String vendorId,
      String? searchKey,
      String? page,
      bool? isSearch}) async {
    var headers = {
      'Authorization': 'Bearer ${Common.loginReponse.value.data!.token!}'
    };
    var response = await sendGet(
      "${Constants.API_BASE_URL}get-approved-items",
      headers: headers,
      query: isSearch == true
          ? {"search_keyword": searchKey, "vendor_id": vendorId}
          : {"page": page, "limit": "4", "vendor_id": vendorId},
      //  {"vendor_id": vendorId}
    );
    if (response == null) {
      Constants.internalServerErrorToast();
      return null;
    }
    if (response.body['status'] == 200) {
      GetVendorApprovedItemModel menuData =
          GetVendorApprovedItemModel.fromJson(response.body);
      return menuData;
    } else if (response.body['status'] == 400) {
      appWidgets.hideDialog();
      appWidgets().showToast("Sorry", response.body['message']);
    } else {
      appWidgets.hideDialog();
      Constants.internalServerErrorToast();
    }
    return null;
  }

  Future<dynamic> searchMenuItems({
    required String page,
    required String id,
    required String keyWord,
  }) async {
    var headers = {
      'Authorization': 'Bearer ${Common.loginReponse.value.data!.token!}'
    };
    var response = await sendGet(
      "${Constants.API_BASE_URL}search-menu-items?menu_id=$id&page=$page&limit=10&search_keyword=$keyWord&role=${Common.loginReponse.value.data!.role!}",
      headers: headers,
    );
    if (response == null) {
      Constants.internalServerErrorToast();
      return null;
    }
    if (response.body['status'] == 200) {
      GetMenuItemModel menuData = GetMenuItemModel.fromJson(response.body);
      return menuData;
    } else if (response.body['status'] == 400) {
      appWidgets.hideDialog();
      appWidgets().showToast("Sorry", response.body['message']);
    } else {
      appWidgets.hideDialog();
      Constants.internalServerErrorToast();
    }
    return null;
  }

  Future<dynamic> chnageMenuStatus({
    String? columnName,
    String? id,
    int? value,
  }) async {
    var data = {
      "menu_item_id": id,
      "column_name": columnName,
      "value": value.toString(),
    };
    var headers = {
      'Authorization': 'Bearer ${Common.loginReponse.value.data!.token!}'
    };
    var response = await sendPost(
      "${Constants.API_BASE_URL}change-menu-status",
      headers: headers,
      data,
    );
    if (response == null) {
      appWidgets.hideDialog();
      Constants.soryyTryAgainToast();
      return null;
    }
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

  Future<dynamic> deleteMenuItem({
    String? id,
  }) async {
    var data = {
      "menu_item_id": id,
    };
    var headers = {
      'Authorization': 'Bearer ${Common.loginReponse.value.data!.token!}'
    };
    var response = await sendPost(
      "${Constants.API_BASE_URL}delet-menu-item",
      headers: headers,
      data,
    );
    if (response == null) {
      appWidgets.hideDialog();
      Constants.soryyTryAgainToast();
      return null;
    }
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

  Future<dynamic> addMenu({
    String? itemName,
    String? chefId,
    String? menuId,
    String? menuType,
    String? isWholesaler,
    String? isCatering,
    String? isVeg,
    String? isNonVeg,
    String? itemQuantity,
    String? itemDescription,
    String? itemNotes,
    String? liveStationName,
  }) async {
    Map<String, Object?> data = {
      "item_name": itemName,
      "chef_id": chefId,
      "menu_id": menuId,
      "menu_type": menuType,
      "is_wholesaler": isWholesaler,
      "is_catering": isCatering,
      'is_veg': isVeg,
      "is_non_veg": isNonVeg,
      'item_quantity': itemQuantity,
      'item_description': itemDescription,
      'item_notes': itemNotes,
      'live_station_name': liveStationName ?? "",
    };

    var headers = {
      'Authorization': 'Bearer ${Common.loginReponse.value.data!.token!}'
    };
    var response = await sendPost(
      "${Constants.API_BASE_URL}add-menu-item",
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

  Future<dynamic> editMenu({
    String? itemName,
    String? chefId,
    String? itemId,
    String? menuId,
    String? menuType,
    String? isWholesaler,
    String? isCatering,
    String? isVeg,
    String? isNonVeg,
    String? itemQuantity,
    String? itemDescription,
    String? itemNotes,
    String? liveStationName,
  }) async {
    Map<String, Object?> data = {
      "item_name": itemName,
      "menu_item_id": itemId,
      "chef_id": chefId,
      "menu_id": menuId,
      "menu_type": menuType,
      "is_wholesaler": isWholesaler,
      "is_catering": isCatering,
      'is_veg': isVeg,
      "is_non_veg": isNonVeg,
      'item_quantity': itemQuantity,
      'item_description': itemDescription,
      'item_notes': itemNotes,
      'live_station_name': liveStationName ?? "",
    };

    var headers = {
      'Authorization': 'Bearer ${Common.loginReponse.value.data!.token!}'
    };
    var response = await sendPost(
      "${Constants.API_BASE_URL}update-menu-item",
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

  Future<dynamic> getMenuItemFromID({
    required String id,
  }) async {
    var headers = {
      'Authorization': 'Bearer ${Common.loginReponse.value.data!.token!}'
    };
    var response = await sendGet(
      "${Constants.API_BASE_URL}get-menu-item?menu_id=$id",
      headers: headers,
    );
    if (response == null) {
      Constants.internalServerErrorToast();
      return null;
    }
    if (response.body['status'] == 200) {
      MenuItemModel menuData = MenuItemModel.fromJson(response.body);
      return menuData;
    } else if (response.body['status'] == 400) {
      appWidgets.hideDialog();
      appWidgets().showToast("Sorry", response.body['message']);
    } else {
      appWidgets.hideDialog();
      Constants.internalServerErrorToast();
    }
    return null;
  }

  Future<dynamic> requestItem(
      {List<int>? ids, required bool addedByVendor, String? vendorID}) async {
    Map<String, Object?> data = addedByVendor
        ? {"item_id": ids, "added_by_admin": "1", "vendor_id": vendorID}
        : {
            "item_id": ids,
          };

    var headers = {
      'Authorization': 'Bearer ${Common.loginReponse.value.data!.token!}'
    };
    var response = await sendPostRaw(
      "${Constants.API_BASE_URL}add-vendor-request-items",
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

  Future<dynamic> AddItemToAnOrder(
      {List<int>? ids, required String orderId, String? vendorID}) async {
    String result = ids?.isNotEmpty == true ? ids!.join(',') : '';
    Map<String, Object?> data = {
      "item_id": result,
      "vendor_id": vendorID,
      "order_id": orderId
    };

    var headers = {
      'Authorization': 'Bearer ${Common.loginReponse.value.data!.token!}'
    };
    var response = await sendPost(
      "${Constants.API_BASE_URL}add-item-to-order",
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

  Future<dynamic> editItemToAnOrder(
      {String? id,
      required String orderId,
      String? vendorID,
      String? itemQty,
      String? itmPrice}) async {
    Map<String, Object?> data = {
      "item_id": id,
      "vendor_id": vendorID,
      "order_id": orderId,
      "item_qty": itemQty,
      "item_price": itmPrice,
    };

    var headers = {
      'Authorization': 'Bearer ${Common.loginReponse.value.data!.token!}'
    };
    var response = await sendPost(
      "${Constants.API_BASE_URL}edit-order-item",
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

  Future<dynamic> addToCart({
    required String id,
  }) async {
    var headers = {
      'Authorization': 'Bearer ${Common.loginReponse.value.data!.token!}'
    };
    var data = {"item_id": id};
    var response = await sendPost(
      "${Constants.API_BASE_URL}add-item-to-cart",
      data,
      headers: headers,
    );
    if (response == null) {
      Constants.internalServerErrorToast();
      return null;
    }
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

  Future<dynamic> getCartItem() async {
    var headers = {
      'Authorization': 'Bearer ${Common.loginReponse.value.data!.token!}'
    };
    var response = await sendGet(
      "${Constants.API_BASE_URL}get-cart-items",
      headers: headers,
    );
    if (response == null) {
      Constants.internalServerErrorToast();
      return null;
    }
    if (response.body['status'] == 200) {
      getCartItemModel menuData = getCartItemModel.fromJson(response.body);
      return menuData;
    } else if (response.body['status'] == 400) {
      appWidgets.hideDialog();
      appWidgets().showToast("Sorry", response.body['message']);
    } else {
      appWidgets.hideDialog();
      Constants.internalServerErrorToast();
    }
    return null;
  }

  Future<dynamic> getDashBoardCounter() async {
    var headers = {
      'Authorization': 'Bearer ${Common.loginReponse.value.data!.token!}'
    };
    var data = {"role": Common.loginReponse.value.data!.role!};
    var response = await sendGet(
      "${Constants.API_BASE_URL}get-dashboard-counter",
      query: data,
      headers: headers,
    );
    if (response == null) {
      Get.back();
      Constants.internalServerErrorToast();
      return null;
    }
    if (response.body['status'] == 200) {
      dashBoardCounterModel menuData =
          dashBoardCounterModel.fromJson(response.body);
      return menuData;
    } else if (response.body['status'] == 400) {
      appWidgets.hideDialog();
      appWidgets().showToast("Sorry", response.body['message']);
    } else {
      appWidgets.hideDialog();
      Constants.internalServerErrorToast();
    }
    return null;
  }

  Future<dynamic> getInvoice(String id) async {
    var headers = {
      'Authorization': 'Bearer ${Common.loginReponse.value.data!.token!}'
    };
    var data = {"order_id": id};
    var response = await sendGet(
      "${Constants.API_BASE_URL}generate-order-invoice",
      query: data,
      headers: headers,
    );
    if (response == null) {
      Get.back();
      Constants.internalServerErrorToast();
      return null;
    }
    if (response.body['status'] == 200) {
      return response.body['data']['invoice_url'];
    } else if (response.body['status'] == 400) {
      appWidgets.hideDialog();
      appWidgets().showToast("Sorry", response.body['message']);
    } else {
      appWidgets.hideDialog();
      Constants.internalServerErrorToast();
    }
    return null;
  }

  Future<dynamic> getInvoiceLink(String startDate, String endDate) async {
    var headers = {
      'Authorization': 'Bearer ${Common.loginReponse.value.data!.token!}'
    };
    var data = {"from_date": startDate, "to_date": endDate};
    var response = await sendGet(
      "${Constants.API_BASE_URL}generate-purchase-order-report",
      query: data,
      headers: headers,
    );
    if (response == null) {
      Get.back();
      Constants.internalServerErrorToast();
      return null;
    }
    if (response.body['status'] == 200) {
      return response.body['data']['invoice_url'];
    } else if (response.body['status'] == 400) {
      appWidgets.hideDialog();
      appWidgets().showToast("Sorry", response.body['message']);
    } else {
      appWidgets.hideDialog();
      Constants.internalServerErrorToast();
    }
    return null;
  }

  Future<dynamic> getChefInvoiceLink(
      String startDate, String endDate, String chefID) async {
    var headers = {
      'Authorization': 'Bearer ${Common.loginReponse.value.data!.token!}'
    };
    var data = {"from_date": startDate, "to_date": endDate, "chef_id": chefID};
    var response = await sendGet(
      "${Constants.API_BASE_URL}get-chef-orders-report",
      query: data,
      headers: headers,
    );
    if (response == null) {
      Get.back();
      Constants.internalServerErrorToast();
      return null;
    }
    if (response.body['status'] == 200) {
      return response.body['data']['invoice_url'];
    } else if (response.body['status'] == 400) {
      appWidgets.hideDialog();
      appWidgets().showToast("Sorry", response.body['message']);
    } else {
      appWidgets.hideDialog();
      Constants.internalServerErrorToast();
    }
    return null;
  }

  Future<dynamic> getGeneraicInvoiceLink(String startDate, String endDate,
      String? chefID, String reportType) async {
    var headers = {
      'Authorization': 'Bearer ${Common.loginReponse.value.data!.token!}'
    };
    var data = chefID == null
        ? {
            "from_date": startDate,
            "to_date": endDate,
            "report_type":
                reportType.toString().replaceAll(" ", "_").toLowerCase()
          }
        : {
            "from_date": startDate,
            "to_date": endDate,
            "vendor_id": chefID,
            "report_type":
                reportType.toString().replaceAll(" ", "_").toLowerCase()
          };
    var response = await sendGet(
      "${Constants.API_BASE_URL}get-generic-report",
      query: data,
      headers: headers,
    );
    if (response == null) {
      Constants.internalServerErrorToast();
      return null;
    }
    if (response.body['status'] == 200) {
      appWidgets.hideDialog();
      return response.body['data']['invoice_url'];
    } else if (response.body['status'] == 400) {
      appWidgets.hideDialog();
      appWidgets().showToast("Sorry", response.body['message']);
    } else {
      appWidgets.hideDialog();
      Constants.internalServerErrorToast();
    }
    return null;
  }

  Future<dynamic> placeOrder({
    String? tax,
    String? shippingCharges,
    String? subTotal,
    String? totalAmount,
    String? isSelf,
    String? orderBillingAddress,
    String? orderNotes,
    String? paymentType,
    var orderItems,
  }) async {
    var headers = {
      'Authorization': 'Bearer ${Common.loginReponse.value.data!.token!}'
    };
    var data = {
      "tax": tax,
      "shipping_charges": shippingCharges,
      'sub_total': totalAmount,
      'total_amount': subTotal,
      'is_self_pickup': isSelf,
      "order_note": orderNotes,
      "order_billing_address": orderBillingAddress,
      'order_items': orderItems,
      'payment_type': paymentType,
    };
    var response = await sendPost(
      "${Constants.API_BASE_URL}create-order",
      data,
      headers: headers,
    );
    if (response == null) {
      Constants.internalServerErrorToast();
      return null;
    }
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

  Future<dynamic> assignOrderToChef({
    String? itemId,
    String? chefId,
    String? orderID,
    String? date,
  }) async {
    var headers = {
      'Authorization': 'Bearer ${Common.loginReponse.value.data!.token!}'
    };
    var data = {
      "item_id": itemId,
      "chef_id": chefId,
      "order_id": orderID,
      "preperation_date": date
    };
    var response = await sendPost(
      "${Constants.API_BASE_URL}assign-order-to-chef",
      headers: headers,
      data,
    );
    if (response == null) {
      appWidgets.hideDialog();
      Constants.internalServerErrorToast();
      return null;
    } else {
      try {
        if (response.body['status'] == 200) {
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
  }

  Future<dynamic> assignOrderToDeliveryUSer({
    String? deliveryUserId,
    String? orderID,
  }) async {
    var headers = {
      'Authorization': 'Bearer ${Common.loginReponse.value.data!.token!}'
    };
    var data = {
      "order_id": orderID,
      "delivery_user_id": deliveryUserId,
    };
    var response = await sendPost(
      "${Constants.API_BASE_URL}assign-order-to-delivery-user",
      headers: headers,
      data,
    );
    if (response == null) {
      appWidgets.hideDialog();
      Constants.internalServerErrorToast();
      return null;
    } else {
      try {
        if (response.body['status'] == 200) {
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
  }
}
