class GetMenuItemModel {
  String? message;
  int? status;
  Data? data;

  GetMenuItemModel({this.message, this.status, this.data});

  GetMenuItemModel.fromJson(Map<String, dynamic> json) {
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
  int? limit;
  int? currentPage;
  int? totalPages;
  List<MenuItemsList>? menuItemsList;

  Data(
      {this.totalRecords,
      this.limit,
      this.currentPage,
      this.totalPages,
      this.menuItemsList});

  Data.fromJson(Map<String, dynamic> json) {
    totalRecords = json['total_records'];
    limit = json['limit'];
    currentPage = json['current_page'];
    totalPages = json['total_pages'];
    if (json['menu_items_list'] != null) {
      menuItemsList = <MenuItemsList>[];
      json['menu_items_list'].forEach((v) {
        menuItemsList!.add(MenuItemsList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total_records'] = totalRecords;
    data['limit'] = limit;
    data['current_page'] = currentPage;
    data['total_pages'] = totalPages;
    if (menuItemsList != null) {
      data['menu_items_list'] = menuItemsList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class MenuItemsList {
  int? id;
  String? itemName;
  int? menuId;
  int? isChefSpecial;
  int? showInMenu;
  String? profileImage;
  String? description;

  MenuItemsList(
      {this.id,
      this.itemName,
      this.menuId,
      this.isChefSpecial,
      this.showInMenu,
      this.profileImage,
      this.description});

  MenuItemsList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    itemName = json['item_name'];
    menuId = json['menu_id'];
    isChefSpecial = json['is_chef_special'];
    showInMenu = json['show_in_menu'];
    profileImage = json['profile_image'];
    description = json['item_description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['item_name'] = itemName;
    data['menu_id'] = menuId;
    data['is_chef_special'] = isChefSpecial;
    data['show_in_menu'] = showInMenu;
    data['profile_image'] = profileImage;
    return data;
  }
}
