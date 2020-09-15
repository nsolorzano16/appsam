import 'dart:io';

import 'package:appsam/src/models/planes_model.dart';
import 'package:appsam/src/models/user_model.dart';

import 'package:appsam/src/models/dashboard/total_pacientes_anio_mes.dart';
import 'package:appsam/src/models/device_model.dart';
import 'package:appsam/src/providers/FirebaseNotificationService.dart';
import 'package:appsam/src/providers/dashboad_service.dart';
import 'package:appsam/src/providers/devices_service.dart';
import 'package:appsam/src/utils/utils.dart';
import 'package:appsam/src/widgets/firebaseMessageWrapper.dart';

import 'package:flutter/material.dart';

import 'package:appsam/src/utils/storage_util.dart';
import 'package:appsam/src/widgets/drawer.dart';
import 'package:getflutter/components/card/gf_card.dart';
import 'package:getflutter/components/list_tile/gf_list_tile.dart';
import 'package:getflutter/components/progress_bar/gf_progress_bar.dart';

class HomePage extends StatefulWidget {
  static final String routeName = 'home';
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final UserModel _usuario =
      userModelFromJson(StorageUtil.getString('usuarioGlobal'));
  final PlanesModel _plan =
      planesModelFromJson(StorageUtil.getString('planUsuario'));
  int consultasAtendidas = StorageUtil.getInt('consultasAtendidas');
  final String name = 'sam-app';
  final DashboardService _dashboardService = DashboardService();
  final PageController _controller =
      PageController(initialPage: 0, viewportFraction: 0.8);

  @override
  void initState() {
    //final _pushService = new Firebasem();
    // _pushService.initNotifications();
    FirebaseNotificationService.instance.sendDeviceToken();
    final _devicesService = new DevicesService();
    final device = new DevicesModel();
    device.deviceId = 0;

    if (_usuario.rolId == 2) {
      device.usuarioId = _usuario.id;
    } else if (_usuario.rolId == 3) {
      device.usuarioId = _usuario.asistenteId;
    } else {
      device.usuarioId = '';
    }
    device.usuario = _usuario.userName;
    device.creadoFecha = DateTime.now();
    device.tokenDevice = StorageUtil.getString('tokenDevice');
    device.platform = Platform.operatingSystem;
    _devicesService.addDevice(device);

    super.initState();
  }

//23 de julio 7pm mac
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final _style = TextStyle(
      fontSize: 25,
      fontWeight: FontWeight.w600,
    );
    final _styleSubt = TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w600,
    );
    double porcentajeConsultas = consultasAtendidas / _plan.consultas;
    return WillPopScope(
        child: FirebaseMessageWrapper(
          child: Scaffold(
              backgroundColor: colorFondoApp(),
              drawer: MenuWidget(),
              appBar: AppBar(
                title: Text('Inicio'),
              ),
              body: ListView(
                physics: ClampingScrollPhysics(),
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GFCard(
                        elevation: elevationCards(),
                        title: GFListTile(
                          title: Text(
                            '${_plan.nombre}',
                            style: _style,
                          ),
                          subTitle: Text(
                            'Tipo de plan',
                          ),
                        ),
                        content: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 5.0),
                              child: Text(
                                'Porcentaje de plan consumido',
                                style: _style,
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 5.0),
                              child: Text(
                                'Consultas $consultasAtendidas/${_plan.consultas}',
                                style: _styleSubt,
                              ),
                            ),
                            GFProgressBar(
                              animation: true,
                              percentage: porcentajeConsultas,
                              lineHeight: 20,
                              alignment: MainAxisAlignment.spaceBetween,
                              child: Text(
                                '${porcentajeConsultas * 100}%',
                                textAlign: TextAlign.end,
                                style: TextStyle(
                                    fontSize: 16, color: Colors.white),
                              ),
                              progressBarColor: Colors.red,
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Total de pacientes',
                          style: _style,
                        ),
                      ),
                      FutureBuilder(
                        future: _dashboardService
                            .getTotalPacienteAnioMes(_usuario.userName),
                        builder: (BuildContext context,
                            AsyncSnapshot<List<TotalPacientesAnioMes>>
                                snapshot) {
                          if (!snapshot.hasData)
                            return loadingIndicator(context);

                          return snapshot.data.length > 0
                              ? Container(
                                  height: size.height * 0.20,
                                  child: PageView.builder(
                                    physics: ClampingScrollPhysics(),
                                    itemCount: snapshot.data.length,
                                    controller: _controller,
                                    itemBuilder: (context, index) {
                                      final item = snapshot.data[index];
                                      return Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Card(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                          elevation: elevationCards(),
                                          child: LayoutBuilder(
                                            builder: (BuildContext context,
                                                BoxConstraints constraints) {
                                              return Row(
                                                children: [
                                                  Container(
                                                    width:
                                                        constraints.maxWidth /
                                                            2,
                                                    child: Column(
                                                      children: [
                                                        TweenAnimationBuilder<
                                                            int>(
                                                          duration:
                                                              const Duration(
                                                                  milliseconds:
                                                                      800),
                                                          tween: IntTween(
                                                            begin: 0,
                                                            end: item.total,
                                                          ),
                                                          builder: (BuildContext
                                                                  context,
                                                              value,
                                                              Widget child) {
                                                            return Text(
                                                              value.toString(),
                                                              style: TextStyle(
                                                                  fontSize: 64,
                                                                  shadows: [
                                                                    Shadow(
                                                                      blurRadius:
                                                                          1,
                                                                      color: Colors
                                                                              .grey[
                                                                          300],
                                                                      offset:
                                                                          Offset(
                                                                              1,
                                                                              1),
                                                                    )
                                                                  ]),
                                                            );
                                                          },
                                                        ),
                                                        Text(
                                                          'Total',
                                                          style: _style,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Container(
                                                    width:
                                                        constraints.maxWidth /
                                                            2,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Column(
                                                        children: [
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceAround,
                                                            children: [
                                                              Text(
                                                                'Año:',
                                                                style: _style,
                                                              ),
                                                              TweenAnimationBuilder<
                                                                  int>(
                                                                duration: const Duration(
                                                                    milliseconds:
                                                                        1000),
                                                                tween: IntTween(
                                                                  begin: 0,
                                                                  end:
                                                                      item.year,
                                                                ),
                                                                builder: (BuildContext
                                                                        context,
                                                                    value,
                                                                    Widget
                                                                        child) {
                                                                  return Text(
                                                                    value
                                                                        .toString(),
                                                                    style:
                                                                        _style,
                                                                  );
                                                                },
                                                              ),
                                                            ],
                                                          ),
                                                          SizedBox(
                                                            height: 18,
                                                          ),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceAround,
                                                            children: [
                                                              Text(
                                                                'Mes:',
                                                                style: _style,
                                                              ),
                                                              Text(
                                                                '${item.mes.substring(0, 3)}.',
                                                                style: _style,
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              );
                                            },
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                )
                              : Container(
                                  height: size.height * 0.20,
                                  width: double.infinity,
                                  alignment: Alignment.center,
                                  child: Text('No se han creado pacientes'),
                                );
                          // return Container();
                        },
                      ),
                    ],
                  ),
                ],
              )),
        ),
        onWillPop: () async => false);
  }
}
