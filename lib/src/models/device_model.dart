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

  DevicesModel({
    this.deviceId,
    this.usuarioId,
    this.tokenDevice,
    this.platform,
  });

  factory DevicesModel.fromJson(Map<String, dynamic> json) => DevicesModel(
        deviceId: json["deviceId"],
        usuarioId: json["usuarioId"],
        tokenDevice: json["tokenDevice"],
        platform: json["platform"],
      );

  Map<String, dynamic> toJson() => {
        "deviceId": deviceId,
        "usuarioId": usuarioId,
        "tokenDevice": tokenDevice,
        "platform": platform,
      };
}
