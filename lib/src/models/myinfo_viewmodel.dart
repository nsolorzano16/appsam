// To parse this JSON data, do
//
//     final myInfoViewModel = myInfoViewModelFromJson(jsonString);

import 'dart:convert';

import 'package:appsam/src/models/planes_model.dart';
import 'package:appsam/src/models/user_model.dart';

MyInfoViewModel myInfoViewModelFromJson(String str) =>
    MyInfoViewModel.fromJson(json.decode(str));

String myInfoViewModelToJson(MyInfoViewModel data) =>
    json.encode(data.toJson());

class MyInfoViewModel {
  MyInfoViewModel({
    this.plan,
    this.usuario,
    this.consultasAtendidas,
  });

  PlanesModel plan;
  UserModel usuario;
  int consultasAtendidas;

  factory MyInfoViewModel.fromJson(Map<String, dynamic> json) =>
      MyInfoViewModel(
        plan: PlanesModel.fromJson(json["plan"]),
        usuario: UserModel.fromJson(json["usuario"]),
        consultasAtendidas: json["consultasAtendidas"],
      );

  Map<String, dynamic> toJson() => {
        "plan": plan.toJson(),
        "usuario": usuario.toJson(),
        "consultasAtendidas": consultasAtendidas,
      };
}
