import 'dart:convert';
import 'package:appsam/src/models/examenesIndicados_viewmodel.dart';
import 'package:http/http.dart' as http;

import 'package:appsam/src/models/examenIndicado_Model.dart';
import 'package:appsam/src/utils/storage_util.dart';
import 'package:appsam/src/utils/utils.dart';

class ExamenesService {
  final _apiURL = EnviromentVariables().getApiURL();

  Future<ExamenIndicadoModel> addExamen(ExamenIndicadoModel examen) async {
    final String token = StorageUtil.getString('token');
    final headers = {
      "content-type": "application/json",
      "accept": "application/json",
      'authorization': 'Bearer $token',
    };
    final url = '$_apiURL/api/ExamenIndicado';

    final resp = await http.post(url,
        headers: headers, body: examenIndicadoModelToJson(examen));
    final decodedData = json.decode(resp.body);

    if (resp.statusCode == 200) {
      final examen = new ExamenIndicadoModel.fromJson(decodedData);
      return examen;
    }

    return null;
  }

  Future<ExamenesIndicadosViewModel> updateExamen(
      ExamenesIndicadosViewModel examen) async {
    final String token = StorageUtil.getString('token');
    final headers = {
      "content-type": "application/json",
      "accept": "application/json",
      'authorization': 'Bearer $token',
    };
    final url = '$_apiURL/api/ExamenIndicado/edit';

    final resp = await http.put(url,
        headers: headers, body: examenesIndicadosViewModelToJson(examen));
    final decodedData = json.decode(resp.body);

    if (resp.statusCode == 200) {
      final examen = new ExamenesIndicadosViewModel.fromJson(decodedData);
      return examen;
    }

    return null;
  }

  Future<List<ExamenIndicadoModel>> getExamenesIndicados(
      int pacienteId, int doctorId, int preclinicaId) async {
    final String token = StorageUtil.getString('token');
    final headers = {
      "content-type": "application/json",
      "accept": "application/json",
      'authorization': 'Bearer $token',
    };
    final url =
        '$_apiURL/api/ExamenIndicado/listar/pacienteId/$pacienteId/doctorId/$doctorId/preclinicaid/$preclinicaId';
    final List<ExamenIndicadoModel> lista = new List();

    final resp = await http.get(url, headers: headers);

    if (resp.statusCode == 200 && resp.body.isNotEmpty) {
      final decodedData = json.decode(resp.body);
      decodedData.forEach((examen) {
        final examenTemp = ExamenIndicadoModel.fromJson(examen);
        lista.add(examenTemp);
      });
      if (lista != null) return lista;
    }

    return [];
  }

  Future<List<ExamenesIndicadosViewModel>> getDetalleExamenesIndicados(
      int pacienteId, int doctorId, int preclinicaId) async {
    final String token = StorageUtil.getString('token');
    final headers = {
      "content-type": "application/json",
      "accept": "application/json",
      'authorization': 'Bearer $token',
    };
    final url =
        '$_apiURL/api/ExamenIndicado/detail/pacienteId/$pacienteId/doctorId/$doctorId/preclinicaid/$preclinicaId';
    final List<ExamenesIndicadosViewModel> lista = new List();

    final resp = await http.get(url, headers: headers);

    if (resp.statusCode == 200 && resp.body.isNotEmpty) {
      final decodedData = json.decode(resp.body);
      decodedData.forEach((examen) {
        final examenTemp = ExamenesIndicadosViewModel.fromJson(examen);
        if (examenTemp.examenDetalle != null) {
          examenTemp.examenDetalle = examenTemp.examenDetalle[0].toUpperCase() +
              examenTemp.examenDetalle.substring(1).toLowerCase();
        }
        lista.add(examenTemp);
      });
      if (lista != null) return lista;
    }

    return [];
  }
}
