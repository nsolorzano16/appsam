import 'dart:convert';

import 'package:appsam/src/models/paciente_model.dart';
import 'package:appsam/src/utils/storage_util.dart';
import 'package:appsam/src/utils/utils.dart';
import 'package:http/http.dart' as http;

class PacientesService {
  final _apiURL = EnviromentVariables().getApiURL();

  Future<PacientePaginadoModel> getPacientesPaginado(
      int page, String filter) async {
    final String token = StorageUtil.getString('token');
    final headers = {
      "content-type": "application/json",
      "accept": "application/json",
      'authorization': 'Bearer $token',
    };
    final url = '$_apiURL/api/Pacientes/page/$page/limit/50?filter=$filter';
    final resp = await http.get(url, headers: headers);
    Map<String, dynamic> decodeResp = json.decode(resp.body);
    var pacientes = new PacientePaginadoModel();
    pacientes = PacientePaginadoModel.fromJson(decodeResp);
    if (resp.statusCode == 200 && pacientes != null) {
      return pacientes;
    }
    return null;
  }

  Future<bool> addPaciente(Paciente paciente) async {
    final String token = StorageUtil.getString('token');
    final headers = {
      "content-type": "application/json",
      "accept": "application/json",
      'authorization': 'Bearer $token',
    };
    final url = '$_apiURL/api/Pacientes';

    //print(usuarioModelToJson(usuario));
    final resp =
        await http.post(url, headers: headers, body: pacienteToJson(paciente));
    print('${resp.body} ESTE ES EL BODY DE ADD PACIENTE');
    if (resp.statusCode == 200) return true;

    return false;
  }

  Future<bool> updatePaciente(Paciente paciente) async {
    final String token = StorageUtil.getString('token');
    final headers = {
      "content-type": "application/json",
      "accept": "application/json",
      'authorization': 'Bearer $token',
    };
    final url = '$_apiURL/api/Pacientes';

    //print(usuarioModelToJson(usuario));
    final resp =
        await http.put(url, headers: headers, body: pacienteToJson(paciente));
    if (resp.statusCode == 200) return true;

    return false;
  }
}
