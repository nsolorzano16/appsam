import 'dart:async';

import 'package:appsam/src/blocs/validators.dart';
import 'package:appsam/src/models/usuario_model.dart';
import 'package:appsam/src/providers/usuario_provider.dart';
import 'package:rxdart/rxdart.dart';

class AsistentesBloc with Validators {
// LISTA DE ASISTENTES
  final _asistentesController = BehaviorSubject<List<UsuarioModel>>();
  final _asistentesBusquedaController = BehaviorSubject<List<UsuarioModel>>();
  final _ultimaPaginaController = BehaviorSubject<int>();
  final listAsistentes = new List<UsuarioModel>();

  final _usuarioProvider = new UsuarioProvider();

  Stream<List<UsuarioModel>> get asistentesStream =>
      _asistentesController.stream;
  Stream<List<UsuarioModel>> get asistentesBusquedaStream =>
      _asistentesBusquedaController.stream;
  Stream<int> get ultimaPaginaStream => _ultimaPaginaController.stream;

  Function(List<UsuarioModel>) get asistentesSink => _asistentesController.add;
  Function(List<UsuarioModel>) get onChangeAsistentesBusqueda =>
      _asistentesBusquedaController.add;

  cargarAsistentesPaginado(int page, String filter, int doctorId) async {
    final asistentes =
        await _usuarioProvider.getAsistentesPaginado(page, filter, doctorId);
    _ultimaPaginaController.sink.add(asistentes.totalPages);
    listAsistentes.addAll(asistentes.items);
    asistentesSink(listAsistentes);
  }

  cargarAsistentesPaginadoBusqueda(
      int page, String filter, int doctorId) async {
    final asistentes =
        await _usuarioProvider.getAsistentesPaginado(page, filter, doctorId);
    onChangeAsistentesBusqueda(asistentes.items);
  }

  dispose() {
    _asistentesController?.close();
    _asistentesBusquedaController?.close();
    //listAsistentes.clear();
    _ultimaPaginaController?.close();
    print('===============');
    print('Se cierra el stream');
    print("=================");
  }

  int get ultimaPagina => _ultimaPaginaController.value;
}
