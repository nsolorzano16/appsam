import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:appsam/src/models/diagnosticos_model.dart';
import 'package:appsam/src/utils/storage_util.dart';
import 'package:appsam/src/utils/utils.dart';

class DiagnosticosService {
  final _apiURL = EnviromentVariables().getApiURL();

  Future<List<Diagnosticos>> addListaDiagnosticos(
      List<Diagnosticos> diagnosticos) async {
    final List<Diagnosticos> lista = new List();
    final String token = StorageUtil.getString('token');
    final headers = {
      "content-type": "application/json",
      "accept": "application/json",
      'authorization': 'Bearer $token',
    };
    final url = '$_apiURL/api/Diagnosticos';
    final resp = await http.post(url,
        headers: headers, body: diagnosticosToJsonList(diagnosticos));

    if (resp.statusCode == 200 && resp.body.isNotEmpty) {
      final decodedData = json.decode(resp.body);
      decodedData.forEach((diagnostico) {
        final diagnosticoTemp = Diagnosticos.fromJson(diagnostico);
        lista.add(diagnosticoTemp);
      });
      return lista;
    }
    return [];
  }

  Future<List<Diagnosticos>> updateListaDiagnosticos(
      List<Diagnosticos> diagnosticos) async {
    final String token = StorageUtil.getString('token');
    final headers = {
      "content-type": "application/json",
      "accept": "application/json",
      'authorization': 'Bearer $token',
    };
    final List<Diagnosticos> lista = new List();
    final url = '$_apiURL/api/Diagnosticos';

    final resp = await http.put(url,
        headers: headers, body: diagnosticosToJsonList(diagnosticos));
    final decodedData = json.decode(resp.body);

    if (resp.statusCode == 200 && resp.body.isNotEmpty) {
      decodedData.forEach((diagnostico) {
        final diagnosticoTemp = Diagnosticos.fromJson(diagnostico);
        lista.add(diagnosticoTemp);
      });
      return lista;
    }

    return [];
  }

  Future<bool> desactivar(Diagnosticos diagnostico) async {
    final String token = StorageUtil.getString('token');
    final headers = {
      "content-type": "application/json",
      "accept": "application/json",
      'authorization': 'Bearer $token',
    };
    final url = '$_apiURL/api/Diagnosticos/desactivar';

    final resp = await http.put(url,
        headers: headers, body: diagnosticosToJson(diagnostico));

    if (resp.statusCode == 200) return true;

    return false;
  }

  Future<List<Diagnosticos>> getDiagnosticos(
      int pacienteId, int doctorId, int preclinicaId) async {
    final String token = StorageUtil.getString('token');
    final List<Diagnosticos> lista = new List();
    final headers = {
      "content-type": "application/json",
      "accept": "application/json",
      'authorization': 'Bearer $token',
    };
    final url =
        '$_apiURL/api/Diagnosticos/pacienteId/$pacienteId/doctorId/$doctorId/preclinicaid/$preclinicaId';

    final resp = await http.get(url, headers: headers);

    if (resp.statusCode == 200 && resp.body.isNotEmpty) {
      final decodedData = json.decode(resp.body);
      decodedData.forEach((diagnostico) {
        final diagnosticoTemp = Diagnosticos.fromJson(diagnostico);
        lista.add(diagnosticoTemp);
      });
      if (lista != null) return lista;
    }

    return [];
  }
}
