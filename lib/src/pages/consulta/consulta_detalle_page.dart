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
import 'package:appsam/src/pages/consulta/menuConsulta_page.dart';
import 'package:appsam/src/utils/utils.dart';
import 'package:appsam/src/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:getflutter/getflutter.dart';
import 'package:intl/intl.dart';

class ConsultaDetallePage extends StatefulWidget {
  static final String routeName = 'consulta_detalle';
  final PreclinicaViewModel preclinica;
  final ConsultaModel consulta;

  const ConsultaDetallePage(
      {Key key, @required this.preclinica, @required this.consulta})
      : super(key: key);

  @override
  _ConsultaDetallePageState createState() => _ConsultaDetallePageState();
}

class _ConsultaDetallePageState extends State<ConsultaDetallePage> {
  final TextStyle _estiloSubt =
      new TextStyle(fontSize: 12.0, color: Colors.grey);
  final TextStyle estiloDatos = new TextStyle(
    fontSize: 14.0,
  );

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _consultaDetalle = widget.consulta;
    final _preclinicaDetalle = widget.preclinica;

    return WillPopScope(
        child: Scaffold(
          appBar: AppBar(
            title: Text('Detalle de Consulta'),
            actions: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => MenuConsultaPage(
                                preclinica: _preclinicaDetalle,
                              )));
                },
              )
            ],
          ),
          drawer: MenuWidget(),
          body: SingleChildScrollView(
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
                          placeholder: AssetImage('assets/jar-loading.gif'),
                          image: NetworkImage(_preclinicaDetalle.fotoUrl)),
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
                  content: Table(children: _camposPaciente(_preclinicaDetalle)),
                ),
                _AccordionPreclinica(
                    preclinica: _preclinicaDetalle,
                    estiloDatos: estiloDatos,
                    estiloSubt: _estiloSubt),
                (_consultaDetalle.antecedentesFamiliaresPersonales != null)
                    ? _AccordionAntecedentes(
                        antecedentes:
                            _consultaDetalle.antecedentesFamiliaresPersonales,
                        estiloDatos: estiloDatos,
                        estiloSubt: _estiloSubt)
                    : Container(),
                (_consultaDetalle.habitos != null)
                    ? _AccordionHabitos(
                        habitos: _consultaDetalle.habitos,
                        estiloDatos: estiloDatos,
                        estiloSubt: _estiloSubt)
                    : Container(),
                (_consultaDetalle.historialGinecoObstetra != null)
                    ? _AccordionHistorialGinecoObstetra(
                        historial: _consultaDetalle.historialGinecoObstetra,
                        estiloDatos: estiloDatos,
                        estiloSubt: _estiloSubt)
                    : Container(),
                (_consultaDetalle.farmacosUsoActual.length > 0)
                    ? _AccordionFarmacos(
                        farmacos: _consultaDetalle.farmacosUsoActual,
                        estiloDatos: estiloDatos,
                        estiloSubt: _estiloSubt)
                    : Container(),
                (_consultaDetalle.examenFisico != null)
                    ? _AccordionExamenFisico(
                        examenFisico: _consultaDetalle.examenFisico,
                        estiloDatos: estiloDatos,
                        estiloSubt: _estiloSubt)
                    : Container(),
                (_consultaDetalle.examenFisicoGinecologico != null)
                    ? _AccordionExamenGinecologico(
                        examenGinecologico:
                            _consultaDetalle.examenFisicoGinecologico,
                        estiloDatos: estiloDatos,
                        estiloSubt: _estiloSubt)
                    : Container(),
                (_consultaDetalle.diagnosticos.length > 0)
                    ? _AccordionDiagnosticos(
                        diagnosticos: _consultaDetalle.diagnosticos,
                        estiloDatos: estiloDatos,
                        estiloSubt: _estiloSubt)
                    : Container(),
                (_consultaDetalle.notas.length > 0)
                    ? _AccordionNotas(
                        notas: _consultaDetalle.notas,
                        estiloDatos: estiloDatos,
                        estiloSubt: _estiloSubt)
                    : Container(),
              ],
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
          content: Column(
        children: <Widget>[
          Table(
            columnWidths: {2: FractionColumnWidth(0.5)},
            children: [
              TableRow(children: [
                Column(
                  children: <Widget>[
                    Text(
                      _preclinica.peso.toString(),
                      style: estiloDatos,
                    ),
                    Text(
                      'Peso',
                      style: _estiloSubt,
                    ),
                    Divider()
                  ],
                ),
                Column(
                  children: <Widget>[
                    Text(
                      _preclinica.altura.toString(),
                      style: estiloDatos,
                    ),
                    Text(
                      'Altura',
                      style: _estiloSubt,
                    ),
                    Divider()
                  ],
                ),
                Column(
                  children: <Widget>[
                    Text(
                      _preclinica.frecuenciaRespiratoria.toString(),
                      style: estiloDatos,
                    ),
                    Text(
                      'Frecuencia Respiratoria',
                      style: _estiloSubt,
                    ),
                    Divider()
                  ],
                )
              ]),
              TableRow(children: [
                Column(
                  children: <Widget>[
                    Text(
                      _preclinica.presionSistolica.toString(),
                      style: estiloDatos,
                    ),
                    Text(
                      'P. Sistolica',
                      style: _estiloSubt,
                    ),
                    Divider()
                  ],
                ),
                Column(
                  children: <Widget>[
                    Text(
                      _preclinica.presionDiastolica.toString(),
                      style: estiloDatos,
                    ),
                    Text(
                      'P. Diastolica',
                      style: _estiloSubt,
                    ),
                    Divider()
                  ],
                ),
                Column(
                  children: <Widget>[
                    Text(
                      _preclinica.ritmoCardiaco.toString(),
                      style: estiloDatos,
                    ),
                    Text(
                      'Ritmo Cardiaco',
                      style: _estiloSubt,
                    ),
                    Divider()
                  ],
                )
              ])
            ],
          ),
          Table(
            columnWidths: {1: FractionColumnWidth(0.7)},
            children: [
              TableRow(children: [
                Column(
                  children: <Widget>[
                    Text(
                      _preclinica.imc.toString(),
                      style: estiloDatos,
                    ),
                    Text(
                      'IMC',
                      style: _estiloSubt,
                    ),
                  ],
                ),
                Column(
                  children: <Widget>[
                    Text(
                      (_preclinica.pesoDescripcion != null)
                          ? _preclinica.pesoDescripcion.toString()
                          : '****',
                      style: estiloDatos,
                    ),
                    Text(
                      'Descripción de Peso',
                      style: _estiloSubt,
                    ),
                  ],
                )
              ])
            ],
          ),
          Divider(),
          Text(
            'Notas Preclinica',
            style: _estiloSubt,
          ),
          Text(
            _preclinica.notas,
            textAlign: TextAlign.justify,
          )
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
        'Antecedentes Personales',
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
            validaNulo(
                _antecedentes.antecedentesPatologicosFamiliares.toString()),
            textAlign: TextAlign.justify,
            style: estiloDatos,
          ),
          Divider(),
          Text(
            'Antecedentes Patológicos Personales:',
            style: _estiloSubt,
          ),
          Text(
            validaNulo(
                _antecedentes.antecedentesPatologicosPersonales.toString()),
            textAlign: TextAlign.justify,
            style: estiloDatos,
          ),
          Divider(),
          Text(
            'Antecedentes No Patológicos Familiares:',
            style: _estiloSubt,
          ),
          Text(
            validaNulo(
                _antecedentes.antecedentesNoPatologicosFamiliares.toString()),
            textAlign: TextAlign.justify,
            style: estiloDatos,
          ),
          Divider(),
          Text(
            'Antecedentes Patológicos Personales:',
            style: _estiloSubt,
          ),
          Text(
            validaNulo(
                _antecedentes.antecedentesNoPatologicosPersonales.toString()),
            textAlign: TextAlign.justify,
            style: estiloDatos,
          ),
          Divider(),
          Text(
            'Antecedentes Inmuno Alergicos Personales:',
            style: _estiloSubt,
          ),
          Text(
            validaNulo(
                _antecedentes.antecedentesInmunoAlergicosPersonales.toString()),
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
              SizedBox(
                width: 8.0,
              ),
              (_habitos.cafe)
                  ? Flexible(
                      child: Text(
                        'Tazas: ${_habitos.tazasCafe}',
                        overflow: TextOverflow.ellipsis,
                        style: estiloDatos,
                      ),
                    )
                  : Text('')
            ],
          ),
          SizedBox(
            height: 8.0,
          ),
          Row(
            children: <Widget>[
              Text(
                'El paciente fuma:',
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
              SizedBox(
                width: 8.0,
              ),
              (_habitos.cigarrillo)
                  ? Flexible(
                      child: Text(
                        'Cigarrillos: ${_habitos.cantidadCigarrillo}',
                        overflow: TextOverflow.ellipsis,
                        style: estiloDatos,
                      ),
                    )
                  : Text('')
            ],
          )
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
    String menarquia;
    String fur;
    String fechaMenopausia;

    if (_historial.menarquia != null) {
      menarquia = format.format(_historial.menarquia);
    } else {
      menarquia = '';
    }

    if (_historial.fur != null) {
      fur = format.format(_historial.fur);
    } else {
      fur = '';
    }

    if (_historial.fechaMenopausia != null) {
      fechaMenopausia = format.format(_historial.fechaMenopausia);
    } else {
      fechaMenopausia = '';
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
                        menarquia,
                        textAlign: TextAlign.justify,
                        style: estiloDatos,
                      ),
                      Text(
                        'Menarquia:',
                        style: _estiloSubt,
                      ),
                      Divider(),
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      Text(
                        fur,
                        textAlign: TextAlign.justify,
                        style: estiloDatos,
                      ),
                      Text(
                        'Fur:',
                        style: _estiloSubt,
                      ),
                      Divider(),
                    ],
                  )
                ],
              )
            ],
          ),
          Text(
            'Sg:',
            style: _estiloSubt,
          ),
          Text(
            validaNulo(_historial.sg.toString()),
            textAlign: TextAlign.justify,
            style: estiloDatos,
          ),
          Divider(),
          Text(
            'G:',
            style: _estiloSubt,
          ),
          Text(
            validaNulo(_historial.g.toString()),
            textAlign: TextAlign.justify,
            style: estiloDatos,
          ),
          Divider(),
          Text(
            'P:',
            style: _estiloSubt,
          ),
          Text(
            validaNulo(_historial.p.toString()),
            textAlign: TextAlign.justify,
            style: estiloDatos,
          ),
          Divider(),
          Text(
            'C:',
            style: _estiloSubt,
          ),
          Text(
            validaNulo(_historial.c.toString()),
            textAlign: TextAlign.justify,
            style: estiloDatos,
          ),
          Divider(),
          Text(
            'HV:',
            style: _estiloSubt,
          ),
          Text(
            validaNulo(_historial.hv.toString()),
            textAlign: TextAlign.justify,
            style: estiloDatos,
          ),
          Divider(),
          Text(
            'FPP:',
            style: _estiloSubt,
          ),
          Text(
            validaNulo(_historial.fpp.toString()),
            textAlign: TextAlign.justify,
            style: estiloDatos,
          ),
          Divider(),
          Text(
            'UC:',
            style: _estiloSubt,
          ),
          Text(
            validaNulo(_historial.uc.toString()),
            textAlign: TextAlign.justify,
            style: estiloDatos,
          ),
          Divider(),
          Text(
            'Fecha menopausia:',
            style: _estiloSubt,
          ),
          Text(
            fechaMenopausia,
            textAlign: TextAlign.justify,
            style: estiloDatos,
          ),
          Divider(),
          Text(
            'Anticonceptivo:',
            style: _estiloSubt,
          ),
          Text(
            validaNulo(_historial.anticonceptivo.toString()),
            textAlign: TextAlign.justify,
            style: estiloDatos,
          ),
          Divider(),
          Text(
            'Vacunación:',
            style: _estiloSubt,
          ),
          Text(
            validaNulo(_historial.vacunacion.toString()),
            textAlign: TextAlign.justify,
            style: estiloDatos,
          ),
          Divider(),
          Text(
            'Notas:',
            style: _estiloSubt,
          ),
          Text(
            validaNulo(_historial.notas.toString()),
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
        _estiloSubt = estiloSubt,
        super(key: key);

  final List<FarmacosUsoActual> _farmacos;
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
            validaNulo(_examenFisico.aspectoGeneral),
            textAlign: TextAlign.justify,
            style: estiloDatos,
          ),
          Divider(),
          Text(
            'Edad Aparente:',
            style: _estiloSubt,
          ),
          Text(
            validaNulo(_examenFisico.edadAparente.toString()),
            textAlign: TextAlign.justify,
            style: estiloDatos,
          ),
          Divider(),
          Text(
            'Marcha:',
            style: _estiloSubt,
          ),
          Text(
            validaNulo(_examenFisico.marcha),
            textAlign: TextAlign.justify,
            style: estiloDatos,
          ),
          Divider(),
          Text(
            'Orientaciones:',
            style: _estiloSubt,
          ),
          Text(
            validaNulo(_examenFisico.orientaciones),
            textAlign: TextAlign.justify,
            style: estiloDatos,
          ),
          Divider(),
          Text(
            'Pulso:',
            style: _estiloSubt,
          ),
          Text(
            validaNulo(_examenFisico.pulso),
            textAlign: TextAlign.justify,
            style: estiloDatos,
          ),
          Divider(),
          Text(
            'Pabd:',
            style: _estiloSubt,
          ),
          Text(
            validaNulo(_examenFisico.pabd),
            textAlign: TextAlign.justify,
            style: estiloDatos,
          ),
          Divider(),
          Text(
            'Ptorax:',
            style: _estiloSubt,
          ),
          Text(
            validaNulo(_examenFisico.ptorax),
            textAlign: TextAlign.justify,
            style: estiloDatos,
          ),
          Divider(),
          Text(
            'Observaciones:',
            style: _estiloSubt,
          ),
          Text(
            validaNulo(_examenFisico.observaciones),
            textAlign: TextAlign.justify,
            style: estiloDatos,
          ),
          Divider(),
          Table(
            children: [
              TableRow(children: [
                Column(
                  children: <Widget>[
                    (_examenFisico.dolorAusente)
                        ? Icon(Icons.check, color: Colors.green)
                        : Icon(Icons.close, color: Colors.red),
                    Text(
                      'Dolor Ausente',
                      style: _estiloSubt,
                    ),
                    Divider()
                  ],
                ),
                Column(
                  children: <Widget>[
                    (_examenFisico.dolorPresente)
                        ? Icon(Icons.check, color: Colors.green)
                        : Icon(Icons.close, color: Colors.red),
                    Text(
                      'Dolor Presente',
                      style: _estiloSubt,
                    ),
                    Divider()
                  ],
                ),
              ]),
              TableRow(children: [
                Column(
                  children: <Widget>[
                    (_examenFisico.dolorPresenteLeve)
                        ? Icon(Icons.check, color: Colors.green)
                        : Icon(Icons.close, color: Colors.red),
                    Text(
                      'Dolor Presente Leve',
                      style: _estiloSubt,
                    ),
                    Divider()
                  ],
                ),
                Column(
                  children: <Widget>[
                    (_examenFisico.dolorPresenteModerado)
                        ? Icon(Icons.check, color: Colors.green)
                        : Icon(Icons.close, color: Colors.red),
                    Text(
                      'Dolor Presente Moderado',
                      style: _estiloSubt,
                    ),
                    Divider()
                  ],
                ),
              ]),
              TableRow(children: [
                Column(
                  children: <Widget>[
                    (_examenFisico.dolorPresenteSevero)
                        ? Icon(Icons.check, color: Colors.green)
                        : Icon(Icons.close, color: Colors.red),
                    Text(
                      'Dolor Presente Severo',
                      style: _estiloSubt,
                    ),
                    Divider()
                  ],
                ),
                Column(
                  children: <Widget>[
                    (_examenFisico.excesoDePeso)
                        ? Icon(Icons.check, color: Colors.green)
                        : Icon(Icons.close, color: Colors.red),
                    Text(
                      'Exceso de Peso',
                      style: _estiloSubt,
                    ),
                    Divider()
                  ],
                ),
              ]),
            ],
          ),
          Text(
            'Peso Ideal:',
            style: _estiloSubt,
          ),
          Text(
            validaNulo(_examenFisico.pesoIdeal.toString()),
            textAlign: TextAlign.justify,
            style: estiloDatos,
          ),
          Divider(),
          Text(
            'Libras a bajar:',
            style: _estiloSubt,
          ),
          Text(
            validaNulo(_examenFisico.librasABajar.toString()),
            textAlign: TextAlign.justify,
            style: estiloDatos,
          ),
          Divider(),
          Text(
            'Interpretación:',
            style: _estiloSubt,
          ),
          Text(
            validaNulo(_examenFisico.interpretacion),
            textAlign: TextAlign.justify,
            style: estiloDatos,
          ),
          Divider(),
          Text(
            'Cabeza:',
            style: _estiloSubt,
          ),
          Text(
            validaNulo(_examenFisico.cabeza),
            textAlign: TextAlign.justify,
            style: estiloDatos,
          ),
          Divider(),
          Text(
            'Oidos:',
            style: _estiloSubt,
          ),
          Text(
            validaNulo(_examenFisico.oidos),
            textAlign: TextAlign.justify,
            style: estiloDatos,
          ),
          Divider(),
          Text(
            'Ojos:',
            style: _estiloSubt,
          ),
          Text(
            validaNulo(_examenFisico.ojos),
            textAlign: TextAlign.justify,
            style: estiloDatos,
          ),
          Divider(),
          Text(
            'Fo:',
            style: _estiloSubt,
          ),
          Text(
            validaNulo(_examenFisico.fo),
            textAlign: TextAlign.justify,
            style: estiloDatos,
          ),
          Divider(),
          Text(
            'Nariz:',
            style: _estiloSubt,
          ),
          Text(
            validaNulo(_examenFisico.nariz),
            textAlign: TextAlign.justify,
            style: estiloDatos,
          ),
          Divider(),
          Text(
            'Orofaringe:',
            style: _estiloSubt,
          ),
          Text(
            validaNulo(_examenFisico.oroFaringe),
            textAlign: TextAlign.justify,
            style: estiloDatos,
          ),
          Divider(),
          Text(
            'Cuello:',
            style: _estiloSubt,
          ),
          Text(
            validaNulo(_examenFisico.cuello),
            textAlign: TextAlign.justify,
            style: estiloDatos,
          ),
          Divider(),
          Text(
            'Torax:',
            style: _estiloSubt,
          ),
          Text(
            validaNulo(_examenFisico.torax),
            textAlign: TextAlign.justify,
            style: estiloDatos,
          ),
          Divider(),
          Text(
            'Mamas:',
            style: _estiloSubt,
          ),
          Text(
            validaNulo(_examenFisico.mamas),
            textAlign: TextAlign.justify,
            style: estiloDatos,
          ),
          Divider(),
          Text(
            'Pulmones:',
            style: _estiloSubt,
          ),
          Text(
            validaNulo(_examenFisico.pulmones),
            textAlign: TextAlign.justify,
            style: estiloDatos,
          ),
          Divider(),
          Text(
            'Corazón:',
            style: _estiloSubt,
          ),
          Text(
            validaNulo(_examenFisico.corazon),
            textAlign: TextAlign.justify,
            style: estiloDatos,
          ),
          Divider(),
          Text(
            'Rot:',
            style: _estiloSubt,
          ),
          Text(
            validaNulo(_examenFisico.rot),
            textAlign: TextAlign.justify,
            style: estiloDatos,
          ),
          Divider(),
          Text(
            'Abdomen:',
            style: _estiloSubt,
          ),
          Text(
            validaNulo(_examenFisico.abdomen),
            textAlign: TextAlign.justify,
            style: estiloDatos,
          ),
          Divider(),
          Text(
            'Piel Foneras:',
            style: _estiloSubt,
          ),
          Text(
            validaNulo(_examenFisico.pielfoneras),
            textAlign: TextAlign.justify,
            style: estiloDatos,
          ),
          Divider(),
          Text(
            'Genitales:',
            style: _estiloSubt,
          ),
          Text(
            validaNulo(_examenFisico.genitales),
            textAlign: TextAlign.justify,
            style: estiloDatos,
          ),
          Divider(),
          Text(
            'Recto Prostatico:',
            style: _estiloSubt,
          ),
          Text(
            validaNulo(_examenFisico.rectoProstatico),
            textAlign: TextAlign.justify,
            style: estiloDatos,
          ),
          Divider(),
          Text(
            'Miembros:',
            style: _estiloSubt,
          ),
          Text(
            validaNulo(_examenFisico.miembros),
            textAlign: TextAlign.justify,
            style: estiloDatos,
          ),
          Divider(),
          Text(
            'Neurólogico:',
            style: _estiloSubt,
          ),
          Text(
            validaNulo(_examenFisico.neurologico),
            textAlign: TextAlign.justify,
            style: estiloDatos,
          ),
          Divider(),
        ],
      )),
    );
  }
}

