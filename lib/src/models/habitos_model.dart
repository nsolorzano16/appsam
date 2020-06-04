// To parse this JSON data, do
//
//     final habitos = habitosFromJson(jsonString);

import 'dart:convert';

Habitos habitosFromJson(String str) => Habitos.fromJson(json.decode(str));

String habitosToJson(Habitos data) => json.encode(data.toJson());

class Habitos {
  int habitoId;
  int pacienteId;
  int doctorId;
  bool cafe;
  bool cigarrillo;
  bool alcohol;
  bool drogasEstupefaciente;
  int preclinicaId;
  bool activo;
  String creadoPor;
  DateTime creadoFecha;
  String modificadoPor;
  DateTime modificadoFecha;
  String notas;

  Habitos({
    this.habitoId,
    this.pacienteId,
    this.doctorId,
    this.cafe,
    this.cigarrillo,
    this.alcohol,
    this.drogasEstupefaciente,
    this.preclinicaId,
    this.activo,
    this.creadoPor,
    this.creadoFecha,
    this.modificadoPor,
    this.modificadoFecha,
    this.notas,
  });

  factory Habitos.fromJson(Map<String, dynamic> json) => Habitos(
        habitoId: json["habitoId"],
        pacienteId: json["pacienteId"],
        doctorId: json["doctorId"],
        cafe: json["cafe"],
        cigarrillo: json["cigarrillo"],
        alcohol: json["alcohol"],
        drogasEstupefaciente: json["drogasEstupefaciente"],
        preclinicaId: json["preclinicaId"],
        activo: json["activo"],
        creadoPor: json["creadoPor"],
        creadoFecha: DateTime.parse(json["creadoFecha"]),
        modificadoPor: json["modificadoPor"],
        modificadoFecha: DateTime.parse(json["modificadoFecha"]),
        notas: json["notas"],
      );

  Map<String, dynamic> toJson() => {
        "habitoId": habitoId,
        "pacienteId": pacienteId,
        "doctorId": doctorId,
        "cafe": cafe,
        "cigarrillo": cigarrillo,
        "alcohol": alcohol,
        "drogasEstupefaciente": drogasEstupefaciente,
        "preclinicaId": preclinicaId,
        "activo": activo,
        "creadoPor": creadoPor,
        "creadoFecha": creadoFecha.toIso8601String(),
        "modificadoPor": modificadoPor,
        "modificadoFecha": modificadoFecha.toIso8601String(),
        "notas": notas,
      };
}
