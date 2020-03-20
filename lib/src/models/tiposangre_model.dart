// To parse this JSON data, do
//
//     final TipoSangreModel = EstadoCivilModelFromJson(jsonString);

import 'dart:convert';

TipoSangreModel estadoCivilModelFromJson(String str) =>
    TipoSangreModel.fromJson(json.decode(str));

String estadoCivilModelToJson(TipoSangreModel data) =>
    json.encode(data.toJson());

class TipoSangreModel {
  String texto;
  String valor;

  TipoSangreModel({
    this.texto,
    this.valor,
  });

  factory TipoSangreModel.fromJson(Map<String, dynamic> json) =>
      TipoSangreModel(
        texto: json["texto"],
        valor: json["valor"],
      );

  Map<String, dynamic> toJson() => {
        "texto": texto,
        "valor": valor,
      };
}
