import 'dart:convert';

import 'package:appsam/src/models/paginados/preclinica_paginadoVM.dart';
import 'package:appsam/src/utils/storage_util.dart';
import 'package:appsam/src/utils/utils.dart';
import 'package:http/http.dart' as http;

class PreclinicaService {
  final _apiURL = EnviromentVariables().getApiURL();

  Future<PreclinicaPaginadoViewModel> getpreclinicasPaginado(
      int page, int doctorId) async {
    final String token = StorageUtil.getString('token');
    final headers = {
      "content-type": "application/json",
      "accept": "application/json",
      'authorization': 'Bearer $token',
    };
    final url =
        '$_apiURL/api/Preclinica/page/$page/limit/50/doctorId/$doctorId';
    final resp = await http.get(url, headers: headers);
    Map<String, dynamic> decodeResp = json.decode(resp.body);
    var preclinicas = new PreclinicaPaginadoViewModel();
    preclinicas = PreclinicaPaginadoViewModel.fromJson(decodeResp);
    if (resp.statusCode == 200 && preclinicas != null) {
      return preclinicas;
    }
    return null;
  }
}
