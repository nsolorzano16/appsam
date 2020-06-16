// To parse this JSON data, do
//
//     final historialGinecoObstetra = historialGinecoObstetraFromJson(jsonString);

import 'dart:convert';

HistorialGinecoObstetra historialGinecoObstetraFromJson(String str) =>
    HistorialGinecoObstetra.fromJson(json.decode(str));

String historialGinecoObstetraToJson(HistorialGinecoObstetra data) =>
    json.encode(data.toJson());

class HistorialGinecoObstetra {
  HistorialGinecoObstetra({
    this.historialId,
    this.pacienteId,
    this.anticonceptivoId,
    this.fechaMenarquia,
    this.fum,
    this.g,
    this.p,
    this.c,
    this.hv,
    this.hm,
    this.descripcionAnticonceptivos,
    this.vacunaVph,
    this.fechaMenopausia,
    this.preclinicaId,
    this.activo,
    this.creadoPor,
    this.creadoFecha,
    this.modificadoPor,
    this.modificadoFecha,
    this.notas,
  });

  int historialId;
  int pacienteId;
  int anticonceptivoId;
  DateTime fechaMenarquia;
  DateTime fum;
  int g;
  int p;
  int c;
  int hv;
  int hm;
  String descripcionAnticonceptivos;
  bool vacunaVph;
  DateTime fechaMenopausia;
  int preclinicaId;
  bool activo;
  String creadoPor;
  DateTime creadoFecha;
  String modificadoPor;
  DateTime modificadoFecha;
  String notas;

  factory HistorialGinecoObstetra.fromJson(Map<String, dynamic> json) =>
      HistorialGinecoObstetra(
        historialId: json["historialId"],
        pacienteId: json["pacienteId"],
        anticonceptivoId: json["anticonceptivoId"],
        fechaMenarquia: json["fechaMenarquia"] == null
            ? null
            : DateTime.parse(json["fechaMenarquia"]),
        fum: json["fum"] == null ? null : DateTime.parse(json["fum"]),
        g: json["g"],
        p: json["p"],
        c: json["c"],
        hv: json["hv"],
        hm: json["hm"],
        descripcionAnticonceptivos: json["descripcionAnticonceptivos"],
        vacunaVph: json["vacunaVph"],
        fechaMenopausia: json["fechaMenopausia"] == null
            ? null
            : DateTime.parse(json["fechaMenopausia"]),
        preclinicaId: json["preclinicaId"],
        activo: json["activo"],
        creadoPor: json["creadoPor"],
        creadoFecha: DateTime.parse(json["creadoFecha"]),
        modificadoPor: json["modificadoPor"],
        modificadoFecha: DateTime.parse(json["modificadoFecha"]),
        notas: json["notas"],
      );

  Map<String, dynamic> toJson() => {
        "historialId": historialId,
        "pacienteId": pacienteId,
        "anticonceptivoId": anticonceptivoId,
        "fechaMenarquia":
            fechaMenarquia == null ? null : fechaMenarquia.toIso8601String(),
        "fum": fum == null ? null : fum.toIso8601String(),
        "g": g,
        "p": p,
        "c": c,
        "hv": hv,
        "hm": hm,
        "descripcionAnticonceptivos": descripcionAnticonceptivos,
        "vacunaVph": vacunaVph,
        "fechaMenopausia":
            fechaMenopausia == null ? null : fechaMenopausia.toIso8601String(),
        "preclinicaId": preclinicaId,
        "activo": activo,
        "creadoPor": creadoPor,
        "creadoFecha": creadoFecha.toIso8601String(),
        "modificadoPor": modificadoPor,
        "modificadoFecha": modificadoFecha.toIso8601String(),
        "notas": notas,
      };
}
