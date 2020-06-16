import 'package:appsam/src/blocs/consulta_bloc.dart';
import 'package:appsam/src/models/antecedentesFamiliaresPersonales_model.dart';
import 'package:appsam/src/models/consultaGeneral_model.dart';
import 'package:appsam/src/models/consulta_model.dart';
import 'package:appsam/src/models/diagnosticos_model.dart';

import 'package:appsam/src/models/examenFisico_model.dart';
import 'package:appsam/src/models/examenesIndicados_viewmodel.dart';
import 'package:appsam/src/models/farmacosUsoActual_model.dart';
import 'package:appsam/src/models/habitos_model.dart';
import 'package:appsam/src/models/historialGinecoObstetra_model.dart';
import 'package:appsam/src/models/notas_model.dart';
import 'package:appsam/src/models/paginados/preclinica_paginadoVM.dart';
import 'package:appsam/src/models/planTerapeutico_viewmodel.dart';

import 'package:appsam/src/utils/utils.dart';
import 'package:appsam/src/widgets/drawer.dart';
import 'package:appsam/src/widgets/firebaseMessageWrapper.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:getflutter/getflutter.dart';
import 'package:intl/intl.dart';

class ConsultaDetallePage extends StatefulWidget {
  static final String routeName = 'consulta_detalle';

  @override
  _ConsultaDetallePageState createState() => _ConsultaDetallePageState();
}

class _ConsultaDetallePageState extends State<ConsultaDetallePage> {
  final TextStyle _estiloSubt =
      new TextStyle(fontSize: 12.0, color: Colors.grey);
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
                  return SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        GFCard(
                          elevation: 5.0,
                          title: GFListTile(
                            avatar: ClipRRect(
                              borderRadius: BorderRadius.circular(100.0),
                              child: FadeInImage(
                                  width: 100,
                                  height: 100,
                                  placeholder:
                                      AssetImage('assets/jar-loading.gif'),
                                  image:
                                      NetworkImage(_preclinicaDetalle.fotoUrl)),
                            ),
                            title: Text(
                                '${_preclinicaDetalle.nombres} ${_preclinicaDetalle.primerApellido} ${_preclinicaDetalle.segundoApellido}'),
                            subTitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                    'Identificación: ${_preclinicaDetalle.identificacion}'),
                              ],
                            ),
                          ),
                          content: Table(
                              children: _camposPaciente(_preclinicaDetalle)),
                        ),
                        _AccordionPreclinica(
                            preclinica: _preclinicaDetalle,
                            estiloDatos: estiloDatos,
                            estiloSubt: _estiloSubt),
                        (_consultaDetalle.antecedentesFamiliaresPersonales !=
                                null)
                            ? _AccordionAntecedentes(
                                antecedentes: _consultaDetalle
                                    .antecedentesFamiliaresPersonales,
                                estiloDatos: estiloDatos,
                                estiloSubt: _estiloSubt)
                            : Container(),
                        (_consultaDetalle.habitos != null)
                            ? _AccordionHabitos(
                                habitos: _consultaDetalle.habitos,
                                estiloDatos: estiloDatos,
                                estiloSubt: _estiloSubt,
                              )
                            : Container(),
                        (_consultaDetalle.historialGinecoObstetra != null)
                            ? _AccordionHistorialGinecoObstetra(
                                historial:
                                    _consultaDetalle.historialGinecoObstetra,
                                estiloDatos: estiloDatos,
                                estiloSubt: _estiloSubt)
                            : Container(),
                        (_consultaDetalle.farmacosUsoActual.length != 0)
                            ? _AccordionFarmacos(
                                farmacos: _consultaDetalle.farmacosUsoActual,
                                estiloDatos: estiloDatos,
                                estiloSubt: _estiloSubt)
                            : Container(),
                        (_consultaDetalle.consultaGeneral != null)
                            ? _AccordionDetalleConsulta(
                                consultaGeneral:
                                    _consultaDetalle.consultaGeneral,
                                estiloDatos: estiloDatos,
                                estiloSubt: _estiloSubt)
                            : Container(),
                        (_consultaDetalle.examenFisico != null)
                            ? _AccordionExamenFisico(
                                examenFisico: _consultaDetalle.examenFisico,
                                estiloDatos: estiloDatos,
                                estiloSubt: _estiloSubt)
                            : Container(),
                        (_consultaDetalle.diagnosticos.length != 0)
                            ? _AccordionDiagnosticos(
                                diagnosticos: _consultaDetalle.diagnosticos,
                                estiloDatos: estiloDatos,
                                estiloSubt: _estiloSubt)
                            : Container(),
                        (_consultaDetalle.notas.length != 0)
                            ? _AccordionNotas(
                                notas: _consultaDetalle.notas,
                                estiloDatos: estiloDatos)
                            : Container(),
                        (_consultaDetalle.examenesIndicados.length != 0)
                            ? _AccordionExamenesIndicados(
                                examenes: _consultaDetalle.examenesIndicados,
                                estiloDatos: estiloDatos,
                                estiloSubt: _estiloSubt,
                              )
                            : Container(),
                        (_consultaDetalle.planesTerapeuticos.length != 0)
                            ? _AccordionPlanTerapeutico(
                                planes: _consultaDetalle.planesTerapeuticos,
                                estiloDatos: estiloDatos,
                                estiloSubt: _estiloSubt,
                              )
                            : Container(),
                      ],
                    ),
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

