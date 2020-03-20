// To parse this JSON data, do
//
//     final parentescoModel = parentescoModelFromJson(jsonString);

import 'dart:convert';

ParentescoModel parentescoModelFromJson(String str) =>
    ParentescoModel.fromJson(json.decode(str));

String parentescoModelToJson(ParentescoModel data) =>
    json.encode(data.toJson());

class ParentescoModel {
  String texto;
  String valor;

  ParentescoModel({
    this.texto,
    this.valor,
  });

  factory ParentescoModel.fromJson(Map<String, dynamic> json) =>
      ParentescoModel(
        texto: json["texto"],
        valor: json["valor"],
      );

  Map<String, dynamic> toJson() => {
        "texto": texto,
        "valor": valor,
      };
}
