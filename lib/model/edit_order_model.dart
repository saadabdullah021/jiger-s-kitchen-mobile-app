import 'package:jigers_kitchen/model/order_list_model.dart';

class editItemModel {
  String? message;
  int? status;
  OrdersList? data;

  editItemModel({this.message, this.status, this.data});

  editItemModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'];
    data = json['data'] != null ? OrdersList.fromJson(json['data']) : null;
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
