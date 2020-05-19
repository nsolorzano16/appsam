import 'dart:convert';

UsuarioModel usuarioModelFromJson(String str) =>
    UsuarioModel.fromJson(json.decode(str));

String usuarioModelToJson(UsuarioModel data) => json.encode(data.toJson());

class UsuarioModel {
  int usuarioId;
  int rolId;
  int asistenteId;
  String nombres;
  String primerApellido;
  String segundoApellido;
  String identificacion;
  DateTime fechaNacimiento;
  int edad;
  String sexo;
  String telefono1;
  String telefono2;
  String colegioNumero;
  String email;
  String userName;
  String password;
  String passwordSalt;
  String passwordHash;
  bool activo;
  String creadoPor;
  DateTime creadoFecha;
  String modificadoPor;
  DateTime modificadoFecha;
  String notas;
  String fotoUrl;
  String tokenDevice;

  UsuarioModel({
    this.usuarioId,
    this.rolId,
    this.asistenteId,
    this.nombres,
    this.primerApellido,
    this.segundoApellido,
    this.identificacion,
    this.fechaNacimiento,
    this.edad,
    this.sexo,
    this.telefono1,
    this.telefono2,
    this.colegioNumero,
    this.email,
    this.userName,
    this.password,
    this.passwordSalt,
    this.passwordHash,
    this.activo,
    this.creadoPor,
    this.creadoFecha,
    this.modificadoPor,
    this.modificadoFecha,
    this.notas,
    this.fotoUrl,
    this.tokenDevice,
  });

  factory UsuarioModel.fromJson(Map<String, dynamic> json) => UsuarioModel(
      usuarioId: json["usuarioId"],
      rolId: json["rolId"],
      asistenteId: json["asistenteId"],
      nombres: json["nombres"],
      primerApellido: json["primerApellido"],
      segundoApellido: json["segundoApellido"],
      identificacion: json["identificacion"],
      fechaNacimiento: DateTime.parse(json["fechaNacimiento"]),
      edad: json["edad"],
      sexo: json["sexo"],
      telefono1: json["telefono1"],
      telefono2: json["telefono2"],
      colegioNumero: json["colegioNumero"],
      email: json["email"],
      userName: json["userName"],
      password: json["password"] == null ? null : json["password"],
      passwordSalt: json["passwordSalt"] == null ? null : json["passwordSalt"],
      passwordHash: json["passwordHash"] == null ? null : json["passwordHash"],
      activo: json["activo"],
      creadoPor: json["creadoPor"],
      creadoFecha: DateTime.parse(json["creadoFecha"]),
      modificadoPor: json["modificadoPor"],
      modificadoFecha: DateTime.parse(json["modificadoFecha"]),
      notas: json["notas"],
      fotoUrl: json["fotoUrl"],
      tokenDevice: json["tokenDevice"]);

  Map<String, dynamic> toJson() => {
        "usuarioId": usuarioId,
        "rolId": rolId,
        "asistenteId": asistenteId,
        "nombres": nombres,
        "primerApellido": primerApellido,
        "segundoApellido": segundoApellido,
        "identificacion": identificacion,
        "fechaNacimiento": fechaNacimiento.toIso8601String(),
        "edad": edad,
        "sexo": sexo,
        "telefono1": telefono1,
        "telefono2": telefono2,
        "colegioNumero": colegioNumero,
        "email": email,
        "userName": userName,
        "password": password == null ? null : password,
        "passwordSalt": passwordSalt == null ? null : passwordSalt,
        "passwordHash": passwordHash == null ? null : passwordHash,
        "activo": activo,
        "creadoPor": creadoPor,
        "creadoFecha": creadoFecha.toIso8601String(),
        "modificadoPor": modificadoPor,
        "modificadoFecha": modificadoFecha.toIso8601String(),
        "notas": notas,
        "fotoUrl": fotoUrl,
        "tokenDevice": tokenDevice
      };
}
