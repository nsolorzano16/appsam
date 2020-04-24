import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:appsam/src/models/consulta_model.dart';
import 'package:appsam/src/utils/storage_util.dart';
import 'package:appsam/src/utils/utils.dart';

class ConsultaService {
  final _apiURL = EnviromentVariables().getApiURL();

  Future<ConsultaModel> getDetalleConsulta(
      int pacienteId, int doctorId, int preclinicaId) async {
    final String token = StorageUtil.getString('token');
    final headers = {
      "content-type": "application/json",
      "accept": "application/json",
      'authorization': 'Bearer $token',
    };
    final url =
        '$_apiURL/api/Consulta/pacienteId/$pacienteId/doctorId/$doctorId/preclinicaId/$preclinicaId';

    //print(usuarioModelToJson(usuario));
    final resp = await http.get(url, headers: headers);
    final decodedData = json.decode(resp.body);

    if (resp.statusCode == 200) {
      final consulta = new ConsultaModel.fromJson(decodedData);
      return consulta;
    }

    return null;
  }
}
