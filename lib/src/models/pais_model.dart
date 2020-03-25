// To parse this JSON data, do
//
//     final paisModel = paisModelFromJson(jsonString);

import 'dart:convert';

List<PaisModel> paisModelFromJson(String str) =>
    List<PaisModel>.from(json.decode(str).map((x) => PaisModel.fromJson(x)));

String paisModelToJson(List<PaisModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PaisModel {
  int paisId;
  String nombre;

  PaisModel({
    this.paisId,
    this.nombre,
  });

  factory PaisModel.fromJson(Map<String, dynamic> json) => PaisModel(
        paisId: json["paisId"],
        nombre: json["nombre"],
      );

  Map<String, dynamic> toJson() => {
        "paisId": paisId,
        "nombre": nombre,
      };
}
