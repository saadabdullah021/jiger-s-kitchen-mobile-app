import 'package:jigers_kitchen/model/user_data_model.dart';
import 'package:jigers_kitchen/utils/widget/appwidgets.dart';

import '../contstants.dart';
import 'base_api.dart';

class AppInterface extends BaseApi {
  Future<UserDataModel?> register({
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
    var headers = {
      'Accept': '/',
      'User-Agent': 'Thunder Client (https://www.thunderclient.com)'
    };
    var response = await sendPost(
        "${Constants.API_BASE_URL}register-vendor", data,
        headers: headers);
    if (response == null) return null;
    if (response.body['status'] == 200) {
      UserDataModel resposeData = UserDataModel.fromJson(response.body['data']);

      return resposeData;
    } else if (response.body['status'] == 400) {
      appWidgets().showToast("Sorry", response.body['message']);
      return null;
    }
    return null;
  }
}
