import 'package:rxdart/rxdart.dart';

import 'package:appsam/src/blocs/validators.dart';
import 'package:appsam/src/models/antecedentesFamiliaresPersonales_model.dart';
import 'package:appsam/src/providers/antecedentes_service.dart';

class AntecedentesFamiliaresBloc with Validators {
  final _antecedentesService = new AntecedentesService();
  final _conDataController = new BehaviorSubject<bool>();

  Function(bool) get onChangeConData => _conDataController.sink.add;

  Future<AntecedentesFamiliaresPersonales> addAntecedentes(
      AntecedentesFamiliaresPersonales antecedentes) async {
    return await _antecedentesService.addAntecedentes(antecedentes);
  }

  Future<AntecedentesFamiliaresPersonales> updateAntecedentes(
      AntecedentesFamiliaresPersonales antecedentes) async {
    return await _antecedentesService.updateAntecedentes(antecedentes);
  }

  dispose() {
    _conDataController?.close();
  }
}
