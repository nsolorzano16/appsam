import 'package:appsam/src/blocs/validators.dart';
import 'package:appsam/src/models/historialGinecoObstetra_model.dart';
import 'package:appsam/src/providers/historialGineco_service.dart';
import 'package:rxdart/subjects.dart';

class HistorialGinecoObstetraBloc with Validators {
  final _historialService = new HistorialGinecoObstetraService();

  final _dataStreamController = new BehaviorSubject<DataStream>();
  Stream<DataStream> get dataStream => _dataStreamController.stream;
  Function(DataStream) get onChangeDataStream => _dataStreamController.sink.add;
  DataStream get dataStreamValue => _dataStreamController.value;

  Future<HistorialGinecoObstetra> addHistorial(
      HistorialGinecoObstetra historial) async {
    return await _historialService.addHistorial(historial);
  }

  Future<HistorialGinecoObstetra> updateHistorial(
      HistorialGinecoObstetra historial) async {
    return await _historialService.updateHistorial(historial);
  }

  Future<HistorialGinecoObstetra> getHistorialGinecoObstetra(
      int pacienteId, String doctorId) async {
    return await _historialService.getHistorialGinecoObstetra(pacienteId);
  }

  dispose() {
    _dataStreamController?.close();
  }
}

class DataStream {
  final String menarquiaTexto;
  final String furTexto;
  final String fechaMenopausiaTexto;

  final DateTime menarquia;
  final DateTime fur;
  final DateTime fechaMenopausia;

  DataStream(this.menarquiaTexto, this.furTexto, this.fechaMenopausiaTexto,
      this.menarquia, this.fur, this.fechaMenopausia);
}
