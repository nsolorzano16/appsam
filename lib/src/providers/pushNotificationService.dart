import 'dart:async';
import 'dart:io';

import 'package:appsam/src/models/usuario_model.dart';
import 'package:appsam/src/providers/usuario_provider.dart';
import 'package:appsam/src/utils/storage_util.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotificationService {
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  final usuarioService = new UsuarioProvider();

  final _notificationsController = StreamController<String>.broadcast();
  Stream<String> get notificaciones => _notificationsController.stream;

//ccABKCu-X78:APA91bFlmWvUOtYefqDrP9wnWaxqR_KM2S8Nui5bf0T7K6gjCgV2F3RyzO3d3Lda4Oz4YJuC-4D6657s3nNgl4INKvmKTbUctVSiQAg1p2V6f0Hug6ZvUjK0NhoSDFgfXVeGFOiJtv4y

  initNotifications() {
    _firebaseMessaging.requestNotificationPermissions();
    _firebaseMessaging.getToken().then((token) {
      StorageUtil.putString('tokenDevice', token);
    });

    _firebaseMessaging.configure(onMessage: (info) async {
      print('====== ON MESSAGE ======');
      print(info);
      String argumento = 'no-data';
      if (Platform.isAndroid) {
        argumento = info['data']['comida'] ?? 'no-data';
      }
      _notificationsController.sink.add(argumento);
    }, onLaunch: (info) async {
      print("==== ON LAUNCH====");
    }, onResume: (info) async {
      print('==== ON RESUME ====');

      final notification = info['data']['comida'];
      _notificationsController.sink.add(notification);
    });
  }

  dispose() {
    _notificationsController?.close();
  }
}
