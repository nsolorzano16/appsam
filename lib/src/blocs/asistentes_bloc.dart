import 'dart:async';
import 'package:appsam/src/models/user_model.dart';
import 'package:rxdart/rxdart.dart';

import 'package:appsam/src/blocs/validators.dart';
import 'package:appsam/src/providers/usuario_provider.dart';

class AsistentesBloc with Validators {
// LISTA DE ASISTENTES
  final _asistentesController = BehaviorSubject<List<UserModel>>();
  final _asistentesBusquedaController = BehaviorSubject<List<UserModel>>();

  final _totalPagesController = BehaviorSubject<int>();
  final _currentPageController = BehaviorSubject<int>();

  final listAsistentes = new List<UserModel>();
  final _usuarioProvider = new UsuarioProvider();

  Stream<List<UserModel>> get asistentesStream => _asistentesController.stream;
  Stream<List<UserModel>> get asistentesBusquedaStream =>
      _asistentesBusquedaController.stream;

  Function(List<UserModel>) get asistentesSink => _asistentesController.add;
  Function(List<UserModel>) get onChangeAsistentesBusqueda =>
      _asistentesBusquedaController.add;

  cargarAsistentesPaginado(int page, String filter, String doctorId) async {
    final asistentes =
        await _usuarioProvider.getAsistentesPaginado(page, filter, doctorId);
    _totalPagesController.sink.add(asistentes.totalPages);

    listAsistentes.addAll(asistentes.items);
    asistentesSink(listAsistentes);
    _totalPagesController.sink.add(asistentes.totalPages);
    _currentPageController.sink.add(asistentes.currentPage);
  }

  cargarAsistentesPaginadoBusqueda(
      int page, String filter, String doctorId) async {
    final asistentes =
        await _usuarioProvider.getAsistentesPaginado(page, filter, doctorId);
    onChangeAsistentesBusqueda(asistentes.items);
  }

  dispose() {
    _asistentesController.close();
    _asistentesBusquedaController.close();
    _totalPagesController.close();
    _currentPageController.close();
  }

  int get totalPages => _totalPagesController.value;
  int get currentPage => _currentPageController.value;
}
