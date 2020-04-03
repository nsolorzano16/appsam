// To parse this JSON data, do
//
//     final consulta = consultaFromJson(jsonString);

import 'dart:convert';

import 'package:appsam/src/models/antecedentesFamiliaresPersonales_model.dart';
import 'package:appsam/src/models/diagnosticos_model.dart';
import 'package:appsam/src/models/examenFisicoGinecologico_model.dart';
import 'package:appsam/src/models/examenFisico_model.dart';
import 'package:appsam/src/models/farmacosUsoActual_model.dart';
import 'package:appsam/src/models/habitos_model.dart';
import 'package:appsam/src/models/historialGinecoObstetra_model.dart';
import 'package:appsam/src/models/notas_model.dart';
import 'package:appsam/src/models/preclinica_model.dart';

ConsultaModel consultaFromJson(String str) =>
    ConsultaModel.fromJson(json.decode(str));

String consultaToJson(ConsultaModel data) => json.encode(data.toJson());

class ConsultaModel {
  Preclinica preclinica;
  AntecedentesFamiliaresPersonales antecedentesFamiliaresPersonales;
  Habitos habitos;
  HistorialGinecoObstetra historialGinecoObstetra;
  List<FarmacosUsoActual> farmacosUsoActual;
  ExamenFisico examenFisico;
  ExamenFisicoGinecologico examenFisicoGinecologico;
  List<Diagnosticos> diagnosticos;
  List<Notas> notas;

  ConsultaModel({
    this.preclinica,
    this.antecedentesFamiliaresPersonales,
    this.habitos,
    this.historialGinecoObstetra,
    this.farmacosUsoActual,
    this.examenFisico,
    this.examenFisicoGinecologico,
    this.diagnosticos,
    this.notas,
  });

  factory ConsultaModel.fromJson(Map<String, dynamic> json) => ConsultaModel(
        preclinica: Preclinica.fromJson(json["preclinica"]),
        antecedentesFamiliaresPersonales:
            AntecedentesFamiliaresPersonales.fromJson(
                json["antecedentesFamiliaresPersonales"]),
        habitos: Habitos.fromJson(json["habitos"]),
        historialGinecoObstetra:
            HistorialGinecoObstetra.fromJson(json["historialGinecoObstetra"]),
        farmacosUsoActual: List<FarmacosUsoActual>.from(
            json["farmacosUsoActual"]
                .map((x) => FarmacosUsoActual.fromJson(x))),
        examenFisico: ExamenFisico.fromJson(json["examenFisico"]),
        examenFisicoGinecologico:
            ExamenFisicoGinecologico.fromJson(json["examenFisicoGinecologico"]),
        diagnosticos: List<Diagnosticos>.from(
            json["diagnosticos"].map((x) => Diagnosticos.fromJson(x))),
        notas: List<Notas>.from(json["notas"].map((x) => Notas.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "preclinica": preclinica == null ? null : preclinica.toJson(),
        "antecedentesFamiliaresPersonales":
            antecedentesFamiliaresPersonales == null
                ? null
                : antecedentesFamiliaresPersonales.toJson(),
        "habitos": habitos == null ? null : habitos.toJson(),
        "historialGinecoObstetra": historialGinecoObstetra == null
            ? null
            : historialGinecoObstetra.toJson(),
        "farmacosUsoActual": farmacosUsoActual == null
            ? null
            : List<dynamic>.from(farmacosUsoActual.map((x) => x.toJson())),
        "examenFisico": examenFisico == null ? null : examenFisico.toJson(),
        "examenFisicoGinecologico": examenFisicoGinecologico == null
            ? null
            : examenFisicoGinecologico.toJson(),
        "diagnosticos": diagnosticos == null
            ? null
            : List<dynamic>.from(diagnosticos.map((x) => x.toJson())),
        "notas": notas == null
            ? null
            : List<dynamic>.from(notas.map((x) => x.toJson())),
      };
}
