import 'dart:convert';
import 'dart:io';
import 'package:appsam/src/models/create_user_viewmodel.dart';
import 'package:appsam/src/models/myinfo_viewmodel.dart';
import 'package:appsam/src/models/user_model.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime_type/mime_type.dart';

import 'package:appsam/src/models/asistentes_paginado_model.dart';
import 'package:appsam/src/utils/storage_util.dart';
import 'package:appsam/src/utils/utils.dart';

class UsuarioProvider {
  final _apiURL = EnviromentVariables().getApiURL();

  final headers = {
    "content-type": "application/json",
    "accept": "application/json",
  };

  Future<AsistentesPaginadoModel> getAsistentesPaginado(
      int page, String filter, String doctorId) async {
    final String token = StorageUtil.getString('token');
    final headers = {
      "content-type": "application/json",
      "accept": "application/json",
      'authorization': 'Bearer $token',
    };

    var httpClient = http.Client();
    try {
      var resp = await httpClient.get(
          '$_apiURL/api/User/assistants/page/$page/limit/50/doctorid/$doctorId?filter=$filter',
          headers: headers);
      Map<String, dynamic> decodeResp = json.decode(resp.body);
      var asistentes = new AsistentesPaginadoModel();
      asistentes = AsistentesPaginadoModel.fromJson(decodeResp);
      return asistentes;
    } finally {
      httpClient.close();
    }
  }

  Future<bool> addAsistente(CreateUserViewModel usuario) async {
    final String token = StorageUtil.getString('token');
    final headers = {
      "content-type": "application/json",
      "accept": "application/json",
      'authorization': 'Bearer $token',
    };
    final url = '$_apiURL/api/User/create';

    final resp = await http.post(url,
        headers: headers, body: createUserViewModelToJson(usuario));

    if (resp.statusCode == 200) return true;

    return false;
  }

  Future<UserModel> updateAsistente(UserModel usuario) async {
    final String token = StorageUtil.getString('token');
    final headers = {
      "content-type": "application/json",
      "accept": "application/json",
      'authorization': 'Bearer $token',
    };
    final url = '$_apiURL/api/User/edit';

    final resp =
        await http.put(url, headers: headers, body: userModelToJson(usuario));

    if (resp.statusCode == 200 && resp.body.isNotEmpty) {
      final decodedData = json.decode(resp.body);
      final usuario = new UserModel.fromJson(decodedData);
      return usuario;
    }

    return null;
  }

  Future<UserModel> resetPassword(
      String id, String password, String modificadoPor) async {
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
      final usuario = new UserModel.fromJson(decodedData);
      return usuario;
    }

    return null;
  }

  Future<MyInfoViewModel> getMyInfo(String id) async {
    final String token = StorageUtil.getString('token');
    final headers = {
      "content-type": "application/json",
      "accept": "application/json",
      'authorization': 'Bearer $token',
    };

    final resp =
        await http.get('$_apiURL/api/User/myinfo/id/$id', headers: headers);

    if (resp.statusCode == 200 && resp.body.isNotEmpty) {
      final decodedData = json.decode(resp.body);
      final myInfo = new MyInfoViewModel.fromJson(decodedData);
      return myInfo;
    }

    return null;
  }

  Future<UserModel> subirFotoApi(String id, File imagen) async {
    final String token = StorageUtil.getString('token');
    final headers = {
      "content-type": "application/json",
      "accept": "application/json",
      'authorization': 'Bearer $token',
    };
    final url = Uri.parse('$_apiURL/api/User/profilephoto/$id');
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
    final usuario = new UserModel.fromJson(decodedData);
    return usuario;
  }
}
