// To parse this JSON data, do
//
//     final resetPasswordResponseModel = resetPasswordResponseModelFromJson(jsonString);

import 'dart:convert';

ResetPasswordResponseModel resetPasswordResponseModelFromJson(String str) =>
    ResetPasswordResponseModel.fromJson(json.decode(str));

String resetPasswordResponseModelToJson(ResetPasswordResponseModel data) =>
    json.encode(data.toJson());

class ResetPasswordResponseModel {
  ResetPasswordResponseModel({
    this.tokenChangePassword,
    this.userId,
  });

  String tokenChangePassword;
  String userId;

  factory ResetPasswordResponseModel.fromJson(Map<String, dynamic> json) =>
      ResetPasswordResponseModel(
        tokenChangePassword: json["tokenChangePassword"],
        userId: json["userId"],
      );

  Map<String, dynamic> toJson() => {
        "tokenChangePassword": tokenChangePassword,
        "userId": userId,
      };
}
