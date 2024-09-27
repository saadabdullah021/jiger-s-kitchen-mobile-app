import 'package:jigers_kitchen/model/chef_drop_down_data_model.dart';

class getPriceSlabModel {
  String? message;
  int? status;
  Data? data;

  getPriceSlabModel({this.message, this.status, this.data});

  getPriceSlabModel.fromJson(Map<String, dynamic> json) {
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
  List<ChefData>? vendors;
  MenuItemInfo? menuItemInfo;

  Data({this.vendors, this.menuItemInfo});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['vendors'] != null) {
      vendors = <ChefData>[];
      json['vendors'].forEach((v) {
        vendors!.add(ChefData.fromJson(v));
      });
    }
    menuItemInfo = json['menu_item_info'] != null
        ? MenuItemInfo.fromJson(json['menu_item_info'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (vendors != null) {
      data['vendors'] = vendors!.map((v) => v.toJson()).toList();
    }
    if (menuItemInfo != null) {
      data['menu_item_info'] = menuItemInfo!.toJson();
    }
    return data;
  }
}

class MenuItemInfo {
  int? id;
  String? itemName;
  String? itemQuantity;

  MenuItemInfo({this.id, this.itemName, this.itemQuantity});

  MenuItemInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    itemName = json['item_name'];
    itemQuantity = json['item_quantity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['item_name'] = itemName;
    data['item_quantity'] = itemQuantity;
    return data;
  }
}
