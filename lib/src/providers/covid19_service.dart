import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:appsam/src/models/dashboard/summaryCovid19_model.dart';

const _apiURL = 'https://api.covid19api.com';

class CovidService {
  Future<SummaryCovid19Model> getSumary() async {
    final headers = {
      "content-type": "application/json",
      "accept": "application/json",
    };
    final url = '$_apiURL/summary';
    final resp = await http.get(
      url,
      headers: headers,
    );

    if (resp.statusCode == 200 && resp.body.isNotEmpty) {
      final decodedData = json.decode(resp.body);
      final antecedente = new SummaryCovid19Model.fromJson(decodedData);
      return antecedente;
    }

    return null;
  }
}
