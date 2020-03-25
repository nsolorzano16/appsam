// To parse this JSON data, do
//
//     final grupoSanguineo = grupoSanguineoFromJson(jsonString);

import 'dart:convert';

List<GrupoSanguineoModel> grupoSanguineoFromJson(String str) =>
    List<GrupoSanguineoModel>.from(
        json.decode(str).map((x) => GrupoSanguineoModel.fromJson(x)));

String grupoSanguineoToJson(List<GrupoSanguineoModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GrupoSanguineoModel {
  int grupoSanguineoId;
  String nombre;

  GrupoSanguineoModel({
    this.grupoSanguineoId,
    this.nombre,
  });

  factory GrupoSanguineoModel.fromJson(Map<String, dynamic> json) =>
      GrupoSanguineoModel(
        grupoSanguineoId: json["grupoSanguineoId"],
        nombre: json["nombre"],
      );

  Map<String, dynamic> toJson() => {
        "grupoSanguineoId": grupoSanguineoId,
        "nombre": nombre,
      };
}
