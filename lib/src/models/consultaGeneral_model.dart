// To parse this JSON data, do
//
//     final consultaGeneralModel = consultaGeneralModelFromJson(jsonString);

import 'dart:convert';

ConsultaGeneralModel consultaGeneralModelFromJson(String str) =>
    ConsultaGeneralModel.fromJson(json.decode(str));

String consultaGeneralModelToJson(ConsultaGeneralModel data) =>
    json.encode(data.toJson());

class ConsultaGeneralModel {
  int consultaId;
  int pacienteId;
  int doctorId;
  int preclinicaId;
  String motivoConsulta;
  String fog;
  String hea;
  bool activo;
  String creadoPor;
  DateTime creadoFecha;
  String modificadoPor;
  DateTime modificadoFecha;
  String notas;

  ConsultaGeneralModel({
    this.consultaId,
    this.pacienteId,
    this.doctorId,
    this.preclinicaId,
    this.motivoConsulta,
    this.fog,
    this.hea,
    this.activo,
    this.creadoPor,
    this.creadoFecha,
    this.modificadoPor,
    this.modificadoFecha,
    this.notas,
  });

  factory ConsultaGeneralModel.fromJson(Map<String, dynamic> json) =>
      ConsultaGeneralModel(
        consultaId: json["consultaId"],
        pacienteId: json["pacienteId"],
        doctorId: json["doctorId"],
        preclinicaId: json["preclinicaId"],
        motivoConsulta: json["motivoConsulta"] == null ? "" : json["motivoConsulta"],
        fog: json["fog"] == null ? "" : json["fog"],
        hea: json["hea"] ==null ?"":json["hea"],
        activo: json["activo"],
        creadoPor: json["creadoPor"],
        creadoFecha: DateTime.parse(json["creadoFecha"]),
        modificadoPor: json["modificadoPor"],
        modificadoFecha: DateTime.parse(json["modificadoFecha"]),
        notas: json["notas"] == null ? "": json["notas"],
      );

  Map<String, dynamic> toJson() => {
        "consultaId": consultaId,
        "pacienteId": pacienteId,
        "doctorId": doctorId,
        "preclinicaId": preclinicaId,
        "motivoConsulta": motivoConsulta,
        "fog": fog,
        "hea": hea,
        "activo": activo,
        "creadoPor": creadoPor,
        "creadoFecha": creadoFecha.toIso8601String(),
        "modificadoPor": modificadoPor,
        "modificadoFecha": modificadoFecha.toIso8601String(),
        "notas": notas,
      };
}
