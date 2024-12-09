class loginModel {
  String? message;
  int? status;
  Data? data;

  loginModel({this.message, this.status, this.data});

  loginModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    data['status'] = status;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  int? id;
  String? name;
  String? email;
  String? emailVerifiedAt;
  String? phoneNumber;
  String? role;
  String? profileImage;
  int? status;
  String? userName;
  String? multipleOrderEmail;
  String? vendorCategory;
  String? token;
  String? tax;
  String? billingAddress;
  String? shippingAddress;
  String? deliveryCharges;
  String? fcmToken;
  int? addedBy;
  String? updatedBy;
  int? registeredAt;
  int? lastLoginAt;
  String? createdAt;
  String? updatedAt;
  String? cartConter;

  Data(
      {this.id,
      this.name,
      this.email,
      this.emailVerifiedAt,
      this.cartConter,
      this.phoneNumber,
      this.role,
      this.profileImage,
      this.status,
      this.userName,
      this.multipleOrderEmail,
      this.vendorCategory,
      this.token,
      this.tax,
      this.billingAddress,
      this.shippingAddress,
      this.deliveryCharges,
      this.fcmToken,
      this.addedBy,
      this.updatedBy,
      this.registeredAt,
      this.lastLoginAt,
      this.createdAt,
      this.updatedAt});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    emailVerifiedAt = json['email_verified_at'];
    cartConter = json["cart_counter"].toString();
    phoneNumber = json['phone_number'];
    role = json['role'];
    profileImage = json['profile_image'];
    status = json['status'];
    userName = json['user_name'];
    multipleOrderEmail = json['multiple_order_email'];
    vendorCategory = json['vendor_category'];
    token = json['token'];
    tax = json['tax'];
    billingAddress = json['billing_address'];
    shippingAddress = json['shipping_address'];
    deliveryCharges = json['delivery_charges'];
    fcmToken = json['fcm_token'];
    addedBy = json['added_by'];
    updatedBy = json['updated_by'].toString();
    registeredAt = json['registered_at'];
    lastLoginAt = json['last_login_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['email_verified_at'] = emailVerifiedAt;
    data['phone_number'] = phoneNumber;
    data['role'] = role;
    data['profile_image'] = profileImage;
    data['status'] = status;
    data['user_name'] = userName;
    data['multiple_order_email'] = multipleOrderEmail;
    data['vendor_category'] = vendorCategory;
    data['token'] = token;
    data['tax'] = tax;
    data['billing_address'] = billingAddress;
    data['shipping_address'] = shippingAddress;
    data['delivery_charges'] = deliveryCharges;
    data['fcm_token'] = fcmToken;
    data['added_by'] = addedBy;
    data['updated_by'] = updatedBy;
    data['registered_at'] = registeredAt;
    data['last_login_at'] = lastLoginAt;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
