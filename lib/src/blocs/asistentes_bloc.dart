import 'dart:async';
import 'package:rxdart/rxdart.dart';

import 'package:appsam/src/blocs/validators.dart';
import 'package:appsam/src/models/usuario_model.dart';
import 'package:appsam/src/providers/usuario_provider.dart';

class AsistentesBloc with Validators {
// LISTA DE ASISTENTES
  final _asistentesController = BehaviorSubject<List<UsuarioModel>>();
  final _asistentesBusquedaController = BehaviorSubject<List<UsuarioModel>>();

  final _totalPagesController = BehaviorSubject<int>();
  final _currentPageController = BehaviorSubject<int>();

  final listAsistentes = new List<UsuarioModel>();
  final _usuarioProvider = new UsuarioProvider();

  Stream<List<UsuarioModel>> get asistentesStream =>
      _asistentesController.stream;
  Stream<List<UsuarioModel>> get asistentesBusquedaStream =>
      _asistentesBusquedaController.stream;

  Function(List<UsuarioModel>) get asistentesSink => _asistentesController.add;
  Function(List<UsuarioModel>) get onChangeAsistentesBusqueda =>
      _asistentesBusquedaController.add;

  cargarAsistentesPaginado(int page, String filter, int doctorId) async {
    final asistentes =
        await _usuarioProvider.getAsistentesPaginado(page, filter, doctorId);
    _totalPagesController.sink.add(asistentes.totalPages);

    listAsistentes.addAll(asistentes.items);
    asistentesSink(listAsistentes);
    _totalPagesController.sink.add(asistentes.totalPages);
    _currentPageController.sink.add(asistentes.currentPage);
  }

  cargarAsistentesPaginadoBusqueda(
      int page, String filter, int doctorId) async {
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
