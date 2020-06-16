// To parse this JSON data, do
//
//     final examenDetalleModel = examenDetalleModelFromJson(jsonString);

import 'dart:convert';

ExamenDetalleModel examenDetalleModelFromJson(String str) =>
    ExamenDetalleModel.fromJson(json.decode(str));

String examenDetalleModelToJson(ExamenDetalleModel data) =>
    json.encode(data.toJson());

class ExamenDetalleModel {
  int examenDetalleId;
  int examenTipoId;
  int examenCategoriaId;
  String nombre;

  ExamenDetalleModel({
    this.examenDetalleId,
    this.examenTipoId,
    this.examenCategoriaId,
    this.nombre,
  });

  factory ExamenDetalleModel.fromJson(Map<String, dynamic> json) =>
      ExamenDetalleModel(
        examenDetalleId: json["examenDetalleId"],
        examenTipoId: json["examenTipoId"],
        examenCategoriaId: json["examenCategoriaId"],
        nombre: json["nombre"] == null ? "" : json["nombre"],
      );

  Map<String, dynamic> toJson() => {
        "examenDetalleId": examenDetalleId,
        "examenTipoId": examenTipoId,
        "examenCategoriaId": examenCategoriaId,
        "nombre": nombre,
      };
}
