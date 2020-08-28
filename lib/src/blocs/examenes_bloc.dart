import 'package:appsam/src/models/examenDetalle_model.dart';
import 'package:appsam/src/models/examenIndicado_Model.dart';
import 'package:appsam/src/models/examenTipo_model.dart';
import 'package:appsam/src/models/examenesIndicados_viewmodel.dart';
import 'package:appsam/src/providers/combos_service.dart';
import 'package:appsam/src/providers/examenes_service.dart';
import 'package:flutter/cupertino.dart';

class ExamenesBlocNoti extends ChangeNotifier {
  final _examenService = ExamenesService();
  final _combosService = CombosService();

  bool loading = false;
  bool loadingDetalles = false;
  List<ExamenTipoModel> listaTipos = List();
  List<ExamenDetalleModel> listaDetalles = List();

  void getTiposExamenes(int categoriaId) async {
    loading = true;
    notifyListeners();
    final tipos = await _combosService.getTiposExamenes(categoriaId);
    listaTipos = tipos;
    loading = false;
    notifyListeners();
  }

  void getDetalleExamenes(int tipoId, int categoriaId) async {
    loadingDetalles = true;
    notifyListeners();
    final detalles =
        await _combosService.getDetalleExamenes(tipoId, categoriaId);
    listaDetalles = detalles;
    loadingDetalles = false;
    notifyListeners();
  }

  void clearList() {
    listaDetalles.clear();
    listaTipos.clear();
    notifyListeners();
  }

  Future<ExamenIndicadoModel> addExamen(ExamenIndicadoModel examen) async {
    return await _examenService.addExamen(examen);
  }

  Future<ExamenesIndicadosViewModel> updateExamen(
      ExamenesIndicadosViewModel examen) async {
    return await _examenService.updateExamen(examen);
  }

  Future<List<ExamenesIndicadosViewModel>> getDetalleExamenesIndicados(
      int pacienteId, String doctorId, int preclinicaId) async {
    return await _examenService.getDetalleExamenesIndicados(
        pacienteId, doctorId, preclinicaId);
  }
}