class _AccordionPreclinica extends StatelessWidget {
  const _AccordionPreclinica({
    Key key,
    @required PreclinicaViewModel preclinica,
    @required this.estiloDatos,
    @required TextStyle estiloSubt,
  })  : _preclinica = preclinica,
        _estiloSubt = estiloSubt,
        super(key: key);

  final PreclinicaViewModel _preclinica;
  final TextStyle estiloDatos;
  final TextStyle _estiloSubt;

  @override
  Widget build(BuildContext context) {
    return GFAccordion(
      contentPadding: EdgeInsets.all(3.0),
      collapsedTitlebackgroundColor: Theme.of(context).accentColor,
      expandedTitlebackgroundColor: Colors.redAccent,
      collapsedIcon: Icon(
        Icons.keyboard_arrow_down,
        color: Colors.white,
      ),
      expandedIcon: Icon(
        Icons.keyboard_arrow_up,
        color: Colors.white,
      ),
      titleChild: Text(
        'Preclinica',
        style: TextStyle(color: Colors.white, fontSize: 16.0),
      ),
      contentChild: GFCard(
          content: Table(
        children: [
          TableRow(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    '${_preclinica.peso}',
                    textAlign: TextAlign.justify,
                    style: estiloDatos,
                  ),
                  Text(
                    'Peso lb.',
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
                    '${_preclinica.altura}',
                    textAlign: TextAlign.justify,
                    style: estiloDatos,
                  ),
                  Text(
                    'Altura cm.',
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
                    '${_preclinica.frecuenciaRespiratoria}',
                    textAlign: TextAlign.justify,
                    style: estiloDatos,
                  ),
                  Text(
                    'Frec. Respiratoria/min',
                    textAlign: TextAlign.left,
                    style: _estiloSubt,
                  ),
                  Divider()
                ],
              ),
            ],
          ),
          TableRow(children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  '${_preclinica.imc}',
                  textAlign: TextAlign.justify,
                  style: estiloDatos,
                ),
                Text(
                  'IMC',
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
                  '${_preclinica.presionSistolica} / ${_preclinica.presionDiastolica}',
                  textAlign: TextAlign.justify,
                  style: estiloDatos,
                ),
                Text(
                  'Presion/mmHg',
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
                  '${_preclinica.ritmoCardiaco}',
                  textAlign: TextAlign.justify,
                  style: estiloDatos,
                ),
                Text(
                  'Ritmo Cardiaco',
                  textAlign: TextAlign.left,
                  style: _estiloSubt,
                ),
                Divider()
              ],
            ),
          ]),
          TableRow(children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  '${_preclinica.temperatura}',
                  textAlign: TextAlign.justify,
                  style: estiloDatos,
                ),
                Text(
                  'Temperatura Cº',
                  textAlign: TextAlign.left,
                  style: _estiloSubt,
                ),
                Divider()
              ],
            ),
            Column(),
            Column()
          ]),
        ],
      )),
    );
  }
}

