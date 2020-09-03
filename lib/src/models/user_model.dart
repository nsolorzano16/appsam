// To parse this JSON data, do
//
//     final editUserViewModel = editUserViewModelFromJson(jsonString);

import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  UserModel({
    this.id,
    this.userName,
    this.email,
    this.phoneNumber,
    this.rolId,
    this.asistenteId,
    this.planId,
    this.nombres,
    this.primerApellido,
    this.segundoApellido,
    this.identificacion,
    this.fechaNacimiento,
    this.edad,
    this.sexo,
    this.telefono2,
    this.colegioNumero,
    this.fotoUrl,
    this.activo,
    this.creadoPor,
    this.creadoFecha,
    this.modificadoPor,
    this.modificadoFecha,
    this.notas,
    this.lockoutEnd,
    this.accessFailedCount,
    this.locked,
  });

  String id;
  String userName;
  String email;
  String phoneNumber;
  int rolId;
  String asistenteId;
  int planId;
  String nombres;
  String primerApellido;
  String segundoApellido;
  String identificacion;
  DateTime fechaNacimiento;
  int edad;
  String sexo;
  String telefono2;
  String colegioNumero;
  String fotoUrl;
  bool activo;
  String creadoPor;
  DateTime creadoFecha;
  String modificadoPor;
  DateTime modificadoFecha;
  String notas;
  String lockoutEnd;
  int accessFailedCount;
  bool locked;

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json["id"],
        userName: json["userName"],
        email: json["email"],
        phoneNumber: json["phoneNumber"],
        rolId: json["rolId"],
        asistenteId: json["asistenteId"],
        planId: json["planId"],
        nombres: json["nombres"],
        primerApellido: json["primerApellido"],
        segundoApellido:
            json["segundoApellido"] == null ? '' : json["segundoApellido"],
        identificacion:
            json["identificacion"] == null ? '' : json["identificacion"],
        fechaNacimiento: DateTime.parse(json["fechaNacimiento"]),
        edad: json["edad"],
        sexo: json["sexo"],
        telefono2: json["telefono2"] == null ? '' : json["telefono2"],
        colegioNumero: json["colegioNumero"],
        fotoUrl: json["fotoUrl"],
        activo: json["activo"],
        creadoPor: json["creadoPor"],
        creadoFecha: DateTime.parse(json["creadoFecha"]),
        modificadoPor: json["modificadoPor"],
        modificadoFecha: DateTime.parse(json["modificadoFecha"]),
        notas: json["notas"] == null ? '' : json["notas"],
        lockoutEnd: json["lockoutEnd"] == null ? null : json["lockoutEnd"],
        accessFailedCount:
            json["accessFailedCount"] == null ? 0 : json["accessFailedCount"],
        locked: json["locked"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "userName": userName,
        "email": email,
        "phoneNumber": phoneNumber,
        "rolId": rolId,
        "asistenteId": asistenteId,
        "planId": planId,
        "nombres": nombres,
        "primerApellido": primerApellido,
        "segundoApellido": segundoApellido,
        "identificacion": identificacion,
        "fechaNacimiento": fechaNacimiento.toIso8601String(),
        "edad": edad,
        "sexo": sexo,
        "telefono2": telefono2,
        "colegioNumero": colegioNumero,
        "fotoUrl": fotoUrl,
        "activo": activo,
        "creadoPor": creadoPor,
        "creadoFecha": creadoFecha.toIso8601String(),
        "modificadoPor": modificadoPor,
        "modificadoFecha": modificadoFecha.toIso8601String(),
        "notas": notas,
        "lockoutEnd": lockoutEnd,
        "accessFailedCount": accessFailedCount,
        "locked": locked,
      };
}
