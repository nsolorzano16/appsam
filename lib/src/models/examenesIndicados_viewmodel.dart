// To parse this JSON data, do
//
//     final examenesIndicadosViewModel = examenesIndicadosViewModelFromJson(jsonString);

import 'dart:convert';

ExamenesIndicadosViewModel examenesIndicadosViewModelFromJson(String str) =>
    ExamenesIndicadosViewModel.fromJson(json.decode(str));

String examenesIndicadosViewModelToJson(ExamenesIndicadosViewModel data) =>
    json.encode(data.toJson());

class ExamenesIndicadosViewModel {
  int examenIndicadoId;
  int pacienteId;
  String doctorId;
  int preclinicaId;
  int examenCategoriaId;
  int examenTipoId;
  int examenDetalleId;
  String nombre;
  bool activo;
  String creadoPor;
  DateTime creadoFecha;
  String modificadoPor;
  DateTime modificadoFecha;
  String notas;
  String examenCategoria;
  String examenTipo;
  String examenDetalle;

  ExamenesIndicadosViewModel({
    this.examenIndicadoId,
    this.pacienteId,
    this.doctorId,
    this.preclinicaId,
    this.examenCategoriaId,
    this.examenTipoId,
    this.examenDetalleId,
    this.nombre,
    this.activo,
    this.creadoPor,
    this.creadoFecha,
    this.modificadoPor,
    this.modificadoFecha,
    this.notas,
    this.examenCategoria,
    this.examenTipo,
    this.examenDetalle,
  });

  factory ExamenesIndicadosViewModel.fromJson(Map<String, dynamic> json) =>
      ExamenesIndicadosViewModel(
        examenIndicadoId: json["examenIndicadoId"],
        pacienteId: json["pacienteId"],
        doctorId: json["doctorId"],
        preclinicaId: json["preclinicaId"],
        examenCategoriaId: json["examenCategoriaId"],
        examenTipoId: json["examenTipoId"],
        examenDetalleId: json["examenDetalleId"],
        nombre: json["nombre"] == null ? "" : json["nombre"],
        activo: json["activo"],
        creadoPor: json["creadoPor"],
        creadoFecha: DateTime.parse(json["creadoFecha"]),
        modificadoPor: json["modificadoPor"],
        modificadoFecha: DateTime.parse(json["modificadoFecha"]),
        notas: json["notas"] == null ? "" : json["notas"],
        examenCategoria:
            json["examenCategoria"] == null ? "" : json["examenCategoria"],
        examenTipo: json["examenTipo"] == null ? "" : json["examenTipo"],
        examenDetalle:
            json["examenDetalle"] == null ? "" : json["examenDetalle"],
      );

  Map<String, dynamic> toJson() => {
        "examenIndicadoId": examenIndicadoId,
        "pacienteId": pacienteId,
        "doctorId": doctorId,
        "preclinicaId": preclinicaId,
        "examenCategoriaId": examenCategoriaId,
        "examenTipoId": examenTipoId,
        "examenDetalleId": examenDetalleId,
        "nombre": nombre,
        "activo": activo,
        "creadoPor": creadoPor,
        "creadoFecha": creadoFecha.toIso8601String(),
        "modificadoPor": modificadoPor,
        "modificadoFecha": modificadoFecha.toIso8601String(),
        "notas": notas,
        "examenCategoria": examenCategoria,
        "examenTipo": examenTipo,
        "examenDetalle": examenDetalle,
      };
}
