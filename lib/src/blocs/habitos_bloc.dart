import 'package:appsam/src/blocs/validators.dart';
import 'package:appsam/src/models/habitos_model.dart';
import 'package:appsam/src/providers/habitos_service.dart';

class HabitosBloc with Validators {
  final _habitosService = new HabitosService();

  Future<Habitos> addHabitos(Habitos habitos) async {
    return await _habitosService.addHabitos(habitos);
  }

  Future<Habitos> updateHabitos(Habitos habitos) async {
    return await _habitosService.updateHabitos(habitos);
  }

  dispose() {}
}
