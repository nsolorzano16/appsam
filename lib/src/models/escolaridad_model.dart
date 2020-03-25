// To parse this JSON data, do
//
//     final escolaridadModel = escolaridadModelFromJson(jsonString);

import 'dart:convert';

List<EscolaridadModel> escolaridadModelFromJson(String str) =>
    List<EscolaridadModel>.from(
        json.decode(str).map((x) => EscolaridadModel.fromJson(x)));

String escolaridadModelToJson(List<EscolaridadModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class EscolaridadModel {
  int escolaridadId;
  String nombre;

  EscolaridadModel({
    this.escolaridadId,
    this.nombre,
  });

  factory EscolaridadModel.fromJson(Map<String, dynamic> json) =>
      EscolaridadModel(
        escolaridadId: json["escolaridadId"],
        nombre: json["nombre"],
      );

  Map<String, dynamic> toJson() => {
        "escolaridadId": escolaridadId,
        "nombre": nombre,
      };
}