class _AccordionAntecedentes extends StatelessWidget {
  const _AccordionAntecedentes({
    Key key,
    @required AntecedentesFamiliaresPersonales antecedentes,
    @required this.estiloDatos,
    @required TextStyle estiloSubt,
  })  : _antecedentes = antecedentes,
        _estiloSubt = estiloSubt,
        super(key: key);

  final AntecedentesFamiliaresPersonales _antecedentes;
  final TextStyle estiloDatos;
  final TextStyle _estiloSubt;

  @override
  Widget build(BuildContext context) {
    return GFAccordion(
      contentPadding: EdgeInsets.all(3.0),
      collapsedTitlebackgroundColor: Theme.of(context).accentColor,
      expandedTitlebackgroundColor: Colors.redAccent,
      collapsedIcon: Icon(
        Icons.keyboard_arrow_down,
        color: Colors.white,
      ),
      expandedIcon: Icon(
        Icons.keyboard_arrow_up,
        color: Colors.white,
      ),
      titleChild: Text(
        'Antecedentes',
        style: TextStyle(color: Colors.white, fontSize: 16.0),
      ),
      contentChild: GFCard(
          content: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Antecedentes Patológicos Familiares:',
            style: _estiloSubt,
          ),
          Text(
            _antecedentes.antecedentesPatologicosFamiliares,
            textAlign: TextAlign.justify,
            style: estiloDatos,
          ),
          Divider(),
          Text(
            'Antecedentes Patológicos Personales:',
            style: _estiloSubt,
          ),
          Text(
            _antecedentes.antecedentesPatologicosPersonales,
            textAlign: TextAlign.justify,
            style: estiloDatos,
          ),
          Divider(),
          Text(
            'Antecedentes No Patológicos Familiares:',
            style: _estiloSubt,
          ),
          Text(
            _antecedentes.antecedentesNoPatologicosFamiliares,
            textAlign: TextAlign.justify,
            style: estiloDatos,
          ),
          Divider(),
          Text(
            'Antecedentes No Patológicos Personales:',
            style: _estiloSubt,
          ),
          Text(
            _antecedentes.antecedentesNoPatologicosPersonales,
            textAlign: TextAlign.justify,
            style: estiloDatos,
          ),
          Divider(),
          Text(
            'Antecedentes Inmuno Alergicos Personales:',
            style: _estiloSubt,
          ),
          Text(
            _antecedentes.antecedentesInmunoAlergicosPersonales,
            textAlign: TextAlign.justify,
            style: estiloDatos,
          ),
          Divider()
        ],
      )),
    );
  }
}

class _AccordionHabitos extends StatelessWidget {
  const _AccordionHabitos({
    Key key,
    @required Habitos habitos,
    @required this.estiloDatos,
    @required TextStyle estiloSubt,
  })  : _habitos = habitos,
        _estiloSubt = estiloSubt,
        super(key: key);

  final Habitos _habitos;
  final TextStyle estiloDatos;
  final TextStyle _estiloSubt;

