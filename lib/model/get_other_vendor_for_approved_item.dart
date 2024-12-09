class GetOtherVendorForApprovedItemModel {
  String? message;
  int? status;
  List<OtherPriceData>? data;

  GetOtherVendorForApprovedItemModel({this.message, this.status, this.data});

  GetOtherVendorForApprovedItemModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'];
    if (json['data'] != null) {
      data = <OtherPriceData>[];
      json['data'].forEach((v) {
        data!.add(OtherPriceData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    data['status'] = status;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class OtherPriceData {
  int? id;
  String? quantity;
  String? price;
  int? userId;
  int? menuItemId;
  int? deletedAt;
  String? createdAt;
  String? updatedAt;
  int? vendorId;
  GetVendors? getVendors;

  OtherPriceData(
      {this.id,
      this.quantity,
      this.price,
      this.userId,
      this.menuItemId,
      this.deletedAt,
      this.createdAt,
      this.updatedAt,
      this.vendorId,
      this.getVendors});

  OtherPriceData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    quantity = json['quantity'];
    price = json['price'];
    userId = json['user_id'];
    menuItemId = json['menu_item_id'];
    deletedAt = json['deleted_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    vendorId = json['vendor_id'];
    getVendors = json['get_vendors'] != null
        ? GetVendors.fromJson(json['get_vendors'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['quantity'] = quantity;
    data['price'] = price;
    data['user_id'] = userId;
    data['menu_item_id'] = menuItemId;
    data['deleted_at'] = deletedAt;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['vendor_id'] = vendorId;
    if (getVendors != null) {
      data['get_vendors'] = getVendors!.toJson();
    }
    return data;
  }
}

class GetVendors {
  int? id;
  String? name;
  String? profileImage;

  GetVendors({this.id, this.name, this.profileImage});

  GetVendors.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    profileImage = json['profile_image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['profile_image'] = profileImage;
    return data;
  }
}
