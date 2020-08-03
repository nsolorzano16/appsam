import 'package:animate_do/animate_do.dart';
import 'package:appsam/src/blocs/consulta_bloc.dart';
import 'package:appsam/src/blocs/examenFisico_bloc.dart';
import 'package:appsam/src/blocs/historialGineco_bloc.dart';
import 'package:appsam/src/blocs/preclinica_bloc.dart';

import 'package:appsam/src/models/consulta_model.dart';
import 'package:appsam/src/models/examenFisico_model.dart';
import 'package:appsam/src/models/historialGinecoObstetra_model.dart';
import 'package:appsam/src/models/paginados/preclinica_paginadoVM.dart';
import 'package:appsam/src/models/usuario_model.dart';
import 'package:appsam/src/pages/consulta/examenFisico/crear_ExamenFisico_page.dart';
import 'package:appsam/src/pages/consulta/historialGinecoObstetra/crear_HistorialGineco_page.dart';
import 'package:appsam/src/utils/storage_util.dart';
import 'package:appsam/src/utils/utils.dart';
import 'package:appsam/src/widgets/drawer.dart';
import 'package:appsam/src/widgets/firebaseMessageWrapper.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:getflutter/getflutter.dart';
import 'package:progress_dialog/progress_dialog.dart';

class MenuConsultaPage extends StatefulWidget {
  static final String routeName = 'menu_consulta';

  final PreclinicaViewModel preclinica;

  const MenuConsultaPage({Key key, this.preclinica}) : super(key: key);

  @override
  _MenuConsultaPageState createState() => _MenuConsultaPageState();
}

