class CreateItemModel {
  int? itemId;
  double? itemBasePrice;
  double? itemQuantity;
  String? itemNote;

  CreateItemModel(
      {this.itemId, this.itemBasePrice, this.itemQuantity, this.itemNote});

  CreateItemModel.fromJson(Map<String, dynamic> json) {
    itemId = json['item_id'];
    itemBasePrice = json['item_base_price'];
    itemQuantity = json['item_quantity'];
    itemNote = json['item_note'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['item_id'] = itemId;
    data['item_base_price'] = itemBasePrice;
    data['item_quantity'] = itemQuantity;
    data['item_note'] = itemNote;
    return data;
  }
}
