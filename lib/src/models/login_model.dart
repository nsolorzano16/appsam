// To parse this JSON data, do
//
//     final loginModel = loginModelFromJson(jsonString);

import 'dart:convert';

LoginModel loginModelFromJson(String str) => LoginModel.fromJson(json.decode(str));

String loginModelToJson(LoginModel data) => json.encode(data.toJson());

class LoginModel {
    String usuario;
    String password;

    LoginModel({
        this.usuario,
        this.password,
    });

    factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
        usuario: json["usuario"],
        password: json["password"],
    );

    Map<String, dynamic> toJson() => {
        "usuario": usuario,
        "password": password,
    };
}
