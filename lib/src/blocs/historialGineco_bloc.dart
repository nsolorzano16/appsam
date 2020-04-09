import 'package:appsam/src/blocs/validators.dart';
import 'package:appsam/src/models/historialGinecoObstetra_model.dart';
import 'package:appsam/src/providers/historialGineco_service.dart';

class HistorialGinecoObstetraBloc with Validators {
  final _historialService = new HistorialGinecoObstetraService();

  Future<HistorialGinecoObstetra> addHistorial(
      HistorialGinecoObstetra historial) async {
    return await _historialService.addHistorial(historial);
  }

  Future<HistorialGinecoObstetra> updateHistorial(
      HistorialGinecoObstetra historial) async {
    return await _historialService.updateHistorial(historial);
  }

  dispose() {}
}