class _AccordionExamenGinecologico extends StatelessWidget {
  const _AccordionExamenGinecologico({
    Key key,
    @required ExamenFisicoGinecologico examenGinecologico,
    @required this.estiloDatos,
    @required TextStyle estiloSubt,
  })  : _examenGinecologico = examenGinecologico,
        _estiloSubt = estiloSubt,
        super(key: key);

  final ExamenFisicoGinecologico _examenGinecologico;
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
        'Examen Físico Ginecológico',
        style: TextStyle(color: Colors.white, fontSize: 16.0),
      ),
      contentChild: GFCard(
          content: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'AFU:',
            style: _estiloSubt,
          ),
          Text(
            validaNulo(_examenGinecologico.afu),
            textAlign: TextAlign.justify,
            style: estiloDatos,
          ),
          Divider(),
          Text(
            'Pelvis:',
            style: _estiloSubt,
          ),
          Text(
            validaNulo(_examenGinecologico.pelvis),
            textAlign: TextAlign.justify,
            style: estiloDatos,
          ),
          Divider(),
          Text(
            'Dorso:',
            style: _estiloSubt,
          ),
          Text(
            validaNulo(_examenGinecologico.dorso),
            textAlign: TextAlign.justify,
            style: estiloDatos,
          ),
          Divider(),
          Text(
            'FCF:',
            style: _estiloSubt,
          ),
          Text(
            validaNulo(_examenGinecologico.fcf),
            textAlign: TextAlign.justify,
            style: estiloDatos,
          ),
          Divider(),
          Text(
            'AP:',
            style: _estiloSubt,
          ),
          Text(
            validaNulo(_examenGinecologico.ap),
            textAlign: TextAlign.justify,
            style: estiloDatos,
          ),
          Divider(),
          Text(
            'Notas:',
            style: _estiloSubt,
          ),
          Text(
            validaNulo(_examenGinecologico.notas),
            textAlign: TextAlign.justify,
            style: estiloDatos,
          ),
          Divider()
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
        _estiloSubt = estiloSubt,
        super(key: key);

  final List<Diagnosticos> _diagnosticos;
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
    @required TextStyle estiloSubt,
  })  : _notas = notas,
        _estiloSubt = estiloSubt,
        super(key: key);

  final List<Notas> _notas;
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
