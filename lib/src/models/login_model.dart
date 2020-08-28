// To parse this JSON data, do
//
//     final loginModel = loginModelFromJson(jsonString);

import 'dart:convert';

LoginModel loginModelFromJson(String str) =>
    LoginModel.fromJson(json.decode(str));

String loginModelToJson(LoginModel data) => json.encode(data.toJson());

class LoginModel {
  String userName;
  String password;

  LoginModel({
    this.userName,
    this.password,
  });

  factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
        userName: json["userName"],
        password: json["password"],
      );

  Map<String, dynamic> toJson() => {
        "userName": userName,
        "password": password,
      };
}
