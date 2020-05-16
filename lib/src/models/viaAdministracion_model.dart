// To parse this JSON data, do
//
//     final viaAdministracionModel = viaAdministracionModelFromJson(jsonString);

import 'dart:convert';

ViaAdministracionModel viaAdministracionModelFromJson(String str) =>
    ViaAdministracionModel.fromJson(json.decode(str));

String viaAdministracionModelToJson(ViaAdministracionModel data) =>
    json.encode(data.toJson());

class ViaAdministracionModel {
  int viaAdministracionId;
  String nombre;

  ViaAdministracionModel({
    this.viaAdministracionId,
    this.nombre,
  });

  factory ViaAdministracionModel.fromJson(Map<String, dynamic> json) =>
      ViaAdministracionModel(
        viaAdministracionId: json["viaAdministracionId"],
        nombre: json["nombre"],
      );

  Map<String, dynamic> toJson() => {
        "viaAdministracionId": viaAdministracionId,
        "nombre": nombre,
      };
}
