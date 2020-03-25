import 'package:appsam/src/blocs/validators.dart';
import 'package:appsam/src/models/consulta_model.dart';
import 'package:appsam/src/providers/consulta_service.dart';

class ConsultaBloc with Validators {
  final _consultaService = new ConsultaService();

  Future<bool> addConsulta(ConsultaModel consulta) async {
    return await _consultaService.addConsulta(consulta);
  }
}
