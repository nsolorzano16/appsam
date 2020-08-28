import 'package:appsam/src/blocs/validators.dart';
import 'package:appsam/src/models/diagnosticos_model.dart';
import 'package:appsam/src/models/diagnosticos_viewmodel.dart';
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

  Future<bool> desactivar(DiagnosticosViewModel diagnostico) async {
    return await _diagnosticosService.desactivar(diagnostico);
  }

  Future<Diagnosticos> addDiagnostico(Diagnosticos diagnostico) async {
    return await _diagnosticosService.addDiagnosticos(diagnostico);
  }

  Future<List<DiagnosticosViewModel>> getDiagnosticos(
      int pacienteId, String doctorId, int preclinicaId) async {
    return await _diagnosticosService.getDiagnosticos(
        pacienteId, doctorId, preclinicaId);
  }

  dispose() {}
}
