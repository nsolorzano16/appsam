import 'dart:convert';

Diagnosticos consultaFromJson(String str) =>
    Diagnosticos.fromJson(json.decode(str));

String consultaToJson(Diagnosticos data) => json.encode(data.toJson());

class Diagnosticos {
  int diagnosticoId;
  int pacienteId;
  int doctorId;
  String problemasClinicos;
  bool activo;
  String creadoPor;
  DateTime creadoFecha;
  String modificadoPor;
  DateTime modificadoFecha;
  String notas;
  int notaId;
  String descripcion;

  Diagnosticos({
    this.diagnosticoId,
    this.pacienteId,
    this.doctorId,
    this.problemasClinicos,
    this.activo,
    this.creadoPor,
    this.creadoFecha,
    this.modificadoPor,
    this.modificadoFecha,
    this.notas,
    this.notaId,
    this.descripcion,
  });

  factory Diagnosticos.fromJson(Map<String, dynamic> json) => Diagnosticos(
        diagnosticoId:
            json["diagnosticoId"] == null ? null : json["diagnosticoId"],
        pacienteId: json["pacienteId"],
        doctorId: json["doctorId"],
        problemasClinicos: json["problemasClinicos"] == null
            ? null
            : json["problemasClinicos"],
        activo: json["activo"],
        creadoPor: json["creadoPor"],
        creadoFecha: DateTime.parse(json["creadoFecha"]),
        modificadoPor: json["modificadoPor"],
        modificadoFecha: DateTime.parse(json["modificadoFecha"]),
        notas: json["notas"],
        notaId: json["notaId"] == null ? null : json["notaId"],
        descripcion: json["descripcion"] == null ? null : json["descripcion"],
      );

  Map<String, dynamic> toJson() => {
        "diagnosticoId": diagnosticoId == null ? null : diagnosticoId,
        "pacienteId": pacienteId,
        "doctorId": doctorId,
        "problemasClinicos":
            problemasClinicos == null ? null : problemasClinicos,
        "activo": activo,
        "creadoPor": creadoPor,
        "creadoFecha": creadoFecha.toIso8601String(),
        "modificadoPor": modificadoPor,
        "modificadoFecha": modificadoFecha.toIso8601String(),
        "notas": notas,
        "notaId": notaId == null ? null : notaId,
        "descripcion": descripcion == null ? null : descripcion,
      };
}
