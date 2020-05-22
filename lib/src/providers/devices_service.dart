import 'dart:convert';
import 'package:appsam/src/models/device_model.dart';
import 'package:http/http.dart' as http;

import 'package:appsam/src/utils/storage_util.dart';
import 'package:appsam/src/utils/utils.dart';

class DevicesService {
  final _apiURL = EnviromentVariables().getApiURL();

  Future<DevicesModel> addDevice(DevicesModel device) async {
    final String token = StorageUtil.getString('token');
    final headers = {
      "content-type": "application/json",
      "accept": "application/json",
      'authorization': 'Bearer $token',
    };
    final url = '$_apiURL/api/Devices';

    final resp = await http.post(url,
        headers: headers, body: devicesModelToJson(device));

    if (resp.statusCode == 200) {
      final decodedData = json.decode(resp.body);
      final dev = new DevicesModel.fromJson(decodedData);
      return dev;
    }

    return null;
  }
} // fin clase
