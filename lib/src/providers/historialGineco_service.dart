import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:appsam/src/utils/storage_util.dart';

import 'package:appsam/src/models/historialGinecoObstetra_model.dart';
import 'package:appsam/src/utils/utils.dart';

class HistorialGinecoObstetraService {
  final _apiURL = EnviromentVariables().getApiURL();

  Future<HistorialGinecoObstetra> addHistorial(
      HistorialGinecoObstetra historial) async {
    final String token = StorageUtil.getString('token');
    final headers = {
      "content-type": "application/json",
      "accept": "application/json",
      'authorization': 'Bearer $token',
    };
    final url = '$_apiURL/api/HistorialGinecoObstetra';

    final resp = await http.post(url,
        headers: headers, body: historialGinecoObstetraToJson(historial));

    if (resp.statusCode == 200 && resp.body.isNotEmpty) {
      final decodedData = json.decode(resp.body);
      final habito = new HistorialGinecoObstetra.fromJson(decodedData);
      return habito;
    }

    return null;
  }

  Future<HistorialGinecoObstetra> updateHistorial(
      HistorialGinecoObstetra historial) async {
    final String token = StorageUtil.getString('token');
    final headers = {
      "content-type": "application/json",
      "accept": "application/json",
      'authorization': 'Bearer $token',
    };
    final url = '$_apiURL/api/HistorialGinecoObstetra';

    final resp = await http.put(url,
        headers: headers, body: historialGinecoObstetraToJson(historial));

    if (resp.statusCode == 200 && resp.body.isNotEmpty) {
      final decodedData = json.decode(resp.body);
      final habito = new HistorialGinecoObstetra.fromJson(decodedData);
      return habito;
    }

    return null;
  }

  Future<HistorialGinecoObstetra> getHistorialGinecoObstetra(
      int pacienteId, int doctorId) async {
    final String token = StorageUtil.getString('token');
    final headers = {
      "content-type": "application/json",
      "accept": "application/json",
      'authorization': 'Bearer $token',
    };
    final url =
        '$_apiURL/api/HistorialGinecoObstetra/pacienteId/$pacienteId/doctorId/$doctorId';

    //print(usuarioModelToJson(usuario));
    final resp = await http.get(url, headers: headers);

    if (resp.statusCode == 200 && resp.body.isNotEmpty) {
      final decodedData = json.decode(resp.body);
      final historial = new HistorialGinecoObstetra.fromJson(decodedData);
      return historial;
    }

    return null;
  }
}
