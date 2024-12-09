class menuTabModel {
  String? message;
  int? status;
  List<TabData>? tabData;

  menuTabModel({this.message, this.status, this.tabData});

  menuTabModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'];
    if (json['data'] != null) {
      tabData = <TabData>[];
      json['data'].forEach((v) {
        tabData!.add(TabData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    data['status'] = status;
    if (tabData != null) {
      data['data'] = tabData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TabData {
  int? id;
  String? name;

  TabData({this.id, this.name});

  TabData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    return data;
  }
}
