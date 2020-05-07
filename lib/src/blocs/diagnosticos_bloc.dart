import 'package:appsam/src/blocs/validators.dart';
import 'package:appsam/src/models/diagnosticos_model.dart';
import 'package:appsam/src/providers/diagnosticos_service.dart';

class DiagnosticosBloc with Validators {
  final _diagnosticosService = new DiagnosticosService();

  Future<List<Diagnosticos>> addListaDiagnosticos(
      List<Diagnosticos> diagnosticos) async {
    return await _diagnosticosService.addListaDiagnosticos(diagnosticos);
  }

  Future<List<Diagnosticos>> updateListaDiagnosticos(
      List<Diagnosticos> diagnosticos) async {
    return await _diagnosticosService.updateListaDiagnosticos(diagnosticos);
  }

  Future<bool> desactivar(Diagnosticos diagnostico) async {
    return await _diagnosticosService.desactivar(diagnostico);
  }

  Future<List<Diagnosticos>> getDiagnosticos(
      int pacienteId, int doctorId, int preclinicaId) async {
    return await _diagnosticosService.getDiagnosticos(
        pacienteId, doctorId, preclinicaId);
  }

  dispose() {}
}
