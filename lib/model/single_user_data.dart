class singleUserModel {
  String? message;
  int? status;
  Data? data;

  singleUserModel({this.message, this.status, this.data});

  singleUserModel.fromJson(Map<String, dynamic> json) {
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
  int? id;
  String? name;
  String? lastName;
  String? email;
  String? userName;
  String? phoneNumber;
  String? profileImage;
  String? decodedPassword;
  String? vendorCategory;

  Data(
      {this.id,
      this.name,
      this.lastName,
      this.email,
      this.userName,
      this.phoneNumber,
      this.profileImage,
      this.decodedPassword,
      this.vendorCategory});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['first_name'];
    lastName = json['last_name'];
    email = json['email'];
    userName = json['user_name'];
    phoneNumber = json['phone_number'];
    profileImage = json['profile_image'];
    decodedPassword = json['decoded_password'];
    vendorCategory = json['vendor_category'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['user_name'] = userName;
    data['phone_number'] = phoneNumber;
    data['profile_image'] = profileImage;
    data['decoded_password'] = decodedPassword;
    data['vendor_category'] = vendorCategory;
    return data;
  }
}
