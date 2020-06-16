// To parse this JSON data, do
//
//     final antecedentesFamiliaresPersonales = antecedentesFamiliaresPersonalesFromJson(jsonString);

import 'dart:convert';

AntecedentesFamiliaresPersonales antecedentesFamiliaresPersonalesFromJson(
        String str) =>
    AntecedentesFamiliaresPersonales.fromJson(json.decode(str));

String antecedentesFamiliaresPersonalesToJson(
        AntecedentesFamiliaresPersonales data) =>
    json.encode(data.toJson());

class AntecedentesFamiliaresPersonales {
  AntecedentesFamiliaresPersonales({
    this.antecedentesFamiliaresPersonalesId,
    this.pacienteId,
    this.preclinicaId,
    this.antecedentesPatologicosFamiliares,
    this.antecedentesPatologicosPersonales,
    this.antecedentesNoPatologicosFamiliares,
    this.antecedentesNoPatologicosPersonales,
    this.antecedentesInmunoAlergicosPersonales,
    this.activo,
    this.creadoPor,
    this.creadoFecha,
    this.modificadoPor,
    this.modificadoFecha,
    this.notas,
  });

  int antecedentesFamiliaresPersonalesId;
  int pacienteId;
  int preclinicaId;
  String antecedentesPatologicosFamiliares;
  String antecedentesPatologicosPersonales;
  String antecedentesNoPatologicosFamiliares;
  String antecedentesNoPatologicosPersonales;
  String antecedentesInmunoAlergicosPersonales;
  bool activo;
  String creadoPor;
  DateTime creadoFecha;
  String modificadoPor;
  DateTime modificadoFecha;
  String notas;

  factory AntecedentesFamiliaresPersonales.fromJson(
          Map<String, dynamic> json) =>
      AntecedentesFamiliaresPersonales(
        antecedentesFamiliaresPersonalesId:
            json["antecedentesFamiliaresPersonalesId"],
        pacienteId: json["pacienteId"],
        preclinicaId: json["preclinicaId"],
        antecedentesPatologicosFamiliares:
            json["antecedentesPatologicosFamiliares"] == null
                ? ""
                : json["antecedentesPatologicosFamiliares"],
        antecedentesPatologicosPersonales:
            json["antecedentesPatologicosPersonales"] == null
                ? ""
                : json["antecedentesPatologicosPersonales"],
        antecedentesNoPatologicosFamiliares:
            json["antecedentesNoPatologicosFamiliares"] == null
                ? ""
                : json["antecedentesNoPatologicosFamiliares"],
        antecedentesNoPatologicosPersonales:
            json["antecedentesNoPatologicosPersonales"] == null
                ? ""
                : json["antecedentesNoPatologicosPersonales"],
        antecedentesInmunoAlergicosPersonales:
            json["antecedentesInmunoAlergicosPersonales"] == null
                ? ""
                : json["antecedentesInmunoAlergicosPersonales"],
        activo: json["activo"],
        creadoPor: json["creadoPor"],
        creadoFecha: DateTime.parse(json["creadoFecha"]),
        modificadoPor: json["modificadoPor"],
        modificadoFecha: DateTime.parse(json["modificadoFecha"]),
        notas: json["notas"] == null ? "" : json["notas"],
      );

  Map<String, dynamic> toJson() => {
        "antecedentesFamiliaresPersonalesId":
            antecedentesFamiliaresPersonalesId,
        "pacienteId": pacienteId,
        "preclinicaId": preclinicaId,
        "antecedentesPatologicosFamiliares": antecedentesPatologicosFamiliares,
        "antecedentesPatologicosPersonales": antecedentesPatologicosPersonales,
        "antecedentesNoPatologicosFamiliares":
            antecedentesNoPatologicosFamiliares,
        "antecedentesNoPatologicosPersonales":
            antecedentesNoPatologicosPersonales,
        "antecedentesInmunoAlergicosPersonales":
            antecedentesInmunoAlergicosPersonales,
        "activo": activo,
        "creadoPor": creadoPor,
        "creadoFecha": creadoFecha.toIso8601String(),
        "modificadoPor": modificadoPor,
        "modificadoFecha": modificadoFecha.toIso8601String(),
        "notas": notas,
      };
}
