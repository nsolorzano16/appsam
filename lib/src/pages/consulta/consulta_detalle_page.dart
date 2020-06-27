import 'dart:ui';

import 'package:appsam/src/blocs/consulta_bloc.dart';
import 'package:appsam/src/models/antecedentesFamiliaresPersonales_model.dart';
import 'package:appsam/src/models/consultaGeneral_model.dart';
import 'package:appsam/src/models/consulta_model.dart';
import 'package:appsam/src/models/diagnosticos_model.dart';

import 'package:appsam/src/models/examenFisico_model.dart';
import 'package:appsam/src/models/examenesIndicados_viewmodel.dart';
import 'package:appsam/src/models/farmacosUsoActual_model.dart';
import 'package:appsam/src/models/habitos_model.dart';

import 'package:appsam/src/models/historialGineco_viewmodel.dart';
import 'package:appsam/src/models/notas_model.dart';
import 'package:appsam/src/models/paginados/preclinica_paginadoVM.dart';
import 'package:appsam/src/models/planTerapeutico_viewmodel.dart';

import 'package:appsam/src/pages/consulta/consultaDetalle/d_antecedentes_consulta_page.dart';
import 'package:appsam/src/pages/consulta/consultaDetalle/d_consultaGeneral_page.dart';
import 'package:appsam/src/pages/consulta/consultaDetalle/d_diagnosticos_page.dart';
import 'package:appsam/src/pages/consulta/consultaDetalle/d_examenFisico_page.dart';
import 'package:appsam/src/pages/consulta/consultaDetalle/d_examenes_page.dart';
import 'package:appsam/src/pages/consulta/consultaDetalle/d_farmacos_page.dart';
import 'package:appsam/src/pages/consulta/consultaDetalle/d_habitos_page.dart';
import 'package:appsam/src/pages/consulta/consultaDetalle/d_historialGinecologico_page.dart';
import 'package:appsam/src/pages/consulta/consultaDetalle/d_notas_page.dart';
import 'package:appsam/src/pages/consulta/consultaDetalle/d_planTerapeutico_page.dart';
import 'package:appsam/src/pages/consulta/consultaDetalle/d_preclinica_consulta_page.dart';

import 'package:appsam/src/utils/utils.dart';
import 'package:appsam/src/widgets/drawer.dart';
import 'package:appsam/src/widgets/firebaseMessageWrapper.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/fa_icon.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:getflutter/getflutter.dart';
import 'package:intl/intl.dart';

class ConsultaDetallePage extends StatefulWidget {
  static final String routeName = 'consulta_detalle';

  @override
  _ConsultaDetallePageState createState() => _ConsultaDetallePageState();
}

class _ConsultaDetallePageState extends State<ConsultaDetallePage> {
  final TextStyle estiloDatos = new TextStyle(
    fontSize: 14.0,
  );

  final ConsultaBloc _consultaBloc = new ConsultaBloc();
  Future<ConsultaModel> _consultaFuture;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _consultaBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final PreclinicaViewModel _preclinicaDetalle =
        ModalRoute.of(context).settings.arguments;
    _consultaFuture = _consultaBloc.getDetalleConsulta(
        _preclinicaDetalle.pacienteId,
        _preclinicaDetalle.doctorId,
        _preclinicaDetalle.preclinicaId);
    final size = MediaQuery.of(context).size;

