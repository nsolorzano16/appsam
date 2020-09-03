// To parse this JSON data, do
//
//     final fotosPacienteModel = fotosPacienteModelFromJson(jsonString);

import 'dart:convert';

FotosPacienteModel fotosPacienteModelFromJson(String str) =>
    FotosPacienteModel.fromJson(json.decode(str));

String fotosPacienteModelToJson(FotosPacienteModel data) =>
    json.encode(data.toJson());

class FotosPacienteModel {
  FotosPacienteModel({
    this.fotoId,
    this.pacienteId,
    this.usuarioId,
    this.asistenteId,
    this.fotoUrl,
    this.activo,
    this.creadoPor,
    this.creadoFecha,
    this.modificadoPor,
    this.modificadoFecha,
    this.notas,
  });

  int fotoId;
  int pacienteId;
  String usuarioId;
  String asistenteId;
  String fotoUrl;
  bool activo;
  String creadoPor;
  DateTime creadoFecha;
  String modificadoPor;
  DateTime modificadoFecha;
  String notas;

  factory FotosPacienteModel.fromJson(Map<String, dynamic> json) =>
      FotosPacienteModel(
        fotoId: json["fotoId"],
        usuarioId: json["usuarioId"],
        asistenteId: json["asistenteId"],
        pacienteId: json["pacienteId"],
        fotoUrl: json["fotoUrl"],
        activo: json["activo"],
        creadoPor: json["creadoPor"],
        creadoFecha: DateTime.parse(json["creadoFecha"]),
        modificadoPor: json["modificadoPor"],
        modificadoFecha: DateTime.parse(json["modificadoFecha"]),
        notas: json["notas"],
      );

  Map<String, dynamic> toJson() => {
        "fotoId": fotoId,
        "usuarioId": usuarioId,
        "asistenteId": asistenteId,
        "pacienteId": pacienteId,
        "fotoUrl": fotoUrl,
        "activo": activo,
        "creadoPor": creadoPor,
        "creadoFecha": creadoFecha.toIso8601String(),
        "modificadoPor": modificadoPor,
        "modificadoFecha": modificadoFecha.toIso8601String(),
        "notas": notas,
      };
}
