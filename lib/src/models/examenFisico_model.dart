// To parse this JSON data, do
//
//     final examenFisico = examenFisicoFromJson(jsonString);

import 'dart:convert';

ExamenFisico examenFisicoFromJson(String str) =>
    ExamenFisico.fromJson(json.decode(str));

String examenFisicoToJson(ExamenFisico data) => json.encode(data.toJson());

class ExamenFisico {
  int examenFisicoId;
  int pacienteId;
  int doctorId;
  String aspectoGeneral;
  String pielFaneras;
  String cabeza;
  String oidos;
  String ojos;
  String nariz;
  String boca;
  String cuello;
  String torax;
  String abdomen;
  String columnaVertebralRegionLumbar;
  String miembrosInferioresSuperiores;
  String genitales;
  String neurologico;
  int preclinicaId;
  bool activo;
  String creadoPor;
  DateTime creadoFecha;
  String modificadoPor;
  DateTime modificadoFecha;
  String notas;

  ExamenFisico({
    this.examenFisicoId,
    this.pacienteId,
    this.doctorId,
    this.aspectoGeneral,
    this.pielFaneras,
    this.cabeza,
    this.oidos,
    this.ojos,
    this.nariz,
    this.boca,
    this.cuello,
    this.torax,
    this.abdomen,
    this.columnaVertebralRegionLumbar,
    this.miembrosInferioresSuperiores,
    this.genitales,
    this.neurologico,
    this.preclinicaId,
    this.activo,
    this.creadoPor,
    this.creadoFecha,
    this.modificadoPor,
    this.modificadoFecha,
    this.notas,
  });

  factory ExamenFisico.fromJson(Map<String, dynamic> json) => ExamenFisico(
        examenFisicoId: json["examenFisicoId"],
        pacienteId: json["pacienteId"],
        doctorId: json["doctorId"],
        aspectoGeneral:
            json["aspectoGeneral"] == null ? "" : json["aspectoGeneral"],
        pielFaneras: json["pielFaneras"] == null ? "" : json["pielFaneras"],
        cabeza: json["cabeza"] == null ? "" : json["cabeza"],
        oidos: json["oidos"] == null ? "" : json["oidos"],
        ojos: json["ojos"] == null ? "" : json["ojos"],
        nariz: json["nariz"] == null ? "" : json["nariz"],
        boca: json["boca"] == null ? "" : json["boca"],
        cuello: json["cuello"] == null ? "" : json["cuello"],
        torax: json["torax"] == null ? "" : json["torax"],
        abdomen: json["abdomen"] == null ? "" : json["abdomen"],
        columnaVertebralRegionLumbar:
            json["columnaVertebralRegionLumbar"] == null
                ? ""
                : json["columnaVertebralRegionLumbar"],
        miembrosInferioresSuperiores:
            json["miembrosInferioresSuperiores"] == null
                ? ""
                : json["miembrosInferioresSuperiores"],
        genitales: json["genitales"] == null ? "" : json["genitales"],
        neurologico: json["neurologico"] == null ? "" : json["neurologico"],
        preclinicaId: json["preclinicaId"],
        activo: json["activo"],
        creadoPor: json["creadoPor"],
        creadoFecha: DateTime.parse(json["creadoFecha"]),
        modificadoPor: json["modificadoPor"],
        modificadoFecha: DateTime.parse(json["modificadoFecha"]),
        notas: json["notas"] == null ? "" : json["notas"],
      );

  Map<String, dynamic> toJson() => {
        "examenFisicoId": examenFisicoId,
        "pacienteId": pacienteId,
        "doctorId": doctorId,
        "aspectoGeneral": aspectoGeneral,
        "pielFaneras": pielFaneras,
        "cabeza": cabeza,
        "oidos": oidos,
        "ojos": ojos,
        "nariz": nariz,
        "boca": boca,
        "cuello": cuello,
        "torax": torax,
        "abdomen": abdomen,
        "columnaVertebralRegionLumbar": columnaVertebralRegionLumbar,
        "miembrosInferioresSuperiores": miembrosInferioresSuperiores,
        "genitales": genitales,
        "neurologico": neurologico,
        "preclinicaId": preclinicaId,
        "activo": activo,
        "creadoPor": creadoPor,
        "creadoFecha": creadoFecha.toIso8601String(),
        "modificadoPor": modificadoPor,
        "modificadoFecha": modificadoFecha.toIso8601String(),
        "notas": notas,
      };
}
