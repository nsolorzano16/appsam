// To parse this JSON data, do
//
//     final eventosModel = eventosModelFromJson(jsonString);

import 'dart:convert';

import 'package:appsam/src/models/calendarioFecha_model.dart';

List<EventosModel> eventosModelFromJson(String str) => List<EventosModel>.from(
    json.decode(str).map((x) => EventosModel.fromJson(x)));

String eventosModelToJson(List<EventosModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class EventosModel {
  EventosModel({
    this.date,
    this.events,
  });

  DateTime date;
  List<CalendarioFechaModel> events;

  factory EventosModel.fromJson(Map<String, dynamic> json) => EventosModel(
        date: DateTime.parse(json["date"]),
        events: List<CalendarioFechaModel>.from(
            json["events"].map((x) => CalendarioFechaModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "date": date.toIso8601String(),
        "events": List<dynamic>.from(events.map((x) => x.toJson())),
      };
}
