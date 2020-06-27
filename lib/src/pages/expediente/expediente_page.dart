import 'package:animate_do/animate_do.dart';
import 'package:appsam/src/models/expediente_model.dart';
import 'package:appsam/src/pages/expediente/exp_antecedentes_page.dart';
import 'package:appsam/src/pages/expediente/exp_farmacos_page.dart';
import 'package:appsam/src/pages/expediente/exp_habitos.dart';
import 'package:appsam/src/pages/expediente/exp_historialGineco_page.dart';

import 'package:appsam/src/pages/expediente/exp_paciente_page.dart';
import 'package:appsam/src/providers/consulta_service.dart';
import 'package:appsam/src/utils/utils.dart';
import 'package:appsam/src/widgets/drawer.dart';
import 'package:appsam/src/widgets/firebaseMessageWrapper.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ExpedientePage extends StatefulWidget {
  final int pacienteId;
  final int doctorId;

  const ExpedientePage({@required this.pacienteId, @required this.doctorId});

  @override
  _ExpedientePageState createState() => _ExpedientePageState();
}

class _ExpedientePageState extends State<ExpedientePage> {
  final ConsultaService _consultaService = new ConsultaService();

  Future<ExpedienteViewModel> _expedienteFuture;

  int get _pacienteId => widget.pacienteId;
  int get _doctorId => widget.doctorId;
  int _selectedIndex = 0;
  PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
  }

  _changeIndex(int index) {
    _pageController.jumpToPage(index);
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    _expedienteFuture = _consultaService.getExpediente(_pacienteId, _doctorId);

    return WillPopScope(
      child: FirebaseMessageWrapper(
        child: Scaffold(
            appBar: AppBar(
              title: Text('Expediente'),
              actions: <Widget>[
                IconButton(
                    icon: Icon(Icons.arrow_back_ios),
                    onPressed: () =>
                        Navigator.pushReplacementNamed(context, 'pacientes'))
              ],
            ),
            drawer: MenuWidget(),
            body: FutureBuilder(
              future: _expedienteFuture,
              builder: (BuildContext context,
                  AsyncSnapshot<ExpedienteViewModel> snapshot) {
                if (!snapshot.hasData) return loadingIndicator(context);
                return Row(
                  children: <Widget>[
                    Expanded(
                      child: _pages(snapshot.data),
                    ),
                    NavigationRail(
                      elevation: 3,
                      selectedIndex: _selectedIndex,
                      labelType: NavigationRailLabelType.none,
                      onDestinationSelected: (index) {
                        _changeIndex(index);
                      },
                      destinations: [
                        _navItem(FontAwesomeIcons.userCircle),
                        _navItem(FontAwesomeIcons.heartbeat),
                        _navItem(FontAwesomeIcons.coffee),
                        _navItem(FontAwesomeIcons.baby),
                        _navItem(FontAwesomeIcons.capsules),
                        // _navItem(FontAwesomeIcons.clipboardList)
                      ],
                    ),
                  ],
                );
              },
            )),
      ),
      onWillPop: () async => false,
    );
  }

  NavigationRailDestination _navItem(IconData icon) {
    return NavigationRailDestination(
        icon: Icon(icon), selectedIcon: Icon(icon), label: Text(''));
  }

  PageView _pages(ExpedienteViewModel expediente) {
    return PageView(
      physics: NeverScrollableScrollPhysics(),
      controller: _pageController,
      onPageChanged: (value) {
        setState(() {
          _selectedIndex = value;
        });
      },
      children: <Widget>[
        ZoomIn(child: PacienteDetail(paciente: expediente.paciente)),
        (expediente.antecedentesFamiliaresPersonales == null)
            ? _noInfo()
            : ZoomIn(
                child: ExpAntecedentes(
                    antecedentes: expediente.antecedentesFamiliaresPersonales),
              ),
        (expediente.habitos == null)
            ? _noInfo()
            : ZoomIn(
                child: ExpHabitos(habitos: expediente.habitos),
              ),
        (expediente.historialGinecoObstetra == null)
            ? _noInfo()
            : ZoomIn(
                child: ExpHistorialGineco(
                    historial: expediente.historialGinecoObstetra),
              ),
        (expediente.farmacosUsoActual == null)
            ? _noInfo()
            : ZoomIn(
                child: ExpFarmacos(farmacos: expediente.farmacosUsoActual),
              ),
      ],
    );
  }

  Widget _noInfo() {
    return ZoomIn(child: Center(child: Text('No hay información.')));
  }
}
