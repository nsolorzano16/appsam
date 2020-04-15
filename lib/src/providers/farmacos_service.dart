import 'dart:convert';
import 'package:appsam/src/models/farmacosUsoActual_model.dart';
import 'package:http/http.dart' as http;
import 'package:appsam/src/utils/storage_util.dart';

import 'package:appsam/src/utils/utils.dart';

class FarmacosUsoActualService {
  final _apiURL = EnviromentVariables().getApiURL();

  Future<List<FarmacosUsoActual>> addListaFarmacos(
      List<FarmacosUsoActual> farmacos) async {
    final String token = StorageUtil.getString('token');
    final headers = {
      "content-type": "application/json",
      "accept": "application/json",
      'authorization': 'Bearer $token',
    };
    final url = '$_apiURL/api/FarmacosUsoActual';
    final List<FarmacosUsoActual> lista = new List();

    final resp = await http.post(url,
        headers: headers, body: farmacosUsoActualToJsonList(farmacos));
    final decodedData = json.decode(resp.body);
    //print(decodedData);

    if (resp.statusCode == 200) {
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
    final String token = StorageUtil.getString('token');
    final headers = {
      "content-type": "application/json",
      "accept": "application/json",
      'authorization': 'Bearer $token',
    };
    final url = '$_apiURL/api/FarmacosUsoActual';
    final List<FarmacosUsoActual> lista = new List();

    final resp = await http.put(url,
        headers: headers, body: farmacosUsoActualToJsonList(farmacos));
    final decodedData = json.decode(resp.body);

    if (resp.statusCode == 200) {
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

    //print(usuarioModelToJson(usuario));
    final resp = await http.put(url,
        headers: headers, body: farmacosUsoActualToJson(farmaco));

    // final decodedData = json.decode(resp.body);

    // print(decodedData);

    if (resp.statusCode == 200) return true;

    return false;
  }
}
