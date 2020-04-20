import 'dart:convert';
import 'package:appsam/src/models/examenFisicoGinecologico_model.dart';
import 'package:http/http.dart' as http;

import 'package:appsam/src/utils/storage_util.dart';
import 'package:appsam/src/utils/utils.dart';

class ExamenGinecologicoService {
  final _apiURL = EnviromentVariables().getApiURL();

  Future<ExamenFisicoGinecologico> addExamenGinecologico(
      ExamenFisicoGinecologico examenGinecologico) async {
    final String token = StorageUtil.getString('token');
    final headers = {
      "content-type": "application/json",
      "accept": "application/json",
      'authorization': 'Bearer $token',
    };
    final url = '$_apiURL/api/ExamenFisicoGinecologico';

    final resp = await http.post(url,
        headers: headers,
        body: examenFisicoGinecologicoToJson(examenGinecologico));
    final decodedData = json.decode(resp.body);

    if (resp.statusCode == 200) {
      final examen = new ExamenFisicoGinecologico.fromJson(decodedData);
      return examen;
    }

    return null;
  }

  Future<ExamenFisicoGinecologico> updateExamenGinecologico(
      ExamenFisicoGinecologico examenGinecologico) async {
    final String token = StorageUtil.getString('token');
    final headers = {
      "content-type": "application/json",
      "accept": "application/json",
      'authorization': 'Bearer $token',
    };
    final url = '$_apiURL/api/ExamenFisicoGinecologico';

    //print(usuarioModelToJson(usuario));
    final resp = await http.put(url,
        headers: headers,
        body: examenFisicoGinecologicoToJson(examenGinecologico));
    final decodedData = json.decode(resp.body);

    if (resp.statusCode == 200) {
      final examen = new ExamenFisicoGinecologico.fromJson(decodedData);
      return examen;
    }

    return null;
  }
} // fin clase
