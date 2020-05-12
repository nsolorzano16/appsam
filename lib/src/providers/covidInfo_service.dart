import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:appsam/src/models/covidInfo_model.dart';

class CovidInfoService {
  final _apiURL = 'https://api.covid19api.com';

  Future<List<CovidInfoModel>> getDayOne() async {
    final url = '$_apiURL/total/dayone/country/honduras';
    final resp = await http.get(url);
    final decodeResp = json.decode(resp.body);

    if (decodeResp == null) return [];

    final List<CovidInfoModel> lista = new List();

    decodeResp.forEach((info) {
      final infoTemp = CovidInfoModel.fromJson(info);
      lista.add(infoTemp);
    });

    if (resp.statusCode == 200 && lista != null) {
      return lista;
    }
    return [];
  }

  Future<ReporteGlobalModel> resumenCovid19() async {
    final url = '$_apiURL/summary';
    final resp = await http.get(url);
    final decodeResp = json.decode(resp.body);

    if (resp.statusCode == 200 && decodeResp.isNotEmpty) {
      final decodedData = json.decode(resp.body);
      final antecedente = new ReporteGlobalModel.fromJson(decodedData);
      return antecedente;
    }

    return null;
  }
}
