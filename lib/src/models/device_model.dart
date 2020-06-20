// To parse this JSON data, do
//
//     final devicesModel = devicesModelFromJson(jsonString);

import 'dart:convert';

DevicesModel devicesModelFromJson(String str) =>
    DevicesModel.fromJson(json.decode(str));

String devicesModelToJson(DevicesModel data) => json.encode(data.toJson());

class DevicesModel {
  int deviceId;
  int usuarioId;
  String tokenDevice;
  String platform;
  DateTime creadoFecha;
  String usuario;

  DevicesModel({
    this.deviceId,
    this.usuarioId,
    this.tokenDevice,
    this.platform,
    this.creadoFecha,
    this.usuario,
  });

  factory DevicesModel.fromJson(Map<String, dynamic> json) => DevicesModel(
        deviceId: json["deviceId"],
        usuarioId: json["usuarioId"],
        tokenDevice: json["tokenDevice"],
        platform: json["platform"],
        creadoFecha: DateTime.parse(json["creadoFecha"]),
        usuario: json["usuario"],
      );

  Map<String, dynamic> toJson() => {
        "deviceId": deviceId,
        "usuarioId": usuarioId,
        "tokenDevice": tokenDevice,
        "platform": platform,
        "creadoFecha": creadoFecha.toIso8601String(),
        "usuario": usuario,
      };
}
