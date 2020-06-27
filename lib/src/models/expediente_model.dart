// To parse this JSON data, do
//
//     final expedienteViewModel = expedienteViewModelFromJson(jsonString);

import 'dart:convert';

import 'package:appsam/src/models/antecedentesFamiliaresPersonales_model.dart';
import 'package:appsam/src/models/consultaGeneral_model.dart';
import 'package:appsam/src/models/diagnosticos_model.dart';
import 'package:appsam/src/models/examenFisico_model.dart';
import 'package:appsam/src/models/examenesIndicados_viewmodel.dart';
import 'package:appsam/src/models/farmacosUsoActual_model.dart';
import 'package:appsam/src/models/habitos_model.dart';
import 'package:appsam/src/models/historialGineco_viewmodel.dart';
import 'package:appsam/src/models/notas_model.dart';
import 'package:appsam/src/models/paginados/pacientesPaginado_model.dart';
import 'package:appsam/src/models/planTerapeutico_viewmodel.dart';
import 'package:appsam/src/models/preclinica_model.dart';

ExpedienteViewModel expedienteViewModelFromJson(String str) =>
    ExpedienteViewModel.fromJson(json.decode(str));

String expedienteViewModelToJson(ExpedienteViewModel data) =>
    json.encode(data.toJson());

class ExpedienteViewModel {
  ExpedienteViewModel({
    this.antecedentesFamiliaresPersonales,
    this.habitos,
    this.historialGinecoObstetra,
    this.farmacosUsoActual,
    this.paciente,
    this.consultas,
  });

  AntecedentesFamiliaresPersonales antecedentesFamiliaresPersonales;
  Habitos habitos;
  HistorialGinecoViewModel historialGinecoObstetra;
  List<FarmacosUsoActual> farmacosUsoActual;
  PacientesViewModel paciente;
  List<Consulta> consultas;

  factory ExpedienteViewModel.fromJson(Map<String, dynamic> json) =>
      ExpedienteViewModel(
        antecedentesFamiliaresPersonales:
            json["antecedentesFamiliaresPersonales"] == null
                ? null
                : AntecedentesFamiliaresPersonales.fromJson(
                    json["antecedentesFamiliaresPersonales"]),
        habitos:
            json["habitos"] == null ? null : Habitos.fromJson(json["habitos"]),
        historialGinecoObstetra: json["historialGinecoObstetra"] == null
            ? null
            : HistorialGinecoViewModel.fromJson(
                json["historialGinecoObstetra"]),
        farmacosUsoActual: json["farmacosUsoActual"] == null
            ? null
            : List<FarmacosUsoActual>.from(json["farmacosUsoActual"]
                .map((x) => FarmacosUsoActual.fromJson(x))),
        paciente: json["paciente"] == null
            ? null
            : PacientesViewModel.fromJson(json["paciente"]),
        consultas: List<Consulta>.from(
            json["consultas"].map((x) => Consulta.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "antecedentesFamiliaresPersonales":
            antecedentesFamiliaresPersonales.toJson(),
        "habitos": habitos.toJson(),
        "historialGinecoObstetra": historialGinecoObstetra.toJson(),
        "farmacosUsoActual":
            List<dynamic>.from(farmacosUsoActual.map((x) => x.toJson())),
        "paciente": paciente.toJson(),
        "consultas": List<dynamic>.from(consultas.map((x) => x.toJson())),
      };
}

class Consulta {
  Consulta({
    this.preclinica,
    this.examenFisico,
    this.diagnosticos,
    this.notas,
    this.consultaGeneral,
    this.examenesIndicados,
    this.planesTerapeuticos,
  });

  Preclinica preclinica;
  ExamenFisico examenFisico;
  List<Diagnosticos> diagnosticos;
  List<Notas> notas;
  ConsultaGeneralModel consultaGeneral;
  List<ExamenesIndicadosViewModel> examenesIndicados;
  List<PlanTerapeuticoViewModel> planesTerapeuticos;

  factory Consulta.fromJson(Map<String, dynamic> json) => Consulta(
        preclinica: json["preclinica"] == null
            ? null
            : Preclinica.fromJson(json["preclinica"]),
        examenFisico: json["examenFisico"] == null
            ? null
            : ExamenFisico.fromJson(json["examenFisico"]),
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
        "examenFisico": examenFisico.toJson(),
        "diagnosticos": List<dynamic>.from(diagnosticos.map((x) => x.toJson())),
        "notas": List<dynamic>.from(notas.map((x) => x.toJson())),
        "consultaGeneral": consultaGeneral.toJson(),
        "examenesIndicados":
            List<dynamic>.from(examenesIndicados.map((x) => x.toJson())),
        "planesTerapeuticos":
            List<dynamic>.from(planesTerapeuticos.map((x) => x.toJson())),
      };
}
