import 'dart:io';

import 'package:appsam/src/blocs/validators.dart';
import 'package:appsam/src/models/usuario_model.dart';
import 'package:appsam/src/providers/usuario_provider.dart';
import 'package:rxdart/rxdart.dart';

class CrearEditarAsistentesBloc with Validators {
  final _usuarioProvider = new UsuarioProvider();
// declaracion de todos los streams del form
  final _nombresController = BehaviorSubject<String>();
  final _primerApellidoController = BehaviorSubject<String>();
  final _segundoApellidoController = BehaviorSubject<String>();
  final _identificacionController = BehaviorSubject<String>();
  final _fechaNacimientoController = BehaviorSubject<String>();
  final _telefono1Controller = BehaviorSubject<String>();
  final _telefono2Controller = BehaviorSubject<String>();
  final _emailController = BehaviorSubject<String>();
  final _colegioNumeroController = BehaviorSubject<String>();
  final _userNameController = BehaviorSubject<String>();
  final _passwordController = BehaviorSubject<String>();
  final _notasController = BehaviorSubject<String>();

  final _fotoUrlController = BehaviorSubject<String>();

  Stream<String> get nombresStream =>
      _nombresController.stream.transform(validarCampoTexto);
  Stream<String> get primerApellidoStream =>
      _primerApellidoController.stream.transform(validarCampoTexto);
  Stream<String> get segundoApellidoStream =>
      _segundoApellidoController.stream.transform(validarCampoTexto);
  Stream<String> get identificacionStream =>
      _identificacionController.stream.transform(validarIdentificacion);
  Stream<String> get fechaNacimientoStream => _fechaNacimientoController.stream;
  Stream<String> get telefono1Stream =>
      _telefono1Controller.stream.transform(validarCampoTexto);
  Stream<String> get telefono2Stream => _telefono2Controller.stream;
  Stream<String> get emailStream =>
      _emailController.stream.transform(validarEmail);
  Stream<String> get colegioNumeroStream =>
      _emailController.stream.transform(validarCampoTexto);
  Stream<String> get userNameStream =>
      _userNameController.stream.transform(validarCampoTexto);
  Stream<String> get passwordStream =>
      _passwordController.stream.transform(validarCampoTexto);
  Stream<String> get notasStream => _notasController.stream;
  Stream<String> get fotoUrlStream => _fotoUrlController.stream;

  // ************

  Function(String) get changeNombres => _nombresController.sink.add;
  Function(String) get changePrimerApellido =>
      _primerApellidoController.sink.add;
  Function(String) get changeSegundoApellido =>
      _segundoApellidoController.sink.add;
  Function(String) get changeIdentificacion =>
      _identificacionController.sink.add;
  Function(String) get changeFechaNacimiento =>
      _fechaNacimientoController.sink.add;
  Function(String) get changeTelefono1 => _telefono1Controller.sink.add;
  Function(String) get changeTelefono2 => _telefono2Controller.sink.add;
  Function(String) get changeEmail => _emailController.sink.add;
  Function(String) get changeColegioNumero => _colegioNumeroController.sink.add;
  Function(String) get changeUserName => _userNameController.sink.add;
  Function(String) get changePassword => _passwordController.sink.add;
  Function(String) get changeNotas => _notasController.sink.add;
  Function(String) get changeFotoUrl => _fotoUrlController.sink.add;

  // todo ok
  Stream<bool> get todoOkStream => CombineLatestStream.combine8(
      nombresStream,
      primerApellidoStream,
      segundoApellidoStream,
      identificacionStream,
      telefono1Stream,
      emailStream,
      userNameStream,
      passwordStream,
      (n, pa, sa, i, t, e, u, p) => true);

  void addUser(UsuarioModel usuario) async {
    await _usuarioProvider.addAsistente(usuario);
  }

  Future<UsuarioModel> updateUser(UsuarioModel usuario) async {
    return await _usuarioProvider.updateAsistente(usuario);
  }

  Future<UsuarioModel> resetPassword(
      int id, String password, String modificadoPor) async {
    return await _usuarioProvider.resetPassword(id, password, modificadoPor);
  }

  Future<UsuarioModel> getMyInfo(int id) async {
    return await _usuarioProvider.getMyInfo(id);
  }

  Future<UsuarioModel> subirFotoApi(int id, File imagen) async {
    return await _usuarioProvider.subirFotoApi(id, imagen);
  }

  dispose() {
    _nombresController?.close();

    _primerApellidoController?.close();
    _segundoApellidoController?.close();
    _identificacionController?.close();
    _fechaNacimientoController?.close();
    _telefono1Controller?.close();
    _telefono2Controller?.close();
    _emailController?.close();
    _colegioNumeroController?.close();
    _userNameController?.close();
    _passwordController?.close();
    _notasController?.close();
    _fotoUrlController?.close();
    print('=====Se cierra el Stream==== Create-Edit-Asistentes-Bloc');
  }

  // valores get
  String get nombres => _nombresController.value;
  String get primerApellido => _primerApellidoController.value;
  String get segundoApellido => _segundoApellidoController.value;
  String get identificacion => _identificacionController.value;
  String get fechaNacimiento => _fechaNacimientoController.value;
  String get telefono1 => _telefono1Controller.value;
  String get telefono2 => _telefono2Controller.value;
  String get email => _emailController.value;
  String get colegioNumero => _colegioNumeroController.value;
  String get userName => _userNameController.value;
  String get password => _passwordController.value;
  String get notas => _notasController.value;
  String get fotoURL => _fotoUrlController.value;
}
