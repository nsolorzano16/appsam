// To parse this JSON data, do
//
//     final religionModel = religionModelFromJson(jsonString);

import 'dart:convert';

List<ReligionModel> religionModelFromJson(String str) =>
    List<ReligionModel>.from(
        json.decode(str).map((x) => ReligionModel.fromJson(x)));

String religionModelToJson(List<ReligionModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ReligionModel {
  int religionId;
  String nombre;

  ReligionModel({
    this.religionId,
    this.nombre,
  });

  factory ReligionModel.fromJson(Map<String, dynamic> json) => ReligionModel(
        religionId: json["religionId"],
        nombre: json["nombre"],
      );

  Map<String, dynamic> toJson() => {
        "religionId": religionId,
        "nombre": nombre,
      };
}
