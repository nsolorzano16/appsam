import 'dart:convert';
import 'dart:io';

import 'package:appsam/src/models/paginados/fotosPacientePaginado_model.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:appsam/src/models/fotosPaciente_model.dart';
import 'package:appsam/src/utils/storage_util.dart';
import 'package:appsam/src/utils/utils.dart';
import 'package:mime_type/mime_type.dart';

class FotosPacienteService {
  final _apiURL = EnviromentVariables().getApiURL();

  Future<FotosPacienteModel> updateFotosPaciente(
      FotosPacienteModel foto) async {
    final String token = StorageUtil.getString('token');
    final headers = {
      "content-type": "application/json",
      "accept": "application/json",
      'authorization': 'Bearer $token',
    };
    final url = '$_apiURL/api/FotosPaciente';

    //print(usuarioModelToJson(usuario));
    final resp = await http.put(url,
        headers: headers, body: fotosPacienteModelToJson(foto));

    if (resp.statusCode == 200) {
      final decodedData = json.decode(resp.body);
      final foto = new FotosPacienteModel.fromJson(decodedData);
      return foto;
    }

    return null;
  }

  Future<FotosPacientePaginadoModel> getFotosPacientePaginado(
      int page, String filter, int pacienteId) async {
    final String token = StorageUtil.getString('token');
    final headers = {
      "content-type": "application/json",
      "accept": "application/json",
      'authorization': 'Bearer $token',
    };

    var httpClient = http.Client();
    try {
      var resp = await httpClient.get(
          '$_apiURL/api/FotosPaciente/page/$page/limit/50/pacienteid/$pacienteId?filter=$filter',
          headers: headers);
      Map<String, dynamic> decodeResp = json.decode(resp.body);
      var fotos = new FotosPacientePaginadoModel();
      fotos = FotosPacientePaginadoModel.fromJson(decodeResp);
      return fotos;
    } finally {
      httpClient.close();
    }
  }

  Future<FotosPacienteModel> addFotoPaciente(
      int pacienteId, File imagen, String notas, String username) async {
    final String token = StorageUtil.getString('token');
    final headers = {
      "content-type": "application/json",
      "accept": "application/json",
      'authorization': 'Bearer $token',
    };

    Map<String, String> fields = {
      'notas': notas,
    };

    final url = Uri.parse(
        '$_apiURL/api/FotosPaciente/pacienteid/$pacienteId/username/$username');
    final mimeType = mime(imagen.path).split('/');
    final imageUploadRequest = http.MultipartRequest('POST', url);
    imageUploadRequest.headers.addAll(headers);
    imageUploadRequest.fields.addAll(fields);

    final file = await http.MultipartFile.fromPath('foto', imagen.path,
        contentType: MediaType(mimeType[0], mimeType[1]));

    imageUploadRequest.files.add(file);
    final streamResponse = await imageUploadRequest.send();
    final resp = await http.Response.fromStream(streamResponse);
    if (resp.statusCode != 200 && resp.statusCode != 201) {
      return null;
    }
    final decodedData = json.decode(resp.body);
    final foto = new FotosPacienteModel.fromJson(decodedData);
    return foto;
  }
}
