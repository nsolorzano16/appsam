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

const duration = Duration(milliseconds: 300);

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
          itemBuilder: (_, index) => AnimatedOpacity(
            opacity: _currentPage == index ? 1.0 : 0.5,
            duration: duration,
            child: _ItemConsulta(
              consulta: _consultas[index],
              itemSelected: _currentPage == index,
            ),
          ),
        ))
      ],
    ));
  }
}

class _ItemConsulta extends StatefulWidget {
  final bool itemSelected;
  final Consulta consulta;

  const _ItemConsulta({Key key, this.itemSelected, this.consulta})
      : super(key: key);

  @override
  __ItemConsultaState createState() => __ItemConsultaState();
}

class __ItemConsultaState extends State<_ItemConsulta> {
  bool _selected = false;
  Consulta get _consulta => widget.consulta;
  bool get _itemSelected => widget.itemSelected;

  @override
  Widget build(BuildContext context) {
    if (!_itemSelected) _selected = false;
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final itemHeight =
            constraints.maxHeight * (_itemSelected ? 0.53 : 0.55);
        final itemWidth = constraints.maxWidth * 0.90;

        // final backWidth = _selected ? itemWidth * 1.05 : itemWidth;
        final backHeight = _selected ? itemHeight * 0.9 : itemHeight;

        return SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(top: 20),
            // color: Colors.red,
            // alignment: Alignment.center,
            child: GestureDetector(
              onTap: _onTap,
              onVerticalDragUpdate: _onVerticalDrag,
              child: Stack(
                children: <Widget>[
                  _BackItem(
                    backHeight: backHeight,
                    backWidth: itemWidth,
                    selected: _selected,
                    itemHeight: itemHeight,
                    consulta: _consulta,
                  ),
                  _FrontItem(
                      itemHeight: itemHeight,
                      itemWidth: itemWidth,
                      selected: _selected,
                      consulta: _consulta)
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _onTap() {
    setState(() {
      _selected = !_selected;
    });

    // if (_selected) {

    //   Navigator.of(context).push(
    //     PageRouteBuilder(
    //         transitionDuration: const Duration(milliseconds: 700),
    //         pageBuilder: (_, animation1, __) => page,
    //         transitionsBuilder: (_, animation1, animation2, child) {
    //           return FadeTransition(
    //             opacity: animation1,
    //             child: child,
    //           );
    //         }),
    //   );
    // } else {
    //   setState(() {
    //     _selected = !_selected;
    //   });
    // }
  }

  void _onVerticalDrag(DragUpdateDetails details) {
    if (details.primaryDelta > 3.0) {
      setState(() {
        _selected = false;
      });
    }
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
      child: AnimatedContainer(
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(
              color: Colors.grey,
              blurRadius: 7,
            )
          ], borderRadius: BorderRadius.circular(10), color: Colors.white),
          duration: duration,
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
                  _itemInfo(_consulta.preclinica.peso.toString(), 'Peso (lb)',
                      FontAwesomeIcons.weight),
                  _itemInfo(_consulta.preclinica.altura.toString(),
                      'Altura (cm)', FontAwesomeIcons.arrowsAltV),
                  _itemInfo(_consulta.preclinica.temperatura.toString(),
                      'Temperatura (c°)', FontAwesomeIcons.thermometerHalf),
                  _itemInfo(
                      _consulta.preclinica.frecuenciaRespiratoria.toString(),
                      'Frecuencia respiratoria/min',
                      FontAwesomeIcons.heartbeat),
                  SizedBox(
                    height: 25,
                  ),
                  (!_selected)
                      ? Icon(
                          Icons.keyboard_arrow_down,
                          size: 32,
                        )
                      : Icon(
                          Icons.keyboard_arrow_up,
                          size: 32,
                        )
                ],
              ),

              // Positioned.fill(
              //     child: Hero(
              //         tag: _consulta.preclinica.preclinicaId,
              //         child: Container(

              //         )))
            ],
          )),
    );
  }

  Widget _itemInfo(String title, String subtitle, IconData icon) {
    return Container(
      padding: const EdgeInsets.only(left: 10.0, right: 10.0),
      width: double.infinity,
      height: 50,
      child: ListTile(
        trailing: FaIcon(
          icon,
          color: Colors.red,
          size: 17,
        ),
        contentPadding: EdgeInsets.all(2),
        title: Text(title),
        subtitle: Text(subtitle),
      ),
    );
  }
}

