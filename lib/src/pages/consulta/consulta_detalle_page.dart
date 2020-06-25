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
import 'package:flutter_svg/flutter_svg.dart';

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
  final _pageController = PageController(viewportFraction: 0.9);

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
                      Expanded(
                        child: Stack(
                          children: <Widget>[
                            Positioned(
                              child: GFCard(
                                height: size.height * 0.5,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0)),
                                elevation: 5.0,
                                title: GFListTile(
                                  title: Text(
                                      '${_preclinicaDetalle.nombres} ${_preclinicaDetalle.primerApellido} ${_preclinicaDetalle.segundoApellido}'),
                                  subTitle: Text(
                                      '${_preclinicaDetalle.identificacion}'),
                                  avatar: ClipOval(
                                    child: FadeInImage(
                                        fit: BoxFit.cover,
                                        width: 40.0,
                                        height: 40.0,
                                        placeholder: AssetImage(
                                            'assets/jar-loading.gif'),
                                        image: NetworkImage(
                                            _preclinicaDetalle.fotoUrl)),
                                  ),
                                ),
                                content: Table(
                                    children:
                                        _camposPaciente(_preclinicaDetalle)),
                              ),
                            ),
                            Positioned(
                              top: size.height * 0.55,
                              bottom: size.height * 0.05,
                              right: 0,
                              left: 0,
                              child: PageView(
                                controller: _pageController,
                                children: <Widget>[
                                  _cardPreclinica(
                                      context, size, _preclinicaDetalle),
                                  _cardAntecedentes(
                                      context,
                                      size,
                                      _preclinicaDetalle,
                                      _consultaDetalle
                                          .antecedentesFamiliaresPersonales),
                                  _cardConsultaGeneral(
                                      context,
                                      size,
                                      _preclinicaDetalle,
                                      _consultaDetalle.consultaGeneral),
                                  _cardDiagnosticos(
                                      context,
                                      size,
                                      _preclinicaDetalle,
                                      _consultaDetalle.diagnosticos),
                                  _cardExamenes(
                                      context,
                                      size,
                                      _preclinicaDetalle,
                                      _consultaDetalle.examenesIndicados),
                                  _cardExamenFisico(
                                      context,
                                      size,
                                      _preclinicaDetalle,
                                      _consultaDetalle.examenFisico),
                                  _cardFarmacos(
                                      context,
                                      size,
                                      _preclinicaDetalle,
                                      _consultaDetalle.farmacosUsoActual),
                                  _cardHabitos(
                                      context,
                                      size,
                                      _preclinicaDetalle,
                                      _consultaDetalle.habitos),
                                  _cardHistorialGineco(
                                      context,
                                      size,
                                      _preclinicaDetalle,
                                      _consultaDetalle.historialGinecoObstetra),
                                  _cardNotas(context, size, _preclinicaDetalle,
                                      _consultaDetalle.notas),
                                  _cardPlanTerapeutico(
                                      context,
                                      size,
                                      _preclinicaDetalle,
                                      _consultaDetalle.planesTerapeuticos),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
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
      Size size,
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
      child: Card(
        color: Color.fromRGBO(255, 218, 198, 1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        margin: EdgeInsets.all(10),
        elevation: 4,
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 20),
              child: Text(
                'Antecedentes Personales',
                style: TextStyle(
                    fontSize: 16, color: Color.fromRGBO(124, 106, 10, 1)),
              ),
            ),
            Container(
              height: size.height * 0.15,
              child: Hero(
                tag: 'antecedentesPortada',
                child: SvgPicture.asset(
                  'assets/svg/antecedentes.svg',
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  GestureDetector _cardConsultaGeneral(BuildContext context, Size size,
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
      child: Card(
        color: Color.fromRGBO(242, 232, 109, 1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        margin: EdgeInsets.all(10),
        elevation: 4,
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 20),
              child: Text(
                'Consulta General',
                style: TextStyle(
                    fontSize: 16, color: Color.fromRGBO(163, 133, 96, 1)),
              ),
            ),
            Container(
              height: size.height * 0.15,
              child: Hero(
                tag: 'consultageneralportada',
                child: SvgPicture.asset(
                  'assets/svg/consultageneral.svg',
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  GestureDetector _cardDiagnosticos(BuildContext context, Size size,
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
      child: Card(
        color: Color.fromRGBO(250, 179, 169, 1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        margin: EdgeInsets.all(10),
        elevation: 4,
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 20),
              child: Text(
                'Diagnosticos',
                style: TextStyle(
                    fontSize: 16, color: Color.fromRGBO(70, 50, 57, 1)),
              ),
            ),
            Container(
              height: size.height * 0.15,
              child: Hero(
                tag: 'diagnosticosportada',
                child: SvgPicture.asset(
                  'assets/svg/diagnosticos.svg',
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  GestureDetector _cardExamenes(
      BuildContext context,
      Size size,
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
      child: Card(
        color: Color.fromRGBO(0, 148, 198, 1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        margin: EdgeInsets.all(10),
        elevation: 4,
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 20),
              child: Text(
                'Examenes',
                style: TextStyle(
                    fontSize: 16, color: Color.fromRGBO(4, 15, 22, 1)),
              ),
            ),
            Container(
              height: size.height * 0.15,
              child: Hero(
                tag: 'examenesportada',
                child: SvgPicture.asset(
                  'assets/svg/examenes.svg',
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  GestureDetector _cardExamenFisico(BuildContext context, Size size,
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
      child: Card(
        color: Color.fromRGBO(153, 225, 217, 1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        margin: EdgeInsets.all(10),
        elevation: 4,
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 20),
              child: Text(
                'Examen Fisico',
                style: TextStyle(
                    fontSize: 16, color: Color.fromRGBO(50, 41, 47, 1)),
              ),
            ),
            Container(
              height: size.height * 0.15,
              child: Hero(
                tag: 'examenfisicoportada',
                child: SvgPicture.asset(
                  'assets/svg/examenfisico.svg',
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  GestureDetector _cardFarmacos(BuildContext context, Size size,
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
      child: Card(
        color: Color.fromRGBO(183, 182, 193, 1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        margin: EdgeInsets.all(10),
        elevation: 4,
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 20),
              child: Text(
                'Farmacos',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
            Container(
              height: size.height * 0.15,
              child: Hero(
                tag: 'farmacosportada',
                child: SvgPicture.asset(
                  'assets/svg/farmacos.svg',
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  GestureDetector _cardHabitos(BuildContext context, Size size,
      PreclinicaViewModel preclinica, Habitos habitos) {
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
      child: Card(
        color: Color.fromRGBO(225, 242, 254, 1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        margin: EdgeInsets.all(10),
        elevation: 4,
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 20),
              child: Text(
                'Habitos',
                style: TextStyle(
                    fontSize: 16, color: Color.fromRGBO(35, 2, 46, 1)),
              ),
            ),
            Container(
              height: size.height * 0.15,
              child: Hero(
                tag: 'habitosPortada',
                child: SvgPicture.asset(
                  'assets/svg/habitos.svg',
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  GestureDetector _cardHistorialGineco(BuildContext context, Size size,
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
      child: Card(
        color: Color.fromRGBO(171, 255, 79, 1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        margin: EdgeInsets.all(10),
        elevation: 4,
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 20),
              child: Text(
                'Historial Ginecológico',
                style: TextStyle(
                    fontSize: 16, color: Color.fromRGBO(41, 191, 18, 1)),
              ),
            ),
            Container(
              height: size.height * 0.15,
              child: Hero(
                tag: 'historialginecologicoportada',
                child: SvgPicture.asset(
                  'assets/svg/historialginecologico.svg',
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  GestureDetector _cardNotas(BuildContext context, Size size,
      PreclinicaViewModel preclinica, List<Notas> notas) {
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
      child: Card(
        color: Color.fromRGBO(219, 84, 97, 1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        margin: EdgeInsets.all(10),
        elevation: 4,
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 20),
              child: Text(
                'Notas',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
            Container(
              height: size.height * 0.15,
              child: Hero(
                tag: 'notasportada',
                child: SvgPicture.asset(
                  'assets/svg/notas.svg',
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  GestureDetector _cardPlanTerapeutico(BuildContext context, Size size,
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
        color: Color.fromRGBO(140, 173, 167, 1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        margin: EdgeInsets.all(10),
        elevation: 4,
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 20),
              child: Text(
                'Plan Terapeutico',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
            Container(
              height: size.height * 0.15,
              child: Hero(
                tag: 'planterapeuticoportada',
                child: SvgPicture.asset(
                  'assets/svg/planterapeutico.svg',
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  GestureDetector _cardPreclinica(
      BuildContext context, Size size, PreclinicaViewModel preclinica) {
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
      child: Card(
        color: Color.fromRGBO(180, 212, 238, 1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        margin: EdgeInsets.all(10),
        elevation: 4,
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 20),
              child: Text(
                'Preclinica',
                style: TextStyle(
                    fontSize: 16, color: Color.fromRGBO(129, 113, 122, 1)),
              ),
            ),
            Container(
              height: size.height * 0.15,
              child: Hero(
                tag: 'preclinicaPortada',
                child: SvgPicture.asset(
                  'assets/svg/preclinica.svg',
                ),
              ),
            )
          ],
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
