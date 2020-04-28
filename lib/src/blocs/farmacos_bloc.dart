import 'package:appsam/src/blocs/validators.dart';
import 'package:appsam/src/models/farmacosUsoActual_model.dart';
import 'package:appsam/src/providers/farmacos_service.dart';

class FarmacosUsoActualBloc with Validators {
  final _farmacosService = new FarmacosUsoActualService();

  Future<List<FarmacosUsoActual>> addListaFarmacos(
      List<FarmacosUsoActual> farmacos) async {
    return await _farmacosService.addListaFarmacos(farmacos);
  }

  Future<List<FarmacosUsoActual>> updateListaFarmacos(
      List<FarmacosUsoActual> farmacos) async {
    return await _farmacosService.updateListaFarmacos(farmacos);
  }

  Future<bool> desactivar(FarmacosUsoActual farmaco) async {
    return await _farmacosService.desactivar(farmaco);
  }

  Future<List<FarmacosUsoActual>> getFarmacos(
      int pacienteId, int doctorId) async {
    return await _farmacosService.getFarmacos(pacienteId, doctorId);
  }

  dispose() {}
}
