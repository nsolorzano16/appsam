// To parse this JSON data, do
//
//     final planTerapeuticoModel = planTerapeuticoModelFromJson(jsonString);

import 'dart:convert';

PlanTerapeuticoModel planTerapeuticoModelFromJson(String str) =>
    PlanTerapeuticoModel.fromJson(json.decode(str));

String planTerapeuticoModelToJson(PlanTerapeuticoModel data) =>
    json.encode(data.toJson());

class PlanTerapeuticoModel {
  int planTerapeuticoId;
  int pacienteId;
  int doctorId;
  int viaAdministracionId;
  int preclinicaId;
  String nombreMedicamento;
  String dosis;
  String horario;
  bool permanente;
  String diasRequeridos;
  bool activo;
  String creadoPor;
  DateTime creadoFecha;
  String modificadoPor;
  DateTime modificadoFecha;
  String notas;

  PlanTerapeuticoModel({
    this.planTerapeuticoId,
    this.pacienteId,
    this.doctorId,
    this.viaAdministracionId,
    this.preclinicaId,
    this.nombreMedicamento,
    this.dosis,
    this.horario,
    this.permanente,
    this.diasRequeridos,
    this.activo,
    this.creadoPor,
    this.creadoFecha,
    this.modificadoPor,
    this.modificadoFecha,
    this.notas,
  });

  factory PlanTerapeuticoModel.fromJson(Map<String, dynamic> json) =>
      PlanTerapeuticoModel(
        planTerapeuticoId: json["planTerapeuticoId"],
        pacienteId: json["pacienteId"],
        doctorId: json["doctorId"],
        viaAdministracionId: json["viaAdministracionId"],
        preclinicaId: json["preclinicaId"],
        nombreMedicamento:
            json["nombreMedicamento"] == null ? "" : json["nombreMedicamento"],
        dosis: json["dosis"] == null ? "" : json["dosis"],
        horario: json["horario"] == null ? "" : json["horario"],
        permanente: json["permanente"],
        diasRequeridos:
            json["diasRequeridos"] == null ? "" : json["diasRequeridos"],
        activo: json["activo"],
        creadoPor: json["creadoPor"],
        creadoFecha: DateTime.parse(json["creadoFecha"]),
        modificadoPor: json["modificadoPor"],
        modificadoFecha: DateTime.parse(json["modificadoFecha"]),
        notas: json["notas"] == null ? "" : json["notas"],
      );

  Map<String, dynamic> toJson() => {
        "planTerapeuticoId": planTerapeuticoId,
        "pacienteId": pacienteId,
        "doctorId": doctorId,
        "viaAdministracionId": viaAdministracionId,
        "preclinicaId": preclinicaId,
        "nombreMedicamento": nombreMedicamento,
        "dosis": dosis,
        "horario": horario,
        "permanente": permanente,
        "diasRequeridos": diasRequeridos,
        "activo": activo,
        "creadoPor": creadoPor,
        "creadoFecha": creadoFecha.toIso8601String(),
        "modificadoPor": modificadoPor,
        "modificadoFecha": modificadoFecha.toIso8601String(),
        "notas": notas,
      };
}
