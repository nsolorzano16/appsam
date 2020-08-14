import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime_type/mime_type.dart';

import 'package:appsam/src/models/asistentes_paginado_model.dart';
import 'package:appsam/src/models/usuario_model.dart';
import 'package:appsam/src/utils/storage_util.dart';
import 'package:appsam/src/utils/utils.dart';

class UsuarioProvider {
  final _apiURL = EnviromentVariables().getApiURL();

  final headers = {
    "content-type": "application/json",
    "accept": "application/json",
  };
  Future<Map<String, dynamic>> login(String usuario, String password) async {
    final loginJson = {'Usuario': usuario, 'Password': password};

    final resp = await http.post('$_apiURL/api/Usuarios/Login',
        headers: headers, body: json.encode(loginJson));
    Map<String, dynamic> decodeResp = json.decode(resp.body);

    if (resp.statusCode == 200) {
      if (decodeResp.containsKey('token')) {
        StorageUtil.putString('token', decodeResp['token']);
        // StorageUtil.putInt('usuarioId', decodeResp['usuarioId']);
        // StorageUtil.putInt('rolId', decodeResp['rolId']);
        // StorageUtil.putString('userName', decodeResp['userName']);
        // StorageUtil.putString('email', decodeResp['email']);
        // StorageUtil.putString('nombres', decodeResp['nombres']);
        // StorageUtil.putString('primerApellido', decodeResp['primerApellido']);
        // StorageUtil.putString('segundoApellido', decodeResp['segundoApellido']);
        StorageUtil.putString('fotoUrl', decodeResp['fotoUrl']);

        return {
          'ok': true,
          'usuario': decodeResp['usuario'],
          'token': decodeResp['token'],
          'plan': decodeResp['plan'],
          'consultasAtendidas': decodeResp['consultasAtendidas']
        };
      }
    }
    return {
      'ok': false,
      'mensaje': 'Credenciales '
          'incorrectas o el usuario no existe'
    };
  }

  Future<AsistentesPaginadoModel> getAsistentesPaginado(
      int page, String filter, int doctorId) async {
    final String token = StorageUtil.getString('token');
    final headers = {
      "content-type": "application/json",
      "accept": "application/json",
      'authorization': 'Bearer $token',
    };

    var httpClient = http.Client();
    try {
      var resp = await httpClient.get(
          '$_apiURL/api/Usuarios/asistentes/page/$page/limit/50/doctorid/$doctorId?filter=$filter',
          headers: headers);
      Map<String, dynamic> decodeResp = json.decode(resp.body);
      var asistentes = new AsistentesPaginadoModel();
      asistentes = AsistentesPaginadoModel.fromJson(decodeResp);
      return asistentes;
    } finally {
      httpClient.close();
    }
  }

  Future<bool> addAsistente(UsuarioModel usuario) async {
    // final String token = StorageUtil.getString('token');
    final headers = {
      "content-type": "application/json",
      "accept": "application/json",
      //'authorization': 'Bearer $token',
    };
    final url = '$_apiURL/api/usuarios';

    final resp = await http.post(url,
        headers: headers, body: usuarioModelToJson(usuario));

    if (resp.statusCode == 200) return true;

    return false;
  }

  Future<UsuarioModel> updateAsistente(UsuarioModel usuario) async {
    final String token = StorageUtil.getString('token');
    final headers = {
      "content-type": "application/json",
      "accept": "application/json",
      'authorization': 'Bearer $token',
    };
    final url = '$_apiURL/api/usuarios';

    final resp = await http.put(url,
        headers: headers, body: usuarioModelToJson(usuario));

    if (resp.statusCode == 200 && resp.body.isNotEmpty) {
      final decodedData = json.decode(resp.body);
      final usuario = new UsuarioModel.fromJson(decodedData);
      return usuario;
    }

    return null;
  }

  Future<UsuarioModel> resetPassword(
      int id, String password, String modificadoPor) async {
    final String token = StorageUtil.getString('token');
    final headersas = {
      "content-type": "application/json",
      "accept": "application/json",
      'authorization': 'Bearer $token',
    };
    final resetModel = {
      'id': id,
      'password': password,
      'modificadoPor': modificadoPor
    };

    final resp = await http.put('$_apiURL/api/Usuarios/changePassword',
        headers: headersas, body: json.encode(resetModel));

    if (resp.statusCode == 200 && resp.body.isNotEmpty) {
      final decodedData = json.decode(resp.body);
      final usuario = new UsuarioModel.fromJson(decodedData);
      return usuario;
    }

    return null;
  }

  Future<UsuarioModel> getMyInfo(int id) async {
    final String token = StorageUtil.getString('token');
    final headers = {
      "content-type": "application/json",
      "accept": "application/json",
      'authorization': 'Bearer $token',
    };
    final resp =
        await http.get('$_apiURL/api/Usuarios/info/$id', headers: headers);

    if (resp.statusCode == 200 && resp.body.isNotEmpty) {
      final decodedData = json.decode(resp.body);
      final usuario = new UsuarioModel.fromJson(decodedData);
      return usuario;
    }

    return null;
  }

  Future<UsuarioModel> subirFotoApi(int id, File imagen) async {
    final String token = StorageUtil.getString('token');
    final headers = {
      "content-type": "application/json",
      "accept": "application/json",
      'authorization': 'Bearer $token',
    };
    final url = Uri.parse('$_apiURL/api/Usuarios/profilefoto/$id');
    final mimeType = mime(imagen.path).split('/');
    final imageUploadRequest = http.MultipartRequest('POST', url);

    final file = await http.MultipartFile.fromPath('logoImage', imagen.path,
        contentType: MediaType(mimeType[0], mimeType[1]));
    imageUploadRequest.files.add(file);
    imageUploadRequest.headers.addAll(headers);
    final streamResponse = await imageUploadRequest.send();
    final resp = await http.Response.fromStream(streamResponse);
    if (resp.statusCode != 200 && resp.statusCode != 201) {
      return null;
    }
    final decodedData = json.decode(resp.body);
    final usuario = new UsuarioModel.fromJson(decodedData);
    return usuario;
  }
}
