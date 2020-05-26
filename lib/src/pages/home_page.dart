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

  @override
  void initState() {
    super.initState();
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
    device.tokenDevice = StorageUtil.getString('tokenDevice');
    device.platform = Platform.operatingSystem;
    _devicesService.addDevice(device);
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
            body: Container(),
          ),
        ),
        onWillPop: () async => false);
  }
}
