class GetOtherVendorItemDetailModel {
  String? message;
  int? status;
  List<OtherPriceDetail>? data;

  GetOtherVendorItemDetailModel({this.message, this.status, this.data});

  GetOtherVendorItemDetailModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'];
    if (json['data'] != null) {
      data = <OtherPriceDetail>[];
      json['data'].forEach((v) {
        data!.add(OtherPriceDetail.fromJson(v));
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

class OtherPriceDetail {
  int? id;
  String? quantity;
  String? price;
  int? userId;
  int? menuItemId;
  int? deletedAt;
  String? createdAt;
  String? updatedAt;
  int? vendorId;

  OtherPriceDetail(
      {this.id,
      this.quantity,
      this.price,
      this.userId,
      this.menuItemId,
      this.deletedAt,
      this.createdAt,
      this.updatedAt,
      this.vendorId});

  OtherPriceDetail.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    quantity = json['quantity'];
    price = json['price'];
    userId = json['user_id'];
    menuItemId = json['menu_item_id'];
    deletedAt = json['deleted_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    vendorId = json['vendor_id'];
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
    return data;
  }
}
