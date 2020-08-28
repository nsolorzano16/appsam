import 'dart:convert';
import 'package:appsam/src/models/planTerapeutico_model.dart';
import 'package:appsam/src/models/planTerapeutico_viewmodel.dart';
import 'package:http/http.dart' as http;

import 'package:appsam/src/utils/storage_util.dart';
import 'package:appsam/src/utils/utils.dart';

class PlanTerapeuticoService {
  final _apiURL = EnviromentVariables().getApiURL();

  Future<PlanTerapeuticoModel> addPlan(PlanTerapeuticoModel plan) async {
    final String token = StorageUtil.getString('token');
    final headers = {
      "content-type": "application/json",
      "accept": "application/json",
      'authorization': 'Bearer $token',
    };
    final url = '$_apiURL/api/PlanTerapeutico';

    final resp = await http.post(url,
        headers: headers, body: planTerapeuticoModelToJson(plan));

    if (resp.statusCode == 200 && resp.body.isNotEmpty) {
      final decodedData = json.decode(resp.body);
      final _plan = new PlanTerapeuticoModel.fromJson(decodedData);
      return _plan;
    }

    return null;
  }

  Future<PlanTerapeuticoViewModel> updatePlan(
      PlanTerapeuticoViewModel plan) async {
    final String token = StorageUtil.getString('token');
    final headers = {
      "content-type": "application/json",
      "accept": "application/json",
      'authorization': 'Bearer $token',
    };
    final url = '$_apiURL/api/PlanTerapeutico/edit';

    final resp = await http.put(url,
        headers: headers, body: planTerapeuticoViewModelToJson(plan));

    if (resp.statusCode == 200 && resp.body.isNotEmpty) {
      final decodedData = json.decode(resp.body);
      final _plan = new PlanTerapeuticoViewModel.fromJson(decodedData);
      return _plan;
    }

    return null;
  }

  Future<List<PlanTerapeuticoViewModel>> getPlanes(
      int pacienteId, String doctorId, int preclinicaId) async {
    final String token = StorageUtil.getString('token');
    final headers = {
      "content-type": "application/json",
      "accept": "application/json",
      'authorization': 'Bearer $token',
    };
    final url =
        '$_apiURL/api/PlanTerapeutico/movil/listar/pacienteId/$pacienteId/doctorId/$doctorId/preclinicaid/$preclinicaId';
    final List<PlanTerapeuticoViewModel> lista = new List();

    final resp = await http.get(url, headers: headers);

    if (resp.statusCode == 200 && resp.body.isNotEmpty) {
      final decodedData = json.decode(resp.body);
      decodedData.forEach((plan) {
        final planTemp = PlanTerapeuticoViewModel.fromJson(plan);
        lista.add(planTemp);
      });
      if (lista != null) return lista;
    }

    return [];
  }
}
