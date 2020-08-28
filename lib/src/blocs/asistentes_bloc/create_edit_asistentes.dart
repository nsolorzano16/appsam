import 'dart:io';
import 'package:appsam/src/models/create_user_viewmodel.dart';
import 'package:appsam/src/models/myinfo_viewmodel.dart';
import 'package:appsam/src/models/user_model.dart';

import 'package:appsam/src/blocs/validators.dart';
import 'package:appsam/src/providers/usuario_provider.dart';

class CrearEditarAsistentesBloc with Validators {
  final _usuarioProvider = new UsuarioProvider();

  Future<bool> addUser(CreateUserViewModel usuario) async {
    return await _usuarioProvider.addAsistente(usuario);
  }

  Future<UserModel> updateUser(UserModel usuario) async {
    return await _usuarioProvider.updateAsistente(usuario);
  }

  Future<UserModel> resetPassword(
      String id, String password, String modificadoPor) async {
    return await _usuarioProvider.resetPassword(id, password, modificadoPor);
  }

  Future<MyInfoViewModel> getMyInfo(String id) async {
    return await _usuarioProvider.getMyInfo(id);
  }

  Future<UserModel> subirFotoApi(String id, File imagen) async {
    return await _usuarioProvider.subirFotoApi(id, imagen);
  }

  dispose() {
    print('=====Se cierra el Stream==== Create-Edit-Asistentes-Bloc');
  }
}
