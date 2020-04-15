import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:appsam/src/models/examenFisico_model.dart';
import 'package:appsam/src/utils/storage_util.dart';
import 'package:appsam/src/utils/utils.dart';

class ExamenFisicoService {
  final _apiURL = EnviromentVariables().getApiURL();

  Future<ExamenFisico> addExamenFisico(ExamenFisico examenFisico) async {
    final String token = StorageUtil.getString('token');
    final headers = {
      "content-type": "application/json",
      "accept": "application/json",
      'authorization': 'Bearer $token',
    };
    final url = '$_apiURL/api/ExamenFisico';

    final resp = await http.post(url,
        headers: headers, body: examenFisicoToJson(examenFisico));
    final decodedData = json.decode(resp.body);

    if (resp.statusCode == 200) {
      final examen = new ExamenFisico.fromJson(decodedData);
      return examen;
    }

    return null;
  }

  Future<ExamenFisico> updateExamenFisico(ExamenFisico examenFisico) async {
    final String token = StorageUtil.getString('token');
    final headers = {
      "content-type": "application/json",
      "accept": "application/json",
      'authorization': 'Bearer $token',
    };
    final url = '$_apiURL/api/ExamenFisico';

    //print(usuarioModelToJson(usuario));
    final resp = await http.put(url,
        headers: headers, body: examenFisicoToJson(examenFisico));
    final decodedData = json.decode(resp.body);

    if (resp.statusCode == 200) {
      final examen = new ExamenFisico.fromJson(decodedData);
      return examen;
    }

    return null;
  }
} // fin clase
