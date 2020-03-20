// To parse this JSON data, do
//
//     final EstadoCivilModel = EstadoCivilModelFromJson(jsonString);

import 'dart:convert';

EstadoCivilModel estadoCivilModelFromJson(String str) =>
    EstadoCivilModel.fromJson(json.decode(str));

String estadoCivilModelToJson(EstadoCivilModel data) =>
    json.encode(data.toJson());

class EstadoCivilModel {
  String texto;
  String valor;

  EstadoCivilModel({
    this.texto,
    this.valor,
  });

  factory EstadoCivilModel.fromJson(Map<String, dynamic> json) =>
      EstadoCivilModel(
        texto: json["texto"],
        valor: json["valor"],
      );

  Map<String, dynamic> toJson() => {
        "texto": texto,
        "valor": valor,
      };
}
