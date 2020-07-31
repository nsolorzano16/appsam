import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:appsam/src/models/paginados/enfermedadesPaginado_model.dart';
import 'package:appsam/src/utils/storage_util.dart';
import 'package:appsam/src/utils/utils.dart';

class CieService {
  final _apiURL = EnviromentVariables().getApiURL();

  Future<EnfermedadesPaginadoModel> getEnfermedadesPaginado(
      int page, String filter) async {
    final String token = StorageUtil.getString('token');
    final headers = {
      "content-type": "application/json",
      "accept": "application/json",
      'authorization': 'Bearer $token',
    };
    final url = '$_apiURL/api/Cie/page/$page/limit/50?filter=$filter';
    final resp = await http.get(url, headers: headers);
    if (resp.statusCode == 200 && resp.body.isNotEmpty) {
      Map<String, dynamic> decodeResp = json.decode(resp.body);
      var enfermedades = new EnfermedadesPaginadoModel();
      enfermedades = EnfermedadesPaginadoModel.fromJson(decodeResp);

      return enfermedades;
    }

    return null;
  }
}
