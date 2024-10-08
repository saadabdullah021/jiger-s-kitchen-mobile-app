class GetChefOrderListModel {
  String? message;
  int? status;
  Data? data;

  GetChefOrderListModel({this.message, this.status, this.data});

  GetChefOrderListModel.fromJson(Map<String, dynamic> json) {
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
  int? currentPage;
  int? lastPage;
  int? totalItems;
  int? perPage;
  Items? items;

  Data(
      {this.currentPage,
      this.lastPage,
      this.totalItems,
      this.perPage,
      this.items});

  Data.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    lastPage = json['last_page'];
    totalItems = json['total_items'];
    perPage = json['per_page'];
    items = json['items'] != null ? Items.fromJson(json['items']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['current_page'] = currentPage;
    data['last_page'] = lastPage;
    data['total_items'] = totalItems;
    data['per_page'] = perPage;
    if (items != null) {
      data['items'] = items!.toJson();
    }
    return data;
  }
}

class Items {
  int? currentPage;
  List<ItemData>? data;
  String? firstPageUrl;
  int? from;
  int? lastPage;
  String? lastPageUrl;
  List<Links>? links;
  String? nextPageUrl;
  String? path;
  int? perPage;
  String? prevPageUrl;
  int? to;
  int? total;

  Items(
      {this.currentPage,
      this.data,
      this.firstPageUrl,
      this.from,
      this.lastPage,
      this.lastPageUrl,
      this.links,
      this.nextPageUrl,
      this.path,
      this.perPage,
      this.prevPageUrl,
      this.to,
      this.total});

  Items.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    if (json['data'] != null) {
      data = <ItemData>[];
      json['data'].forEach((v) {
        data!.add(ItemData.fromJson(v));
      });
    }
    firstPageUrl = json['first_page_url'];
    from = json['from'];
    lastPage = json['last_page'];
    lastPageUrl = json['last_page_url'];
    if (json['links'] != null) {
      links = <Links>[];
      json['links'].forEach((v) {
        links!.add(Links.fromJson(v));
      });
    }
    nextPageUrl = json['next_page_url'];
    path = json['path'];
    perPage = json['per_page'];
    prevPageUrl = json['prev_page_url'];
    to = json['to'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['current_page'] = currentPage;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['first_page_url'] = firstPageUrl;
    data['from'] = from;
    data['last_page'] = lastPage;
    data['last_page_url'] = lastPageUrl;
    if (links != null) {
      data['links'] = links!.map((v) => v.toJson()).toList();
    }
    data['next_page_url'] = nextPageUrl;
    data['path'] = path;
    data['per_page'] = perPage;
    data['prev_page_url'] = prevPageUrl;
    data['to'] = to;
    data['total'] = total;
    return data;
  }
}

class ItemData {
  int? id;
  int? orderId;
  int? itemId;
  String? itemBasePrice;
  String? itemQuantity;
  String? itemNote;
  String? itemPrepTime;
  String? chefStatus;
  int? chefId;
  OrderInfo? orderInfo;
  MenuItemInfo? menuItemInfo;

  ItemData(
      {this.id,
      this.orderId,
      this.itemId,
      this.itemBasePrice,
      this.itemQuantity,
      this.itemNote,
      this.itemPrepTime,
      this.chefStatus,
      this.chefId,
      this.orderInfo,
      this.menuItemInfo});

  ItemData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderId = json['order_id'];
    itemId = json['item_id'];
    itemBasePrice = json['item_base_price'];
    itemQuantity = json['item_quantity'];
    itemNote = json['item_note'];
    itemPrepTime = json['item_prep_time'];
    chefStatus = json['chef_status'];
    chefId = json['chef_id'];
    orderInfo = json['order_info'] != null
        ? OrderInfo.fromJson(json['order_info'])
        : null;
    menuItemInfo = json['menu_item_info'] != null
        ? MenuItemInfo.fromJson(json['menu_item_info'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['order_id'] = orderId;
    data['item_id'] = itemId;
    data['item_base_price'] = itemBasePrice;
    data['item_quantity'] = itemQuantity;
    data['item_note'] = itemNote;
    data['item_prep_time'] = itemPrepTime;
    data['chef_status'] = chefStatus;
    data['chef_id'] = chefId;
    if (orderInfo != null) {
      data['order_info'] = orderInfo!.toJson();
    }
    if (menuItemInfo != null) {
      data['menu_item_info'] = menuItemInfo!.toJson();
    }
    return data;
  }
}

class OrderInfo {
  int? id;
  String? orderIdentifier;
  int? orderBy;
  String? tax;
  String? shippingCharges;
  String? subTotal;
  String? totalAmount;
  int? isSelfPickup;
  String? orderNote;
  String? orderCreatedAt;

  OrderInfo(
      {this.id,
      this.orderIdentifier,
      this.orderBy,
      this.tax,
      this.shippingCharges,
      this.subTotal,
      this.totalAmount,
      this.isSelfPickup,
      this.orderNote,
      this.orderCreatedAt});

  OrderInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderIdentifier = json['order_identifier'];
    orderBy = json['order_by'];
    tax = json['tax'];
    shippingCharges = json['shipping_charges'];
    subTotal = json['sub_total'];
    totalAmount = json['total_amount'];
    isSelfPickup = json['is_self_pickup'];
    orderNote = json['order_note'];
    orderCreatedAt = json['order_created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['order_identifier'] = orderIdentifier;
    data['order_by'] = orderBy;
    data['tax'] = tax;
    data['shipping_charges'] = shippingCharges;
    data['sub_total'] = subTotal;
    data['total_amount'] = totalAmount;
    data['is_self_pickup'] = isSelfPickup;
    data['order_note'] = orderNote;
    data['order_created_at'] = orderCreatedAt;
    return data;
  }
}

class MenuItemInfo {
  int? id;
  String? itemName;
  String? itemDescription;
  String? profileImage;

  MenuItemInfo(
      {this.id, this.itemName, this.itemDescription, this.profileImage});

  MenuItemInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    itemName = json['item_name'];
    itemDescription = json['item_description'];
    profileImage = json['profile_image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['item_name'] = itemName;
    data['item_description'] = itemDescription;
    data['profile_image'] = profileImage;
    return data;
  }
}

class Links {
  String? url;
  String? label;
  bool? active;

  Links({this.url, this.label, this.active});

  Links.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    label = json['label'];
    active = json['active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['url'] = url;
    data['label'] = label;
    data['active'] = active;
    return data;
  }
}
