class ChefDropDownData {
  String? message;
  int? status;
  List<ChefData>? data;

  ChefDropDownData({this.message, this.status, this.data});

  ChefDropDownData.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'];
    if (json['data'] != null) {
      data = <ChefData>[];
      json['data'].forEach((v) {
        data!.add(ChefData.fromJson(v));
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

class ChefData {
  int? id;
  String? name;
  String? profileImage;

  ChefData({this.id, this.name, this.profileImage});

  ChefData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    profileImage = json['profile_image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['profile_image'] = profileImage;
    return data;
  }
}
