// To parse this JSON data, do
//
//     final totalPacientesAnioMes = totalPacientesAnioMesFromJson(jsonString);

import 'dart:convert';

List<TotalPacientesAnioMes> totalPacientesAnioMesFromJson(String str) =>
    List<TotalPacientesAnioMes>.from(
        json.decode(str).map((x) => TotalPacientesAnioMes.fromJson(x)));

String totalPacientesAnioMesToJson(List<TotalPacientesAnioMes> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TotalPacientesAnioMes {
  TotalPacientesAnioMes({
    this.year,
    this.mes,
    this.total,
  });

  int year;
  String mes;
  int total;

  factory TotalPacientesAnioMes.fromJson(Map<String, dynamic> json) =>
      TotalPacientesAnioMes(
        year: json["year"],
        mes: json["mes"],
        total: json["total"],
      );

  Map<String, dynamic> toJson() => {
        "year": year,
        "mes": mes,
        "total": total,
      };
}
