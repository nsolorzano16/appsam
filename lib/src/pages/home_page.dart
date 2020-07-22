import 'dart:io';

import 'package:appsam/src/models/device_model.dart';
import 'package:appsam/src/models/usuario_model.dart';
import 'package:appsam/src/providers/FirebaseNotificationService.dart';
import 'package:appsam/src/providers/devices_service.dart';
import 'package:appsam/src/widgets/firebaseMessageWrapper.dart';

import 'package:flutter/material.dart';

import 'package:appsam/src/utils/storage_util.dart';
import 'package:appsam/src/widgets/drawer.dart';

class HomePage extends StatefulWidget {
  static final String routeName = 'home';
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final UsuarioModel _usuario =
      usuarioModelFromJson(StorageUtil.getString('usuarioGlobal'));
  final String name = 'sam-app';

  @override
  void initState() {
    StorageUtil.putString('ultimaPagina', HomePage.routeName);
    //final _pushService = new Firebasem();
    // _pushService.initNotifications();
    FirebaseNotificationService.instance.sendDeviceToken();
    final _devicesService = new DevicesService();
    final device = new DevicesModel();
    device.deviceId = 0;

    if (_usuario.rolId == 2) {
      device.usuarioId = _usuario.usuarioId;
    } else if (_usuario.rolId == 3) {
      device.usuarioId = _usuario.asistenteId;
    } else {
      device.usuarioId = 0;
    }
    device.usuario = _usuario.userName;
    device.creadoFecha = DateTime.now();
    device.tokenDevice = StorageUtil.getString('tokenDevice');
    device.platform = Platform.operatingSystem;
    _devicesService.addDevice(device);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: FirebaseMessageWrapper(
          child: Scaffold(
              drawer: MenuWidget(),
              appBar: AppBar(
                title: Text('Inicio'),
              ),
              body: Center(
                child: Text(
                  'Release Date: 22 de julio de 2020 6:00 p.m',
                  style: TextStyle(fontSize: 16.0),
                ),
              )),
        ),
        onWillPop: () async => false);
  }

  // final FirebaseOptions options = const FirebaseOptions(
  //   googleAppID: '1:830338990221:android:8382bb597361e56bcde2c4',
  //   gcmSenderID: '830338990221',
  //   apiKey: 'AIzaSyB_zGgdbaJtCSkM9GGYfu-1BTUThvOOSSo',
  //   projectID: 'sam-app-446ee',
  // );

  // Future<void> configure() async {
  //   final FirebaseApp app = await FirebaseApp.configure(
  //     name: name,
  //     options: options,
  //   );
  //   assert(app != null);

  //   _firestore = Firestore(app: app);

  //   // _firestore
  //   //     .collection('agenda')
  //   //     .document('1')
  //   //     .snapshots()
  //   //     .forEach((element) => print('${element.data}'));

  //   _firestore.collection('agenda').getDocuments().then((value) {
  //     value.documents.forEach((element) {
  //       print(element.data);
  //     });
  //   });

  //   _firestore.collection('consulta').getDocuments().then((value) {
  //     value.documents.forEach((element) {
  //       print(element.data);
  //     });
  //   });

  //   print('Configured $app');
  // }

  // Future<void> allApps() async {
  //   final List<FirebaseApp> apps = await FirebaseApp.allApps();
  //   print('Currently configured apps: $apps');
  // }

  // Future<void> optiones() async {
  //   final FirebaseApp app = await FirebaseApp.appNamed(name);
  //   final FirebaseOptions options = await app?.options;
  //   print('Current options for app $name: $options');
  // }
}
