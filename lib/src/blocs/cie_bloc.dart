import 'dart:async';

import 'package:appsam/src/models/cie_model.dart';
import 'package:appsam/src/providers/cie_service.dart';

class CieBloc {
  final _cieService = CieService();
  final List<CieModel> lista = List();

  final _enfermedadesBusquedaController =
      new StreamController<List<CieModel>>.broadcast();

  Stream<List<CieModel>> get enfermedadesBusquedaStream =>
      _enfermedadesBusquedaController.stream;

  Function(List<CieModel>) get onChangeEnfermedades =>
      _enfermedadesBusquedaController.add;

  void cargarEnfermedadesBusqueda(int page, String filter) async {
    final enfermedades =
        await _cieService.getEnfermedadesPaginado(page, filter);

    onChangeEnfermedades(enfermedades.items);
  }

  dispose() {
    _enfermedadesBusquedaController.close();
  }
}
