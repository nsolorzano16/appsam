// To parse this JSON data, do
//
//     final calendarioMovilViewModel = calendarioMovilViewModelFromJson(jsonString);

import 'dart:convert';

import 'package:appsam/src/models/calendarioFecha_model.dart';

List<CalendarioMovilViewModel> calendarioMovilViewModelFromJson(String str) =>
    List<CalendarioMovilViewModel>.from(
        json.decode(str).map((x) => CalendarioMovilViewModel.fromJson(x)));

String calendarioMovilViewModelToJson(List<CalendarioMovilViewModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CalendarioMovilViewModel {
  DateTime date;
  List<CalendarioFechaModel> events;

  CalendarioMovilViewModel({
    this.date,
    this.events,
  });

  factory CalendarioMovilViewModel.fromJson(Map<String, dynamic> json) =>
      CalendarioMovilViewModel(
        date: DateTime.parse(json["date"]),
        events: List<CalendarioFechaModel>.from(
            json["events"].map((x) => CalendarioFechaModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "date": date.toIso8601String(),
        "events": List<dynamic>.from(events.map((x) => x.toJson())),
      };
}
