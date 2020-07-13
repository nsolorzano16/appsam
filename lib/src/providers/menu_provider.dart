import 'package:appsam/src/blocs/notifications_bloc/webNotificationsStream.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:appsam/src/models/menu_model.dart';

class _MenuProvider {
  var opciones = new List<Ruta>();

  _MenuProvider();

  Future<List<Ruta>> cargarData() async {
    final resp = await rootBundle.loadString('data/menu_opts.json');

    var dataMap = menuModelFromJson(resp);

    opciones = dataMap.rutas;
    opciones.forEach((element) {
      if (element.texto == 'Consulta') {
        element.notificaciones =
            (WebNotificicationsStream.instance.consultaPendiente.total == null)
                ? 0
                : WebNotificicationsStream.instance.consultaPendiente.total;
      } else if (element.texto == 'Agenda') {
        element.notificaciones =
            (WebNotificicationsStream.instance.agendaPendiente.total == null)
                ? 0
                : WebNotificicationsStream.instance.agendaPendiente.total;
      }
    });

    return opciones;
  }
}

final menuProvider = new _MenuProvider();
