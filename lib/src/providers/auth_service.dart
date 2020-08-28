import 'dart:convert';

import 'package:appsam/src/models/auth_responseLogin_model.dart';
import 'package:appsam/src/models/change_password_model.dart';
import 'package:appsam/src/models/reset_password_response_model.dart';
import 'package:http/http.dart' as http;
import 'package:appsam/src/models/login_model.dart';
import 'package:appsam/src/utils/utils.dart';

class AuthService {
  final _apiURL = EnviromentVariables().getApiURL();
  final headers = {
    "content-type": "application/json",
    "accept": "application/json",
  };

  Future<AuthResponseLoginModel> login(String usuario, String password) async {
    final login = new LoginModel();
    login.userName = usuario;
    login.password = password;

    final resp = await http.post('$_apiURL/api/Auth/login',
        headers: headers, body: loginModelToJson(login));

    if (resp.statusCode == 200 && resp.body.isNotEmpty) {
      final decodedData = json.decode(resp.body);
      final authResponse = new AuthResponseLoginModel.fromJson(decodedData);

      return authResponse;
    }

    return null;
  }

  Future<ResetPasswordResponseModel> resetPassword(String email) async {
    Map model = <String, String>{"email": email};

    final resp = await http.post('$_apiURL/api/Auth/resetpassword',
        headers: headers, body: json.encode(model));

    if (resp.statusCode == 200 && resp.body.isNotEmpty) {
      final decodedData = json.decode(resp.body);
      final authResponse = new ResetPasswordResponseModel.fromJson(decodedData);

      return authResponse;
    }

    return null;
  }

  Future<bool> changePassword(ChangePasswordModel model) async {
    final resp = await http.post('$_apiURL/api/Auth/changepassword',
        headers: headers, body: changePasswordModelToJson(model));
    if (resp.statusCode == 200) {
      return true;
    }

    return false;
  }
}
