import 'package:appsam/src/blocs/validators.dart';
import 'package:appsam/src/models/antecedentesFamiliaresPersonales_model.dart';
import 'package:appsam/src/providers/antecedentes_service.dart';

class AntecedentesFamiliaresBloc with Validators {
  final _antecedentesService = new AntecedentesService();

  Future<AntecedentesFamiliaresPersonales> addAntecedentes(
      AntecedentesFamiliaresPersonales antecedentes) async {
    return await _antecedentesService.addAntecedentes(antecedentes);
  }

  Future<AntecedentesFamiliaresPersonales> updateAntecedentes(
      AntecedentesFamiliaresPersonales antecedentes) async {
    return await _antecedentesService.updateAntecedentes(antecedentes);
  }

  Future<AntecedentesFamiliaresPersonales> getAntecedente(
      int pacienteId) async {
    return await _antecedentesService.getAntecedente(pacienteId);
  }

  dispose() {}
}
