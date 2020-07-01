import 'package:appsam/src/models/expediente_model.dart';
import 'package:appsam/src/pages/consulta/consultaDetalle/d_consultaGeneral_page.dart';
import 'package:appsam/src/pages/consulta/consultaDetalle/d_diagnosticos_page.dart';
import 'package:appsam/src/pages/consulta/consultaDetalle/d_examenFisico_page.dart';
import 'package:appsam/src/pages/consulta/consultaDetalle/d_examenes_page.dart';
import 'package:appsam/src/pages/consulta/consultaDetalle/d_notas_page.dart';
import 'package:appsam/src/pages/consulta/consultaDetalle/d_planTerapeutico_page.dart';
import 'package:appsam/src/utils/utils.dart';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class ExpConsultas extends StatefulWidget {
  final List<Consulta> consultas;

  const ExpConsultas({@required this.consultas});

  @override
  _ExpConsultasState createState() => _ExpConsultasState();
}

class _ExpConsultasState extends State<ExpConsultas> {
  int _currentPage = 0;
  List<Consulta> get _consultas => widget.consultas;

  @override
  Widget build(BuildContext context) {
    return Container(
        // color: Color.fromRGBO(255, 244, 233, 1),

        child: Column(
      children: <Widget>[
        Expanded(
            child: PageView.builder(
          itemCount: _consultas.length,
          onPageChanged: (page) {
            setState(() {
              _currentPage = page;
            });
          },
          controller: PageController(viewportFraction: 0.85),
          itemBuilder: (_, index) => _ItemConsulta(
            consulta: _consultas[index],
          ),
        )),
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Text(
            '${_currentPage + 1}/${_consultas.length}',
            style: TextStyle(fontSize: 14),
          ),
        )
      ],
    ));
  }
}

class _ItemConsulta extends StatefulWidget {
  final Consulta consulta;

  const _ItemConsulta({Key key, this.consulta}) : super(key: key);

  @override
  __ItemConsultaState createState() => __ItemConsultaState();
}

class __ItemConsultaState extends State<_ItemConsulta> {
  bool _selected = false;
  Consulta get _consulta => widget.consulta;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final itemHeight = constraints.maxHeight * 0.8;
        final itemWidth = constraints.maxWidth * 0.90;
        return SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(top: constraints.maxHeight * 0.1),
            child: Column(
              children: <Widget>[
                _FrontItem(
                    itemHeight: itemHeight,
                    itemWidth: itemWidth,
                    selected: _selected,
                    consulta: _consulta)
              ],
            ),
          ),
        );
      },
    );
  }
}

class _FrontItem extends StatelessWidget {
  const _FrontItem({
    Key key,
    @required this.itemHeight,
    @required this.itemWidth,
    @required bool selected,
    @required Consulta consulta,
  })  : _selected = selected,
        _consulta = consulta,
        super(key: key);

  final double itemHeight;
  final double itemWidth;
  final bool _selected;
  final Consulta _consulta;

  @override
  Widget build(BuildContext context) {
    final format = DateFormat.yMMMEd('es_Es');
    final _fechaPreclinica = format.format(_consulta.preclinica.creadoFecha);
    return Center(
      child: Container(
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(
              color: Colors.grey,
              blurRadius: 7,
            )
          ], borderRadius: BorderRadius.circular(10), color: Colors.white),
          height: itemHeight,
          width: itemWidth,
          margin: EdgeInsets.only(bottom: _selected ? itemHeight * 1.3 : 0),
          child: Stack(
            children: <Widget>[
              Column(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text(
                      'Consulta',
                      style: TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.w400),
                    ),
                  ),
                  Text(' $_fechaPreclinica'),
                  _itemInfo(_consulta.preclinica.peso.toString(), 'Peso (lbs)'),
                  _itemInfo(
                      _consulta.preclinica.altura.toString(), 'Altura (cm)'),
                  _itemInfo(_consulta.preclinica.temperatura.toString(),
                      'Temperatura (C°)'),
                  _itemInfo(
                      _consulta.preclinica.frecuenciaRespiratoria.toString(),
                      'Frecuencia respiratoria/rpm'),
                  _itemInfo(_consulta.preclinica.ritmoCardiaco.toString(),
                      'Ritmo cardiaco/bpm'),
                  _itemInfo(_consulta.preclinica.presionSistolica.toString(),
                      'Presión sistolica/mmHg'),
                  _itemInfo(_consulta.preclinica.presionDiastolica.toString(),
                      'Presión diastolica/mmHg'),
                  _itemInfo(_consulta.preclinica.iMc.toString(), 'IMC kg/m²'),
                  SizedBox(
                    height: 10,
                  ),
                  Expanded(
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: <Widget>[
                        _botonConsultaGeneral(context),
                        _botonDiagnosticos(context),
                        _botonExamenes(context),
                        _botonExamenFisico(context),
                        _botonPlanTerapeutico(context),
                        _botonNotas(context),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          )),
    );
  }

