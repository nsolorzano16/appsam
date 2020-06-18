// To parse this JSON data, do
//
//     final eventosModel = eventosModelFromJson(jsonString);

import 'dart:convert';

List<EventosModel> eventosModelFromJson(String str) => List<EventosModel>.from(
    json.decode(str).map((x) => EventosModel.fromJson(x)));

String eventosModelToJson(List<EventosModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

String eventModelToJson(Event data) => json.encode(data.toJson());

class EventosModel {
  EventosModel({
    this.date,
    this.events,
  });

  DateTime date;
  List<Event> events;

  factory EventosModel.fromJson(Map<String, dynamic> json) => EventosModel(
        date: DateTime.parse(json["date"]),
        events: List<Event>.from(json["events"].map((x) => Event.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "date": date.toIso8601String(),
        "events": List<dynamic>.from(events.map((x) => x.toJson())),
      };
}

class Event {
  int calendarioFechaId;
  int doctorId;
  DateTime inicio;
  DateTime fin;
  bool todoElDia;
  String colorPrimario;
  String colorSecundario;
  DateTime fechaFiltro;
  bool activo;
  String creadoPor;
  DateTime creadoFecha;
  String modificadoPor;
  DateTime modificadoFecha;
  String notas;

  Event({
    this.calendarioFechaId,
    this.doctorId,
    this.inicio,
    this.fin,
    this.todoElDia,
    this.colorPrimario,
    this.colorSecundario,
    this.fechaFiltro,
    this.activo,
    this.creadoPor,
    this.creadoFecha,
    this.modificadoPor,
    this.modificadoFecha,
    this.notas,
  });

  factory Event.fromJson(Map<String, dynamic> json) => Event(
        calendarioFechaId: json["calendarioFechaId"],
        doctorId: json["doctorId"],
        inicio: DateTime.parse(json["inicio"]),
        fin: DateTime.parse(json["fin"]),
        todoElDia: json["todoElDia"],
        colorPrimario: json["colorPrimario"],
        colorSecundario: json["colorSecundario"],
        fechaFiltro: DateTime.parse(json["fechaFiltro"]),
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
        "fechaFiltro": fechaFiltro.toIso8601String(),
        "activo": activo,
        "creadoPor": creadoPor,
        "creadoFecha": creadoFecha.toIso8601String(),
        "modificadoPor": modificadoPor,
        "modificadoFecha": modificadoFecha.toIso8601String(),
        "notas": notas,
      };
}
