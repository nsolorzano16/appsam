import 'package:appsam/src/models/notificacionesWeb_model.dart';
import 'package:appsam/src/models/usuario_model.dart';
import 'package:appsam/src/providers/webNotifications_service.dart';
import 'package:appsam/src/utils/storage_util.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:appsam/src/models/menu_model.dart';

class _MenuProvider {
  var opciones = new List<Ruta>();
  final WebNotificationService _notificationService =
      new WebNotificationService();

  _MenuProvider();

  Future<List<Ruta>> cargarData() async {
    final UsuarioModel usuario =
        usuarioModelFromJson(StorageUtil.getString('usuarioGlobal'));
    final resp = await rootBundle.loadString('data/menu_opts.json');
    final NotificacionesWebModel _notiConsultas = await _notificationService
        .getNotificacionesWebConsultas(usuario.usuarioId);
    final NotificacionesWebModel _notiAgenda = await _notificationService
        .getNotificacionesWebAgenda(usuario.usuarioId);

    var dataMap = menuModelFromJson(resp);

    opciones = dataMap.rutas;
    opciones.forEach((element) {
      if (element.texto == 'Consulta')
        element.notificaciones = _notiConsultas.total;
      if (element.texto == 'Agenda') element.notificaciones = _notiAgenda.total;
    });
    return opciones;
  }
}

final menuProvider = new _MenuProvider();
