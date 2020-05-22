import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:appsam/src/models/habitos_model.dart';
import 'package:appsam/src/utils/storage_util.dart';
import 'package:appsam/src/utils/utils.dart';

class HabitosService {
  final _apiURL = EnviromentVariables().getApiURL();

  Future<Habitos> addHabitos(Habitos habitos) async {
    final String token = StorageUtil.getString('token');
    final headers = {
      "content-type": "application/json",
      "accept": "application/json",
      'authorization': 'Bearer $token',
    };
    final url = '$_apiURL/api/Habitos';

    final resp =
        await http.post(url, headers: headers, body: habitosToJson(habitos));

    if (resp.statusCode == 200 && resp.body.isNotEmpty) {
      final decodedData = json.decode(resp.body);
      final habito = new Habitos.fromJson(decodedData);
      return habito;
    }

    return null;
  }

  Future<Habitos> updateHabitos(Habitos habitos) async {
    final String token = StorageUtil.getString('token');
    final headers = {
      "content-type": "application/json",
      "accept": "application/json",
      'authorization': 'Bearer $token',
    };
    final url = '$_apiURL/api/Habitos';

    final resp =
        await http.put(url, headers: headers, body: habitosToJson(habitos));
    final decodedData = json.decode(resp.body);

    if (resp.statusCode == 200) {
      final habito = new Habitos.fromJson(decodedData);
      return habito;
    }

    return null;
  }

  Future<Habitos> getHabito(int pacienteId, int doctorId) async {
    final String token = StorageUtil.getString('token');
    final headers = {
      "content-type": "application/json",
      "accept": "application/json",
      'authorization': 'Bearer $token',
    };
    final url =
        '$_apiURL/api/Habitos/pacienteId/$pacienteId/doctorId/$doctorId';

    //print(usuarioModelToJson(usuario));
    final resp = await http.get(
      url,
      headers: headers,
    );

    if (resp.statusCode == 200 && resp.body.isNotEmpty) {
      final decodedData = json.decode(resp.body);
      final habito = new Habitos.fromJson(decodedData);
      return habito;
    }

    return null;
  }
} // fin clase
