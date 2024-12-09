class MenuItemModel {
  String? message;
  int? status;
  Data? data;

  MenuItemModel({this.message, this.status, this.data});

  MenuItemModel.fromJson(Map<String, dynamic> json) {
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
  String? itemName;
  int? chefId;
  int? menuId;
  String? menuType;
  String? liveStationName;
  int? isWholesaler;
  int? isCatering;
  int? isVeg;
  int? isNonVeg;
  String? itemQuantity;
  String? itemDescription;
  String? itemNotes;
  int? showInMenu;
  int? isChefSpecial;
  String? profileImage;
  String? createdAt;
  String? updatedAt;

  Data(
      {this.id,
      this.itemName,
      this.chefId,
      this.menuId,
      this.menuType,
      this.liveStationName,
      this.isWholesaler,
      this.isCatering,
      this.isVeg,
      this.isNonVeg,
      this.itemQuantity,
      this.itemDescription,
      this.itemNotes,
      this.showInMenu,
      this.isChefSpecial,
      this.profileImage,
      this.createdAt,
      this.updatedAt});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    itemName = json['item_name'];
    chefId = json['chef_id'];
    menuId = json['menu_id'];
    menuType = json['menu_type'];
    liveStationName = json['live_station_name'];
    isWholesaler = json['is_wholesaler'];
    isCatering = json['is_catering'];
    isVeg = json['is_veg'];
    isNonVeg = json['is_non_veg'];
    itemQuantity = json['item_quantity'];
    itemDescription = json['item_description'];
    itemNotes = json['item_notes'];
    showInMenu = json['show_in_menu'];
    isChefSpecial = json['is_chef_special'];
    profileImage = json['profile_image'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['item_name'] = itemName;
    data['chef_id'] = chefId;
    data['menu_id'] = menuId;
    data['menu_type'] = menuType;
    data['live_station_name'] = liveStationName;
    data['is_wholesaler'] = isWholesaler;
    data['is_catering'] = isCatering;
    data['is_veg'] = isVeg;
    data['is_non_veg'] = isNonVeg;
    data['item_quantity'] = itemQuantity;
    data['item_description'] = itemDescription;
    data['item_notes'] = itemNotes;
    data['show_in_menu'] = showInMenu;
    data['is_chef_special'] = isChefSpecial;
    data['profile_image'] = profileImage;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
