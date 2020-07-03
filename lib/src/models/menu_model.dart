// To parse this JSON data, do
//
//     final menuModel = menuModelFromJson(jsonString);

import 'dart:convert';

MenuModel menuModelFromJson(String str) => MenuModel.fromJson(json.decode(str));

String menuModelToJson(MenuModel data) => json.encode(data.toJson());

class MenuModel {
  String nombreApp;
  List<Ruta> rutas;

  MenuModel({
    this.nombreApp,
    this.rutas,
  });

  factory MenuModel.fromJson(Map<String, dynamic> json) => MenuModel(
        nombreApp: json["nombreApp"],
        rutas: List<Ruta>.from(json["rutas"].map((x) => Ruta.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "nombreApp": nombreApp,
        "rutas": List<dynamic>.from(rutas.map((x) => x.toJson())),
      };
}

class Ruta {
  String ruta;
  String icon;
  String texto;
  int notificaciones;
  List<Role> roles;

  Ruta({
    this.ruta,
    this.icon,
    this.texto,
    this.roles,
    this.notificaciones,
  });

  factory Ruta.fromJson(Map<String, dynamic> json) => Ruta(
        ruta: json["ruta"],
        icon: json["icon"],
        texto: json["texto"],
        notificaciones: 0,
        roles: List<Role>.from(json["roles"].map((x) => Role.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "ruta": ruta,
        "icon": icon,
        "texto": texto,
        "notificaciones": notificaciones,
        "roles": List<dynamic>.from(roles.map((x) => x.toJson())),
      };
}

class Role {
  int autorizados;

  Role({
    this.autorizados,
  });

  factory Role.fromJson(Map<String, dynamic> json) => Role(
        autorizados: json["autorizados"],
      );

  Map<String, dynamic> toJson() => {
        "autorizados": autorizados,
      };
}
