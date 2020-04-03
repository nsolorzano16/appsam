import 'dart:convert';

import 'package:appsam/src/models/pacientes_model.dart';
import 'package:appsam/src/models/paginados/pacientesPaginado_model.dart';
import 'package:appsam/src/utils/storage_util.dart';
import 'package:appsam/src/utils/utils.dart';
import 'package:http/http.dart' as http;

class PacientesService {
  final _apiURL = EnviromentVariables().getApiURL();

  Future<PacientesPaginadoModel> getPacientesPaginado(
      int page, String filter, int doctorId) async {
    final String token = StorageUtil.getString('token');
    final headers = {
      "content-type": "application/json",
      "accept": "application/json",
      'authorization': 'Bearer $token',
    };
    final url =
        '$_apiURL/api/Pacientes/page/$page/limit/50/doctor/$doctorId?filter=$filter';
    final resp = await http.get(url, headers: headers);
    Map<String, dynamic> decodeResp = json.decode(resp.body);
    var pacientes = new PacientesPaginadoModel();
    pacientes = PacientesPaginadoModel.fromJson(decodeResp);
    if (resp.statusCode == 200 && pacientes != null) {
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
    print(pacienteModelToJson(paciente));

    final resp = await http.post(url,
        headers: headers, body: pacienteModelToJson(paciente));
    print("-------------------");

    print(resp.body);
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

    //print(usuarioModelToJson(usuario));
    final resp = await http.put(url,
        headers: headers, body: pacientesViewModelToJson(paciente));
    final decodedData = json.decode(resp.body);

    if (resp.statusCode == 200) {
      final usuario = new PacientesViewModel.fromJson(decodedData);
      return usuario;
    }

    return null;
  }
}
