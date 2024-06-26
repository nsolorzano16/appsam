import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:appsam/src/models/preclinica_model.dart';
import 'package:appsam/src/models/paginados/preclinica_paginadoVM.dart';
import 'package:appsam/src/utils/storage_util.dart';
import 'package:appsam/src/utils/utils.dart';

class PreclinicaService {
  final _apiURL = EnviromentVariables().getApiURL();

  Future<PreclinicaPaginadoViewModel> getpreclinicasPaginado(
      int page, String doctorId, int atendida) async {
    final String token = StorageUtil.getString('token');
    final headers = {
      "content-type": "application/json",
      "accept": "application/json",
      'authorization': 'Bearer $token',
    };
    final url =
        '$_apiURL/api/Preclinica/page/$page/limit/50/doctorId/$doctorId/atendida/$atendida';
    final resp = await http.get(url, headers: headers);
    if (resp.statusCode == 200 && resp.body.isNotEmpty) {
      Map<String, dynamic> decodeResp = json.decode(resp.body);
      var preclinicas = new PreclinicaPaginadoViewModel();
      preclinicas = PreclinicaPaginadoViewModel.fromJson(decodeResp);
      return preclinicas;
    }
    return null;
  }

  Future<bool> addPreclinica(Preclinica preclinica) async {
    final String token = StorageUtil.getString('token');
    final headers = {
      "content-type": "application/json",
      "accept": "application/json",
      'authorization': 'Bearer $token',
    };
    final url = '$_apiURL/api/Preclinica';
    final resp = await http.post(url,
        headers: headers, body: preclinicaToJson(preclinica));

    if (resp.statusCode == 200) {
      return true;
    }
    return false;
  }

  Future<PreclinicaViewModel> updatePreclinica(
      PreclinicaViewModel preclinica) async {
    final String token = StorageUtil.getString('token');
    final headers = {
      "content-type": "application/json",
      "accept": "application/json",
      'authorization': 'Bearer $token',
    };
    final url = '$_apiURL/api/Preclinica';

    final resp = await http.put(url,
        headers: headers, body: preclinicaViewModelToJson(preclinica));

    if (resp.statusCode == 200 && resp.body.isNotEmpty) {
      final decodedData = json.decode(resp.body);
      final preclinica = new PreclinicaViewModel.fromJson(decodedData);
      return preclinica;
    }

    return null;
  }
}
