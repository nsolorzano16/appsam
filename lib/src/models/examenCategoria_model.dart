// To parse this JSON data, do
//
//     final examenCategoriaModel = examenCategoriaModelFromJson(jsonString);

import 'dart:convert';

ExamenCategoriaModel examenCategoriaModelFromJson(String str) =>
    ExamenCategoriaModel.fromJson(json.decode(str));

String examenCategoriaModelToJson(ExamenCategoriaModel data) =>
    json.encode(data.toJson());

class ExamenCategoriaModel {
  int examenCategoriaId;
  String nombre;

  ExamenCategoriaModel({
    this.examenCategoriaId,
    this.nombre,
  });

  factory ExamenCategoriaModel.fromJson(Map<String, dynamic> json) =>
      ExamenCategoriaModel(
        examenCategoriaId: json["examenCategoriaId"],
        nombre: json["nombre"] == null ? "" : json["nombre"],
      );

  Map<String, dynamic> toJson() => {
        "examenCategoriaId": examenCategoriaId,
        "nombre": nombre,
      };
}
