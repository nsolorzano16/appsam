// To parse this JSON data, do
//
//     final createUserViewModel = createUserViewModelFromJson(jsonString);

import 'dart:convert';

CreateUserViewModel createUserViewModelFromJson(String str) =>
    CreateUserViewModel.fromJson(json.decode(str));

String createUserViewModelToJson(CreateUserViewModel data) =>
    json.encode(data.toJson());

class CreateUserViewModel {
  CreateUserViewModel({
    this.rolId,
    this.asistenteId,
    this.planId,
    this.nombres,
    this.primerApellido,
    this.segundoApellido,
    this.identificacion,
    this.fechaNacimiento,
    this.sexo,
    this.phoneNumber,
    this.telefono2,
    this.colegioNumero,
    this.userName,
    this.email,
    this.password,
    this.creadoPor,
    this.notas,
  });

  int rolId;
  String asistenteId;
  int planId;
  String nombres;
  String primerApellido;
  String segundoApellido;
  String identificacion;
  DateTime fechaNacimiento;
  String sexo;
  String phoneNumber;
  String telefono2;
  String colegioNumero;
  String userName;
  String email;
  String password;
  String creadoPor;
  String notas;

  factory CreateUserViewModel.fromJson(Map<String, dynamic> json) =>
      CreateUserViewModel(
        rolId: json["rolId"],
        asistenteId: json["asistenteId"],
        planId: json["planId"],
        nombres: json["nombres"],
        primerApellido: json["primerApellido"],
        segundoApellido: json["segundoApellido"],
        identificacion: json["identificacion"],
        fechaNacimiento: DateTime.parse(json["fechaNacimiento"]),
        sexo: json["sexo"],
        phoneNumber: json["phoneNumber"],
        telefono2: json["telefono2"],
        colegioNumero: json["colegioNumero"],
        userName: json["userName"],
        email: json["email"],
        password: json["password"],
        creadoPor: json["creadoPor"],
        notas: json["notas"],
      );

  Map<String, dynamic> toJson() => {
        "rolId": rolId,
        "asistenteId": asistenteId,
        "planId": planId,
        "nombres": nombres,
        "primerApellido": primerApellido,
        "segundoApellido": segundoApellido,
        "identificacion": identificacion,
        "fechaNacimiento": fechaNacimiento.toIso8601String(),
        "sexo": sexo,
        "phoneNumber": phoneNumber,
        "telefono2": telefono2,
        "colegioNumero": colegioNumero,
        "userName": userName,
        "email": email,
        "password": password,
        "creadoPor": creadoPor,
        "notas": notas,
      };
}
