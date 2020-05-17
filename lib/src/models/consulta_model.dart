// To parse this JSON data, do
//
//     final consultaModel = consultaModelFromJson(jsonString);

import 'dart:convert';

import 'package:appsam/src/models/antecedentesFamiliaresPersonales_model.dart';
import 'package:appsam/src/models/consultaGeneral_model.dart';
import 'package:appsam/src/models/diagnosticos_model.dart';
import 'package:appsam/src/models/examenFisicoGinecologico_model.dart';
import 'package:appsam/src/models/examenFisico_model.dart';
import 'package:appsam/src/models/examenesIndicados_viewmodel.dart';
import 'package:appsam/src/models/farmacosUsoActual_model.dart';
import 'package:appsam/src/models/habitos_model.dart';
import 'package:appsam/src/models/historialGinecoObstetra_model.dart';
import 'package:appsam/src/models/notas_model.dart';
import 'package:appsam/src/models/planTerapeutico_viewmodel.dart';
import 'package:appsam/src/models/preclinica_model.dart';

ConsultaModel consultaModelFromJson(String str) =>
    ConsultaModel.fromJson(json.decode(str));

String consultaModelToJson(ConsultaModel data) => json.encode(data.toJson());

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
  ConsultaGeneralModel consultaGeneral;
  List<ExamenesIndicadosViewModel> examenesIndicados;
  List<PlanTerapeuticoViewModel> planesTerapeuticos;

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
    this.consultaGeneral,
    this.examenesIndicados,
    this.planesTerapeuticos,
  });

  factory ConsultaModel.fromJson(Map<String, dynamic> json) => ConsultaModel(
        preclinica: json["preclinica"] == null
            ? null
            : Preclinica.fromJson(json["preclinica"]),
        antecedentesFamiliaresPersonales:
            json["antecedentesFamiliaresPersonales"] == null
                ? null
                : AntecedentesFamiliaresPersonales.fromJson(
                    json["antecedentesFamiliaresPersonales"]),
        habitos:
            json["habitos"] == null ? null : Habitos.fromJson(json["habitos"]),
        historialGinecoObstetra: json["historialGinecoObstetra"] == null
            ? null
            : HistorialGinecoObstetra.fromJson(json["historialGinecoObstetra"]),
        farmacosUsoActual: json["farmacosUsoActual"] == null
            ? null
            : List<FarmacosUsoActual>.from(json["farmacosUsoActual"]
                .map((x) => FarmacosUsoActual.fromJson(x))),
        examenFisico: json["examenFisico"] == null
            ? null
            : ExamenFisico.fromJson(json["examenFisico"]),
        examenFisicoGinecologico: json["examenFisicoGinecologico"] == null
            ? null
            : ExamenFisicoGinecologico.fromJson(
                json["examenFisicoGinecologico"]),
        diagnosticos: json["diagnosticos"] == null
            ? null
            : List<Diagnosticos>.from(
                json["diagnosticos"].map((x) => Diagnosticos.fromJson(x))),
        notas: json["notas"] == null
            ? null
            : List<Notas>.from(json["notas"].map((x) => Notas.fromJson(x))),
        consultaGeneral: json["consultaGeneral"] == null
            ? null
            : ConsultaGeneralModel.fromJson(json["consultaGeneral"]),
        examenesIndicados: json["examenesIndicados"] == null
            ? null
            : List<ExamenesIndicadosViewModel>.from(json["examenesIndicados"]
                .map((x) => ExamenesIndicadosViewModel.fromJson(x))),
        planesTerapeuticos: json["planesTerapeuticos"] == null
            ? null
            : List<PlanTerapeuticoViewModel>.from(json["planesTerapeuticos"]
                .map((x) => PlanTerapeuticoViewModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "preclinica": preclinica.toJson(),
        "antecedentesFamiliaresPersonales":
            antecedentesFamiliaresPersonales.toJson(),
        "habitos": habitos.toJson(),
        "historialGinecoObstetra": historialGinecoObstetra.toJson(),
        "farmacosUsoActual":
            List<dynamic>.from(farmacosUsoActual.map((x) => x.toJson())),
        "examenFisico": examenFisico.toJson(),
        "examenFisicoGinecologico": examenFisicoGinecologico.toJson(),
        "diagnosticos": List<dynamic>.from(diagnosticos.map((x) => x.toJson())),
        "notas": List<dynamic>.from(notas.map((x) => x.toJson())),
        "consultaGeneral": consultaGeneral.toJson(),
        "examenesIndicados":
            List<dynamic>.from(examenesIndicados.map((x) => x.toJson())),
        "planesTerapeuticos":
            List<dynamic>.from(planesTerapeuticos.map((x) => x.toJson())),
      };
}