  @override
  Widget build(BuildContext context) {
    return GFAccordion(
      contentPadding: EdgeInsets.all(3.0),
      collapsedTitlebackgroundColor: Theme.of(context).accentColor,
      expandedTitlebackgroundColor: Colors.redAccent,
      collapsedIcon: Icon(
        Icons.keyboard_arrow_down,
        color: Colors.white,
      ),
      expandedIcon: Icon(
        Icons.keyboard_arrow_up,
        color: Colors.white,
      ),
      titleChild: Text(
        'Habitos',
        style: TextStyle(color: Colors.white, fontSize: 16.0),
      ),
      contentChild: GFCard(
          content: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(
                'El paciente consume café:',
              ),
              SizedBox(
                width: 8.0,
              ),
              (_habitos.cafe)
                  ? Icon(
                      Icons.check_circle_outline,
                      color: Colors.green,
                      size: 16,
                    )
                  : Icon(
                      Icons.close,
                      color: Colors.red,
                      size: 16,
                    ),
            ],
          ),
          SizedBox(
            height: 8.0,
          ),
          Divider(),
          Row(
            children: <Widget>[
              Text(
                'El paciente consume cigarrillos:',
              ),
              SizedBox(
                width: 8.0,
              ),
              (_habitos.cigarrillo)
                  ? Icon(
                      Icons.check_circle_outline,
                      color: Colors.green,
                      size: 16,
                    )
                  : Icon(
                      Icons.close,
                      color: Colors.red,
                      size: 16,
                    ),
            ],
          ),
          Divider(),
          Row(
            children: <Widget>[
              Text(
                'El paciente consume drogas:',
              ),
              SizedBox(
                width: 8.0,
              ),
              (_habitos.drogasEstupefaciente
                  ? Icon(
                      Icons.check_circle_outline,
                      color: Colors.green,
                      size: 16,
                    )
                  : Icon(
                      Icons.close,
                      color: Colors.red,
                      size: 16,
                    )),
            ],
          ),
          Divider(),
          Row(
            children: <Widget>[
              Text(
                'El paciente consume alcohol:',
              ),
              SizedBox(
                width: 8.0,
              ),
              (_habitos.alcohol
                  ? Icon(
                      Icons.check_circle_outline,
                      color: Colors.green,
                      size: 16,
                    )
                  : Icon(
                      Icons.close,
                      color: Colors.red,
                      size: 16,
                    )),
            ],
          ),
          Divider(),
          Text(
            'Notas:',
            style: _estiloSubt,
          ),
          Text(
            _habitos.notas,
            textAlign: TextAlign.justify,
            style: estiloDatos,
          ),
        ],
      )),
    );
  }
}

class _AccordionHistorialGinecoObstetra extends StatelessWidget {
  const _AccordionHistorialGinecoObstetra({
    Key key,
    @required HistorialGinecoObstetra historial,
    @required this.estiloDatos,
    @required TextStyle estiloSubt,
  })  : _historial = historial,
        _estiloSubt = estiloSubt,
        super(key: key);

  final HistorialGinecoObstetra _historial;
  final TextStyle estiloDatos;
  final TextStyle _estiloSubt;

  @override
  Widget build(BuildContext context) {
    final format = DateFormat.yMMMEd('es_Es');

    String fum;

    if (_historial.fum != null) {
      fum = format.format(_historial.fum);
    } else {
      fum = '';
    }

    return GFAccordion(
      contentPadding: EdgeInsets.all(3.0),
      collapsedTitlebackgroundColor: Theme.of(context).accentColor,
      expandedTitlebackgroundColor: Colors.redAccent,
      collapsedIcon: Icon(
        Icons.keyboard_arrow_down,
        color: Colors.white,
      ),
      expandedIcon: Icon(
        Icons.keyboard_arrow_up,
        color: Colors.white,
      ),
      titleChild: Text(
        'Historial Gineco Obstetra',
        style: TextStyle(color: Colors.white, fontSize: 16.0),
      ),
      contentChild: GFCard(
          content: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Table(
            children: [
              TableRow(
                children: [
                  Column(
                    children: <Widget>[
                      Text(
                        fum,
                        textAlign: TextAlign.justify,
                        style: estiloDatos,
                      ),
                      Text(
                        'Fecha ultima mestruación:',
                        style: _estiloSubt,
                      ),
                      Divider(),
                    ],
                  ),
                ],
              )
            ],
          ),
          Text(
            'G:',
            style: _estiloSubt,
          ),
          Text(
            _historial.g.toString(),
            textAlign: TextAlign.justify,
            style: estiloDatos,
          ),
          Divider(),
          Text(
            'P:',
            style: _estiloSubt,
          ),
          Text(
            _historial.p.toString(),
            textAlign: TextAlign.justify,
            style: estiloDatos,
          ),
          Divider(),
          Text(
            'C:',
            style: _estiloSubt,
          ),
          Text(
            _historial.c.toString(),
            textAlign: TextAlign.justify,
            style: estiloDatos,
          ),
          Divider(),
          Text(
            'HV:',
            style: _estiloSubt,
          ),
          Text(
            _historial.hv.toString(),
            textAlign: TextAlign.justify,
            style: estiloDatos,
          ),
          Divider(),
          Text(
            'Notas:',
            style: _estiloSubt,
          ),
          Text(
            _historial.notas,
            textAlign: TextAlign.justify,
            style: estiloDatos,
          ),
          Divider(),
        ],
      )),
    );
  }
}

