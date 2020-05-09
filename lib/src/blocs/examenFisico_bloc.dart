import 'package:appsam/src/blocs/validators.dart';
import 'package:appsam/src/models/examenFisico_model.dart';
import 'package:appsam/src/providers/examenFisico_service.dart';

class ExamenFisicoBloc with Validators {
  final _examenFisicoService = new ExamenFisicoService();

  Future<ExamenFisico> addExamenFisico(ExamenFisico examenFisico) async {
    return await _examenFisicoService.addExamenFisico(examenFisico);
  }

  Future<ExamenFisico> updateExamenFisico(ExamenFisico examenFisico) async {
    return await _examenFisicoService.updateExamenFisico(examenFisico);
  }

  Future<ExamenFisico> getExamenFisico(
      int pacienteId, int doctorId, int preclinicaId) async {
    return await _examenFisicoService.getExamenFisico(
        pacienteId, doctorId, preclinicaId);
  }

  dispose() {}
}
