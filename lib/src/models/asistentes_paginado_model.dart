// To parse this JSON data, do
//
//     final asistentesPaginadoModel = asistentesPaginadoModelFromJson(jsonString);

import 'dart:convert';

import 'package:appsam/src/models/user_model.dart';

AsistentesPaginadoModel asistentesPaginadoModelFromJson(String str) =>
    AsistentesPaginadoModel.fromJson(json.decode(str));

String asistentesPaginadoModelToJson(AsistentesPaginadoModel data) =>
    json.encode(data.toJson());

class AsistentesPaginadoModel {
  AsistentesPaginadoModel({
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
  List<UserModel> items;

  factory AsistentesPaginadoModel.fromJson(Map<String, dynamic> json) =>
      AsistentesPaginadoModel(
        totalItems: json["totalItems"],
        totalPages: json["totalPages"],
        currentPage: json["currentPage"],
        itemCount: json["itemCount"],
        items: List<UserModel>.from(
            json["items"].map((x) => UserModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "totalItems": totalItems,
        "totalPages": totalPages,
        "currentPage": currentPage,
        "itemCount": itemCount,
        "items": List<dynamic>.from(items.map((x) => x.toJson())),
      };
}