class _AccordionFarmacos extends StatelessWidget {
  const _AccordionFarmacos({
    Key key,
    @required List<FarmacosUsoActual> farmacos,
    @required this.estiloDatos,
    @required TextStyle estiloSubt,
  })  : _farmacos = farmacos,
        super(key: key);

  final List<FarmacosUsoActual> _farmacos;
  final TextStyle estiloDatos;

  @override
  Widget build(BuildContext context) {
    return GFAccordion(
      contentPadding: EdgeInsets.all(3.0),
      collapsedTitlebackgroundColor: Theme.of(context).accentColor,
      expandedTitlebackgroundColor: Colors.redAccent,
      collapsedIcon: Icon(
        Icons.keyboard_arrow_down,
        color: Colors.white,
      ),
      expandedIcon: Icon(
        Icons.keyboard_arrow_up,
        color: Colors.white,
      ),
      titleChild: Text(
        'Farmacos de Uso Actual',
        style: TextStyle(color: Colors.white, fontSize: 16.0),
      ),
      contentChild: GFCard(
          content: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _crearItems(_farmacos))),
    );
  }

  List<Widget> _crearItems(List<FarmacosUsoActual> lista) {
    return lista.map((f) {
      return Column(
        children: <Widget>[
          ExpansionTile(
            title: Text('Nombre: ${f.nombre}'),
            children: <Widget>[
              Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.all(10.0),
                  child: Table(
                    children: [
                      TableRow(children: [
                        Text('Concentracion'),
                        Text(
                          f.concentracion,
                          textAlign: TextAlign.justify,
                        )
                      ]),
                      TableRow(children: [
                        Text('Dosis'),
                        Text(
                          f.dosis,
                          textAlign: TextAlign.justify,
                        )
                      ]),
                      TableRow(children: [
                        Text('Tiempo'),
                        Text(
                          f.tiempo,
                          textAlign: TextAlign.justify,
                        )
                      ]),
                      TableRow(children: [
                        Text('Notas'),
                        Text(
                          f.notas,
                          textAlign: TextAlign.justify,
                        )
                      ])
                    ],
                  ))
            ],
          ),
        ],
      );
    }).toList();
  }
}

class _AccordionExamenFisico extends StatelessWidget {
  const _AccordionExamenFisico({
    Key key,
    @required ExamenFisico examenFisico,
    @required this.estiloDatos,
    @required TextStyle estiloSubt,
  })  : _examenFisico = examenFisico,
        _estiloSubt = estiloSubt,
        super(key: key);

  final ExamenFisico _examenFisico;
  final TextStyle estiloDatos;
  final TextStyle _estiloSubt;

