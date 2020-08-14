// To parse this JSON data, do
//
//     final planesModel = planesModelFromJson(jsonString);

import 'dart:convert';

List<PlanesModel> planesModelFromJsonList(String str) => List<PlanesModel>.from(
    json.decode(str).map((x) => PlanesModel.fromJson(x)));

String planesModelToJsonList(List<PlanesModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

PlanesModel planesModelFromJson(String str) =>
    PlanesModel.fromJson(json.decode(str));

String planesModelToJson(PlanesModel data) => json.encode(data.toJson());

class PlanesModel {
  PlanesModel({
    this.planId,
    this.nombre,
    this.consultas,
    this.imagenes,
    this.asistentes,
    this.activo,
    this.creadoPor,
    this.creadoFecha,
    this.modificadoPor,
    this.modificadoFecha,
    this.notas,
  });

  int planId;
  String nombre;
  int consultas;
  int imagenes;
  int asistentes;
  bool activo;
  String creadoPor;
  DateTime creadoFecha;
  String modificadoPor;
  DateTime modificadoFecha;
  String notas;

  factory PlanesModel.fromJson(Map<String, dynamic> json) => PlanesModel(
        planId: json["planId"],
        nombre: json["nombre"],
        consultas: json["consultas"],
        imagenes: json["imagenes"],
        asistentes: json["asistentes"],
        activo: json["activo"],
        creadoPor: json["creadoPor"],
        creadoFecha: DateTime.parse(json["creadoFecha"]),
        modificadoPor: json["modificadoPor"],
        modificadoFecha: DateTime.parse(json["modificadoFecha"]),
        notas: json["notas"],
      );

  Map<String, dynamic> toJson() => {
        "planId": planId,
        "nombre": nombre,
        "consultas": consultas,
        "imagenes": imagenes,
        "asistentes": asistentes,
        "activo": activo,
        "creadoPor": creadoPor,
        "creadoFecha": creadoFecha.toIso8601String(),
        "modificadoPor": modificadoPor,
        "modificadoFecha": modificadoFecha.toIso8601String(),
        "notas": notas,
      };
}
