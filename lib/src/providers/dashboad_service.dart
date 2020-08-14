import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:appsam/src/models/dashboard/total_pacientes_anio_mes.dart';
import 'package:appsam/src/utils/storage_util.dart';
import 'package:appsam/src/utils/utils.dart';

class DashboardService {
  final _apiURL = EnviromentVariables().getApiURL();

  Future<List<TotalPacientesAnioMes>> getTotalPacienteAnioMes(
      String username) async {
    final List<TotalPacientesAnioMes> lista = new List();

    final String token = StorageUtil.getString('token');
    final headers = {
      "content-type": "application/json",
      "accept": "application/json",
      'authorization': 'Bearer $token',
    };
    final url =
        '$_apiURL/api/Dashboard/totalpacientesaniomes/username/$username';

    //print(usuarioModelToJson(usuario));
    final resp = await http.get(
      url,
      headers: headers,
    );

    if (resp.statusCode == 200 && resp.body.isNotEmpty) {
      final decodedData = json.decode(resp.body);
      decodedData.forEach((item) {
        final itemTemp = TotalPacientesAnioMes.fromJson(item);
        lista.add(itemTemp);
      });
      return lista;
    }

    return [];
  }
}
