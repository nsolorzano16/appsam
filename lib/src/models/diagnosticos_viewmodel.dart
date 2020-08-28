// To parse this JSON data, do
//
//     final diagnosticosViewModel = diagnosticosViewModelFromJson(jsonString);

import 'dart:convert';

DiagnosticosViewModel diagnosticosViewModelFromJson(String str) =>
    DiagnosticosViewModel.fromJson(json.decode(str));

String diagnosticosViewModelToJson(DiagnosticosViewModel data) =>
    json.encode(data.toJson());

class DiagnosticosViewModel {
  DiagnosticosViewModel({
    this.codigoCie,
    this.nombreCie,
    this.diagnosticoId,
    this.pacienteId,
    this.doctorId,
    this.cieId,
    this.preclinicaId,
    this.problemasClinicos,
    this.activo,
    this.creadoPor,
    this.creadoFecha,
    this.modificadoPor,
    this.modificadoFecha,
    this.notas,
  });

  String codigoCie;
  String nombreCie;
  int diagnosticoId;
  int pacienteId;
  String doctorId;
  int cieId;
  int preclinicaId;
  String problemasClinicos;
  bool activo;
  String creadoPor;
  DateTime creadoFecha;
  String modificadoPor;
  DateTime modificadoFecha;
  String notas;

  factory DiagnosticosViewModel.fromJson(Map<String, dynamic> json) =>
      DiagnosticosViewModel(
        codigoCie: json["codigoCie"],
        nombreCie: json["nombreCie"],
        diagnosticoId: json["diagnosticoId"],
        pacienteId: json["pacienteId"],
        doctorId: json["doctorId"],
        cieId: json["cieId"],
        preclinicaId: json["preclinicaId"],
        problemasClinicos: json["problemasClinicos"] == null
            ? null
            : json["problemasClinicos"],
        activo: json["activo"],
        creadoPor: json["creadoPor"],
        creadoFecha: DateTime.parse(json["creadoFecha"]),
        modificadoPor: json["modificadoPor"],
        modificadoFecha: DateTime.parse(json["modificadoFecha"]),
        notas: json["notas"] == null ? "" : json["notas"],
      );

  Map<String, dynamic> toJson() => {
        "codigoCie": codigoCie,
        "nombreCie": nombreCie,
        "diagnosticoId": diagnosticoId,
        "pacienteId": pacienteId,
        "doctorId": doctorId,
        "cieId": cieId,
        "preclinicaId": preclinicaId,
        "problemasClinicos": problemasClinicos,
        "activo": activo,
        "creadoPor": creadoPor,
        "creadoFecha": creadoFecha.toIso8601String(),
        "modificadoPor": modificadoPor,
        "modificadoFecha": modificadoFecha.toIso8601String(),
        "notas": notas,
      };
}
