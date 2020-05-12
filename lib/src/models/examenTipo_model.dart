// To parse this JSON data, do
//
//     final examenTipoModel = examenTipoModelFromJson(jsonString);

import 'dart:convert';

ExamenTipoModel examenTipoModelFromJson(String str) =>
    ExamenTipoModel.fromJson(json.decode(str));

String examenTipoModelToJson(ExamenTipoModel data) =>
    json.encode(data.toJson());

class ExamenTipoModel {
  int examenTipoId;
  int examenCategoriaId;
  String nombre;

  ExamenTipoModel({
    this.examenTipoId,
    this.examenCategoriaId,
    this.nombre,
  });

  factory ExamenTipoModel.fromJson(Map<String, dynamic> json) =>
      ExamenTipoModel(
        examenTipoId: json["examenTipoId"],
        examenCategoriaId: json["examenCategoriaId"],
        nombre: json["nombre"],
      );

  Map<String, dynamic> toJson() => {
        "examenTipoId": examenTipoId,
        "examenCategoriaId": examenCategoriaId,
        "nombre": nombre,
      };
}
