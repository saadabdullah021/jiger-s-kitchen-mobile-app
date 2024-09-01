class userListModel {
  String? message;
  int? status;
  Data? data;

  userListModel({this.message, this.status, this.data});

  userListModel.fromJson(Map<String, dynamic> json) {
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
  List<ChefList>? chefList;

  Data(
      {this.totalRecords,
      this.limit,
      this.currentPage,
      this.totalPages,
      this.chefList});

  Data.fromJson(Map<String, dynamic> json) {
    totalRecords = json['total_records'];
    limit = json['limit'];
    currentPage = json['current_page'];
    totalPages = json['total_pages'];
    if (json['chef_list'] != null) {
      chefList = <ChefList>[];
      json['chef_list'].forEach((v) {
        chefList!.add(ChefList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total_records'] = totalRecords;
    data['limit'] = limit;
    data['current_page'] = currentPage;
    data['total_pages'] = totalPages;
    if (chefList != null) {
      data['chef_list'] = chefList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ChefList {
  int? id;
  String? name;
  String? email;
  String? userName;
  String? phoneNumber;
  String? profileImage;
  int? status;
  String? createdAt;

  ChefList(
      {this.id,
      this.name,
      this.email,
      this.userName,
      this.phoneNumber,
      this.profileImage,
      this.status,
      this.createdAt});

  ChefList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    userName = json['user_name'];
    phoneNumber = json['phone_number'];
    profileImage = json['profile_image'];
    status = json['status'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['user_name'] = userName;
    data['phone_number'] = phoneNumber;
    data['profile_image'] = profileImage;
    data['status'] = status;
    data['created_at'] = createdAt;
    return data;
  }
}
