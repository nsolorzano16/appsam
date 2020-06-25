// To parse this JSON data, do
//
//     final historialGinecoViewModel = historialGinecoViewModelFromJson(jsonString);

import 'dart:convert';

HistorialGinecoViewModel historialGinecoViewModelFromJson(String str) =>
    HistorialGinecoViewModel.fromJson(json.decode(str));

String historialGinecoViewModelToJson(HistorialGinecoViewModel data) =>
    json.encode(data.toJson());

class HistorialGinecoViewModel {
  HistorialGinecoViewModel({
    this.anticonceptivoTexto,
    this.historialId,
    this.pacienteId,
    this.anticonceptivoId,
    this.fechaMenarquia,
    this.fum,
    this.g,
    this.p,
    this.c,
    this.hv,
    this.hm,
    this.descripcionAnticonceptivos,
    this.vacunaVph,
    this.fechaMenopausia,
    this.preclinicaId,
    this.activo,
    this.creadoPor,
    this.creadoFecha,
    this.modificadoPor,
    this.modificadoFecha,
    this.notas,
  });

  String anticonceptivoTexto;
  int historialId;
  int pacienteId;
  int anticonceptivoId;
  DateTime fechaMenarquia;
  DateTime fum;
  int g;
  int p;
  int c;
  int hv;
  int hm;
  String descripcionAnticonceptivos;
  bool vacunaVph;
  DateTime fechaMenopausia;
  int preclinicaId;
  bool activo;
  String creadoPor;
  DateTime creadoFecha;
  String modificadoPor;
  DateTime modificadoFecha;
  String notas;

  factory HistorialGinecoViewModel.fromJson(Map<String, dynamic> json) =>
      HistorialGinecoViewModel(
        anticonceptivoTexto: json["anticonceptivoTexto"] == null
            ? ""
            : json["anticonceptivoTexto"],
        historialId: json["historialId"] == null ? 0 : json["historialId"],
        pacienteId: json["pacienteId"] == null ? 0 : json["pacienteId"],
        anticonceptivoId:
            json["anticonceptivoId"] == null ? 0 : json["anticonceptivoId"],
        fechaMenarquia: json["fechaMenarquia"] == null
            ? null
            : DateTime.parse(json["fechaMenarquia"]),
        fum: json["fum"] == null ? null : DateTime.parse(json["fum"]),
        g: json["g"] == null ? 0 : json["g"],
        p: json["p"] == null ? 0 : json["p"],
        c: json["c"] == null ? 0 : json["c"],
        hv: json["hv"] == null ? 0 : json["hv"],
        hm: json["hm"] == null ? 0 : json["hm"],
        descripcionAnticonceptivos: json["descripcionAnticonceptivos"] == null
            ? ""
            : json["descripcionAnticonceptivos"],
        vacunaVph: json["vacunaVph"],
        fechaMenopausia: json["fechaMenopausia"] == null
            ? null
            : DateTime.parse(json["fechaMenopausia"]),
        preclinicaId: json["preclinicaId"] == null ? 0 : json["preclinicaId"],
        activo: json["activo"],
        creadoPor: json["creadoPor"],
        creadoFecha: DateTime.parse(json["creadoFecha"]),
        modificadoPor: json["modificadoPor"],
        modificadoFecha: DateTime.parse(json["modificadoFecha"]),
        notas: json["notas"] == null ? "" : json["notas"],
      );

  Map<String, dynamic> toJson() => {
        "anticonceptivoTexto": anticonceptivoTexto,
        "historialId": historialId,
        "pacienteId": pacienteId,
        "anticonceptivoId": anticonceptivoId,
        "fechaMenarquia": fechaMenarquia.toIso8601String(),
        "fum": fum.toIso8601String(),
        "g": g,
        "p": p,
        "c": c,
        "hv": hv,
        "hm": hm,
        "descripcionAnticonceptivos": descripcionAnticonceptivos,
        "vacunaVph": vacunaVph,
        "fechaMenopausia": fechaMenopausia.toIso8601String(),
        "preclinicaId": preclinicaId,
        "activo": activo,
        "creadoPor": creadoPor,
        "creadoFecha": creadoFecha.toIso8601String(),
        "modificadoPor": modificadoPor,
        "modificadoFecha": modificadoFecha.toIso8601String(),
        "notas": notas,
      };
}