  @override
  Widget build(BuildContext context) {
    return GFAccordion(
      contentPadding: EdgeInsets.all(3.0),
      collapsedTitlebackgroundColor: Theme.of(context).accentColor,
      expandedTitlebackgroundColor: Colors.redAccent,
      collapsedIcon: Icon(
        Icons.keyboard_arrow_down,
        color: Colors.white,
      ),
      expandedIcon: Icon(
        Icons.keyboard_arrow_up,
        color: Colors.white,
      ),
      titleChild: Text(
        'Examen Físico',
        style: TextStyle(color: Colors.white, fontSize: 16.0),
      ),
      contentChild: GFCard(
          content: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Aspecto General:',
            style: _estiloSubt,
          ),
          Text(
            _examenFisico.aspectoGeneral,
            textAlign: TextAlign.justify,
            style: estiloDatos,
          ),
          Divider(),
          Text(
            'Cabeza:',
            style: _estiloSubt,
          ),
          Text(
            _examenFisico.cabeza,
            textAlign: TextAlign.justify,
            style: estiloDatos,
          ),
          Divider(),
          Text(
            'Oidos:',
            style: _estiloSubt,
          ),
          Text(
            _examenFisico.oidos,
            textAlign: TextAlign.justify,
            style: estiloDatos,
          ),
          Divider(),
          Text(
            'Ojos:',
            style: _estiloSubt,
          ),
          Text(
            _examenFisico.ojos,
            textAlign: TextAlign.justify,
            style: estiloDatos,
          ),
          Divider(),
          Text(
            'Cuello:',
            style: _estiloSubt,
          ),
          Text(
            _examenFisico.cuello,
            textAlign: TextAlign.justify,
            style: estiloDatos,
          ),
          Divider(),
          Text(
            'Torax:',
            style: _estiloSubt,
          ),
          Text(
            _examenFisico.torax,
            textAlign: TextAlign.justify,
            style: estiloDatos,
          ),
          Divider(),
          Text(
            'Abdomen:',
            style: _estiloSubt,
          ),
          Text(
            _examenFisico.abdomen,
            textAlign: TextAlign.justify,
            style: estiloDatos,
          ),
          Divider(),
          Text(
            'Piel Faneras:',
            style: _estiloSubt,
          ),
          Text(
            _examenFisico.pielFaneras,
            textAlign: TextAlign.justify,
            style: estiloDatos,
          ),
          Divider(),
          Text(
            'Genitales:',
            style: _estiloSubt,
          ),
          Text(
            _examenFisico.genitales,
            textAlign: TextAlign.justify,
            style: estiloDatos,
          ),
          Divider(),
          Text(
            'Neurólogico:',
            style: _estiloSubt,
          ),
          Text(
            _examenFisico.neurologico,
            textAlign: TextAlign.justify,
            style: estiloDatos,
          ),
          Divider(),
        ],
      )),
    );
  }
}

class _AccordionDiagnosticos extends StatelessWidget {
  const _AccordionDiagnosticos({
    Key key,
    @required List<Diagnosticos> diagnosticos,
    @required this.estiloDatos,
    @required TextStyle estiloSubt,
  })  : _diagnosticos = diagnosticos,
        super(key: key);

  final List<Diagnosticos> _diagnosticos;
  final TextStyle estiloDatos;

  @override
  Widget build(BuildContext context) {
    return GFAccordion(
      contentPadding: EdgeInsets.all(3.0),
      collapsedTitlebackgroundColor: Theme.of(context).accentColor,
      expandedTitlebackgroundColor: Colors.redAccent,
      collapsedIcon: Icon(
        Icons.keyboard_arrow_down,
        color: Colors.white,
      ),
      expandedIcon: Icon(
        Icons.keyboard_arrow_up,
        color: Colors.white,
      ),
      titleChild: Text(
        'Diagnosticos',
        style: TextStyle(color: Colors.white, fontSize: 16.0),
      ),
      contentChild: GFCard(
          content: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: items(_diagnosticos))),
    );
  }

  List<Widget> items(List<Diagnosticos> lista) {
    return lista.map((f) {
      return Column(
        children: <Widget>[
          ExpansionTile(
            title: Text(
              'Problema Clinico: ${f.problemasClinicos}',
              overflow: TextOverflow.ellipsis,
            ),
            children: <Widget>[
              Container(
                  padding: EdgeInsets.all(10.0),
                  child: GFCard(
                    elevation: 3.0,
                    content: Text(
                      f.problemasClinicos,
                      textAlign: TextAlign.justify,
                    ),
                  ))
            ],
          ),
        ],
      );
    }).toList();
  }
}

class _AccordionNotas extends StatelessWidget {
  const _AccordionNotas({
    Key key,
    @required List<Notas> notas,
    @required this.estiloDatos,
  })  : _notas = notas,
        super(key: key);

  final List<Notas> _notas;
  final TextStyle estiloDatos;

