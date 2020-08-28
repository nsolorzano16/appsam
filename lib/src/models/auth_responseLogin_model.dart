// To parse this JSON data, do
//
//     final authResponseLoginModel = authResponseLoginModelFromJson(jsonString);

import 'dart:convert';

AuthResponseLoginModel authResponseLoginModelFromJson(String str) =>
    AuthResponseLoginModel.fromJson(json.decode(str));

String authResponseLoginModelToJson(AuthResponseLoginModel data) =>
    json.encode(data.toJson());

class AuthResponseLoginModel {
  AuthResponseLoginModel({
    this.resultado,
    this.token,
    this.intentos,
    this.horaDesbloqueo,
  });

  Resultado resultado;
  String token;
  int intentos;
  DateTime horaDesbloqueo;

  factory AuthResponseLoginModel.fromJson(Map<String, dynamic> json) =>
      AuthResponseLoginModel(
        resultado: Resultado.fromJson(json["resultado"]),
        token: json["token"],
        intentos: json["intentos"],
        horaDesbloqueo: DateTime.parse(json["horaDesbloqueo"]),
      );

  Map<String, dynamic> toJson() => {
        "resultado": resultado.toJson(),
        "token": token,
        "intentos": intentos,
        "horaDesbloqueo": horaDesbloqueo.toIso8601String(),
      };
}

class Resultado {
  Resultado({
    this.succeeded,
    this.isLockedOut,
    this.isNotAllowed,
    this.requiresTwoFactor,
  });

  bool succeeded;
  bool isLockedOut;
  bool isNotAllowed;
  bool requiresTwoFactor;

  factory Resultado.fromJson(Map<String, dynamic> json) => Resultado(
        succeeded: json["succeeded"],
        isLockedOut: json["isLockedOut"],
        isNotAllowed: json["isNotAllowed"],
        requiresTwoFactor: json["requiresTwoFactor"],
      );

  Map<String, dynamic> toJson() => {
        "succeeded": succeeded,
        "isLockedOut": isLockedOut,
        "isNotAllowed": isNotAllowed,
        "requiresTwoFactor": requiresTwoFactor,
      };
}
