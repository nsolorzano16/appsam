import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:appsam/src/models/antecedentesFamiliaresPersonales_model.dart';
import 'package:appsam/src/utils/storage_util.dart';
import 'package:appsam/src/utils/utils.dart';

class AntecedentesService {
  final _apiURL = EnviromentVariables().getApiURL();

  Future<AntecedentesFamiliaresPersonales> addAntecedentes(
      AntecedentesFamiliaresPersonales antecedentes) async {
    final String token = StorageUtil.getString('token');
    final headers = {
      "content-type": "application/json",
      "accept": "application/json",
      'authorization': 'Bearer $token',
    };
    final url = '$_apiURL/api/AntecedentesFamiliares';

    //print(usuarioModelToJson(usuario));
    final resp = await http.post(url,
        headers: headers,
        body: antecedentesFamiliaresPersonalesToJson(antecedentes));

    if (resp.statusCode == 200) {
      final decodedData = json.decode(resp.body);
      final antecedente =
          new AntecedentesFamiliaresPersonales.fromJson(decodedData);
      return antecedente;
    }

    return null;
  }

  Future<AntecedentesFamiliaresPersonales> updateAntecedentes(
      AntecedentesFamiliaresPersonales antecedentes) async {
    final String token = StorageUtil.getString('token');
    final headers = {
      "content-type": "application/json",
      "accept": "application/json",
      'authorization': 'Bearer $token',
    };
    final url = '$_apiURL/api/AntecedentesFamiliares';

    //print(usuarioModelToJson(usuario));
    final resp = await http.put(url,
        headers: headers,
        body: antecedentesFamiliaresPersonalesToJson(antecedentes));

    if (resp.statusCode == 200) {
      final decodedData = json.decode(resp.body);
      final antecedente =
          new AntecedentesFamiliaresPersonales.fromJson(decodedData);
      return antecedente;
    }

    return null;
  }

  Future<AntecedentesFamiliaresPersonales> getAntecedente(
      int pacienteId, int doctorId) async {
    final String token = StorageUtil.getString('token');
    final headers = {
      "content-type": "application/json",
      "accept": "application/json",
      'authorization': 'Bearer $token',
    };
    final url =
        '$_apiURL/api/AntecedentesFamiliares/pacienteId/$pacienteId/doctorId/$doctorId';

    //print(usuarioModelToJson(usuario));
    final resp = await http.get(
      url,
      headers: headers,
    );

    if (resp.statusCode == 200 && resp.body.isNotEmpty) {
      final decodedData = json.decode(resp.body);
      final antecedente =
          new AntecedentesFamiliaresPersonales.fromJson(decodedData);
      return antecedente;
    }

    return null;
  }
} // fin clase
