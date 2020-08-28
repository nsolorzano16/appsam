import 'dart:convert';

Diagnosticos diagnosticosFromJson(String str) =>
    Diagnosticos.fromJson(json.decode(str));

String diagnosticosToJson(Diagnosticos data) => json.encode(data.toJson());

String diagnosticosToJsonList(List<Diagnosticos> data) => json.encode(data);

class Diagnosticos {
  Diagnosticos({
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

  factory Diagnosticos.fromJson(Map<String, dynamic> json) => Diagnosticos(
        diagnosticoId:
            json["diagnosticoId"] == null ? null : json["diagnosticoId"],
        pacienteId: json["pacienteId"],
        doctorId: json["doctorId"],
        cieId: json["cieId"],
        preclinicaId: json["preclinicaId"],
        problemasClinicos:
            json["problemasClinicos"] == null ? '' : json["problemasClinicos"],
        activo: json["activo"],
        creadoPor: json["creadoPor"],
        creadoFecha: DateTime.parse(json["creadoFecha"]),
        modificadoPor: json["modificadoPor"],
        modificadoFecha: DateTime.parse(json["modificadoFecha"]),
        notas: json["notas"] == null ? "" : json["notas"],
      );

  Map<String, dynamic> toJson() => {
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
