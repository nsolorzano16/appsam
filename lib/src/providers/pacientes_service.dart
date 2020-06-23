import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:appsam/src/models/pacientes_model.dart';
import 'package:appsam/src/models/paginados/pacientesPaginado_model.dart';
import 'package:appsam/src/utils/storage_util.dart';
import 'package:appsam/src/utils/utils.dart';

class PacientesService {
  final _apiURL = EnviromentVariables().getApiURL();

  Future<PacientesPaginadoModel> getPacientesPaginado(
      int page, String filter) async {
    final String token = StorageUtil.getString('token');
    final headers = {
      "content-type": "application/json",
      "accept": "application/json",
      'authorization': 'Bearer $token',
    };
    final url = '$_apiURL/api/Pacientes/page/$page/limit/50?filter=$filter';
    final resp = await http.get(url, headers: headers);
    if (resp.statusCode == 200 && resp.body.isNotEmpty) {
      Map<String, dynamic> decodeResp = json.decode(resp.body);
      var pacientes = new PacientesPaginadoModel();
      pacientes = PacientesPaginadoModel.fromJson(decodeResp);

      return pacientes;
    }

    return null;
  }

  Future<bool> addPaciente(PacienteModel paciente) async {
    final String token = StorageUtil.getString('token');
    final headers = {
      "content-type": "application/json",
      "accept": "application/json",
      'authorization': 'Bearer $token',
    };
    final url = '$_apiURL/api/Pacientes';

    final resp = await http.post(url,
        headers: headers, body: pacienteModelToJson(paciente));

    if (resp.statusCode == 200) return true;

    return false;
  }

  Future<PacientesViewModel> updatePaciente(PacientesViewModel paciente) async {
    final String token = StorageUtil.getString('token');
    final headers = {
      "content-type": "application/json",
      "accept": "application/json",
      'authorization': 'Bearer $token',
    };
    final url = '$_apiURL/api/Pacientes';

    final resp = await http.put(url,
        headers: headers, body: pacientesViewModelToJson(paciente));

    if (resp.statusCode == 200 && resp.body.isNotEmpty) {
      final decodedData = json.decode(resp.body);
      final paciente = new PacientesViewModel.fromJson(decodedData);
      return paciente;
    }

    return null;
  }
}
