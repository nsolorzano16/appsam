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
    this.fum,
    this.g,
    this.p,
    this.c,
    this.hv,
    this.hm,
    this.anticonceptivos,
    this.vacunaVph,
    this.embarazo,
    this.fpp,
    this.afu,
    this.presentacion,
    this.movimientosFetales,
    this.fcf,
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
  DateTime fum;
  String g;
  String p;
  String c;
  String hv;
  String hm;
  String anticonceptivos;
  bool vacunaVph;
  bool embarazo;
  String fpp;
  String afu;
  DateTime presentacion;
  String movimientosFetales;
  String fcf;
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
        fum: DateTime.parse(json["fum"]),
        g: json["g"],
        p: json["p"],
        c: json["c"],
        hv: json["hv"],
        hm: json["hm"],
        anticonceptivos: json["anticonceptivos"],
        vacunaVph: json["vacunaVph"],
        embarazo: json["embarazo"],
        fpp: json["fpp"],
        afu: json["afu"],
        presentacion: DateTime.parse(json["presentacion"]),
        movimientosFetales: json["movimientosFetales"],
        fcf: json["fcf"],
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
        "fum": fum.toIso8601String(),
        "g": g,
        "p": p,
        "c": c,
        "hv": hv,
        "hm": hm,
        "anticonceptivos": anticonceptivos,
        "vacunaVph": vacunaVph,
        "embarazo": embarazo,
        "fpp": fpp,
        "afu": afu,
        "presentacion": presentacion.toIso8601String(),
        "movimientosFetales": movimientosFetales,
        "fcf": fcf,
        "preclinicaId": preclinicaId,
        "activo": activo,
        "creadoPor": creadoPor,
        "creadoFecha": creadoFecha.toIso8601String(),
        "modificadoPor": modificadoPor,
        "modificadoFecha": modificadoFecha.toIso8601String(),
        "notas": notas,
      };
}
