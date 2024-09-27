import 'package:jigers_kitchen/model/requested_item_list_model.dart';

class GetVendorApprovedItemModel {
  String? message;
  int? status;
  Data? data;

  GetVendorApprovedItemModel({this.message, this.status, this.data});

  GetVendorApprovedItemModel.fromJson(Map<String, dynamic> json) {
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
  int? totalPages;
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
    totalPages = json['total_pages'];
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
