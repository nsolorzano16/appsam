// To parse this JSON data, do
//
//     final calendarioFechaModel = calendarioFechaModelFromJson(jsonString);

import 'dart:convert';

CalendarioFechaModel calendarioFechaModelFromJson(String str) =>
    CalendarioFechaModel.fromJson(json.decode(str));

String calendarioFechaModelToJson(CalendarioFechaModel data) =>
    json.encode(data.toJson());

class CalendarioFechaModel {
  int calendarioFechaId;
  int doctorId;
  DateTime inicio;
  DateTime fin;
  bool todoElDia;
  String colorPrimario;
  String colorSecundario;
  bool activo;
  String creadoPor;
  DateTime creadoFecha;
  String modificadoPor;
  DateTime modificadoFecha;
  String notas;

  CalendarioFechaModel({
    this.calendarioFechaId,
    this.doctorId,
    this.inicio,
    this.fin,
    this.todoElDia,
    this.colorPrimario,
    this.colorSecundario,
    this.activo,
    this.creadoPor,
    this.creadoFecha,
    this.modificadoPor,
    this.modificadoFecha,
    this.notas,
  });

  factory CalendarioFechaModel.fromJson(Map<String, dynamic> json) =>
      CalendarioFechaModel(
        calendarioFechaId: json["calendarioFechaId"],
        doctorId: json["doctorId"],
        inicio: DateTime.parse(json["inicio"]),
        fin: DateTime.parse(json["fin"]),
        todoElDia: json["todoElDia"],
        colorPrimario: json["colorPrimario"],
        colorSecundario: json["colorSecundario"],
        activo: json["activo"],
        creadoPor: json["creadoPor"],
        creadoFecha: DateTime.parse(json["creadoFecha"]),
        modificadoPor: json["modificadoPor"],
        modificadoFecha: DateTime.parse(json["modificadoFecha"]),
        notas: json["notas"],
      );

  Map<String, dynamic> toJson() => {
        "calendarioFechaId": calendarioFechaId,
        "doctorId": doctorId,
        "inicio": inicio.toIso8601String(),
        "fin": fin.toIso8601String(),
        "todoElDia": todoElDia,
        "colorPrimario": colorPrimario,
        "colorSecundario": colorSecundario,
        "activo": activo,
        "creadoPor": creadoPor,
        "creadoFecha": creadoFecha.toIso8601String(),
        "modificadoPor": modificadoPor,
        "modificadoFecha": modificadoFecha.toIso8601String(),
        "notas": notas,
      };
}
