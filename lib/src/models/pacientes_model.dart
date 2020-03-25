// To parse this JSON data, do
//
//     final pacienteModel = pacienteModelFromJson(jsonString);

import 'dart:convert';

PacienteModel pacienteModelFromJson(String str) =>
    PacienteModel.fromJson(json.decode(str));

String pacienteModelToJson(PacienteModel data) => json.encode(data.toJson());

class PacienteModel {
  int pacienteId;
  int doctorId;
  int paisId;
  int profesionId;
  int escolaridadId;
  int religionId;
  int grupoSanguineoId;
  int grupoEtnicoId;
  int departamentoId;
  int municipioId;
  String nombres;
  String primerApellido;
  String segundoApellido;
  String identificacion;
  String email;
  String sexo;
  DateTime fechaNacimiento;
  String estadoCivil;
  String tipoDeSangre;
  String lugarNacimiento;
  int edad;
  String direccion;
  String telefono1;
  String telefono2;
  String nombreEmergencia;
  String telefonoEmergencia;
  String parentesco;
  bool menorDeEdad;
  String nombreMadre;
  String identificacionMadre;
  String nombrePadre;
  String identificacionPadre;
  String carneVacuna;
  String fotoUrl;
  bool activo;
  String creadoPor;
  DateTime creadoFecha;
  String modificadoPor;
  DateTime modificadoFecha;
  String notas;

  PacienteModel({
    this.pacienteId,
    this.doctorId,
    this.paisId,
    this.profesionId,
    this.escolaridadId,
    this.religionId,
    this.grupoSanguineoId,
    this.grupoEtnicoId,
    this.departamentoId,
    this.municipioId,
    this.nombres,
    this.primerApellido,
    this.segundoApellido,
    this.identificacion,
    this.email,
    this.sexo,
    this.fechaNacimiento,
    this.estadoCivil,
    this.tipoDeSangre,
    this.lugarNacimiento,
    this.edad,
    this.direccion,
    this.telefono1,
    this.telefono2,
    this.nombreEmergencia,
    this.telefonoEmergencia,
    this.parentesco,
    this.menorDeEdad,
    this.nombreMadre,
    this.identificacionMadre,
    this.nombrePadre,
    this.identificacionPadre,
    this.carneVacuna,
    this.fotoUrl,
    this.activo,
    this.creadoPor,
    this.creadoFecha,
    this.modificadoPor,
    this.modificadoFecha,
    this.notas,
  });

  factory PacienteModel.fromJson(Map<String, dynamic> json) => PacienteModel(
        pacienteId: json["pacienteId"],
        doctorId: json["doctorId"],
        paisId: json["paisId"],
        profesionId: json["profesionId"],
        escolaridadId: json["escolaridadId"],
        religionId: json["religionId"],
        grupoSanguineoId: json["grupoSanguineoId"],
        grupoEtnicoId: json["grupoEtnicoId"],
        departamentoId: json["departamentoId"],
        municipioId: json["municipioId"],
        nombres: json["nombres"],
        primerApellido: json["primerApellido"],
        segundoApellido: json["segundoApellido"],
        identificacion: json["identificacion"],
        email: json["email"],
        sexo: json["sexo"],
        fechaNacimiento: DateTime.parse(json["fechaNacimiento"]),
        estadoCivil: json["estadoCivil"],
        tipoDeSangre: json["tipoDeSangre"],
        lugarNacimiento: json["lugarNacimiento"],
        edad: json["edad"],
        direccion: json["direccion"],
        telefono1: json["telefono1"],
        telefono2: json["telefono2"],
        nombreEmergencia: json["nombreEmergencia"],
        telefonoEmergencia: json["telefonoEmergencia"],
        parentesco: json["parentesco"],
        menorDeEdad: json["menorDeEdad"],
        nombreMadre: json["nombreMadre"],
        identificacionMadre: json["identificacionMadre"],
        nombrePadre: json["nombrePadre"],
        identificacionPadre: json["identificacionPadre"],
        carneVacuna: json["carneVacuna"],
        fotoUrl: json["fotoUrl"],
        activo: json["activo"],
        creadoPor: json["creadoPor"],
        creadoFecha: DateTime.parse(json["creadoFecha"]),
        modificadoPor: json["modificadoPor"],
        modificadoFecha: DateTime.parse(json["modificadoFecha"]),
        notas: json["notas"],
      );

  Map<String, dynamic> toJson() => {
        "pacienteId": pacienteId,
        "doctorId": doctorId,
        "paisId": paisId,
        "profesionId": profesionId,
        "escolaridadId": escolaridadId,
        "religionId": religionId,
        "grupoSanguineoId": grupoSanguineoId,
        "grupoEtnicoId": grupoEtnicoId,
        "departamentoId": departamentoId,
        "municipioId": municipioId,
        "nombres": nombres,
        "primerApellido": primerApellido,
        "segundoApellido": segundoApellido,
        "identificacion": identificacion,
        "email": email,
        "sexo": sexo,
        "fechaNacimiento": fechaNacimiento.toIso8601String(),
        "estadoCivil": estadoCivil,
        "tipoDeSangre": tipoDeSangre,
        "lugarNacimiento": lugarNacimiento,
        "edad": edad,
        "direccion": direccion,
        "telefono1": telefono1,
        "telefono2": telefono2,
        "nombreEmergencia": nombreEmergencia,
        "telefonoEmergencia": telefonoEmergencia,
        "parentesco": parentesco,
        "menorDeEdad": menorDeEdad,
        "nombreMadre": nombreMadre,
        "identificacionMadre": identificacionMadre,
        "nombrePadre": nombrePadre,
        "identificacionPadre": identificacionPadre,
        "carneVacuna": carneVacuna,
        "fotoUrl": fotoUrl,
        "activo": activo,
        "creadoPor": creadoPor,
        "creadoFecha": creadoFecha.toIso8601String(),
        "modificadoPor": modificadoPor,
        "modificadoFecha": modificadoFecha.toIso8601String(),
        "notas": notas,
      };
}
