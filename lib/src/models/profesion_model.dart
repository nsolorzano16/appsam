// To parse this JSON data, do
//
//     final profesionModel = profesionModelFromJson(jsonString);

import 'dart:convert';

List<ProfesionModel> profesionModelFromJson(String str) =>
    List<ProfesionModel>.from(
        json.decode(str).map((x) => ProfesionModel.fromJson(x)));

String profesionModelToJson(List<ProfesionModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ProfesionModel {
  int profesionId;
  String nombre;

  ProfesionModel({
    this.profesionId,
    this.nombre,
  });

  factory ProfesionModel.fromJson(Map<String, dynamic> json) => ProfesionModel(
        profesionId: json["profesionId"],
        nombre: json["nombre"],
      );

  Map<String, dynamic> toJson() => {
        "profesionId": profesionId,
        "nombre": nombre,
      };
}
