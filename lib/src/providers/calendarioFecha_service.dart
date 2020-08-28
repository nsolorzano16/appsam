import 'dart:convert';
import 'package:appsam/src/models/eventos_model.dart';
import 'package:http/http.dart' as http;

import 'package:appsam/src/models/calendarioFecha_model.dart';
import 'package:appsam/src/utils/storage_util.dart';
import 'package:appsam/src/utils/utils.dart';

class EventosService {
  final _apiURL = EnviromentVariables().getApiURL();

  Future<CalendarioFechaModel> addEvento(CalendarioFechaModel evento) async {
    final String token = StorageUtil.getString('token');
    final headers = {
      "content-type": "application/json",
      "accept": "application/json",
      'authorization': 'Bearer $token',
    };
    final url = '$_apiURL/api/Agenda';

    final resp = await http.post(url,
        headers: headers, body: calendarioFechaModelToJson(evento));

    if (resp.statusCode == 200) {
      final decodedData = json.decode(resp.body);
      final calendarioFecha = new CalendarioFechaModel.fromJson(decodedData);
      return calendarioFecha;
    }

    return null;
  }

  Future<Event> updateEvento(Event evento) async {
    final String token = StorageUtil.getString('token');
    final headers = {
      "content-type": "application/json",
      "accept": "application/json",
      'authorization': 'Bearer $token',
    };
    final url = '$_apiURL/api/Agenda';

    //print(usuarioModelToJson(usuario));
    final resp =
        await http.put(url, headers: headers, body: eventModelToJson(evento));

    if (resp.statusCode == 200) {
      final decodedData = json.decode(resp.body);
      final calendarioFecha = new Event.fromJson(decodedData);
      return calendarioFecha;
    }

    return null;
  }

  Future<List<EventosModel>> getEventos(String doctorId) async {
    final String token = StorageUtil.getString('token');
    final headers = {
      "content-type": "application/json",
      "accept": "application/json",
      'authorization': 'Bearer $token',
    };
    final url = '$_apiURL/api/Agenda/movil/doctorid/$doctorId';
    final resp = await http.get(url, headers: headers);
    final List<EventosModel> lista = new List();

    if (resp.statusCode == 200 && resp.body.isNotEmpty) {
      final decodeResp = json.decode(resp.body);
      decodeResp.forEach((evt) {
        final evtTemp = EventosModel.fromJson(evt);
        lista.add(evtTemp);
      });
      return lista;
    }

    return [];
  }
} // fin clase
