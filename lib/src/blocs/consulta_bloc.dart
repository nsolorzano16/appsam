import 'package:appsam/src/blocs/validators.dart';
import 'package:appsam/src/models/consultaGeneral_model.dart';
import 'package:appsam/src/models/consulta_model.dart';
import 'package:appsam/src/providers/consulta_service.dart';
import 'package:rxdart/rxdart.dart';

class ConsultaBloc with Validators {
  final _consultaService = new ConsultaService();

  final _consultaController = BehaviorSubject<ConsultaModel>();

  //Stream<ConsultaModel> get _consultaStream => _consultaController.stream;

  Function(ConsultaModel) get onChangeConsulta => _consultaController.sink.add;

  dispose() {
    _consultaController?.close();
  }

  Future<ConsultaModel> getDetalleConsulta(
      int pacienteId, String doctorId, int preclinicaId) async {
    return await _consultaService.getDetalleConsulta(
        pacienteId, doctorId, preclinicaId);
  }

  Future<ConsultaGeneralModel> addConsultaGeneral(
      ConsultaGeneralModel consultaGeneral) async {
    return await _consultaService.addConsultaGeneral(consultaGeneral);
  }

  Future<ConsultaGeneralModel> updateConsultaGeneral(
      ConsultaGeneralModel consultaGeneral) async {
    return await _consultaService.updateConsultaGeneral(consultaGeneral);
  }

  Future<ConsultaGeneralModel> getConsultaGeneral(
      int pacienteId, String doctorId, int preclinicaId) async {
    return await _consultaService.getConsultaGeneral(
        pacienteId, doctorId, preclinicaId);
  }

  ConsultaModel get consulta => _consultaController.value;
}
