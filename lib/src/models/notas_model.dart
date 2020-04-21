import 'dart:convert';

Notas notasFromJson(String str) => Notas.fromJson(json.decode(str));

String notasToJson(Notas data) => json.encode(data.toJson());

String notasToJsonList(List<Notas> data) => json.encode(data);

class Notas {
  int notaId;
  int pacienteId;
  int doctorId;
  int preclinicaId;
  bool activo;
  String creadoPor;
  DateTime creadoFecha;
  String modificadoPor;
  DateTime modificadoFecha;
  String notas;

  Notas({
    this.notaId,
    this.pacienteId,
    this.doctorId,
    this.preclinicaId,
    this.activo,
    this.creadoPor,
    this.creadoFecha,
    this.modificadoPor,
    this.modificadoFecha,
    this.notas,
  });

  factory Notas.fromJson(Map<String, dynamic> json) => Notas(
        notaId: json["notaId"] == null ? null : json["notaId"],
        pacienteId: json["pacienteId"],
        doctorId: json["doctorId"],
        preclinicaId: json["preclinicaId"],
        activo: json["activo"],
        creadoPor: json["creadoPor"],
        creadoFecha: DateTime.parse(json["creadoFecha"]),
        modificadoPor: json["modificadoPor"],
        modificadoFecha: DateTime.parse(json["modificadoFecha"]),
        notas: json["notas"],
      );

  Map<String, dynamic> toJson() => {
        "notaId": notaId == null ? null : notaId,
        "pacienteId": pacienteId,
        "doctorId": doctorId,
        "preclinicaId": preclinicaId,
        "activo": activo,
        "creadoPor": creadoPor,
        "creadoFecha": creadoFecha.toIso8601String(),
        "modificadoPor": modificadoPor,
        "modificadoFecha": modificadoFecha.toIso8601String(),
        "notas": notas,
      };
}
