// To parse this JSON data, do
//
//     final preclinicaPaginadoViewModel = preclinicaPaginadoViewModelFromJson(jsonString);

import 'dart:convert';

PreclinicaPaginadoViewModel preclinicaPaginadoViewModelFromJson(String str) =>
    PreclinicaPaginadoViewModel.fromJson(json.decode(str));

String preclinicaPaginadoViewModelToJson(PreclinicaPaginadoViewModel data) =>
    json.encode(data.toJson());

PreclinicaViewModel preclinicaViewModelFromJson(String str) =>
    PreclinicaViewModel.fromJson(json.decode(str));

String preclinicaViewModelToJson(PreclinicaViewModel data) =>
    json.encode(data.toJson());

class PreclinicaPaginadoViewModel {
  int totalItems;
  int totalPages;
  int currentPage;
  int itemCount;
  List<PreclinicaViewModel> items;

  PreclinicaPaginadoViewModel({
    this.totalItems,
    this.totalPages,
    this.currentPage,
    this.itemCount,
    this.items,
  });

  factory PreclinicaPaginadoViewModel.fromJson(Map<String, dynamic> json) =>
      PreclinicaPaginadoViewModel(
        totalItems: json["totalItems"],
        totalPages: json["totalPages"],
        currentPage: json["currentPage"],
        itemCount: json["itemCount"],
        items: List<PreclinicaViewModel>.from(
            json["items"].map((x) => PreclinicaViewModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "totalItems": totalItems,
        "totalPages": totalPages,
        "currentPage": currentPage,
        "itemCount": itemCount,
        "items": List<dynamic>.from(items.map((x) => x.toJson())),
      };
}

class PreclinicaViewModel {
  int preclinicaId;
  int pacienteId;
  String doctorId;
  double peso;
  double altura;
  double temperatura;
  int frecuenciaRespiratoria;
  int ritmoCardiaco;
  int presionSistolica;
  int presionDiastolica;
  double imc;
  bool atendida;
  dynamic pesoDescripcion;
  String nombres;
  String primerApellido;
  String segundoApellido;
  String identificacion;
  dynamic email;
  String sexo;
  DateTime fechaNacimiento;
  String estadoCivil;
  int edad;
  bool menorDeEdad;
  String nombreMadre;
  String identificacionMadre;
  String nombrePadre;
  String identificacionPadre;
  String carneVacuna;
  String fotoUrl;
  String notasPaciente;
  bool activo;
  String creadoPor;
  DateTime creadoFecha;
  String modificadoPor;
  DateTime modificadoFecha;
  String notas;

  PreclinicaViewModel({
    this.preclinicaId,
    this.pacienteId,
    this.doctorId,
    this.peso,
    this.altura,
    this.temperatura,
    this.frecuenciaRespiratoria,
    this.ritmoCardiaco,
    this.presionSistolica,
    this.presionDiastolica,
    this.imc,
    this.atendida,
    this.pesoDescripcion,
    this.nombres,
    this.primerApellido,
    this.segundoApellido,
    this.identificacion,
    this.email,
    this.sexo,
    this.fechaNacimiento,
    this.estadoCivil,
    this.edad,
    this.menorDeEdad,
    this.nombreMadre,
    this.identificacionMadre,
    this.nombrePadre,
    this.identificacionPadre,
    this.carneVacuna,
    this.fotoUrl,
    this.notasPaciente,
    this.activo,
    this.creadoPor,
    this.creadoFecha,
    this.modificadoPor,
    this.modificadoFecha,
    this.notas,
  });

  factory PreclinicaViewModel.fromJson(Map<String, dynamic> json) =>
      PreclinicaViewModel(
        preclinicaId: json["preclinicaId"],
        pacienteId: json["pacienteId"],
        doctorId: json["doctorId"],
        peso: json["peso"].toDouble(),
        altura: json["altura"].toDouble(),
        temperatura: json["temperatura"].toDouble(),
        frecuenciaRespiratoria: json["frecuenciaRespiratoria"],
        ritmoCardiaco: json["ritmoCardiaco"],
        presionSistolica: json["presionSistolica"],
        presionDiastolica: json["presionDiastolica"],
        imc: json["imc"].toDouble(),
        atendida: json["atendida"],
        pesoDescripcion:
            json["pesoDescripcion"] == null ? "" : json["pesoDescripcion"],
        nombres: json["nombres"] == null ? "" : json["nombres"],
        primerApellido:
            json["primerApellido"] == null ? "" : json["primerApellido"],
        segundoApellido:
            json["segundoApellido"] == null ? "" : json["segundoApellido"],
        identificacion:
            json["identificacion"] == null ? "" : json["identificacion"],
        email: json["email"] == null ? "" : json["email"],
        sexo: json["sexo"],
        fechaNacimiento: DateTime.parse(json["fechaNacimiento"]),
        estadoCivil: json["estadoCivil"] == null ? "" : json["estadoCivil"],
        edad: json["edad"],
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
        notasPaciente:
            json["notasPaciente"] == null ? "" : json["notasPaciente"],
        activo: json["activo"],
        creadoPor: json["creadoPor"],
        creadoFecha: DateTime.parse(json["creadoFecha"]),
        modificadoPor: json["modificadoPor"],
        modificadoFecha: DateTime.parse(json["modificadoFecha"]),
        notas: json["notas"] == null ? null : json["notas"],
      );

  Map<String, dynamic> toJson() => {
        "preclinicaId": preclinicaId,
        "pacienteId": pacienteId,
        "doctorId": doctorId,
        "peso": peso,
        "altura": altura,
        "temperatura": temperatura,
        "frecuenciaRespiratoria": frecuenciaRespiratoria,
        "ritmoCardiaco": ritmoCardiaco,
        "presionSistolica": presionSistolica,
        "presionDiastolica": presionDiastolica,
        "imc": imc,
        "atendida": atendida,
        "pesoDescripcion": pesoDescripcion,
        "nombres": nombres,
        "primerApellido": primerApellido,
        "segundoApellido": segundoApellido,
        "identificacion": identificacion,
        "email": email,
        "sexo": sexo,
        "fechaNacimiento": fechaNacimiento.toIso8601String(),
        "estadoCivil": estadoCivil,
        "edad": edad,
        "menorDeEdad": menorDeEdad,
        "nombreMadre": nombreMadre,
        "identificacionMadre": identificacionMadre,
        "nombrePadre": nombrePadre,
        "identificacionPadre": identificacionPadre,
        "carneVacuna": carneVacuna,
        "fotoUrl": fotoUrl,
        "notasPaciente": notasPaciente,
        "activo": activo,
        "creadoPor": creadoPor,
        "creadoFecha": creadoFecha.toIso8601String(),
        "modificadoPor": modificadoPor,
        "modificadoFecha": modificadoFecha.toIso8601String(),
        "notas": notas == null ? null : notas,
      };
}
