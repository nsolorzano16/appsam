import 'dart:convert';

ExamenFisicoGinecologico examenFisicoGinecologicoFromJson(String str) =>
    ExamenFisicoGinecologico.fromJson(json.decode(str));

String examenFisicoGinecologicoToJson(ExamenFisicoGinecologico data) =>
    json.encode(data.toJson());

class ExamenFisicoGinecologico {
  int examenId;
  int pacienteId;
  int doctorId;
  String afu;
  String pelvis;
  String dorso;
  String fcf;
  String ap;
  bool activo;
  String creadoPor;
  DateTime creadoFecha;
  String modificadoPor;
  DateTime modificadoFecha;
  String notas;

  ExamenFisicoGinecologico({
    this.examenId,
    this.pacienteId,
    this.doctorId,
    this.afu,
    this.pelvis,
    this.dorso,
    this.fcf,
    this.ap,
    this.activo,
    this.creadoPor,
    this.creadoFecha,
    this.modificadoPor,
    this.modificadoFecha,
    this.notas,
  });

  factory ExamenFisicoGinecologico.fromJson(Map<String, dynamic> json) =>
      ExamenFisicoGinecologico(
        examenId: json["examenId"],
        pacienteId: json["pacienteId"],
        doctorId: json["doctorId"],
        afu: json["afu"],
        pelvis: json["pelvis"],
        dorso: json["dorso"],
        fcf: json["fcf"],
        ap: json["ap"],
        activo: json["activo"],
        creadoPor: json["creadoPor"],
        creadoFecha: DateTime.parse(json["creadoFecha"]),
        modificadoPor: json["modificadoPor"],
        modificadoFecha: DateTime.parse(json["modificadoFecha"]),
        notas: json["notas"],
      );

  Map<String, dynamic> toJson() => {
        "examenId": examenId,
        "pacienteId": pacienteId,
        "doctorId": doctorId,
        "afu": afu,
        "pelvis": pelvis,
        "dorso": dorso,
        "fcf": fcf,
        "ap": ap,
        "activo": activo,
        "creadoPor": creadoPor,
        "creadoFecha": creadoFecha.toIso8601String(),
        "modificadoPor": modificadoPor,
        "modificadoFecha": modificadoFecha.toIso8601String(),
        "notas": notas,
      };
}
