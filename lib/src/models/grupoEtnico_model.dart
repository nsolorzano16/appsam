// To parse this JSON data, do
//
//     final grupoEtnicoModel = grupoEtnicoModelFromJson(jsonString);

import 'dart:convert';

List<GrupoEtnicoModel> grupoEtnicoModelFromJson(String str) =>
    List<GrupoEtnicoModel>.from(
        json.decode(str).map((x) => GrupoEtnicoModel.fromJson(x)));

String grupoEtnicoModelToJson(List<GrupoEtnicoModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GrupoEtnicoModel {
  int grupoEtnicoId;
  String nombre;

  GrupoEtnicoModel({
    this.grupoEtnicoId,
    this.nombre,
  });

  factory GrupoEtnicoModel.fromJson(Map<String, dynamic> json) =>
      GrupoEtnicoModel(
        grupoEtnicoId: json["grupoEtnicoId"],
        nombre: json["nombre"],
      );

  Map<String, dynamic> toJson() => {
        "grupoEtnicoId": grupoEtnicoId,
        "nombre": nombre,
      };
}
