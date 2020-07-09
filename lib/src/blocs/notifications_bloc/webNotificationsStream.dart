import 'package:appsam/src/models/notificacionesWeb_model.dart';
import 'package:rxdart/rxdart.dart';

class WebNotificicationsStream {
  WebNotificicationsStream._internal();
  static final WebNotificicationsStream _instance =
      WebNotificicationsStream._internal();

  static WebNotificicationsStream get instance {
    return _instance;
  }

  final _agendaController = BehaviorSubject<NotificacionesWebModel>();
  final _consultasController = BehaviorSubject<NotificacionesWebModel>();

  void addConsultaNoti(NotificacionesWebModel consulta) {
    _consultasController.sink.add(consulta);
  }

  void addAgendaNoti(NotificacionesWebModel agenda) {
    _agendaController.sink.add(agenda);
  }

  void dispose() {
    _agendaController.close();
    _consultasController.close();
    print('se cerra web notificacion stream');
  }

  NotificacionesWebModel get agendaPendiente => _agendaController.value;
  NotificacionesWebModel get consultaPendiente => _consultasController.value;
}
