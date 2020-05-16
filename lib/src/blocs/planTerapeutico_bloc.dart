import 'package:appsam/src/blocs/validators.dart';
import 'package:appsam/src/models/planTerapeutico_model.dart';
import 'package:appsam/src/models/planTerapeutico_viewmodel.dart';
import 'package:appsam/src/providers/planTerapeutico_service.dart';

class PlanTerapeuticoBloc with Validators {
  final _planService = new PlanTerapeuticoService();

  Future<PlanTerapeuticoModel> addPlan(PlanTerapeuticoModel plan) async {
    return await _planService.addPlan(plan);
  }

  Future<PlanTerapeuticoViewModel> updatePlan(
      PlanTerapeuticoViewModel plan) async {
    return await _planService.updatePlan(plan);
  }

  Future<List<PlanTerapeuticoViewModel>> getPlanes(
      int pacienteId, int doctorId, int preclinicaId) async {
    return await _planService.getPlanes(pacienteId, doctorId, preclinicaId);
  }

  dispose() {}
}
