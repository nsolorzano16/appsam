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

    if (resp.statusCode == 200 && resp.body.isNotEmpty) {
      final decodedData = json.decode(resp.body);
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

    if (resp.statusCode == 200 && resp.body.isNotEmpty) {
      final decodedData = json.decode(resp.body);
      final examen = new ExamenFisico.fromJson(decodedData);
      return examen;
    }

    return null;
  }

  Future<ExamenFisico> getExamenFisico(
      int pacienteId, String doctorId, int preclinicaId) async {
    final String token = StorageUtil.getString('token');
    final headers = {
      "content-type": "application/json",
      "accept": "application/json",
      'authorization': 'Bearer $token',
    };
    final url =
        '$_apiURL/api/ExamenFisico/pacienteId/$pacienteId/doctorId/$doctorId/preclinicaId/$preclinicaId';

    final resp = await http.get(url, headers: headers);

    if (resp.statusCode == 200 && resp.body.isNotEmpty) {
      final decodedData = json.decode(resp.body);
      final antecedente = new ExamenFisico.fromJson(decodedData);
      return antecedente;
    }

    return null;
  }
} // fin clase
