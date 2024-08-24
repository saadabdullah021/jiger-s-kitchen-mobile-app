class UserDataModel {
  String? message;
  int? status;
  Data? data;

  UserDataModel({this.message, this.status, this.data});

  UserDataModel.fromJson(Map<String, dynamic> json) {
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
  String? name;
  String? userName;
  String? email;
  String? multipleOrderEmail;
  String? phoneNumber;
  String? role;
  String? tax;
  String? vendorCategory;
  String? billingAddress;
  String? shippingAddress;
  String? deliveryCharges;
  int? status;
  String? updatedAt;
  String? createdAt;
  int? id;

  Data(
      {this.name,
      this.userName,
      this.email,
      this.multipleOrderEmail,
      this.phoneNumber,
      this.role,
      this.tax,
      this.vendorCategory,
      this.billingAddress,
      this.shippingAddress,
      this.deliveryCharges,
      this.status,
      this.updatedAt,
      this.createdAt,
      this.id});

  Data.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    userName = json['user_name'];
    email = json['email'];
    multipleOrderEmail = json['multiple_order_email'];
    phoneNumber = json['phone_number'];
    role = json['role'];
    tax = json['tax'];
    vendorCategory = json['vendor_category'];
    billingAddress = json['billing_address'];
    shippingAddress = json['shipping_address'];
    deliveryCharges = json['delivery_charges'];
    status = json['status'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['user_name'] = userName;
    data['email'] = email;
    data['multiple_order_email'] = multipleOrderEmail;
    data['phone_number'] = phoneNumber;
    data['role'] = role;
    data['tax'] = tax;
    data['vendor_category'] = vendorCategory;
    data['billing_address'] = billingAddress;
    data['shipping_address'] = shippingAddress;
    data['delivery_charges'] = deliveryCharges;
    data['status'] = status;
    data['updated_at'] = updatedAt;
    data['created_at'] = createdAt;
    data['id'] = id;
    return data;
  }
}
