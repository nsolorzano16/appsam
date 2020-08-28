import 'package:appsam/src/blocs/validators.dart';
import 'package:appsam/src/models/notas_model.dart';
import 'package:appsam/src/providers/notas_service.dart';

class NotasBloc with Validators {
  final _notasService = new NotasService();

  Future<List<Notas>> addListaNotas(List<Notas> notas) async {
    return await _notasService.addListaNotas(notas);
  }

  Future<List<Notas>> updateListaNotas(List<Notas> notas) async {
    return await _notasService.updateListaNotas(notas);
  }

  Future<bool> desactivar(Notas nota) async {
    return await _notasService.desactivar(nota);
  }

  Future<List<Notas>> getNotas(
      int pacienteId, String doctorId, int preclinicaId) async {
    return await _notasService.getNotas(pacienteId, doctorId, preclinicaId);
  }

  dispose() {}
}
