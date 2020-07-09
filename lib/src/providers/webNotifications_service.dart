import 'package:appsam/src/blocs/notifications_bloc/webNotificationsStream.dart';
import 'package:appsam/src/models/notificacionesWeb_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class WebNotificationService {
  final String name = 'sam-app';

  final FirebaseOptions options = const FirebaseOptions(
    googleAppID: '1:830338990221:android:8382bb597361e56bcde2c4',
    gcmSenderID: '830338990221',
    apiKey: 'AIzaSyB_zGgdbaJtCSkM9GGYfu-1BTUThvOOSSo',
    projectID: 'sam-app-446ee',
  );
  Firestore _firestore;
  WebNotificicationsStream _webNotificationStream =
      WebNotificicationsStream.instance;

  WebNotificationService._internal() {
    _configure();
  }

  static final WebNotificationService _instance =
      WebNotificationService._internal();

  static WebNotificationService get instance {
    return _instance;
  }

  Future<void> _configure() async {
    final FirebaseApp app = await FirebaseApp.configure(
      name: name,
      options: options,
    );
    assert(app != null);

    _firestore = Firestore(app: app);

    print('Configured $app');
  }

  void loadNotificaciones(int doctorId) {
    _firestore
        .collection('agenda')
        .document('$doctorId')
        .snapshots()
        .forEach((element) {
      if (element.data != null) {
        final item = NotificacionesWebModel.fromJson(element.data);
        _webNotificationStream.addAgendaNoti(item);
      } else {
        final noData = new NotificacionesWebModel();
        noData.doctorId = doctorId;
        noData.total = 0;
        _webNotificationStream.addAgendaNoti(noData);
      }
    });

    _firestore
        .collection('consulta')
        .document('$doctorId')
        .snapshots()
        .forEach((element) {
      if (element.data != null) {
        final item = NotificacionesWebModel.fromJson(element.data);
        _webNotificationStream.addConsultaNoti(item);
      } else {
        print('se fue al else xq no hay nada');
        final noData = new NotificacionesWebModel();
        noData.doctorId = doctorId;
        noData.total = 0;
        _webNotificationStream.addConsultaNoti(noData);
      }
    });
  }
}
