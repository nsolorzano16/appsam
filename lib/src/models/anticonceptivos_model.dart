// To parse this JSON data, do
//
//     final anticonceptivosModel = anticonceptivosModelFromJson(jsonString);

import 'dart:convert';

List<AnticonceptivosModel> anticonceptivosModelFromJson(String str) =>
    List<AnticonceptivosModel>.from(
        json.decode(str).map((x) => AnticonceptivosModel.fromJson(x)));

String anticonceptivosModelToJson(List<AnticonceptivosModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AnticonceptivosModel {
  AnticonceptivosModel({
    this.anticonceptivoId,
    this.nombre,
  });

  int anticonceptivoId;
  String nombre;

  factory AnticonceptivosModel.fromJson(Map<String, dynamic> json) =>
      AnticonceptivosModel(
        anticonceptivoId: json["anticonceptivoId"],
        nombre: json["nombre"],
      );

  Map<String, dynamic> toJson() => {
        "anticonceptivoId": anticonceptivoId,
        "nombre": nombre,
      };
}
