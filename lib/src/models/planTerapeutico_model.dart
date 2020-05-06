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
  int preclinicaId;
  String nombreMedicamento;
  String dosis;
  String viaAdministracion;
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
    this.preclinicaId,
    this.nombreMedicamento,
    this.dosis,
    this.viaAdministracion,
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
        preclinicaId: json["preclinicaId"],
        nombreMedicamento: json["nombreMedicamento"],
        dosis: json["dosis"],
        viaAdministracion: json["viaAdministracion"],
        horario: json["horario"],
        permanente: json["permanente"],
        diasRequeridos: json["diasRequeridos"],
        activo: json["activo"],
        creadoPor: json["creadoPor"],
        creadoFecha: DateTime.parse(json["creadoFecha"]),
        modificadoPor: json["modificadoPor"],
        modificadoFecha: DateTime.parse(json["modificadoFecha"]),
        notas: json["notas"],
      );

  Map<String, dynamic> toJson() => {
        "planTerapeuticoId": planTerapeuticoId,
        "pacienteId": pacienteId,
        "doctorId": doctorId,
        "preclinicaId": preclinicaId,
        "nombreMedicamento": nombreMedicamento,
        "dosis": dosis,
        "viaAdministracion": viaAdministracion,
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