class _MenuConsultaPageState extends State<MenuConsultaPage>
    with SingleTickerProviderStateMixin {
  final _consultaBloc = new ConsultaBloc();
  final PreclinicaBloc _preclinicaBloc = new PreclinicaBloc();

  Future<ConsultaModel> _consultaFuture;
  final UsuarioModel _usuario =
      usuarioModelFromJson(StorageUtil.getString('usuarioGlobal'));

  @override
  void dispose() {
    _consultaBloc.dispose();

    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final PreclinicaViewModel _preclinica =
        ModalRoute.of(context).settings.arguments;
    _consultaFuture = _consultaBloc.getDetalleConsulta(
        _preclinica.pacienteId, _preclinica.doctorId, _preclinica.preclinicaId);

    return WillPopScope(
        child: FirebaseMessageWrapper(
          child: DefaultTabController(
            initialIndex: StorageUtil.getInt('indexTabMenuConsulta'),
            length: 2,
            child: Scaffold(
                backgroundColor: colorFondoApp(),
                appBar: AppBar(
                  title: Text('Menu Consulta'),
                ),
                drawer: MenuWidget(),
                body: TabBarView(children: [
                  _tabHistorial(_preclinica),
                  _tabConsulta(_preclinica)
                ]),
                floatingActionButton: FloatingActionButton(
                  onPressed: () => _atendida(context, _preclinica),
                  child: Icon(Icons.save),
                  backgroundColor: Colors.pinkAccent,
                ),
                bottomNavigationBar: Container(
                  color: Colors.red,
                  child: TabBar(
                      labelColor: Colors.white,
                      indicatorColor: Colors.white,
                      tabs: [
                        Tab(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Icon(Icons.watch_later),
                              Text('Historial')
                            ],
                          ),
                        ),
                        Tab(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Icon(FontAwesomeIcons.notesMedical),
                              Text('Consulta')
                            ],
                          ),
                        ),
                      ]),
                )),
          ),
        ),
        onWillPop: () async => false);
  }

  FutureBuilder<ConsultaModel> _tabHistorial(PreclinicaViewModel _preclinica) {
    return FutureBuilder(
      future: _consultaFuture,
      builder: (BuildContext context, AsyncSnapshot<ConsultaModel> snapshot) {
        if (snapshot.hasData) {
          return SingleChildScrollView(
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 15.0,
                ),
                Table(
                  children: [
                    TableRow(children: [
                      FadeInLeft(
                        child: _cardItem(
                            _preclinica,
                            FontAwesomeIcons.userMd,
                            'Resumen de Consulta',
                            'consulta_detalle',
                            Colors.teal,
                            context),
                      ),
                      FadeInRight(
                        child: _cardItem(
                            _preclinica,
                            FontAwesomeIcons.capsules,
                            'Farmacos',
                            'crear_farmacos_uso_actual',
                            Colors.orange,
                            context),
                      ),
                    ]),
                    TableRow(children: [
                      FadeInLeft(
                        child: _cardItem(
                            _preclinica,
                            FontAwesomeIcons.heartbeat,
                            'Antecedentes Familiares',
                            'crear_antecedentes',
                            Colors.blue,
                            context),
                      ),
                      FadeInRight(
                        child: _cardItem(_preclinica, FontAwesomeIcons.coffee,
                            'Habitos', 'crear_habitos', Colors.green, context),
                      )
                    ]),
                    TableRow(children: [
                      (_preclinica.sexo == 'F')
                          ? FadeInLeft(
                              child: _cardItemHistorialGineco(
                                  _preclinica,
                                  FontAwesomeIcons.baby,
                                  'Antecedentes Ginecológicos',
                                  'crear_historial_gineco',
                                  Colors.blueGrey,
                                  context,
                                  _usuario),
                            )
                          : Container(),
                      Container()
                    ]),
                  ],
                )
              ],
            ),
          );
        } else {
          return loadingIndicator(context);
        }
      },
    );
  }

  FutureBuilder<ConsultaModel> _tabConsulta(PreclinicaViewModel _preclinica) {
    return FutureBuilder(
      future: _consultaFuture,
      builder: (BuildContext context, AsyncSnapshot<ConsultaModel> snapshot) {
        if (snapshot.hasData) {
          return SingleChildScrollView(
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 15.0,
                ),
                Table(
                  children: [
                    TableRow(children: [
                      FadeInLeft(
                        child: _cardItem(
                            _preclinica,
                            FontAwesomeIcons.briefcaseMedical,
                            'Consulta General',
                            'crear_consulta_general',
                            Colors.red,
                            context),
                      ),
                      FadeInRight(
                        child: _cardItemExamenFisico(
                            _preclinica,
                            FontAwesomeIcons.diagnoses,
                            'Examen Físico',
                            'crear_examen_fisico',
                            Colors.brown,
                            context,
                            _usuario),
                      ),
                    ]),
                    TableRow(children: [
                      FadeInLeft(
                        child: _cardItem(
                            _preclinica,
                            FontAwesomeIcons.stickyNote,
                            'Plan Terapeutico',
                            'planes_terapeuticos',
                            Colors.lightGreen,
                            context),
                      ),
                      FadeInRight(
                        child: _cardItem(
                            _preclinica,
                            FontAwesomeIcons.flask,
                            'Examenes',
                            'examenes_indicados',
                            Colors.cyan,
                            context),
                      ),
                    ]),
                    TableRow(children: [
                      FadeInLeft(
                        child: _cardItem(
                            _preclinica,
                            Icons.note,
                            'Diagnosticos',
                            'diagnosticos',
                            Colors.pink,
                            context),
                      ),
                      FadeInRight(
                        child: _cardItem(_preclinica, Icons.note_add, 'Notas',
                            'crear_notas', Colors.deepPurple, context),
                      ),
                    ]),
                  ],
                )
              ],
            ),
          );
        } else {
          return loadingIndicator(context);
        }
      },
    );
  }

  Widget _cardItem(PreclinicaViewModel preclinica, IconData icon, String texto,
      String ruta, Color color, BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (ruta == 'crear_consulta_general' ||
            ruta == 'crear_examen_fisico' ||
            ruta == 'crear_diagnosticos' ||
            ruta == 'crear_notas' ||
            ruta == 'examenes_indicados' ||
            ruta == 'planes_terapeuticos') {
          StorageUtil.putInt('indexTabMenuConsulta', 1);
        } else if (ruta == 'consulta_detalle' ||
            ruta == 'crear_antecedentes' ||
            ruta == 'crear_habitos' ||
            ruta == 'crear_historial_gineco' ||
            ruta == 'crear_farmacos_uso_actual') {
          StorageUtil.putInt('indexTabMenuConsulta', 0);
        }
        Navigator.pushReplacementNamed(context, ruta, arguments: preclinica);
      },
      child: GFCard(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        elevation: 6.0,
        height: 110.0,
        color: color,
        content: Column(
          children: <Widget>[
            Container(
              // decoration: BoxDecoration(
              //     shape: BoxShape.circle, color: Colors.red),
              margin: EdgeInsets.only(top: 5.0),
              child: FaIcon(
                icon,
                size: 40.0,
                color: Colors.white,
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 6.0),
              child: Text(
                texto,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 15.0),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _cardItemHistorialGineco(
      PreclinicaViewModel preclinica,
      IconData icon,
      String texto,
      String ruta,
      Color color,
      BuildContext context,
      UsuarioModel usuario) {
    final _historialGinecoBloc = new HistorialGinecoObstetraBloc();

    final HistorialGinecoObstetra _historialEmpty =
        new HistorialGinecoObstetra();

    _historialEmpty.historialId = 0;
    _historialEmpty.pacienteId = preclinica.pacienteId;
    _historialEmpty.preclinicaId = preclinica.preclinicaId;
    _historialEmpty.activo = true;
    _historialEmpty.vacunaVph = false;
    _historialEmpty.anticonceptivoId = 19;
    _historialEmpty.g = 0;
    _historialEmpty.p = 0;
    _historialEmpty.c = 0;
    _historialEmpty.hv = 0;
    _historialEmpty.hm = 0;
    _historialEmpty.creadoPor = usuario.userName;
    _historialEmpty.creadoFecha = DateTime.now();
    _historialEmpty.modificadoPor = usuario.userName;
    _historialEmpty.modificadoFecha = DateTime.now();

    return GestureDetector(
      onTap: () async {
        final ProgressDialog _pr = new ProgressDialog(
          context,
          type: ProgressDialogType.Normal,
          isDismissible: false,
          showLogs: false,
        );
        _pr.update(
          progress: 50.0,
          message: "Espere...",
          progressWidget: Container(
              padding: EdgeInsets.all(8.0), child: CircularProgressIndicator()),
          maxProgress: 100.0,
          progressTextStyle: TextStyle(
              color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
          messageTextStyle: TextStyle(
              color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600),
        );
        await _pr.show();

        final HistorialGinecoObstetra historial =
            await _historialGinecoBloc.getHistorialGinecoObstetra(
                preclinica.pacienteId, preclinica.doctorId);
        await _pr.hide();
        if (historial != null) {
          StorageUtil.putInt('indexTabMenuConsulta', 0);
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => CrearHistorialGinecoObstetraPage(
                        historial: historial,
                        preclinica: preclinica,
                      )));
        } else {
          StorageUtil.putInt('indexTabMenuConsulta', 0);
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => CrearHistorialGinecoObstetraPage(
                        historial: _historialEmpty,
                        preclinica: preclinica,
                      )));
        }
      },
      child: GFCard(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        elevation: 6.0,
        height: 110.0,
        color: color,
        content: Column(
          children: <Widget>[
            Container(
              // decoration: BoxDecoration(
              //     shape: BoxShape.circle, color: Colors.red),
              margin: EdgeInsets.only(top: 5.0),
              child: FaIcon(
                icon,
                size: 40.0,
                color: Colors.white,
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 6.0),
              child: Text(
                texto,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 15.0),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _cardItemExamenFisico(
      PreclinicaViewModel preclinica,
      IconData icon,
      String texto,
      String ruta,
      Color color,
      BuildContext context,
      UsuarioModel usuario) {
    final _examenFisicoBloc = new ExamenFisicoBloc();

    final ExamenFisico _examenEmpty = new ExamenFisico();

    _examenEmpty.examenFisicoId = 0;
    _examenEmpty.pacienteId = preclinica.pacienteId;
    _examenEmpty.doctorId = preclinica.doctorId;
    _examenEmpty.preclinicaId = preclinica.preclinicaId;
    _examenEmpty.activo = true;
    _examenEmpty.creadoPor = usuario.userName;
    _examenEmpty.creadoFecha = DateTime.now();
    _examenEmpty.modificadoPor = usuario.userName;
    _examenEmpty.modificadoFecha = DateTime.now();

    return GestureDetector(
      onTap: () async {
        final ProgressDialog _pr = new ProgressDialog(
          context,
          type: ProgressDialogType.Normal,
          isDismissible: false,
          showLogs: false,
        );
        _pr.update(
          progress: 50.0,
          message: "Espere...",
          progressWidget: Container(
              padding: EdgeInsets.all(8.0), child: CircularProgressIndicator()),
          maxProgress: 100.0,
          progressTextStyle: TextStyle(
              color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
          messageTextStyle: TextStyle(
              color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600),
        );
        await _pr.show();

        final ExamenFisico examenFisico =
            await _examenFisicoBloc.getExamenFisico(preclinica.pacienteId,
                preclinica.doctorId, preclinica.preclinicaId);
        await _pr.hide();
        if (examenFisico != null) {
          StorageUtil.putInt('indexTabMenuConsulta', 1);
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => CrearExamenFisicoPage(
                        examen: examenFisico,
                        preclinica: preclinica,
                      )));
        } else {
          StorageUtil.putInt('indexTabMenuConsulta', 1);
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => CrearExamenFisicoPage(
                        examen: _examenEmpty,
                        preclinica: preclinica,
                      )));
        }
      },
      child: GFCard(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        elevation: 6.0,
        height: 110.0,
        color: color,
        content: Column(
          children: <Widget>[
            Container(
              // decoration: BoxDecoration(
              //     shape: BoxShape.circle, color: Colors.red),
              margin: EdgeInsets.only(top: 5.0),
              child: FaIcon(
                icon,
                size: 40.0,
                color: Colors.white,
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 6.0),
              child: Text(
                texto,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 15.0),
              ),
            )
          ],
        ),
      ),
    );
  }

  _atendida(BuildContext context, PreclinicaViewModel preclinica) {
    AlertDialog alert = AlertDialog(
      title: Text("Información"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            'Al confirmar esta acción la consulta se cambiara a estado \"Atendida\"',
            textAlign: TextAlign.center,
          ),
          Text('Desea completar esta acción?'),
        ],
      ),
      elevation: 24.0,
      actions: [
        FlatButton(
            onPressed: () => Navigator.pop(context), child: Text('Cancelar')),
        FlatButton(
            onPressed: () {
              Navigator.pop(context);
              updatePreclinicaAndGoToDetalleConsulta(preclinica, context);
            },
            child: Text('Aceptar'))
      ],
    );

    // show the dialog
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
        barrierDismissible: false);
  }

  void updatePreclinicaAndGoToDetalleConsulta(
      PreclinicaViewModel preclinica, BuildContext context) async {
    final ProgressDialog _pr = new ProgressDialog(
      context,
      type: ProgressDialogType.Normal,
      isDismissible: false,
      showLogs: false,
    );
    _pr.update(
      progress: 50.0,
      message: "Espere...",
      progressWidget: Container(
          padding: EdgeInsets.all(8.0), child: CircularProgressIndicator()),
      maxProgress: 100.0,
      progressTextStyle: TextStyle(
          color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
      messageTextStyle: TextStyle(
          color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600),
    );
    await _pr.show();

    preclinica.atendida = true;

    final preclinicaEdit = await _preclinicaBloc.updatePreclinica(preclinica);

    if (preclinicaEdit != null) {
      await _pr.hide();
      Navigator.pushReplacementNamed(
        context,
        'preclinica',
      );
    } else {
      mostrarFlushBar(context, Colors.red, 'Info', 'Ha ocurrido un error', 2,
          Icons.info, Colors.white);
    }
  }
}
