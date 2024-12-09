class dashBoardCounterModel {
  String? message;
  int? status;
  Data? data;

  dashBoardCounterModel({this.message, this.status, this.data});

  dashBoardCounterModel.fromJson(Map<String, dynamic> json) {
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
  int? newOrders;
  int? pickupOrders;
  int? outOfDelivery;
  int? deliveredOrders;
  int? cancelledOrders;
  int? paidOrders;
  int? inProgressOrders;

  Data(
      {this.newOrders,
      this.pickupOrders,
      this.outOfDelivery,
      this.deliveredOrders,
      this.cancelledOrders,
      this.paidOrders,
      this.inProgressOrders});

  Data.fromJson(Map<String, dynamic> json) {
    newOrders = json['new_orders'];
    pickupOrders = json['pickup_orders'];
    outOfDelivery = json['out_of_delivery'];
    deliveredOrders = json['delivered_orders'];
    cancelledOrders = json['cancelled_orders'];
    paidOrders = json['paid_orders'];
    inProgressOrders = json['in_progress_orders'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['new_orders'] = newOrders;
    data['pickup_orders'] = pickupOrders;
    data['out_of_delivery'] = outOfDelivery;
    data['delivered_orders'] = deliveredOrders;
    data['cancelled_orders'] = cancelledOrders;
    data['paid_orders'] = paidOrders;
    data['in_progress_orders'] = inProgressOrders;
    return data;
  }
}
