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
    final decodedData = json.decode(resp.body);

    if (resp.statusCode == 200) {
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
    final decodedData = json.decode(resp.body);

    if (resp.statusCode == 200) {
      final habito = new HistorialGinecoObstetra.fromJson(decodedData);
      return habito;
    }

    return null;
  }
}