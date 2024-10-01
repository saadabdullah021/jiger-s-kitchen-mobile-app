class getCartItemModel {
  String? message;
  int? status;
  List<Data>? data;

  getCartItemModel({this.message, this.status, this.data});

  getCartItemModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
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

class Data {
  int? id;
  int? cartId;
  int? itemId;
  List<PriceSlabs>? priceSlabs;
  MenuItem? menuItem;

  Data({this.id, this.cartId, this.itemId, this.priceSlabs, this.menuItem});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    cartId = json['cart_id'];
    itemId = json['item_id'];
    if (json['price_slabs'] != null) {
      priceSlabs = <PriceSlabs>[];
      json['price_slabs'].forEach((v) {
        priceSlabs!.add(PriceSlabs.fromJson(v));
      });
    }
    menuItem =
        json['menu_item'] != null ? MenuItem.fromJson(json['menu_item']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['cart_id'] = cartId;
    data['item_id'] = itemId;
    if (priceSlabs != null) {
      data['price_slabs'] = priceSlabs!.map((v) => v.toJson()).toList();
    }
    if (menuItem != null) {
      data['menu_item'] = menuItem!.toJson();
    }
    return data;
  }
}

class PriceSlabs {
  int? id;
  String? quantity;
  String? price;
  int? userId;
  int? menuItemId;

  PriceSlabs(
      {this.id, this.quantity, this.price, this.userId, this.menuItemId});

  PriceSlabs.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    quantity = json['quantity'];
    price = json['price'];
    userId = json['user_id'];
    menuItemId = json['menu_item_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['quantity'] = quantity;
    data['price'] = price;
    data['user_id'] = userId;
    data['menu_item_id'] = menuItemId;
    return data;
  }
}

class MenuItem {
  int? id;
  String? itemName;
  String? itemQuantity;
  String? itemDescription;
  String? profileImage;

  MenuItem(
      {this.id,
      this.itemName,
      this.itemQuantity,
      this.itemDescription,
      this.profileImage});

  MenuItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    itemName = json['item_name'];
    itemQuantity = json['item_quantity'];
    itemDescription = json['item_description'];
    profileImage = json['profile_image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['item_name'] = itemName;
    data['item_quantity'] = itemQuantity;
    data['item_description'] = itemDescription;
    data['profile_image'] = profileImage;
    return data;
  }
}
