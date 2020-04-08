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
    final decodedData = json.decode(resp.body);

    if (resp.statusCode == 200) {
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
} // fin clase
