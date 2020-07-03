import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:appsam/src/models/notificacionesWeb_model.dart';

class WebNotificationService {
  Future<NotificacionesWebModel> getNotificacionesWebConsultas(
      int doctorId) async {
    var _url =
        'https://us-central1-sam-app-446ee.cloudfunctions.net/api/consulta/data/$doctorId';

    final resp = await http.get(_url);

    if (resp.statusCode == 200 && resp.body.isNotEmpty) {
      final decodedData = json.decode(resp.body);
      final antecedente = new NotificacionesWebModel.fromJson(decodedData);
      return antecedente;
    }

    return null;
  }

  Future<NotificacionesWebModel> getNotificacionesWebAgenda(
      int doctorId) async {
    // final headers = {
    //   "content-type": "application/json",
    //   "accept": "application/json",

    // };
    var _url =
        'https://us-central1-sam-app-446ee.cloudfunctions.net/api/agenda/data/$doctorId';

    final resp = await http.get(_url);

    if (resp.statusCode == 200 && resp.body.isNotEmpty) {
      final decodedData = json.decode(resp.body);
      final antecedente = new NotificacionesWebModel.fromJson(decodedData);
      return antecedente;
    }

    return null;
  }
}
