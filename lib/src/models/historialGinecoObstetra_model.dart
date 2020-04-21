import 'dart:convert';

HistorialGinecoObstetra historialGinecoObstetraFromJson(String str) =>
    HistorialGinecoObstetra.fromJson(json.decode(str));

String historialGinecoObstetraToJson(HistorialGinecoObstetra data) =>
    json.encode(data.toJson());

class HistorialGinecoObstetra {
  int historialId;
  int pacienteId;
  int doctorId;
  int preclinicaId;
  DateTime menarquia;
  DateTime fur;
  String sg;
  String g;
  String p;
  String c;
  String hv;
  String fpp;
  String uc;
  DateTime fechaMenopausia;
  String anticonceptivo;
  String vacunacion;
  bool activo;
  String creadoPor;
  DateTime creadoFecha;
  String modificadoPor;
  DateTime modificadoFecha;
  String notas;

  HistorialGinecoObstetra({
    this.historialId,
    this.pacienteId,
    this.doctorId,
    this.preclinicaId,
    this.menarquia,
    this.fur,
    this.sg,
    this.g,
    this.p,
    this.c,
    this.hv,
    this.fpp,
    this.uc,
    this.fechaMenopausia,
    this.anticonceptivo,
    this.vacunacion,
    this.activo,
    this.creadoPor,
    this.creadoFecha,
    this.modificadoPor,
    this.modificadoFecha,
    this.notas,
  });

  factory HistorialGinecoObstetra.fromJson(Map<String, dynamic> json) =>
      HistorialGinecoObstetra(
        historialId: json["historialId"],
        pacienteId: json["pacienteId"],
        doctorId: json["doctorId"],
        preclinicaId: json["preclinicaId"],
        menarquia: json["menarquia"] == null
            ? null
            : DateTime.parse(json["menarquia"]),
        fur: json["fur"] == null ? null : DateTime.parse(json["fur"]),
        sg: json["sg"],
        g: json["g"],
        p: json["p"],
        c: json["c"],
        hv: json["hv"],
        fpp: json["fpp"],
        uc: json["uc"],
        fechaMenopausia: json["fechaMenopausia"] == null
            ? null
            : DateTime.parse(json["fechaMenopausia"]),
        anticonceptivo: json["anticonceptivo"],
        vacunacion: json["vacunacion"],
        activo: json["activo"],
        creadoPor: json["creadoPor"],
        creadoFecha: DateTime.parse(json["creadoFecha"]),
        modificadoPor: json["modificadoPor"],
        modificadoFecha: DateTime.parse(json["modificadoFecha"]),
        notas: json["notas"],
      );

  Map<String, dynamic> toJson() => {
        "historialId": historialId,
        "pacienteId": pacienteId,
        "doctorId": doctorId,
        "preclinicaId": preclinicaId,
        "menarquia": menarquia == null ? null : menarquia.toIso8601String(),
        "fur": fur == null ? null : fur.toIso8601String(),
        "sg": sg,
        "g": g,
        "p": p,
        "c": c,
        "hv": hv,
        "fpp": fpp,
        "uc": uc,
        "fechaMenopausia":
            fechaMenopausia == null ? null : fechaMenopausia.toIso8601String(),
        "anticonceptivo": anticonceptivo,
        "vacunacion": vacunacion,
        "activo": activo,
        "creadoPor": creadoPor,
        "creadoFecha": creadoFecha.toIso8601String(),
        "modificadoPor": modificadoPor,
        "modificadoFecha": modificadoFecha.toIso8601String(),
        "notas": notas,
      };
}
