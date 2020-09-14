import 'dart:io';
import 'package:appsam/src/models/dashboard/summaryCovid19_model.dart';
import 'package:appsam/src/models/planes_model.dart';
import 'package:appsam/src/models/user_model.dart';
import 'package:appsam/src/providers/covid19_service.dart';
import 'package:charts_flutter/flutter.dart' as charts;

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
import 'package:intl/intl.dart';

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
  final CovidService _covidService = CovidService();

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
    var f = new NumberFormat("###,###,###,###", "en_Es");
    final size = MediaQuery.of(context).size;
    final double fontSize = 18;
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
                      // Container(
                      //   padding: EdgeInsets.all(8.0),
                      //   height: 350,
                      //   child: ListView(
                      //     physics: ClampingScrollPhysics(),
                      //     scrollDirection: Axis.horizontal,
                      //     children: [
                      //       Container(
                      //           height: 350,
                      //           width: 1500,
                      //           child: SimpleBarChart.withSampleData()),
                      //     ],
                      //   ),
                      // ),
                      Container(
                        child: FutureBuilder(
                          future: _covidService.getSumary(),
                          builder: (BuildContext context,
                              AsyncSnapshot<SummaryCovid19Model> snapshot) {
                            if (!snapshot.hasData)
                              return loadingIndicator(context);
                            final _global = snapshot.data.global;
                            final countries = snapshot.data.countries;
                            final honduras = countries.firstWhere(
                                (element) => element.country == 'Honduras');
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _textTitle('Informacion Covid-19 Honduras'),
                                  _cardText(
                                      fontSize,
                                      f,
                                      honduras.totalConfirmed,
                                      'Total Confirmados'),
                                  _cardText(
                                      fontSize,
                                      f,
                                      honduras.totalRecovered,
                                      'Total Recuperados'),
                                  _cardText(fontSize, f, honduras.totalDeaths,
                                      'Total Muertes'),
                                  _space(),
                                  _textTitle('Informacion Covid-19 Global'),
                                  _space(),
                                  _cardText(fontSize, f, _global.totalConfirmed,
                                      'Total Confirmados'),
                                  _cardText(fontSize, f, _global.totalRecovered,
                                      'Total Recuperados'),
                                  _cardText(fontSize, f, _global.totalDeaths,
                                      'Total Muertes'),
                                ],
                              ),
                            );
                          },
                        ),
                      )
                    ],
                  ),
                ],
              )),
        ),
        onWillPop: () async => false);
  }

  Align _textTitle(String text) {
    return Align(
      alignment: Alignment.center,
      child: Text(
        '$text',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  SizedBox _space() {
    return SizedBox(
      height: 10,
    );
  }

  Container _cardText(
      double fontSize, NumberFormat f, int total, String title) {
    return Container(
      width: double.infinity,
      child: Card(
        elevation: elevationCards(),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text(
                title,
                style: TextStyle(fontSize: fontSize),
              ),
              Text(
                '${f.format(total)}',
                style:
                    TextStyle(fontSize: fontSize, fontWeight: FontWeight.w500),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SimpleBarChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  SimpleBarChart(this.seriesList, {this.animate});

  /// Creates a [BarChart] with sample data and no transition.
  factory SimpleBarChart.withSampleData() {
    return new SimpleBarChart(
      _createSampleData(),
      // Disable animations for image tests.
      animate: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return new charts.BarChart(
      seriesList,
      animate: animate,
    );
  }

  /// Create one series with sample hard coded data.
  static List<charts.Series<OrdinalSales, String>> _createSampleData() {
    final data = [
      new OrdinalSales('2014', 5),
      new OrdinalSales('2015', 25),
      new OrdinalSales('2016', 120),
      new OrdinalSales('2017', 75),
      new OrdinalSales('2018', 100),
      new OrdinalSales('2019', 75),
      new OrdinalSales('2020', 100),
      new OrdinalSales('2021', 75),
      new OrdinalSales('2022', 100),
      new OrdinalSales('2023', 75),
      new OrdinalSales('2024', 100),
      new OrdinalSales('2025', 75),
      new OrdinalSales('2026', 100),
      new OrdinalSales('2027', 75),
      new OrdinalSales('2028', 100),
      new OrdinalSales('2029', 75),
      new OrdinalSales('2030', 100),
      new OrdinalSales('2032', 75),
      new OrdinalSales('2033', 75),
      new OrdinalSales('2034', 75),
      new OrdinalSales('2035', 75),
      new OrdinalSales('2036', 75),
      new OrdinalSales('2037', 75),
      new OrdinalSales('2038', 75),
      new OrdinalSales('2039', 75),
      new OrdinalSales('2040', 75),
    ];

    return [
      new charts.Series<OrdinalSales, String>(
        id: 'Sales',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (OrdinalSales sales, _) => sales.year,
        measureFn: (OrdinalSales sales, _) => sales.sales,
        data: data,
      )
    ];
  }
}

/// Sample ordinal data type.
class OrdinalSales {
  final String year;
  final int sales;

  OrdinalSales(this.year, this.sales);
}
