import 'dart:convert';
import 'package:appsam/src/models/notas_model.dart';
import 'package:http/http.dart' as http;

import 'package:appsam/src/utils/storage_util.dart';
import 'package:appsam/src/utils/utils.dart';

class NotasService {
  final _apiURL = EnviromentVariables().getApiURL();

  Future<List<Notas>> addListaNotas(List<Notas> notas) async {
    final String token = StorageUtil.getString('token');
    final headers = {
      "content-type": "application/json",
      "accept": "application/json",
      'authorization': 'Bearer $token',
    };
    final url = '$_apiURL/api/Notas';
    final List<Notas> lista = new List();

    final resp =
        await http.post(url, headers: headers, body: notasToJsonList(notas));
    final decodedData = json.decode(resp.body);

    if (resp.statusCode == 200) {
      decodedData.forEach((nota) {
        final notaTemp = Notas.fromJson(nota);
        lista.add(notaTemp);
      });
      if (lista != null) {
        return lista;
      }
    }

    return [];
  }

  Future<List<Notas>> updateListaNotas(List<Notas> notas) async {
    final String token = StorageUtil.getString('token');
    final headers = {
      "content-type": "application/json",
      "accept": "application/json",
      'authorization': 'Bearer $token',
    };
    final url = '$_apiURL/api/Notas';
    final List<Notas> lista = new List();

    final resp =
        await http.put(url, headers: headers, body: notasToJsonList(notas));
    final decodedData = json.decode(resp.body);

    if (resp.statusCode == 200) {
      decodedData.forEach((nota) {
        final notaTemp = Notas.fromJson(nota);
        lista.add(notaTemp);
      });
      if (lista != null) return lista;
    }

    return [];
  }

  Future<bool> desactivar(Notas nota) async {
    final String token = StorageUtil.getString('token');
    final headers = {
      "content-type": "application/json",
      "accept": "application/json",
      'authorization': 'Bearer $token',
    };
    final url = '$_apiURL/api/Notas/desactivar';

    //print(usuarioModelToJson(usuario));
    final resp = await http.put(url, headers: headers, body: notasToJson(nota));

    if (resp.statusCode == 200) return true;

    return false;
  }

  Future<List<Notas>> getNotas(
      int pacienteId, int doctorId, int preclinicaId) async {
    final String token = StorageUtil.getString('token');
    final headers = {
      "content-type": "application/json",
      "accept": "application/json",
      'authorization': 'Bearer $token',
    };
    final url =
        '$_apiURL/api/Notas/pacienteId/$pacienteId/doctorId/$doctorId/preclinicaid/$preclinicaId';
    final List<Notas> lista = new List();

    final resp = await http.get(url, headers: headers);

    if (resp.statusCode == 200 && resp.body.isNotEmpty) {
      final decodedData = json.decode(resp.body);
      decodedData.forEach((nota) {
        final notaTemp = Notas.fromJson(nota);
        lista.add(notaTemp);
      });
      if (lista != null) return lista;
    }

    return [];
  }
}
