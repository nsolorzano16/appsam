import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:appsam/src/models/consulta_model.dart';
import 'package:appsam/src/utils/storage_util.dart';
import 'package:appsam/src/utils/utils.dart';

class ConsultaService {
  final _apiURL = EnviromentVariables().getApiURL();

  Future<bool> addConsulta(ConsultaModel consulta) async {
    final String token = StorageUtil.getString('token');
    final headers = {
      "content-type": "application/json",
      "accept": "application/json",
      'authorization': 'Bearer $token',
    };
    final url = '$_apiURL/api/Consulta';
    final resp =
        await http.post(url, headers: headers, body: consultaToJson(consulta));

    //print(resp.body);
    if (resp.statusCode == 200) {
      return true;
    }
    return false;
  }
}
