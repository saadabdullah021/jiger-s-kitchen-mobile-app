class RequestedItemListModel {
  String? message;
  int? status;
  Data? data;

  RequestedItemListModel({this.message, this.status, this.data});

  RequestedItemListModel.fromJson(Map<String, dynamic> json) {
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
  int? totalRecords;
  String? limit;
  String? currentPage;
  String? totalPages;
  List<ItemsList>? itemsList;

  Data(
      {this.totalRecords,
      this.limit,
      this.currentPage,
      this.totalPages,
      this.itemsList});

  Data.fromJson(Map<String, dynamic> json) {
    totalRecords = json['total_records'];
    limit = json['limit'].toString();
    currentPage = json['current_page'].toString();
    totalPages = json['total_pages'].toString();
    if (json['items_list'] != null) {
      itemsList = <ItemsList>[];
      json['items_list'].forEach((v) {
        itemsList!.add(ItemsList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total_records'] = totalRecords;
    data['limit'] = limit;
    data['current_page'] = currentPage;
    data['total_pages'] = totalPages;
    if (itemsList != null) {
      data['items_list'] = itemsList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ItemsList {
  int? vendorId;
  int? itemId;
  String? itemName;
  String? description;
  String? profileImage;
  String? updatedAt;

  ItemsList(
      {this.vendorId,
      this.itemId,
      this.itemName,
      this.description,
      this.profileImage,
      this.updatedAt});

  ItemsList.fromJson(Map<String, dynamic> json) {
    vendorId = json['vendor_id'];
    itemId = json['item_id'];
    itemName = json['item_name'];
    profileImage = json['profile_image'];
    updatedAt = json['updated_at'];
    description = json['item_description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['vendor_id'] = vendorId;
    data['item_id'] = itemId;
    data['item_name'] = itemName;
    data['profile_image'] = profileImage;
    data['updated_at'] = updatedAt;
    return data;
  }
}
