// To parse this JSON data, do
//
//     final farmacosUsoActual = farmacosUsoActualFromJson(jsonString);

import 'dart:convert';

FarmacosUsoActual farmacosUsoActualFromJson(String str) =>
    FarmacosUsoActual.fromJson(json.decode(str));

String farmacosUsoActualToJson(FarmacosUsoActual data) =>
    json.encode(data.toJson());

String farmacosUsoActualToJsonList(List<FarmacosUsoActual> data) =>
    json.encode(data);

class FarmacosUsoActual {
  FarmacosUsoActual({
    this.farmacoId,
    this.pacienteId,
    this.preclinicaId,
    this.nombre,
    this.concentracion,
    this.dosis,
    this.tiempo,
    this.activo,
    this.creadoPor,
    this.creadoFecha,
    this.modificadoPor,
    this.modificadoFecha,
    this.notas,
  });

  int farmacoId;
  int pacienteId;
  int preclinicaId;
  String nombre;
  String concentracion;
  String dosis;
  String tiempo;
  bool activo;
  String creadoPor;
  DateTime creadoFecha;
  String modificadoPor;
  DateTime modificadoFecha;
  String notas;

  factory FarmacosUsoActual.fromJson(Map<String, dynamic> json) =>
      FarmacosUsoActual(
        farmacoId: json["farmacoId"],
        pacienteId: json["pacienteId"],
        preclinicaId: json["preclinicaId"],
        nombre: json["nombre"],
        concentracion: json["concentracion"],
        dosis: json["dosis"],
        tiempo: json["tiempo"],
        activo: json["activo"],
        creadoPor: json["creadoPor"],
        creadoFecha: DateTime.parse(json["creadoFecha"]),
        modificadoPor: json["modificadoPor"],
        modificadoFecha: DateTime.parse(json["modificadoFecha"]),
        notas: json["notas"],
      );

  Map<String, dynamic> toJson() => {
        "farmacoId": farmacoId,
        "pacienteId": pacienteId,
        "preclinicaId": preclinicaId,
        "nombre": nombre,
        "concentracion": concentracion,
        "dosis": dosis,
        "tiempo": tiempo,
        "activo": activo,
        "creadoPor": creadoPor,
        "creadoFecha": creadoFecha.toIso8601String(),
        "modificadoPor": modificadoPor,
        "modificadoFecha": modificadoFecha.toIso8601String(),
        "notas": notas,
      };
}
