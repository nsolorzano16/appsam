import 'dart:convert';

FarmacosUsoActual consultaFromJson(String str) =>
    FarmacosUsoActual.fromJson(json.decode(str));

String consultaToJson(FarmacosUsoActual data) => json.encode(data.toJson());

class FarmacosUsoActual {
  int farmacoId;
  int pacienteId;
  int doctorId;
  String nombre;
  String concentracion;
  String dosis;
  String tiempo;
  bool activo;
  String creadoPor;
  DateTime creadoFecha;
  String modificadoPor;
  DateTime modificadoFecha;
  String notas;

  FarmacosUsoActual({
    this.farmacoId,
    this.pacienteId,
    this.doctorId,
    this.nombre,
    this.concentracion,
    this.dosis,
    this.tiempo,
    this.activo,
    this.creadoPor,
    this.creadoFecha,
    this.modificadoPor,
    this.modificadoFecha,
    this.notas,
  });

  factory FarmacosUsoActual.fromJson(Map<String, dynamic> json) =>
      FarmacosUsoActual(
        farmacoId: json["farmacoId"],
        pacienteId: json["pacienteId"],
        doctorId: json["doctorId"],
        nombre: json["nombre"],
        concentracion: json["concentracion"],
        dosis: json["dosis"],
        tiempo: json["tiempo"],
        activo: json["activo"],
        creadoPor: json["creadoPor"],
        creadoFecha: DateTime.parse(json["creadoFecha"]),
        modificadoPor: json["modificadoPor"],
        modificadoFecha: DateTime.parse(json["modificadoFecha"]),
        notas: json["notas"],
      );

  Map<String, dynamic> toJson() => {
        "farmacoId": farmacoId,
        "pacienteId": pacienteId,
        "doctorId": doctorId,
        "nombre": nombre,
        "concentracion": concentracion,
        "dosis": dosis,
        "tiempo": tiempo,
        "activo": activo,
        "creadoPor": creadoPor,
        "creadoFecha": creadoFecha.toIso8601String(),
        "modificadoPor": modificadoPor,
        "modificadoFecha": modificadoFecha.toIso8601String(),
        "notas": notas,
      };
}
