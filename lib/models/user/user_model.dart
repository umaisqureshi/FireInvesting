import 'dart:io';

class SingleUserModel {
  String name;
  String id;
  String email;
  String image;
  String password;
  String type;
  String guruStatus;
  File imageFile;

  SingleUserModel({
     this.name,
     this.id,
     this.email,
    this.image,
    this.password,
    this.type = "investor",
    this.guruStatus,
    this.imageFile,

  });

  set setType(String value) {
    type = value;
  }

  String get getType => type;

  bool isFileEmpty() {
    return imageFile == null;
  }

  bool isGuru() {
    return type == "guru";
  }

  factory SingleUserModel.fromJson(Map<String, dynamic> json) {
    return SingleUserModel(
      name: json['name'],
      id: json['id'],
      email: json['email'],
      image: json['image'],
      type: json['type'],
      guruStatus: json['guruStatus']
    );
  }
}


