// To parse this JSON data, do
//
//     final enfermedadesPaginadoModel = enfermedadesPaginadoModelFromJson(jsonString);

import 'dart:convert';

import 'package:appsam/src/models/cie_model.dart';

EnfermedadesPaginadoModel enfermedadesPaginadoModelFromJson(String str) =>
    EnfermedadesPaginadoModel.fromJson(json.decode(str));

String enfermedadesPaginadoModelToJson(EnfermedadesPaginadoModel data) =>
    json.encode(data.toJson());

class EnfermedadesPaginadoModel {
  EnfermedadesPaginadoModel({
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
  List<CieModel> items;

  factory EnfermedadesPaginadoModel.fromJson(Map<String, dynamic> json) =>
      EnfermedadesPaginadoModel(
        totalItems: json["totalItems"],
        totalPages: json["totalPages"],
        currentPage: json["currentPage"],
        itemCount: json["itemCount"],
        items:
            List<CieModel>.from(json["items"].map((x) => CieModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "totalItems": totalItems,
        "totalPages": totalPages,
        "currentPage": currentPage,
        "itemCount": itemCount,
        "items": List<dynamic>.from(items.map((x) => x.toJson())),
      };
}