    return WillPopScope(
        child: FirebaseMessageWrapper(
          child: Scaffold(
            backgroundColor: Color.fromRGBO(255, 244, 233, 1),
            appBar: AppBar(
              title: Text('Detalle de Consulta'),
              actions: <Widget>[
                IconButton(
                    icon: Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                    ),
                    onPressed: () => Navigator.pushReplacementNamed(
                        context, 'menu_consulta',
                        arguments: _preclinicaDetalle))
              ],
            ),
            drawer: MenuWidget(),
            body: FutureBuilder(
              future: _consultaFuture,
              builder: (BuildContext context,
                  AsyncSnapshot<ConsultaModel> snapshot) {
                final _consultaDetalle = snapshot.data;
                if (snapshot.hasData) {
                  return Column(
                    children: <Widget>[
                      GFCard(
                        height: size.height * 0.5,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0)),
                        elevation: 5.0,
                        title: GFListTile(
                          title: Text(
                              '${_preclinicaDetalle.nombres} ${_preclinicaDetalle.primerApellido} ${_preclinicaDetalle.segundoApellido}'),
                          subTitle:
                              Text('${_preclinicaDetalle.identificacion}'),
                          avatar: ClipOval(
                            child: FadeInImage(
                                fit: BoxFit.cover,
                                width: 40.0,
                                height: 40.0,
                                placeholder:
                                    AssetImage('assets/jar-loading.gif'),
                                image:
                                    NetworkImage(_preclinicaDetalle.fotoUrl)),
                          ),
                        ),
                        content: Table(
                            children: _camposPaciente(_preclinicaDetalle)),
                      ),
                      Expanded(
                        child: ListView(
                          padding: EdgeInsets.all(30),
                          scrollDirection: Axis.horizontal,
                          children: <Widget>[
                            _cardPreclinica(context, _preclinicaDetalle),
                            _cardAntecedentes(
                                context,
                                _preclinicaDetalle,
                                _consultaDetalle
                                    .antecedentesFamiliaresPersonales),
                            _cardConsultaGeneral(context, _preclinicaDetalle,
                                _consultaDetalle.consultaGeneral),
                            _cardDiagnosticos(context, _preclinicaDetalle,
                                _consultaDetalle.diagnosticos),
                            _cardExamenes(context, _preclinicaDetalle,
                                _consultaDetalle.examenesIndicados),
                            _cardExamenFisico(context, _preclinicaDetalle,
                                _consultaDetalle.examenFisico),
                            _cardFarmacos(context, _preclinicaDetalle,
                                _consultaDetalle.farmacosUsoActual),
                            _cardHabitos(context, _preclinicaDetalle,
                                _consultaDetalle.habitos),
                            _cardHistorialGineco(context, _preclinicaDetalle,
                                _consultaDetalle.historialGinecoObstetra),
                            _cardNotas(context, _preclinicaDetalle,
                                _consultaDetalle.notas),
                            _cardPlanTerapeutico(context, _preclinicaDetalle,
                                _consultaDetalle.planesTerapeuticos),
                          ],
                        ),
                      )
                    ],
                  );
                } else {
                  return loadingIndicator(context);
                }
              },
            ),
          ),
        ),
        onWillPop: () async => false);
  }

  GestureDetector _cardAntecedentes(
      BuildContext context,
      PreclinicaViewModel preclinica,
      AntecedentesFamiliaresPersonales antecedentes) {
    return GestureDetector(
      onTap: (antecedentes == null)
          ? () {
              mostrarFlushBar(context, Colors.black, 'Info',
                  'No hay información.', 2, Icons.info, Colors.white);
            }
          : () {
              Navigator.of(context).push(PageRouteBuilder(
                  transitionDuration: const Duration(milliseconds: 800),
                  pageBuilder: (_, animation, __) => FadeTransition(
                        opacity: animation,
                        child: DetalleAntecedentesConsultaPage(
                          preclinica: preclinica,
                          antecedentes: antecedentes,
                        ),
                      )));
            },
      child: Container(
        width: 120,
        height: 120,
        child: Card(
          color: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          elevation: 4,
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 20),
                child: Text(
                  'Antecedentes Personales',
                  style: TextStyle(fontSize: 14, color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 10),
                child: Hero(
                  tag: 'antecedentesPortada',
                  child: FaIcon(
                    FontAwesomeIcons.heartbeat,
                    size: 90,
                    color: Colors.red,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  GestureDetector _cardConsultaGeneral(BuildContext context,
      PreclinicaViewModel preclinica, ConsultaGeneralModel consulta) {
    return GestureDetector(
      onTap: (consulta == null)
          ? () {
              mostrarFlushBar(context, Colors.black, 'Info',
                  'No hay información.', 2, Icons.info, Colors.white);
            }
          : () {
              Navigator.of(context).push(PageRouteBuilder(
                  transitionDuration: const Duration(milliseconds: 800),
                  pageBuilder: (_, animation, __) => FadeTransition(
                        opacity: animation,
                        child: DetConsultaGeneralPage(
                          preclinica: preclinica,
                          consulta: consulta,
                        ),
                      )));
            },
      child: Container(
        height: 120,
        width: 120,
        child: Card(
          color: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          elevation: 4,
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(
                    top: 10, bottom: 20, left: 5, right: 5),
                child: Text(
                  'Consulta General',
                  style: TextStyle(fontSize: 14, color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 20),
                child: Hero(
                  tag: 'consultageneralportada',
                  child: FaIcon(
                    FontAwesomeIcons.briefcaseMedical,
                    size: 100,
                    color: Colors.red,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  GestureDetector _cardDiagnosticos(BuildContext context,
      PreclinicaViewModel preclinica, List<Diagnosticos> diagnosticos) {
    return GestureDetector(
      onTap: (diagnosticos.length == 0)
          ? () {
              mostrarFlushBar(context, Colors.black, 'Info',
                  'No hay información.', 2, Icons.info, Colors.white);
            }
          : () {
              Navigator.of(context).push(PageRouteBuilder(
                  transitionDuration: const Duration(milliseconds: 800),
                  pageBuilder: (_, animation, __) => FadeTransition(
                        opacity: animation,
                        child: DetalleDiagnosticosPage(
                          preclinica: preclinica,
                          diagnosticos: diagnosticos,
                        ),
                      )));
            },
      child: Container(
        width: 120,
        height: 120,
        child: Card(
          color: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          elevation: 4,
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 20),
                child: Text(
                  'Diagnosticos',
                  style: TextStyle(fontSize: 14, color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 35),
                child: Hero(
                  tag: 'diagnosticosportada',
                  child: Icon(
                    Icons.note,
                    size: 100,
                    color: Colors.red,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  GestureDetector _cardExamenes(
      BuildContext context,
      PreclinicaViewModel preclinica,
      List<ExamenesIndicadosViewModel> examenes) {
    return GestureDetector(
      onTap: (examenes.length == 0)
          ? () {
              mostrarFlushBar(context, Colors.black, 'Info',
                  'No hay información.', 2, Icons.info, Colors.white);
            }
          : () {
              Navigator.of(context).push(PageRouteBuilder(
                  transitionDuration: const Duration(milliseconds: 800),
                  pageBuilder: (_, animation, __) => FadeTransition(
                        opacity: animation,
                        child: DetExamenesPage(
                          preclinica: preclinica,
                          examenes: examenes,
                        ),
                      )));
            },
      child: Container(
        width: 120,
        height: 120,
        child: Card(
          color: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          elevation: 4,
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 20),
                child: Text(
                  'Examenes',
                  style: TextStyle(fontSize: 14, color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 15),
                child: Hero(
                  tag: 'examenesportada',
                  child: FaIcon(
                    FontAwesomeIcons.flask,
                    size: 100,
                    color: Colors.red,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  GestureDetector _cardExamenFisico(BuildContext context,
      PreclinicaViewModel preclinica, ExamenFisico examen) {
    return GestureDetector(
      onTap: (examen == null)
          ? () {
              mostrarFlushBar(context, Colors.black, 'Info',
                  'No hay información.', 2, Icons.info, Colors.white);
            }
          : () {
              Navigator.of(context).push(PageRouteBuilder(
                  transitionDuration: const Duration(milliseconds: 800),
                  pageBuilder: (_, animation, __) => FadeTransition(
                        opacity: animation,
                        child: DetExamenFisicoPage(
                          preclinica: preclinica,
                          examenFisico: examen,
                        ),
                      )));
            },
      child: Container(
        width: 120,
        height: 120,
        child: Card(
          color: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          elevation: 4,
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 20),
                child: Text(
                  'Examen Fisico',
                  style: TextStyle(fontSize: 14, color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 32),
                child: Hero(
                  tag: 'examenfisicoportada',
                  child: FaIcon(
                    FontAwesomeIcons.diagnoses,
                    size: 80,
                    color: Colors.red,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  GestureDetector _cardFarmacos(BuildContext context,
      PreclinicaViewModel preclinica, List<FarmacosUsoActual> farmacos) {
    return GestureDetector(
      onTap: (farmacos.length == 0)
          ? () {
              mostrarFlushBar(context, Colors.black, 'Info',
                  'No hay información.', 2, Icons.info, Colors.white);
            }
          : () {
              Navigator.of(context).push(PageRouteBuilder(
                  transitionDuration: const Duration(milliseconds: 800),
                  pageBuilder: (_, animation, __) => FadeTransition(
                        opacity: animation,
                        child: DetFarmacosPage(
                          preclinica: preclinica,
                          farmacos: farmacos,
                        ),
                      )));
            },
      child: Container(
        width: 120,
        height: 120,
        child: Card(
          color: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          elevation: 4,
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 20),
                child: Text(
                  'Farmacos',
                  style: TextStyle(fontSize: 14, color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 35),
                child: Hero(
                  tag: 'farmacosportada',
                  child: FaIcon(
                    FontAwesomeIcons.capsules,
                    size: 80,
                    color: Colors.red,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  GestureDetector _cardHabitos(
      BuildContext context, PreclinicaViewModel preclinica, Habitos habitos) {
    return GestureDetector(
      onTap: (habitos == null)
          ? () {
              mostrarFlushBar(context, Colors.black, 'Info',
                  'No hay información.', 2, Icons.info, Colors.white);
            }
          : () {
              Navigator.of(context).push(PageRouteBuilder(
                  transitionDuration: const Duration(milliseconds: 800),
                  pageBuilder: (_, animation, __) => FadeTransition(
                        opacity: animation,
                        child: DetHabitosPage(
                          preclinica: preclinica,
                          habitos: habitos,
                        ),
                      )));
            },
      child: Container(
        width: 120,
        height: 120,
        child: Card(
          color: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          elevation: 4,
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 20),
                child: Text(
                  'Habitos',
                  style: TextStyle(fontSize: 14, color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 35),
                child: Hero(
                  tag: 'habitosportada',
                  child: FaIcon(
                    FontAwesomeIcons.coffee,
                    size: 80,
                    color: Colors.red,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  GestureDetector _cardHistorialGineco(BuildContext context,
      PreclinicaViewModel preclinica, HistorialGinecoViewModel historial) {
    return GestureDetector(
      onTap: (historial == null)
          ? () {
              mostrarFlushBar(context, Colors.black, 'Info',
                  'No hay información.', 2, Icons.info, Colors.white);
            }
          : () {
              Navigator.of(context).push(PageRouteBuilder(
                  transitionDuration: const Duration(milliseconds: 800),
                  pageBuilder: (_, animation, __) => FadeTransition(
                        opacity: animation,
                        child: DetHistorialGinecologico(
                          preclinica: preclinica,
                          historial: historial,
                        ),
                      )));
            },
      child: Container(
        width: 120,
        height: 120,
        child: Card(
          color: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          elevation: 4,
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 20),
                child: Text(
                  'Historial Ginecológico',
                  style: TextStyle(fontSize: 14, color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                child: Hero(
                  tag: 'historialginecologicoportada',
                  child: FaIcon(
                    FontAwesomeIcons.female,
                    size: 100,
                    color: Colors.red,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  GestureDetector _cardNotas(
      BuildContext context, PreclinicaViewModel preclinica, List<Notas> notas) {
    return GestureDetector(
      onTap: (notas.length == 0)
          ? () {
              mostrarFlushBar(context, Colors.black, 'Info',
                  'No hay información.', 2, Icons.info, Colors.white);
            }
          : () {
              Navigator.of(context).push(PageRouteBuilder(
                  transitionDuration: const Duration(milliseconds: 800),
                  pageBuilder: (_, animation, __) => FadeTransition(
                        opacity: animation,
                        child: DetNotasPage(
                          preclinica: preclinica,
                          notas: notas,
                        ),
                      )));
            },
      child: Container(
        width: 120,
        height: 120,
        child: Card(
          color: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          elevation: 4,
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 20),
                child: Text(
                  'Notas',
                  style: TextStyle(fontSize: 14, color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 30),
                child: Hero(
                  tag: 'notasportada',
                  child: Icon(
                    Icons.note_add,
                    size: 100,
                    color: Colors.red,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  GestureDetector _cardPlanTerapeutico(BuildContext context,
      PreclinicaViewModel preclinica, List<PlanTerapeuticoViewModel> planes) {
    return GestureDetector(
      onTap: (planes.length == 0)
          ? () {
              mostrarFlushBar(context, Colors.black, 'Info',
                  'No hay información.', 2, Icons.info, Colors.white);
            }
          : () {
              Navigator.of(context).push(PageRouteBuilder(
                  transitionDuration: const Duration(milliseconds: 800),
                  pageBuilder: (_, animation, __) => FadeTransition(
                        opacity: animation,
                        child: DetPlanTerapeutico(
                          preclinica: preclinica,
                          plan: planes,
                        ),
                      )));
            },
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 4,
        child: Column(
          children: <Widget>[
            Padding(
              padding:
                  const EdgeInsets.only(top: 10, bottom: 20, left: 5, right: 5),
              child: Text(
                'Plan Terapeutico',
                style: TextStyle(fontSize: 14, color: Colors.red),
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 25),
              child: Hero(
                tag: 'planterapeuticoportada',
                child: FaIcon(
                  FontAwesomeIcons.stickyNote,
                  size: 100,
                  color: Colors.red,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  GestureDetector _cardPreclinica(
      BuildContext context, PreclinicaViewModel preclinica) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 800),
            pageBuilder: (_, animation, __) => FadeTransition(
                  opacity: animation,
                  child: DetallePreclinicaConsultaPage(
                    preclinica: preclinica,
                  ),
                )));
      },
      child: Container(
        width: 120,
        height: 120,
        child: Card(
          color: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          elevation: 4,
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 20),
                child: Text(
                  'Preclinica',
                  style: TextStyle(fontSize: 14, color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 25),
                child: Hero(
                  tag: 'preclinicaPortada',
                  child: FaIcon(
                    FontAwesomeIcons.fileMedical,
                    size: 90,
                    color: Colors.red,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  List<TableRow> _camposPaciente(PreclinicaViewModel preclinica) {
    final TextStyle _estiloSubt =
        new TextStyle(fontSize: 12.0, color: Colors.grey);
    final TextStyle estiloDatos = new TextStyle(
      fontSize: 14.0,
    );
    final format = DateFormat.yMMMEd('es_Es');
    final _fechaNac = format.format(preclinica.fechaNacimiento);
    final lista = [
      TableRow(children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              _fechaNac,
              textAlign: TextAlign.justify,
              style: estiloDatos,
            ),
            Text(
              'Fecha de Nacimiento',
              textAlign: TextAlign.left,
              style: _estiloSubt,
            ),
            Divider()
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              '${(preclinica.sexo == 'M') ? 'Masculino' : 'Femenino'}',
              textAlign: TextAlign.justify,
              style: estiloDatos,
            ),
            Text(
              'Sexo',
              textAlign: TextAlign.left,
              style: _estiloSubt,
            ),
            Divider()
          ],
        )
      ]),
      TableRow(children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              '${preclinica.edad}',
              textAlign: TextAlign.justify,
              style: estiloDatos,
            ),
            Text(
              'Edad',
              textAlign: TextAlign.left,
              style: _estiloSubt,
            ),
            Divider()
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              _estadocivil(preclinica.estadoCivil),
              textAlign: TextAlign.justify,
              style: estiloDatos,
            ),
            Text(
              'Estado Civil',
              textAlign: TextAlign.left,
              style: _estiloSubt,
            ),
            Divider()
          ],
        )
      ]),
      (preclinica.menorDeEdad)
          ? TableRow(children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    (preclinica.nombreMadre != null)
                        ? '${preclinica.nombreMadre}'
                        : '- -',
                    textAlign: TextAlign.justify,
                    style: estiloDatos,
                  ),
                  Text(
                    'Nombre Madre',
                    textAlign: TextAlign.left,
                    style: _estiloSubt,
                  ),
                  Divider(),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    (preclinica.identificacionMadre != null)
                        ? '${preclinica.identificacionMadre}'
                        : '- -',
                    textAlign: TextAlign.justify,
                    style: estiloDatos,
                  ),
                  Text(
                    'Identificación Madre',
                    textAlign: TextAlign.left,
                    style: _estiloSubt,
                  ),
                  Divider(),
                ],
              )
            ])
          : TableRow(children: [Container(), Container()]),
      (preclinica.menorDeEdad)
          ? TableRow(children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    (preclinica.nombrePadre != null)
                        ? '${preclinica.nombrePadre}'
                        : '- -',
                    textAlign: TextAlign.justify,
                    style: estiloDatos,
                  ),
                  Text(
                    'Nombre Padre',
                    textAlign: TextAlign.left,
                    style: _estiloSubt,
                  ),
                  Divider(),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    (preclinica.identificacionPadre != null)
                        ? '${preclinica.identificacionPadre}'
                        : '- -',
                    textAlign: TextAlign.justify,
                    style: estiloDatos,
                  ),
                  Text(
                    'Identificación Padre',
                    textAlign: TextAlign.left,
                    style: _estiloSubt,
                  ),
                  Divider(),
                ],
              )
            ])
          : TableRow(children: [Container(), Container()]),
      (preclinica.menorDeEdad)
          ? TableRow(children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    (preclinica.carneVacuna != null)
                        ? '${preclinica.carneVacuna}'
                        : '- -',
                    textAlign: TextAlign.justify,
                    style: estiloDatos,
                  ),
                  Text(
                    'Carné Vacuna',
                    textAlign: TextAlign.left,
                    style: _estiloSubt,
                  ),
                  Divider(),
                ],
              ),
              Container()
            ])
          : TableRow(children: [Container(), Container()])
    ];

    return lista;
  }

  String _estadocivil(String estadoCivil) {
    if (estadoCivil == 'S') {
      return 'Solter@';
    } else if (estadoCivil == 'C') {
      return 'Casad@';
    } else if (estadoCivil == 'D') {
      return 'Divorciad@';
    } else if (estadoCivil == 'UL') {
      return 'Union Libre';
    }
    return '';
  }
}
