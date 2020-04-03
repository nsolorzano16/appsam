import 'dart:convert';

Preclinica preclinicaromJson(String str) =>
    Preclinica.fromJson(json.decode(str));

String preclinicaToJson(Preclinica data) => json.encode(data.toJson());

class Preclinica {
  int preclinicaId;
  int pacienteId;
  int doctorId;
  int peso;
  double altura;
  int frecuenciaRespiratoria;
  int ritmoCardiaco;
  int presionSistolica;
  int presionDiastolica;
  double iMc;
  bool atendida;
  String pesoDescripcion;
  bool activo;
  String creadoPor;
  DateTime creadoFecha;
  String modificadoPor;
  DateTime modificadoFecha;
  String notas;

  Preclinica({
    this.preclinicaId,
    this.pacienteId,
    this.doctorId,
    this.peso,
    this.altura,
    this.frecuenciaRespiratoria,
    this.ritmoCardiaco,
    this.presionSistolica,
    this.presionDiastolica,
    this.iMc,
    this.atendida,
    this.pesoDescripcion,
    this.activo,
    this.creadoPor,
    this.creadoFecha,
    this.modificadoPor,
    this.modificadoFecha,
    this.notas,
  });

  factory Preclinica.fromJson(Map<String, dynamic> json) => Preclinica(
        preclinicaId: json["preclinicaId"],
        pacienteId: json["pacienteId"],
        doctorId: json["doctorId"],
        peso: json["peso"],
        altura: json["altura"].toDouble(),
        frecuenciaRespiratoria: json["frecuenciaRespiratoria"],
        ritmoCardiaco: json["ritmoCardiaco"],
        presionSistolica: json["presionSistolica"],
        presionDiastolica: json["presionDiastolica"],
        iMc: json["imc"].toDouble(),
        atendida: json["atendida"],
        pesoDescripcion: json["pesoDescripcion"],
        activo: json["activo"],
        creadoPor: json["creadoPor"],
        creadoFecha: DateTime.parse(json["creadoFecha"]),
        modificadoPor: json["modificadoPor"],
        modificadoFecha: DateTime.parse(json["modificadoFecha"]),
        notas: json["notas"],
      );

  Map<String, dynamic> toJson() => {
        "preclinicaId": preclinicaId,
        "pacienteId": pacienteId,
        "doctorId": doctorId,
        "peso": peso,
        "altura": altura,
        "frecuenciaRespiratoria": frecuenciaRespiratoria,
        "ritmoCardiaco": ritmoCardiaco,
        "presionSistolica": presionSistolica,
        "presionDiastolica": presionDiastolica,
        "iMc": iMc,
        "atendida": atendida,
        "pesoDescripcion": pesoDescripcion,
        "activo": activo,
        "creadoPor": creadoPor,
        "creadoFecha": creadoFecha.toIso8601String(),
        "modificadoPor": modificadoPor,
        "modificadoFecha": modificadoFecha.toIso8601String(),
        "notas": notas,
      };
}
