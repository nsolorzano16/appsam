import 'dart:convert';

Notas notasFromJson(String str) => Notas.fromJson(json.decode(str));

String notasToJson(Notas data) => json.encode(data.toJson());

class Notas {
  int diagnosticoId;
  int pacienteId;
  int doctorId;

  bool activo;
  String creadoPor;
  DateTime creadoFecha;
  String modificadoPor;
  DateTime modificadoFecha;
  String notas;

  Notas({
    this.diagnosticoId,
    this.pacienteId,
    this.doctorId,
    this.activo,
    this.creadoPor,
    this.creadoFecha,
    this.modificadoPor,
    this.modificadoFecha,
    this.notas,
  });

  factory Notas.fromJson(Map<String, dynamic> json) => Notas(
        diagnosticoId:
            json["diagnosticoId"] == null ? null : json["diagnosticoId"],
        pacienteId: json["pacienteId"],
        doctorId: json["doctorId"],
        activo: json["activo"],
        creadoPor: json["creadoPor"],
        creadoFecha: DateTime.parse(json["creadoFecha"]),
        modificadoPor: json["modificadoPor"],
        modificadoFecha: DateTime.parse(json["modificadoFecha"]),
        notas: json["notas"],
      );

  Map<String, dynamic> toJson() => {
        "diagnosticoId": diagnosticoId == null ? null : diagnosticoId,
        "pacienteId": pacienteId,
        "doctorId": doctorId,
        "activo": activo,
        "creadoPor": creadoPor,
        "creadoFecha": creadoFecha.toIso8601String(),
        "modificadoPor": modificadoPor,
        "modificadoFecha": modificadoFecha.toIso8601String(),
        "notas": notas,
      };
}
