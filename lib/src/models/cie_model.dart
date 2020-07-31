// To parse this JSON data, do
//
//     final cieModel = cieModelFromJson(jsonString);

import 'dart:convert';

CieModel cieModelFromJson(String str) => CieModel.fromJson(json.decode(str));

String cieModelToJson(CieModel data) => json.encode(data.toJson());

class CieModel {
  CieModel({
    this.cieId,
    this.codigo,
    this.nombre,
  });

  int cieId;
  String codigo;
  String nombre;

  factory CieModel.fromJson(Map<String, dynamic> json) => CieModel(
        cieId: json["cieId"],
        codigo: json["codigo"],
        nombre: json["nombre"],
      );

  Map<String, dynamic> toJson() => {
        "cieId": cieId,
        "codigo": codigo,
        "nombre": nombre,
      };
}
