// To parse this JSON data, do
//
//     final changePasswordModel = changePasswordModelFromJson(jsonString);

import 'dart:convert';

ChangePasswordModel changePasswordModelFromJson(String str) =>
    ChangePasswordModel.fromJson(json.decode(str));

String changePasswordModelToJson(ChangePasswordModel data) =>
    json.encode(data.toJson());

class ChangePasswordModel {
  ChangePasswordModel({
    this.token,
    this.userId,
    this.password,
  });

  String token;
  String userId;
  String password;

  factory ChangePasswordModel.fromJson(Map<String, dynamic> json) =>
      ChangePasswordModel(
        token: json["token"],
        userId: json["userId"],
        password: json["password"],
      );

  Map<String, dynamic> toJson() => {
        "token": token,
        "userId": userId,
        "password": password,
      };
}
