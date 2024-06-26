// To parse this JSON data, do
//
//     final pacientesPaginadoModel = pacientesPaginadoModelFromJson(jsonString);

import 'dart:convert';

PacientesPaginadoModel pacientesPaginadoModelFromJson(String str) =>
    PacientesPaginadoModel.fromJson(json.decode(str));

String pacientesPaginadoModelToJson(PacientesPaginadoModel data) =>
    json.encode(data.toJson());

PacientesViewModel pacientesViewModelFromJson(String str) =>
    PacientesViewModel.fromJson(json.decode(str));

String pacientesViewModelToJson(PacientesViewModel data) =>
    json.encode(data.toJson());

class PacientesPaginadoModel {
  int totalItems;
  int totalPages;
  int currentPage;
  int itemCount;
  List<PacientesViewModel> items;

  PacientesPaginadoModel({
    this.totalItems,
    this.totalPages,
    this.currentPage,
    this.itemCount,
    this.items,
  });

  factory PacientesPaginadoModel.fromJson(Map<String, dynamic> json) =>
      PacientesPaginadoModel(
        totalItems: json["totalItems"],
        totalPages: json["totalPages"],
        currentPage: json["currentPage"],
        itemCount: json["itemCount"],
        items: List<PacientesViewModel>.from(
            json["items"].map((x) => PacientesViewModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "totalItems": totalItems,
        "totalPages": totalPages,
        "currentPage": currentPage,
        "itemCount": itemCount,
        "items": List<dynamic>.from(items.map((x) => x.toJson())),
      };
}

class PacientesViewModel {
  int pacienteId;

  int paisId;
  int profesionId;
  int escolaridadId;
  int religionId;
  int grupoSanguineoId;
  int grupoEtnicoId;
  int departamentoId;
  int municipioId;
  int departamentoResidenciaId;
  int municipioResidenciaId;
  String nombres;
  String primerApellido;
  String segundoApellido;
  String identificacion;
  dynamic email;
  String sexo;
  DateTime fechaNacimiento;
  String estadoCivil;
  int edad;
  String direccion;
  String telefono1;
  dynamic telefono2;
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
  String pais;
  String profesion;
  String escolaridad;
  String religion;
  String grupoSanguineo;
  String grupoEtnico;
  String departamento;
  String municipio;
  String departamentoResidencia;
  String municipioResidencia;
  int preclinicasPendientes;
  bool activo;
  String creadoPor;
  DateTime creadoFecha;
  String modificadoPor;
  DateTime modificadoFecha;
  String notas;

  PacientesViewModel({
    this.pacienteId,
    this.paisId,
    this.profesionId,
    this.escolaridadId,
    this.religionId,
    this.grupoSanguineoId,
    this.grupoEtnicoId,
    this.departamentoId,
    this.municipioId,
    this.departamentoResidenciaId,
    this.municipioResidenciaId,
    this.nombres,
    this.primerApellido,
    this.segundoApellido,
    this.identificacion,
    this.email,
    this.sexo,
    this.fechaNacimiento,
    this.estadoCivil,
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
    this.pais,
    this.profesion,
    this.escolaridad,
    this.religion,
    this.grupoSanguineo,
    this.grupoEtnico,
    this.departamento,
    this.municipio,
    this.departamentoResidencia,
    this.municipioResidencia,
    this.preclinicasPendientes,
    this.activo,
    this.creadoPor,
    this.creadoFecha,
    this.modificadoPor,
    this.modificadoFecha,
    this.notas,
  });

  factory PacientesViewModel.fromJson(Map<String, dynamic> json) =>
      PacientesViewModel(
        pacienteId: json["pacienteId"],
        paisId: json["paisId"],
        profesionId: json["profesionId"],
        escolaridadId: json["escolaridadId"],
        religionId: json["religionId"],
        grupoSanguineoId: json["grupoSanguineoId"],
        grupoEtnicoId: json["grupoEtnicoId"],
        departamentoId: json["departamentoId"],
        municipioId: json["municipioId"],
        departamentoResidenciaId: json["departamentoResidenciaId"],
        municipioResidenciaId: json["municipioResidenciaId"],
        nombres: json["nombres"],
        primerApellido: json["primerApellido"],
        segundoApellido: json["segundoApellido"],
        identificacion:
            json["identificacion"] == null ? "" : json["identificacion"],
        email: json["email"] == null ? "" : json["email"],
        sexo: json["sexo"],
        fechaNacimiento: DateTime.parse(json["fechaNacimiento"]),
        estadoCivil: json["estadoCivil"],
        edad: json["edad"],
        direccion: json["direccion"] == null ? "" : json["direccion"],
        telefono1: json["telefono1"] == null ? "" : json["telefono1"],
        telefono2: json["telefono2"] == null ? "" : json["telefono2"],
        nombreEmergencia:
            json["nombreEmergencia"] == null ? "" : json["nombreEmergencia"],
        telefonoEmergencia: json["telefonoEmergencia"] == null
            ? ""
            : json["telefonoEmergencia"],
        parentesco: json["parentesco"] == null ? "" : json["parentesco"],
        menorDeEdad: json["menorDeEdad"],
        nombreMadre: json["nombreMadre"] == null ? "" : json["nombreMadre"],
        identificacionMadre: json["identificacionMadre"] == null
            ? ""
            : json["identificacionMadre"],
        nombrePadre: json["nombrePadre"] == null ? "" : json["nombrePadre"],
        identificacionPadre: json["identificacionPadre"] == null
            ? ""
            : json["identificacionPadre"],
        carneVacuna: json["carneVacuna"] == null ? "" : json["carneVacuna"],
        fotoUrl: json["fotoUrl"],
        pais: json["pais"] == null ? "" : json["pais"],
        profesion: json["profesion"] == null ? "" : json["profesion"],
        escolaridad: json["escolaridad"] == null ? "" : json["escolaridad"],
        religion: json["religion"] == null ? "" : json["religion"],
        grupoSanguineo:
            json["grupoSanguineo"] == null ? "" : json["grupoSanguineo"],
        grupoEtnico: json["grupoEtnico"] == null ? "" : json["grupoEtnico"],
        departamento: json["departamento"] == null ? "" : json["departamento"],
        municipio: json["municipio"] == null ? "" : json["municipio"],
        departamentoResidencia: json["departamentoResidencia"] == null
            ? ""
            : json["departamentoResidencia"],
        municipioResidencia: json["municipioResidencia"] == null
            ? ""
            : json["municipioResidencia"],
        preclinicasPendientes: json["preclinicasPendientes"],
        activo: json["activo"],
        creadoPor: json["creadoPor"],
        creadoFecha: DateTime.parse(json["creadoFecha"]),
        modificadoPor: json["modificadoPor"],
        modificadoFecha: DateTime.parse(json["modificadoFecha"]),
        notas: json["notas"] == null ? "" : json["notas"],
      );

  Map<String, dynamic> toJson() => {
        "pacienteId": pacienteId,
        "paisId": paisId,
        "profesionId": profesionId,
        "escolaridadId": escolaridadId,
        "religionId": religionId,
        "grupoSanguineoId": grupoSanguineoId,
        "grupoEtnicoId": grupoEtnicoId,
        "departamentoId": departamentoId,
        "municipioId": municipioId,
        "departamentoResidenciaId": departamentoResidenciaId,
        "municipioResidenciaId": municipioResidenciaId,
        "nombres": nombres,
        "primerApellido": primerApellido,
        "segundoApellido": segundoApellido,
        "identificacion": identificacion,
        "email": email,
        "sexo": sexo,
        "fechaNacimiento": fechaNacimiento.toIso8601String(),
        "estadoCivil": estadoCivil,
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
        "pais": pais,
        "profesion": profesion,
        "escolaridad": escolaridad,
        "religion": religion,
        "grupoSanguineo": grupoSanguineo,
        "grupoEtnico": grupoEtnico,
        "departamento": departamento,
        "municipio": municipio,
        "departamentoResidencia": departamentoResidencia,
        "municipioResidencia": municipioResidencia,
        "preclinicasPendientes": preclinicasPendientes,
        "activo": activo,
        "creadoPor": creadoPor,
        "creadoFecha": creadoFecha.toIso8601String(),
        "modificadoPor": modificadoPor,
        "modificadoFecha": modificadoFecha.toIso8601String(),
        "notas": notas,
      };
}
