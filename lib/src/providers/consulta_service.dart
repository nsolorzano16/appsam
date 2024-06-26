import 'dart:convert';
import 'dart:io';
import 'package:appsam/src/models/consultaGeneral_model.dart';
import 'package:appsam/src/models/expediente_model.dart';
import 'package:http/http.dart' as http;

import 'package:appsam/src/models/consulta_model.dart';
import 'package:appsam/src/utils/storage_util.dart';
import 'package:appsam/src/utils/utils.dart';
import 'package:path_provider/path_provider.dart';

class ConsultaService {
  final _apiURL = EnviromentVariables().getApiURL();

  Future<ConsultaModel> getDetalleConsulta(
      int pacienteId, String doctorId, int preclinicaId) async {
    final String token = StorageUtil.getString('token');
    final headers = {
      "content-type": "application/json",
      "accept": "application/json",
      'authorization': 'Bearer $token',
    };
    final url =
        '$_apiURL/api/Consulta/pacienteId/$pacienteId/doctorId/$doctorId/preclinicaId/$preclinicaId';

    final resp = await http.get(url, headers: headers);

    if (resp.statusCode == 200 && resp.body.isNotEmpty) {
      final decodedData = json.decode(resp.body);
      final consulta = new ConsultaModel.fromJson(decodedData);
      return consulta;
    }

    return null;
  }

  Future<ConsultaGeneralModel> addConsultaGeneral(
      ConsultaGeneralModel consultaGeneral) async {
    final String token = StorageUtil.getString('token');
    final headers = {
      "content-type": "application/json",
      "accept": "application/json",
      'authorization': 'Bearer $token',
    };
    final url = '$_apiURL/api/Consulta';

    final resp = await http.post(url,
        headers: headers, body: consultaGeneralModelToJson(consultaGeneral));

    if (resp.statusCode == 200 && resp.body.isNotEmpty) {
      final decodedData = json.decode(resp.body);
      final consulta = new ConsultaGeneralModel.fromJson(decodedData);
      return consulta;
    }
    return null;
  }

  Future<ConsultaGeneralModel> updateConsultaGeneral(
      ConsultaGeneralModel consultaGeneral) async {
    final String token = StorageUtil.getString('token');
    final headers = {
      "content-type": "application/json",
      "accept": "application/json",
      'authorization': 'Bearer $token',
    };
    final url = '$_apiURL/api/Consulta';
    final resp = await http.put(url,
        headers: headers, body: consultaGeneralModelToJson(consultaGeneral));

    if (resp.statusCode == 200 && resp.body.isNotEmpty) {
      final decodedData = json.decode(resp.body);
      final consulta = new ConsultaGeneralModel.fromJson(decodedData);
      return consulta;
    }

    return null;
  }

  Future<ConsultaGeneralModel> getConsultaGeneral(
      int pacienteId, String doctorId, int preclinicaId) async {
    final String token = StorageUtil.getString('token');
    final headers = {
      "content-type": "application/json",
      "accept": "application/json",
      'authorization': 'Bearer $token',
    };
    final url =
        '$_apiURL/api/Consulta/getconsultageneral/pacienteid/$pacienteId/doctorid/$doctorId/preclinicaid/$preclinicaId';

    final resp = await http.get(url, headers: headers);

    if (resp.statusCode == 200 && resp.body.isNotEmpty) {
      final decodedData = json.decode(resp.body);
      final consulta = new ConsultaGeneralModel.fromJson(decodedData);
      return consulta;
    }

    return null;
  }

  Future<ExpedienteViewModel> getExpediente(
      int pacienteId, String doctorId) async {
    final String token = StorageUtil.getString('token');
    final headers = {
      "content-type": "application/json",
      "accept": "application/json",
      'authorization': 'Bearer $token',
    };
    final url =
        '$_apiURL/api/Consulta/expediente/pacienteid/$pacienteId/doctorid/$doctorId';

    final resp = await http.get(url, headers: headers);

    if (resp.statusCode == 200 && resp.body.isNotEmpty) {
      final decodedData = json.decode(resp.body);
      final consulta = new ExpedienteViewModel.fromJson(decodedData);
      return consulta;
    }

    return null;
  }

  Future<File> getExpedientePDF(int pacienteId, String doctorId) async {
    final String token = StorageUtil.getString('token');
    final headers = {
      "content-type": "application/json",
      "accept": "application/json",
      'authorization': 'Bearer $token',
    };
    final url =
        '$_apiURL/api/Consulta/pdf/expediente/pacienteid/$pacienteId/doctorid/$doctorId';

    final resp = await http.get(url, headers: headers);

    if (resp.statusCode == 200) {
      var bytes = resp.bodyBytes;

      Directory appDocDir = await getApplicationDocumentsDirectory();
      String dir = appDocDir.path;
      File file = new File('$dir/expediente.pdf');
      await file.writeAsBytes(bytes);
      return file;
    }

    return null;
  }
}
