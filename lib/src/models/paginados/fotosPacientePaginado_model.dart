// To parse this JSON data, do
//
//     final fotosPacientePaginadoModel = fotosPacientePaginadoModelFromJson(jsonString);

import 'dart:convert';

import 'package:appsam/src/models/fotosPaciente_model.dart';

FotosPacientePaginadoModel fotosPacientePaginadoModelFromJson(String str) =>
    FotosPacientePaginadoModel.fromJson(json.decode(str));

String fotosPacientePaginadoModelToJson(FotosPacientePaginadoModel data) =>
    json.encode(data.toJson());

class FotosPacientePaginadoModel {
  FotosPacientePaginadoModel({
    this.totalItems,
    this.totalPages,
    this.currentPage,
    this.itemCount,
    this.items,
  });

  int totalItems;
  int totalPages;
  int currentPage;
  int itemCount;
  List<FotosPacienteModel> items;

  factory FotosPacientePaginadoModel.fromJson(Map<String, dynamic> json) =>
      FotosPacientePaginadoModel(
        totalItems: json["totalItems"],
        totalPages: json["totalPages"],
        currentPage: json["currentPage"],
        itemCount: json["itemCount"],
        items: json["items"] == null
            ? []
            : List<FotosPacienteModel>.from(
                json["items"].map((x) => FotosPacienteModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "totalItems": totalItems,
        "totalPages": totalPages,
        "currentPage": currentPage,
        "itemCount": itemCount,
        "items": List<dynamic>.from(items.map((x) => x.toJson())),
      };
}
