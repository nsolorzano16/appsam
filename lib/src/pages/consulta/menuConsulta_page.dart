import 'package:appsam/src/blocs/consulta_bloc.dart';
import 'package:appsam/src/models/antecedentesFamiliaresPersonales_model.dart';
import 'package:appsam/src/models/consulta_model.dart';
import 'package:appsam/src/models/diagnosticos_model.dart';
import 'package:appsam/src/models/examenFisicoGinecologico_model.dart';
import 'package:appsam/src/models/examenFisico_model.dart';
import 'package:appsam/src/models/farmacosUsoActual_model.dart';
import 'package:appsam/src/models/habitos_model.dart';
import 'package:appsam/src/models/historialGinecoObstetra_model.dart';
import 'package:appsam/src/models/notas_model.dart';
import 'package:appsam/src/models/paginados/preclinica_paginadoVM.dart';
import 'package:appsam/src/pages/consulta/consulta_detalle_page.dart';
import 'package:appsam/src/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:getflutter/getflutter.dart';

class MenuConsultaPage extends StatefulWidget {
  static final String routeName = 'menu_consulta';

  final PreclinicaViewModel preclinica;

  const MenuConsultaPage({Key key, this.preclinica}) : super(key: key);

  @override
  _MenuConsultaPageState createState() => _MenuConsultaPageState();
}

class _MenuConsultaPageState extends State<MenuConsultaPage> {
  final _consultaBloc = new ConsultaBloc();

  Future<ConsultaModel> _consultaFuture;

  @override
  void dispose() {
    super.dispose();
    _consultaBloc.dispose();
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

    return Scaffold(
      appBar: AppBar(
        title: Text('Menu Consulta'),
      ),
      drawer: MenuWidget(),
      body: FutureBuilder(
        future: _consultaFuture,
        builder: (BuildContext context, AsyncSnapshot<ConsultaModel> snapshot) {
          final _consultaDetalle = snapshot.data;
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
                        (_consultaDetalle.antecedentesFamiliaresPersonales ==
                                null)
                            ? _cardItem(
                                _preclinica,
                                FontAwesomeIcons.heartbeat,
                                'Antecedentes Personales',
                                'crear_antecedentes',
                                Colors.blue,
                                context)
                            : _cardItemFake(FontAwesomeIcons.heartbeat,
                                'Antecedentes Personales', Colors.grey),
                        (_consultaDetalle.habitos == null)
                            ? _cardItem(
                                _preclinica,
                                FontAwesomeIcons.coffee,
                                'Habitos',
                                'crear_habitos',
                                Colors.green,
                                context)
                            : _cardItemFake(
                                FontAwesomeIcons.coffee, 'Habitos', Colors.grey)
                      ]),
                      TableRow(children: [
                        (_consultaDetalle.historialGinecoObstetra == null)
                            ? _cardItem(
                                _preclinica,
                                FontAwesomeIcons.baby,
                                'Historial Gineco Obstetra',
                                'crear_historial_gineco',
                                Colors.blueGrey,
                                context)
                            : _cardItemFake(FontAwesomeIcons.baby,
                                'Historial Gineco Obstetra', Colors.grey),
                        (_consultaDetalle.farmacosUsoActual.length == 0)
                            ? _cardItem(
                                _preclinica,
                                Icons.people,
                                'Farmacos de Uso Actual',
                                'crear_farmacos_uso_actual',
                                Colors.orange,
                                context)
                            : _cardItemFake(Icons.people,
                                'Farmacos de Uso Actual', Colors.grey),
                      ]),
                      TableRow(children: [
                        (_consultaDetalle.examenFisico == null)
                            ? _cardItem(
                                _preclinica,
                                FontAwesomeIcons.child,
                                'Examen Físico',
                                'crear_examen_fisico',
                                Colors.brown,
                                context)
                            : _cardItemFake(FontAwesomeIcons.child,
                                'Examen Físico', Colors.grey),
                        (_consultaDetalle.examenFisicoGinecologico == null)
                            ? _cardItem(
                                _preclinica,
                                FontAwesomeIcons.female,
                                'Examen Físico Ginecológico',
                                'crear_examen_ginecologico',
                                Colors.purple,
                                context)
                            : _cardItemFake(FontAwesomeIcons.female,
                                'Examen Físico Ginecológico', Colors.grey),
                      ]),
                      TableRow(children: [
                        (_consultaDetalle.diagnosticos.length == 0)
                            ? _cardItem(_preclinica, Icons.note, 'Diagnosticos',
                                'crear_diagnosticos', Colors.pink, context)
                            : _cardItemFake(
                                Icons.note, 'Diagnosticos', Colors.grey),
                        (_consultaDetalle.notas.length == 0)
                            ? _cardItem(_preclinica, Icons.note_add, 'Notas',
                                'crear_notas', Colors.deepPurple, context)
                            : _cardItemFake(
                                Icons.note_add, 'Notas', Colors.grey)
                      ]),
                      TableRow(children: [
                        _cardItem(
                            _preclinica,
                            FontAwesomeIcons.userMd,
                            'Resumen de Consulta',
                            'consulta_detalle',
                            Colors.teal,
                            context),
                        _cardItem(_preclinica, FontAwesomeIcons.book, 'Receta',
                            'crear_historial', Colors.lime, context)
                      ]),
                    ],
                  )
                ],
              ),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Widget _cardItem(PreclinicaViewModel preclinica, IconData icon, String texto,
      String ruta, Color color, BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushReplacementNamed(context, ruta, arguments: preclinica);
      },
      child: GFCard(
        elevation: 3.0,
        height: 110.0,
        content: Column(
          children: <Widget>[
            Container(
              // decoration: BoxDecoration(
              //     shape: BoxShape.circle, color: Colors.red),
              margin: EdgeInsets.only(top: 5.0),
              child: FaIcon(
                icon,
                size: 40.0,
                color: color,
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 6.0),
              child: Text(
                texto,
                textAlign: TextAlign.center,
                style: TextStyle(color: color, fontSize: 15.0),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _cardItemFake(IconData icon, String texto, Color color) {
    return GFCard(
      elevation: 3.0,
      height: 110.0,
      content: Column(
        children: <Widget>[
          Container(
            // decoration: BoxDecoration(
            //     shape: BoxShape.circle, color: Colors.red),
            margin: EdgeInsets.only(top: 5.0),
            child: FaIcon(
              icon,
              size: 40.0,
              color: color,
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 6.0),
            child: Text(
              texto,
              textAlign: TextAlign.center,
              style: TextStyle(color: color, fontSize: 15.0),
            ),
          )
        ],
      ),
    );
  }

  Widget _cardItemConsultaDetalle(
    PreclinicaViewModel preclinica,
    IconData icon,
    String texto,
    String ruta,
    Color color,
    BuildContext context,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.pushReplacementNamed(context, 'consulta_detalle',
            arguments: preclinica);
      },
      child: GFCard(
        elevation: 3.0,
        height: 110.0,
        content: Column(
          children: <Widget>[
            Container(
              // decoration: BoxDecoration(
              //     shape: BoxShape.circle, color: Colors.red),
              margin: EdgeInsets.only(top: 5.0),
              child: FaIcon(
                icon,
                size: 40.0,
                color: color,
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 6.0),
              child: Text(
                texto,
                textAlign: TextAlign.center,
                style: TextStyle(color: color, fontSize: 15.0),
              ),
            )
          ],
        ),
      ),
    );
  }
}