  @override
  Widget build(BuildContext context) {
    return GFAccordion(
      contentPadding: EdgeInsets.all(3.0),
      collapsedTitlebackgroundColor: Theme.of(context).accentColor,
      expandedTitlebackgroundColor: Colors.redAccent,
      collapsedIcon: Icon(
        Icons.keyboard_arrow_down,
        color: Colors.white,
      ),
      expandedIcon: Icon(
        Icons.keyboard_arrow_up,
        color: Colors.white,
      ),
      titleChild: Text(
        'Notas',
        style: TextStyle(color: Colors.white, fontSize: 16.0),
      ),
      contentChild: GFCard(
          content: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: items(_notas))),
    );
  }

  List<Widget> items(List<Notas> lista) {
    return lista.map((f) {
      return Column(
        children: <Widget>[
          ExpansionTile(
            title: Text(
              'Nota: ${f.notas}',
              overflow: TextOverflow.ellipsis,
            ),
            children: <Widget>[
              Container(
                  padding: EdgeInsets.all(10.0),
                  child: GFCard(
                    elevation: 3.0,
                    content: Text(
                      f.notas,
                      textAlign: TextAlign.justify,
                    ),
                  ))
            ],
          ),
        ],
      );
    }).toList();
  }
}

class _AccordionDetalleConsulta extends StatelessWidget {
  const _AccordionDetalleConsulta({
    Key key,
    @required ConsultaGeneralModel consultaGeneral,
    @required this.estiloDatos,
    @required TextStyle estiloSubt,
  })  : _consultaGeneral = consultaGeneral,
        _estiloSubt = estiloSubt,
        super(key: key);

  final ConsultaGeneralModel _consultaGeneral;
  final TextStyle estiloDatos;
  final TextStyle _estiloSubt;

  @override
  Widget build(BuildContext context) {
    return GFAccordion(
      contentPadding: EdgeInsets.all(3.0),
      collapsedTitlebackgroundColor: Theme.of(context).accentColor,
      expandedTitlebackgroundColor: Colors.redAccent,
      collapsedIcon: Icon(
        Icons.keyboard_arrow_down,
        color: Colors.white,
      ),
      expandedIcon: Icon(
        Icons.keyboard_arrow_up,
        color: Colors.white,
      ),
      titleChild: Text(
        'Información Consulta General',
        style: TextStyle(color: Colors.white, fontSize: 16.0),
      ),
      contentChild: GFCard(
          content: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Motivo de consulta:',
            style: _estiloSubt,
          ),
          Text(
            _consultaGeneral.motivoConsulta,
            textAlign: TextAlign.justify,
            style: estiloDatos,
          ),
          Divider(),
          Text(
            'Fog:',
            style: _estiloSubt,
          ),
          Text(
            _consultaGeneral.fog,
            textAlign: TextAlign.justify,
            style: estiloDatos,
          ),
          Divider(),
          Text(
            'Hea:',
            style: _estiloSubt,
          ),
          Text(
            _consultaGeneral.hea,
            textAlign: TextAlign.justify,
            style: estiloDatos,
          ),
          Divider(),
          Text(
            'Notas:',
            style: _estiloSubt,
          ),
          Text(
            _consultaGeneral.notas,
            textAlign: TextAlign.justify,
            style: estiloDatos,
          ),
          Divider(),
        ],
      )),
    );
  }
}

class _AccordionExamenesIndicados extends StatelessWidget {
  const _AccordionExamenesIndicados({
    Key key,
    @required List<ExamenesIndicadosViewModel> examenes,
    @required this.estiloDatos,
    @required TextStyle estiloSubt,
  })  : _examenes = examenes,
        super(key: key);

  final List<ExamenesIndicadosViewModel> _examenes;
  final TextStyle estiloDatos;

