class createChefModel {
  String? message;
  int? status;
  Data? data;

  createChefModel({this.message, this.status, this.data});

  createChefModel.fromJson(Map<String, dynamic> json) {
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
  String? name;
  String? userName;
  String? email;
  String? phoneNumber;
  String? role;
  String? profileImage;
  int? status;
  int? registeredAt;
  int? addedBy;
  String? updatedAt;
  String? createdAt;
  int? id;

  Data(
      {this.name,
      this.userName,
      this.email,
      this.phoneNumber,
      this.role,
      this.profileImage,
      this.status,
      this.registeredAt,
      this.addedBy,
      this.updatedAt,
      this.createdAt,
      this.id});

  Data.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    userName = json['user_name'];
    email = json['email'];
    phoneNumber = json['phone_number'];
    role = json['role'];
    profileImage = json['profile_image'];
    status = json['status'];
    registeredAt = json['registered_at'];
    addedBy = json['added_by'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['user_name'] = userName;
    data['email'] = email;
    data['phone_number'] = phoneNumber;
    data['role'] = role;
    data['profile_image'] = profileImage;
    data['status'] = status;
    data['registered_at'] = registeredAt;
    data['added_by'] = addedBy;
    data['updated_at'] = updatedAt;
    data['created_at'] = createdAt;
    data['id'] = id;
    return data;
  }
}
