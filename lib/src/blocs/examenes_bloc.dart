import 'package:appsam/src/blocs/validators.dart';
import 'package:appsam/src/models/examenCategoria_model.dart';
import 'package:appsam/src/models/examenDetalle_model.dart';
import 'package:appsam/src/models/examenIndicado_Model.dart';
import 'package:appsam/src/models/examenTipo_model.dart';
import 'package:appsam/src/providers/examenes_service.dart';
import 'package:rxdart/rxdart.dart';

class ExamenesBloc with Validators {
  final _examenService = new ExamenesService();

  final _combosController = new BehaviorSubject<ListCombosExamenes>();
  Stream<ListCombosExamenes> get combosListStream => _combosController.stream;
  Function(ListCombosExamenes) get onChangeCombosList =>
      _combosController.sink.add;
  ListCombosExamenes get comboModel => _combosController.value;

  Future<ExamenIndicadoModel> addExamen(ExamenIndicadoModel examen) async {
    return await _examenService.addExamen(examen);
  }

  Future<ExamenIndicadoModel> updateExamen(ExamenIndicadoModel examen) async {
    return await _examenService.updateExamen(examen);
  }

  Future<List<ExamenIndicadoModel>> getExamenesIndicados(
      int pacienteId, int doctorId, int preclinicaId) async {
    return await _examenService.getExamenesIndicados(
        pacienteId, doctorId, preclinicaId);
  }

  dispose() {
    _combosController?.close();
  }
}

class ListCombosExamenes {
  List<ExamenTipoModel> listExamenTipo;
  List<ExamenDetalleModel> listExamenDetalle;
  List<ExamenCategoriaModel> listCategorias;
  int examenCategoriaId;
  int examenTipoId;
  int examenDetalleId;

  ListCombosExamenes(
      {this.listExamenTipo,
      this.listExamenDetalle,
      this.listCategorias,
      this.examenCategoriaId,
      this.examenTipoId,
      this.examenDetalleId});
}