  @override
  Widget build(BuildContext context) {
    return GFAccordion(
      contentPadding: EdgeInsets.all(3.0),
      collapsedTitlebackgroundColor: Theme.of(context).accentColor,
      expandedTitlebackgroundColor: Colors.redAccent,
      collapsedIcon: Icon(
        Icons.keyboard_arrow_down,
        color: Colors.white,
      ),
      expandedIcon: Icon(
        Icons.keyboard_arrow_up,
        color: Colors.white,
      ),
      titleChild: Text(
        'Examenes indicados',
        style: TextStyle(color: Colors.white, fontSize: 16.0),
      ),
      contentChild: GFCard(
          content: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _crearItems(_examenes))),
    );
  }

  List<Widget> _crearItems(List<ExamenesIndicadosViewModel> lista) {
    return lista.map((f) {
      return Column(
        children: <Widget>[
          ExpansionTile(
            title: Text('Nombre: ${f.nombre}'),
            children: <Widget>[
              Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.all(10.0),
                  child: Table(
                    children: [
                      TableRow(children: [
                        Text('Examen categoria:'),
                        Text(
                          f.examenCategoria,
                          textAlign: TextAlign.justify,
                        )
                      ]),
                      TableRow(children: [
                        Text('Examen tipo:'),
                        Text(
                          f.examenTipo,
                          textAlign: TextAlign.justify,
                        )
                      ]),
                      TableRow(children: [
                        Text('Examen detalle:'),
                        Text(
                          (f.examenDetalle != null)
                              ? (f.examenDetalle[0].toUpperCase() +
                                  f.examenDetalle.substring(1).toLowerCase())
                              : '',
                          textAlign: TextAlign.justify,
                        )
                      ]),
                      TableRow(children: [
                        Text('Notas:'),
                        Text(
                          (f.notas != null) ? f.notas : '',
                          textAlign: TextAlign.justify,
                        )
                      ])
                    ],
                  ))
            ],
          ),
        ],
      );
    }).toList();
  }
}

class _AccordionPlanTerapeutico extends StatelessWidget {
  const _AccordionPlanTerapeutico({
    Key key,
    @required List<PlanTerapeuticoViewModel> planes,
    @required this.estiloDatos,
    @required TextStyle estiloSubt,
  })  : _planes = planes,
        super(key: key);

  final List<PlanTerapeuticoViewModel> _planes;
  final TextStyle estiloDatos;

  @override
  Widget build(BuildContext context) {
    return GFAccordion(
      contentPadding: EdgeInsets.all(3.0),
      collapsedTitlebackgroundColor: Theme.of(context).accentColor,
      expandedTitlebackgroundColor: Colors.redAccent,
      collapsedIcon: Icon(
        Icons.keyboard_arrow_down,
        color: Colors.white,
      ),
      expandedIcon: Icon(
        Icons.keyboard_arrow_up,
        color: Colors.white,
      ),
      titleChild: Text(
        'Plan Terapeutico',
        style: TextStyle(color: Colors.white, fontSize: 16.0),
      ),
      contentChild: GFCard(
          content: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _crearItems(_planes))),
    );
  }

  List<Widget> _crearItems(List<PlanTerapeuticoViewModel> lista) {
    return lista.map((f) {
      return Column(
        children: <Widget>[
          ExpansionTile(
            title: Text('Nombre: ${f.nombreMedicamento}'),
            children: <Widget>[
              Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.all(10.0),
                  child: Table(
                    children: [
                      TableRow(children: [
                        Text('Via administración:'),
                        Text(
                          f.viaAdministracion,
                          textAlign: TextAlign.justify,
                        )
                      ]),
                      TableRow(children: [
                        Text('Dosis:'),
                        Text(
                          f.dosis,
                          textAlign: TextAlign.justify,
                        )
                      ]),
                      TableRow(children: [
                        Text('Horario:'),
                        Text(
                          (f.horario),
                          textAlign: TextAlign.justify,
                        )
                      ]),
                      TableRow(children: [
                        Text('Dias requeridos:'),
                        Text(
                          (f.diasRequeridos),
                          textAlign: TextAlign.justify,
                        )
                      ]),
                      TableRow(children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text('Permanente:'),
                            Divider(),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            (f.permanente)
                                ? Icon(
                                    Icons.check_circle,
                                    size: 16.0,
                                    color: Colors.green,
                                  )
                                : Icon(
                                    FontAwesomeIcons.timesCircle,
                                    size: 16.0,
                                    color: Colors.red,
                                  ),
                            Divider(),
                          ],
                        ),
                      ]),
                      TableRow(children: [
                        Text('Notas:'),
                        Text(
                          (f.notas != null) ? f.notas : '',
                          textAlign: TextAlign.justify,
                        )
                      ])
                    ],
                  ))
            ],
          ),
        ],
      );
    }).toList();
  }
}
