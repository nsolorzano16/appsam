import 'package:appsam/src/blocs/validators.dart';
import 'package:appsam/src/models/consulta_model.dart';
import 'package:appsam/src/providers/consulta_service.dart';

class ConsultaBloc with Validators {
  final _consultaService = new ConsultaService();

  Future<ConsultaModel> getDetalleConsulta(
      int pacienteId, int doctorId, int preclinicaId) async {
    return await _consultaService.getDetalleConsulta(
        pacienteId, doctorId, preclinicaId);
  }
}