class _BackItem extends StatelessWidget {
  const _BackItem({
    Key key,
    @required this.backHeight,
    @required this.backWidth,
    @required bool selected,
    @required this.itemHeight,
    @required Consulta consulta,
  })  : _selected = selected,
        _consulta = consulta,
        super(key: key);

  final double backHeight;
  final double backWidth;
  final bool _selected;
  final double itemHeight;
  final Consulta _consulta;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedContainer(
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(
              color: Colors.grey,
              blurRadius: 7,
            )
          ], borderRadius: BorderRadius.circular(10), color: Colors.white),
          duration: duration,
          height: backHeight,
          width: backWidth,
          margin: EdgeInsets.only(top: _selected ? itemHeight * 0.88 : 0),
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 30,
              ),
              _itemInfo(_consulta.preclinica.ritmoCardiaco.toString(),
                  'Ritmo cardiaco', FontAwesomeIcons.heart),
              _itemInfo(_consulta.preclinica.presionSistolica.toString(),
                  'Presión sistolica', FontAwesomeIcons.tachometerAlt),
              _itemInfo(_consulta.preclinica.presionDiastolica.toString(),
                  'Presión diastolica', FontAwesomeIcons.tachometerAlt),
              _itemInfo(_consulta.preclinica.iMc.toString(), 'IMC',
                  FontAwesomeIcons.child),
              SizedBox(
                height: 8,
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
              )
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   mainAxisSize: MainAxisSize.max,
              //   children: <Widget>[

              //   ],
              // )
            ],
          )),
    );
  }

  IconButton _botonNotas(BuildContext context) {
    return IconButton(
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

  IconButton _botonPlanTerapeutico(BuildContext context) {
    return IconButton(
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

  IconButton _botonExamenFisico(BuildContext context) {
    return IconButton(
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

  IconButton _botonExamenes(BuildContext context) {
    return IconButton(
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

  IconButton _botonDiagnosticos(BuildContext context) {
    return IconButton(
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

  IconButton _botonConsultaGeneral(BuildContext context) {
    return IconButton(
        icon: FaIcon(
          FontAwesomeIcons.briefcaseMedical,
          size: 20,
        ),
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
              });
  }

  Widget _itemInfo(String title, String subtitle, IconData icon) {
    return Container(
      padding: const EdgeInsets.only(left: 10.0, right: 10.0),
      width: double.infinity,
      height: 50,
      child: ListTile(
        trailing: FaIcon(
          icon,
          color: Colors.red,
          size: 17,
        ),
        contentPadding: EdgeInsets.all(2),
        title: Text(title),
        subtitle: Text(subtitle),
      ),
    );
  }
}

class TravelConceptDetailPage extends StatelessWidget {
  final Consulta location;

  const TravelConceptDetailPage({Key key, this.location}) : super(key: key);

  void _onVerticalDrag(
    DragUpdateDetails details,
    BuildContext context,
  ) {
    if (details.primaryDelta > 3.0) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          GestureDetector(
            onVerticalDragUpdate: (details) =>
                _onVerticalDrag(details, context),
            child: Hero(
              tag: location.preclinica.preclinicaId,
              child: Image.network(
                'https://previews.123rf.com/images/djvstock/djvstock1610/djvstock161004214/64799755-teen-girl-character-avatar-vector-illustration-design.jpg',
                fit: BoxFit.cover,
              ),
            ),
          ),
          ...List.generate((20), (index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(
                      'https://previews.123rf.com/images/djvstock/djvstock1610/djvstock161004214/64799755-teen-girl-character-avatar-vector-illustration-design.jpg'),
                  radius: 15,
                ),
                title: Text('The Dart Side'),
                subtitle: Text(
                    'Come to the Dart Side :) ..... $index\nline 22222 \nline 33'),
              ),
            );
          })
        ],
      ),
    );
  }
}
