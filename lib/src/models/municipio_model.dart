// To parse this JSON data, do
//
//     final municipioModel = municipioModelFromJson(jsonString);

import 'dart:convert';

List<MunicipioModel> municipioModelFromJson(String str) =>
    List<MunicipioModel>.from(
        json.decode(str).map((x) => MunicipioModel.fromJson(x)));

String municipioModelToJson(List<MunicipioModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class MunicipioModel {
  int municipioId;
  int departamentoId;
  String nombre;

  MunicipioModel({
    this.municipioId,
    this.departamentoId,
    this.nombre,
  });

  factory MunicipioModel.fromJson(Map<String, dynamic> json) => MunicipioModel(
        municipioId: json["municipioId"],
        departamentoId: json["departamentoId"],
        nombre: json["nombre"],
      );

  Map<String, dynamic> toJson() => {
        "municipioId": municipioId,
        "departamentoId": departamentoId,
        "nombre": nombre,
      };
}