  FlatButton _botonNotas(BuildContext context) {
    return FlatButton.icon(
        label: Text(
          'Notas',
          style: TextStyle(fontSize: 12),
        ),
        icon: Icon(
          Icons.note_add,
          size: 20,
        ),
        onPressed: (_consulta.notas.length == 0)
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
                            notas: _consulta.notas,
                          ),
                        )));
              });
  }

  FlatButton _botonPlanTerapeutico(BuildContext context) {
    return FlatButton.icon(
        label: Text(
          'Plan terapeutico',
          style: TextStyle(fontSize: 12),
        ),
        icon: FaIcon(
          FontAwesomeIcons.stickyNote,
          size: 20,
        ),
        onPressed: (_consulta.planesTerapeuticos.length == 0)
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
                            plan: _consulta.planesTerapeuticos,
                          ),
                        )));
              });
  }

  FlatButton _botonExamenFisico(BuildContext context) {
    return FlatButton.icon(
      label: Text(
        'Examen Físico',
        style: TextStyle(fontSize: 12),
      ),
      icon: FaIcon(
        FontAwesomeIcons.diagnoses,
        size: 20,
      ),
      onPressed: (_consulta.examenFisico == null)
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
                          examenFisico: _consulta.examenFisico,
                        ),
                      )));
            },
    );
  }

  FlatButton _botonExamenes(BuildContext context) {
    return FlatButton.icon(
        label: Text(
          'Examenes',
          style: TextStyle(fontSize: 12),
        ),
        icon: FaIcon(
          FontAwesomeIcons.flask,
          size: 20,
        ),
        onPressed: (_consulta.examenesIndicados.length == 0)
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
                            examenes: _consulta.examenesIndicados,
                          ),
                        )));
              });
  }

  FlatButton _botonDiagnosticos(BuildContext context) {
    return FlatButton.icon(
      label: Text(
        'Diagnosticos',
        style: TextStyle(fontSize: 12),
      ),
      icon: Icon(
        Icons.note,
        size: 20,
      ),
      onPressed: (_consulta.diagnosticos.length == 0)
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
                          diagnosticos: _consulta.diagnosticos,
                        ),
                      )));
            },
    );
  }

  FlatButton _botonConsultaGeneral(BuildContext context) {
    return FlatButton.icon(
        onPressed: (_consulta.consultaGeneral == null)
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
                            consulta: _consulta.consultaGeneral,
                          ),
                        )));
              },
        icon: FaIcon(
          FontAwesomeIcons.briefcaseMedical,
          size: 20,
        ),
        label: Text(
          'Consulta General',
          style: TextStyle(fontSize: 12),
        ));
  }

  Widget _itemInfo(String title, String subtitle) {
    return Container(
      padding: const EdgeInsets.only(left: 10.0, right: 10.0),
      width: double.infinity,
      height: 50,
      child: ListTile(
        contentPadding: EdgeInsets.all(2),
        title: Text(title),
        subtitle: Text(subtitle),
      ),
    );
  }
}
