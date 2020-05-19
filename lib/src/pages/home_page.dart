import 'package:appsam/src/providers/pushNotificationService.dart';

import 'package:flutter/material.dart';

import 'package:appsam/src/utils/storage_util.dart';
import 'package:appsam/src/widgets/drawer.dart';

class HomePage extends StatefulWidget {
  static final String routeName = 'home';
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    StorageUtil.putString('ultimaPagina', HomePage.routeName);
    final _pushService = new PushNotificationService();
    _pushService.initNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
            drawer: MenuWidget(),
            appBar: AppBar(
              title: Text('Inicio'),
            ),
            body: Container()

            // FutureBuilder(
            //   future: _covidFuture,
            //   builder: (BuildContext context,
            //       AsyncSnapshot<ReporteGlobalModel> snapshot) {
            //     final reporte = snapshot.data;
            //     var f = NumberFormat('###,###,###', 'en_US');
            //     if (snapshot.hasData) {
            //       return Container(
            //         child: Column(
            //           children: <Widget>[
            //             FadeIn(
            //               child: Text(
            //                 'Casos confirmados en el mundo ${f.format(reporte.global.totalConfirmed)}',
            //                 style: TextStyle(
            //                     fontSize: 16.0, fontWeight: FontWeight.bold),
            //               ),
            //             )
            //           ],
            //         ),
            //       );
            //     } else {
            //       return loadingIndicator(context);
            //     }
            //   },
            // ),
            ),
        onWillPop: () async => false);
  }
}
