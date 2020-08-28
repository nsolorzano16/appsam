import 'package:animate_do/animate_do.dart';
import 'package:appsam/src/models/expediente_model.dart';
import 'package:appsam/src/pages/expediente/exp_antecedentes_page.dart';
import 'package:appsam/src/pages/expediente/exp_consultas_page.dart';
import 'package:appsam/src/pages/expediente/exp_farmacos_page.dart';
import 'package:appsam/src/pages/expediente/gallery/exp_gallery.dart';
import 'package:appsam/src/pages/expediente/exp_habitos.dart';
import 'package:appsam/src/pages/expediente/exp_historialGineco_page.dart';

import 'package:appsam/src/pages/expediente/exp_paciente_page.dart';
import 'package:appsam/src/pages/expediente/exp_view_pdf_page.dart';
import 'package:appsam/src/providers/consulta_service.dart';
import 'package:appsam/src/utils/utils.dart';
import 'package:appsam/src/widgets/drawer.dart';
import 'package:appsam/src/widgets/firebaseMessageWrapper.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:unicorndial/unicorndial.dart';

class ExpedientePage extends StatefulWidget {
  final int pacienteId;
  final String doctorId;

  const ExpedientePage({@required this.pacienteId, @required this.doctorId});

  @override
  _ExpedientePageState createState() => _ExpedientePageState();
}

class _ExpedientePageState extends State<ExpedientePage> {
  final ConsultaService _consultaService = new ConsultaService();

  Future<ExpedienteViewModel> _expedienteFuture;

  int get _pacienteId => widget.pacienteId;
  String get _doctorId => widget.doctorId;
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
          backgroundColor: colorFondoApp(),
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
              final expediente = snapshot.data;
              return SafeArea(
                  child: PageView(
                      physics: NeverScrollableScrollPhysics(),
                      controller: _pageController,
                      onPageChanged: (value) {
                        setState(() {
                          _selectedIndex = value;
                        });
                      },
                      children: <Widget>[
                    ZoomIn(
                        child: PacienteDetail(paciente: expediente.paciente)),
                    (expediente.antecedentesFamiliaresPersonales == null)
                        ? _noInfo()
                        : ZoomIn(
                            child: ExpAntecedentes(
                                antecedentes: expediente
                                    .antecedentesFamiliaresPersonales),
                          ),
                    (expediente.habitos == null)
                        ? _noInfo()
                        : ZoomIn(
                            child: ExpHabitos(habitos: expediente.habitos)),
                    (expediente.historialGinecoObstetra == null)
                        ? _noInfo()
                        : ZoomIn(
                            child: ExpHistorialGineco(
                                historial: expediente.historialGinecoObstetra),
                          ),
                    (expediente.farmacosUsoActual.length == 0)
                        ? _noInfo()
                        : ZoomIn(
                            child: ExpFarmacos(
                                farmacos: expediente.farmacosUsoActual)),
                    ZoomIn(
                        child: ExpConsultas(consultas: expediente.consultas)),
                  ]));
            },
          ),
          floatingActionButton: UnicornDialer(
              backgroundColor: Color.fromRGBO(255, 255, 255, 0.6),
              hasBackground: false,
              parentButtonBackground: Theme.of(context).primaryColor,
              orientation: UnicornOrientation.VERTICAL,
              parentButton: Icon(Icons.menu),
              childButtons: botones(
                context,
              )),
          bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              backgroundColor: Colors.red,
              selectedItemColor: Colors.white,
              unselectedItemColor: Colors.black,
              currentIndex: _selectedIndex,
              onTap: (index) => _changeIndex(index),
              items: <BottomNavigationBarItem>[
                _botonNavigationItem(FontAwesomeIcons.userCircle),
                _botonNavigationItem(FontAwesomeIcons.heartbeat),
                _botonNavigationItem(FontAwesomeIcons.coffee),
                _botonNavigationItem(FontAwesomeIcons.baby),
                _botonNavigationItem(FontAwesomeIcons.capsules),
                _botonNavigationItem(FontAwesomeIcons.clipboardList),
              ]),
        ),
      ),
      onWillPop: () async => false,
    );
  }

  BottomNavigationBarItem _botonNavigationItem(IconData icon) {
    return BottomNavigationBarItem(
      icon: FaIcon(
        icon,
      ),
      title: Container(),
    );
  }

  Widget _noInfo() {
    return ZoomIn(child: Center(child: Text('No hay información.')));
  }

  List<UnicornButton> botones(BuildContext context) {
    var childButtons = List<UnicornButton>();

    childButtons.add(
      UnicornButton(
        labelText: 'galeria',
        currentButton: FloatingActionButton(
          heroTag: 'albumfotos',
          backgroundColor: Colors.blueGrey,
          mini: true,
          child: FaIcon(
            FontAwesomeIcons.images,
            size: 17,
          ),
          onPressed: () => Navigator.of(context).push(
            PageRouteBuilder(
              transitionDuration: const Duration(milliseconds: 400),
              pageBuilder: (_, animation, __) => SlideTransition(
                position: Tween<Offset>(
                  begin: Offset(0.0, 1.0),
                  end: Offset(0.0, 0.0),
                ).animate(animation),
                child: ExpGalleryPage(
                  pacienteId: _pacienteId,
                  doctorId: _doctorId,
                ),
              ),
            ),
          ),
        ),
      ),
    );

    childButtons.add(UnicornButton(
      labelText: 'Consulta',
      currentButton: FloatingActionButton(
        mini: true,
        heroTag: 'generandopdf',
        onPressed: () => Navigator.of(context).push(PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 600),
            pageBuilder: (_, animation, __) => FadeTransition(
                  opacity: animation,
                  child: ViewPDFPage(
                    pacienteId: _pacienteId,
                    doctorId: _doctorId,
                  ),
                ))),
        child: FaIcon(
          FontAwesomeIcons.filePdf,
          size: 17,
        ),
      ),
    ));

    return childButtons;
  }
}
