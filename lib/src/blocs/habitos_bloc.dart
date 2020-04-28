import 'package:appsam/src/blocs/validators.dart';
import 'package:appsam/src/models/habitos_model.dart';
import 'package:appsam/src/providers/habitos_service.dart';
import 'package:rxdart/rxdart.dart';

class HabitosBloc with Validators {
  final _habitosService = new HabitosService();

  final _consumeCafeController = BehaviorSubject<bool>();
  Stream<bool> get consumeCafeStream => _consumeCafeController.stream;
  Function(bool) get onChangeConsumeCafe => _consumeCafeController.sink.add;
  bool get consumeCafe => _consumeCafeController.value;

  final _consumeCigarrilloContoller = BehaviorSubject<bool>();
  Stream<bool> get consumeCigarrilloStream =>
      _consumeCigarrilloContoller.stream;
  Function(bool) get onChangeConsumeCigarrillo =>
      _consumeCigarrilloContoller.sink.add;
  bool get consumeCigarrillo => _consumeCigarrilloContoller.value;

  final _labelBotonGuardarController = BehaviorSubject<String>();
  Stream<String> get labelBotonStream => _labelBotonGuardarController.stream;
  Function(String) get onChangeLabelBoton =>
      _labelBotonGuardarController.sink.add;
  String get labelBoton => _labelBotonGuardarController.value;

  Future<Habitos> addHabitos(Habitos habitos) async {
    return await _habitosService.addHabitos(habitos);
  }

  Future<Habitos> updateHabitos(Habitos habitos) async {
    return await _habitosService.updateHabitos(habitos);
  }

  Future<Habitos> getHabito(int pacienteId, int doctorId) async {
    return await _habitosService.getHabito(pacienteId, doctorId);
  }

  dispose() {
    _consumeCafeController?.close();
    _consumeCigarrilloContoller?.close();
    _labelBotonGuardarController?.close();
  }
}
