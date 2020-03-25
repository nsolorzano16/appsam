// To parse this JSON data, do
//
//     final departamentoModel = departamentoModelFromJson(jsonString);

import 'dart:convert';

List<DepartamentoModel> departamentoModelFromJson(String str) =>
    List<DepartamentoModel>.from(
        json.decode(str).map((x) => DepartamentoModel.fromJson(x)));

String departamentoModelToJson(List<DepartamentoModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class DepartamentoModel {
  int departamentoId;
  String nombre;

  DepartamentoModel({
    this.departamentoId,
    this.nombre,
  });

  factory DepartamentoModel.fromJson(Map<String, dynamic> json) =>
      DepartamentoModel(
        departamentoId: json["departamentoId"],
        nombre: json["nombre"],
      );

  Map<String, dynamic> toJson() => {
        "departamentoId": departamentoId,
        "nombre": nombre,
      };
}
