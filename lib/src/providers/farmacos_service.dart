import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:appsam/src/utils/storage_util.dart';
import 'package:appsam/src/models/farmacosUsoActual_model.dart';
import 'package:appsam/src/utils/utils.dart';

class FarmacosUsoActualService {
  final _apiURL = EnviromentVariables().getApiURL();

  Future<List<FarmacosUsoActual>> addListaFarmacos(
      List<FarmacosUsoActual> farmacos) async {
    final String token = StorageUtil.getString('token');
    final List<FarmacosUsoActual> lista = new List();
    final headers = {
      "content-type": "application/json",
      "accept": "application/json",
      'authorization': 'Bearer $token',
    };
    final url = '$_apiURL/api/FarmacosUsoActual';

    final resp = await http.post(url,
        headers: headers, body: farmacosUsoActualToJsonList(farmacos));

    if (resp.statusCode == 200 && resp.body.isNotEmpty) {
      final decodedData = json.decode(resp.body);
      decodedData.forEach((farmaco) {
        final farmacoTemp = FarmacosUsoActual.fromJson(farmaco);
        lista.add(farmacoTemp);
      });
      if (lista != null) {
        return lista;
      }
    }

    return [];
  }

  Future<List<FarmacosUsoActual>> updateListaFarmacos(
      List<FarmacosUsoActual> farmacos) async {
    final List<FarmacosUsoActual> lista = new List();
    final String token = StorageUtil.getString('token');
    final headers = {
      "content-type": "application/json",
      "accept": "application/json",
      'authorization': 'Bearer $token',
    };
    final url = '$_apiURL/api/FarmacosUsoActual';

    final resp = await http.put(url,
        headers: headers, body: farmacosUsoActualToJsonList(farmacos));

    if (resp.statusCode == 200 && resp.body.isNotEmpty) {
      final decodedData = json.decode(resp.body);
      decodedData.forEach((farmaco) {
        final farmacoTemp = FarmacosUsoActual.fromJson(farmaco);
        lista.add(farmacoTemp);
      });
      if (lista != null) return lista;
    }

    return [];
  }

  Future<bool> desactivar(FarmacosUsoActual farmaco) async {
    final String token = StorageUtil.getString('token');
    final headers = {
      "content-type": "application/json",
      "accept": "application/json",
      'authorization': 'Bearer $token',
    };
    final url = '$_apiURL/api/FarmacosUsoActual/desactivar';
    final resp = await http.put(url,
        headers: headers, body: farmacosUsoActualToJson(farmaco));

    if (resp.statusCode == 200) return true;

    return false;
  }

  Future<List<FarmacosUsoActual>> getFarmacos(
      int pacienteId, int doctorId) async {
    final String token = StorageUtil.getString('token');
    final headers = {
      "content-type": "application/json",
      "accept": "application/json",
      'authorization': 'Bearer $token',
    };
    final url =
        '$_apiURL/api/FarmacosUsoActual/pacienteId/$pacienteId/doctorId/$doctorId';
    final List<FarmacosUsoActual> lista = new List();

    final resp = await http.get(url, headers: headers);

    if (resp.statusCode == 200 && resp.body.isNotEmpty) {
      final decodedData = json.decode(resp.body);
      decodedData.forEach((farmaco) {
        final farmacoTemp = FarmacosUsoActual.fromJson(farmaco);
        lista.add(farmacoTemp);
      });
      if (lista != null) return lista;
    }

    return [];
  }
}
