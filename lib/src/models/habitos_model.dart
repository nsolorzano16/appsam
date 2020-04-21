import 'dart:convert';

Habitos habitosFromJson(String str) => Habitos.fromJson(json.decode(str));

String habitosToJson(Habitos data) => json.encode(data.toJson());

class Habitos {
  int habitoId;
  int pacienteId;
  int doctorId;
  int preclinicaId;
  bool cafe;
  bool cigarrillo;
  int tazasCafe;
  int cantidadCigarrillo;
  bool activo;
  String creadoPor;
  DateTime creadoFecha;
  String modificadoPor;
  DateTime modificadoFecha;
  String notas;

  Habitos({
    this.habitoId,
    this.pacienteId,
    this.doctorId,
    this.preclinicaId,
    this.cafe,
    this.cigarrillo,
    this.tazasCafe,
    this.cantidadCigarrillo,
    this.activo,
    this.creadoPor,
    this.creadoFecha,
    this.modificadoPor,
    this.modificadoFecha,
    this.notas,
  });

  factory Habitos.fromJson(Map<String, dynamic> json) => Habitos(
        habitoId: json["habitoId"],
        pacienteId: json["pacienteId"],
        doctorId: json["doctorId"],
        preclinicaId: json["preclinicaId"],
        cafe: json["cafe"],
        cigarrillo: json["cigarrillo"],
        tazasCafe: json["tazasCafe"],
        cantidadCigarrillo: json["cantidadCigarrillo"],
        activo: json["activo"],
        creadoPor: json["creadoPor"],
        creadoFecha: DateTime.parse(json["creadoFecha"]),
        modificadoPor: json["modificadoPor"],
        modificadoFecha: DateTime.parse(json["modificadoFecha"]),
        notas: json["notas"],
      );

  Map<String, dynamic> toJson() => {
        "habitoId": habitoId,
        "pacienteId": pacienteId,
        "doctorId": doctorId,
        "preclinicaId": preclinicaId,
        "cafe": cafe,
        "cigarrillo": cigarrillo,
        "tazasCafe": tazasCafe,
        "cantidadCigarrillo": cantidadCigarrillo,
        "activo": activo,
        "creadoPor": creadoPor,
        "creadoFecha": creadoFecha.toIso8601String(),
        "modificadoPor": modificadoPor,
        "modificadoFecha": modificadoFecha.toIso8601String(),
        "notas": notas,
      };
}
