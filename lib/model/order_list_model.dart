class OrderListModel {
  String? message;
  int? status;
  Data? data;

  OrderListModel({this.message, this.status, this.data});

  OrderListModel.fromJson(Map<String, dynamic> json) {
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
  List<OrdersList>? ordersList;

  Data(
      {this.totalRecords,
      this.limit,
      this.currentPage,
      this.totalPages,
      this.ordersList});

  Data.fromJson(Map<String, dynamic> json) {
    totalRecords = json['total_records'];
    limit = json['limit'].toString();
    currentPage = json['current_page'].toString();
    totalPages = json['total_pages'];
    if (json['orders_list'] != null) {
      ordersList = <OrdersList>[];
      json['orders_list'].forEach((v) {
        ordersList!.add(OrdersList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total_records'] = totalRecords;
    data['limit'] = limit;
    data['current_page'] = currentPage;
    data['total_pages'] = totalPages;
    if (ordersList != null) {
      data['orders_list'] = ordersList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class OrdersList {
  int? id;
  int? deliveryUserForOrder;
  String? orderIdentifier;
  int? orderBy;
  String? tax;
  String? shippingCharges;
  String? subTotal;
  String? totalAmount;
  int? isSelfPickup;
  String? orderNote;
  String? orderStatus;
  String? deliveryStatus;
  String? orderBillingAddress;
  String? orderCreatedAt;
  List<OrdersItems>? ordersItems;
  VendorInfo? vendorInfo;

  OrdersList(
      {this.id,
      this.orderIdentifier,
      this.orderBy,
      this.tax,
      this.deliveryStatus,
      this.deliveryUserForOrder,
      this.subTotal,
      this.totalAmount,
      this.isSelfPickup,
      this.orderNote,
      this.orderStatus,
      this.orderBillingAddress,
      this.orderCreatedAt,
      this.ordersItems,
      this.vendorInfo});

  OrdersList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    deliveryUserForOrder = json['delivery_user_for_order'];
    deliveryStatus = json['deliver_user_status'];
    orderIdentifier = json['order_identifier'];
    orderBy = json['order_by'];
    tax = json['tax'];
    shippingCharges = json['shipping_charges'];
    subTotal = json['sub_total'];
    totalAmount = json['total_amount'];
    isSelfPickup = json['is_self_pickup'];
    orderNote = json['order_note'];
    orderStatus = json['order_status'];
    orderBillingAddress = json['order_billing_address'];
    orderCreatedAt = json['order_created_at'];
    if (json['orders_items'] != null) {
      ordersItems = <OrdersItems>[];
      json['orders_items'].forEach((v) {
        ordersItems!.add(OrdersItems.fromJson(v));
      });
    }
    vendorInfo = json['vendor_info'] != null
        ? VendorInfo.fromJson(json['vendor_info'])
        : null;
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
    data['order_status'] = orderStatus;
    data['order_billing_address'] = orderBillingAddress;
    data['order_created_at'] = orderCreatedAt;
    if (ordersItems != null) {
      data['orders_items'] = ordersItems!.map((v) => v.toJson()).toList();
    }
    if (vendorInfo != null) {
      data['vendor_info'] = vendorInfo!.toJson();
    }
    return data;
  }
}

class OrdersItems {
  int? id;
  int? chefId;
  String? chefStatus;
  String? chefName;
  int? orderId;
  int? itemId;
  String? itemBasePrice;
  String? itemQuantity;
  String? itemNote;
  MenuItemInfo? menuItemInfo;

  OrdersItems(
      {this.id,
      this.orderId,
      this.itemId,
      this.chefId,
      this.chefName,
      this.chefStatus,
      this.itemBasePrice,
      this.itemQuantity,
      this.itemNote,
      this.menuItemInfo});

  OrdersItems.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderId = json['order_id'];
    chefName = json["chef_name"];
    itemId = json['item_id'];
    chefId = json['chef_id'];
    chefStatus = json['chef_status'];
    itemBasePrice = json['item_base_price'];
    itemQuantity = json['item_quantity'];
    itemNote = json['item_note'];
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
    if (menuItemInfo != null) {
      data['menu_item_info'] = menuItemInfo!.toJson();
    }
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

class VendorInfo {
  int? id;
  String? name;
  String? email;
  String? phoneNumber;
  String? role;
  String? profileImage;
  String? userName;
  String? vendorCategory;
  String? tax;
  String? billingAddress;
  String? shippingAddress;
  String? deliveryCharges;
  String? fcmToken;

  VendorInfo(
      {this.id,
      this.name,
      this.email,
      this.phoneNumber,
      this.role,
      this.profileImage,
      this.userName,
      this.vendorCategory,
      this.tax,
      this.billingAddress,
      this.shippingAddress,
      this.deliveryCharges,
      this.fcmToken});

  VendorInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    phoneNumber = json['phone_number'];
    role = json['role'];
    profileImage = json['profile_image'];
    userName = json['user_name'];
    vendorCategory = json['vendor_category'];
    tax = json['tax'];
    billingAddress = json['billing_address'];
    shippingAddress = json['shipping_address'];
    deliveryCharges = json['delivery_charges'];
    fcmToken = json['fcm_token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['phone_number'] = phoneNumber;
    data['role'] = role;
    data['profile_image'] = profileImage;
    data['user_name'] = userName;
    data['vendor_category'] = vendorCategory;
    data['tax'] = tax;
    data['billing_address'] = billingAddress;
    data['shipping_address'] = shippingAddress;
    data['delivery_charges'] = deliveryCharges;
    data['fcm_token'] = fcmToken;
    return data;
  }
}
