import 'package:appsam/src/models/paginados/preclinica_paginadoVM.dart';
import 'package:appsam/src/utils/storage_util.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:intl/intl.dart';

class PreclinicaDetallePage extends StatelessWidget {
  static final String routeName = 'preclinica_detalle';
  @override
  Widget build(BuildContext context) {
    StorageUtil.putString('ultimaPagina', PreclinicaDetallePage.routeName);
    final PreclinicaViewModel _preclinica =
        ModalRoute.of(context).settings.arguments;
    //final _screenSize = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          title: Text('Preclinica Detalle'),
        ),
        body: Stack(
          children: <Widget>[
            _crearFondo(context),
            SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  _crearDatosPaciente(_preclinica),
                  SizedBox(
                    height: 10.0,
                  ),
                  _crearDatosPreclinica(_preclinica),
                  SizedBox(
                    height: 10.0,
                  ),
                  _crearNotasPaciente(_preclinica),
                  SizedBox(
                    height: 10.0,
                  ),
                  _crearNotasPreclinica(_preclinica),
                  SizedBox(
                    height: 10.0,
                  ),
                ],
              ),
            )
          ],
        ));
  }

  Widget _crearFondo(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final fondoMorado = Container(
      height: size.height,
      width: double.infinity,
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: <Color>[
            Color.fromRGBO(0, 0, 77, 1.0),
            Color.fromRGBO(255, 0, 0, 1.0),
          ])),
    );
    final circulo = Container(
      width: 100.0,
      height: 100.0,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100.0),
          color: Color.fromRGBO(255, 255, 255, 0.1)),
    );
    return Stack(
      children: <Widget>[
        fondoMorado,
        Positioned(top: 90.0, left: 30.0, child: circulo),
        Positioned(top: -40.0, left: -30.0, child: circulo),
        Positioned(bottom: -50, right: -10, child: circulo),
        Positioned(bottom: 120, right: 20.0, child: circulo),
        Positioned(bottom: -50.0, left: -20.0, child: circulo),
      ],
    );
  }

  Widget _crearDatosPaciente(PreclinicaViewModel preclinica) {
    return Card(
        elevation: 7.0,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        child: ListTile(
          leading: _fotoPerfil(preclinica),
          title: _infoPaciente(preclinica),
        ));
  }

  Widget _fotoPerfil(PreclinicaViewModel preclinica) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(100.0),
      child: FadeInImage(
          placeholder: AssetImage('assets/jar-loading.gif'),
          image: NetworkImage(preclinica.fotoUrl)),
    );
  }

  Widget _infoPaciente(PreclinicaViewModel preclinica) {
    return Table(children: _camposPaciente(preclinica));
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

  List<TableRow> _camposPaciente(PreclinicaViewModel preclinica) {
    final TextStyle _estiloSubt =
        new TextStyle(fontSize: 12.0, color: Colors.indigo);
    final TextStyle estiloDatos =
        new TextStyle(fontSize: 14.0, color: Colors.black);
    final format = DateFormat.yMMMEd('es_Es');
    final _fechaNac = format.format(preclinica.fechaNacimiento);
    final lista = [
      TableRow(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                '${preclinica.nombres} ${preclinica.primerApellido} ${preclinica.segundoApellido}',
                textAlign: TextAlign.justify,
                style: estiloDatos,
              ),
              Text(
                'Nombre Completo',
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
                '${preclinica.identificacion}',
                textAlign: TextAlign.justify,
                style: estiloDatos,
              ),
              Text(
                'Identificación',
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
      TableRow(children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              '${preclinica.tipoDeSangre}',
              textAlign: TextAlign.justify,
              style: estiloDatos,
            ),
            Text(
              'Tipo de Sangre',
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
              '${(preclinica.email != null) ? preclinica.email : '- -'}',
              textAlign: TextAlign.justify,
              style: estiloDatos,
            ),
            Text(
              'Email',
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

  Widget _crearDatosPreclinica(PreclinicaViewModel preclinica) {
    return Card(
        elevation: 7.0,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        child: ListTile(
          title: _infoPreclinica(preclinica),
        ));
  }

  Widget _infoPreclinica(PreclinicaViewModel preclinica) {
    return Table(children: _camposPreclinica(preclinica));
  }

  List<TableRow> _camposPreclinica(PreclinicaViewModel preclinica) {
    final TextStyle _estiloSubt =
        new TextStyle(fontSize: 12.0, color: Colors.indigo);
    final TextStyle estiloDatos =
        new TextStyle(fontSize: 14.0, color: Colors.black);

    final lista = [
      TableRow(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                '${preclinica.peso} Lb.',
                textAlign: TextAlign.justify,
                style: estiloDatos,
              ),
              Text(
                'Peso',
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
                '${preclinica.altura} cm.',
                textAlign: TextAlign.justify,
                style: estiloDatos,
              ),
              Text(
                'Altura',
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
                '${preclinica.frecuenciaRespiratoria}',
                textAlign: TextAlign.justify,
                style: estiloDatos,
              ),
              Text(
                'Frecuencia Respiratoria',
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
              '${preclinica.ritmoCardiaco}',
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
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              '${preclinica.presionSistolica} / ${preclinica.presionDiastolica}',
              textAlign: TextAlign.justify,
              style: estiloDatos,
            ),
            Text(
              'Presion',
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
              '${preclinica.imc}',
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
        )
      ]),
    ];

    return lista;
  }

  Widget _crearNotasPaciente(PreclinicaViewModel preclinica) {
    final TextStyle _estiloSubt =
        new TextStyle(fontSize: 12.0, color: Colors.indigo);
    final TextStyle estiloDatos =
        new TextStyle(fontSize: 14.0, color: Colors.black);
    return Card(
        elevation: 7.0,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        child: ListTile(
          leading: FaIcon(FontAwesomeIcons.notesMedical),
          title: Text(
            '${preclinica.notasPaciente}',
            style: estiloDatos,
          ),
          subtitle: Text(
            'Notas Paciente',
            style: _estiloSubt,
            textAlign: TextAlign.justify,
          ),
        ));
  }

  Widget _crearNotasPreclinica(PreclinicaViewModel preclinica) {
    final TextStyle _estiloSubt =
        new TextStyle(fontSize: 12.0, color: Colors.indigo);
    final TextStyle estiloDatos =
        new TextStyle(fontSize: 14.0, color: Colors.black);
    return Card(
        elevation: 5.0,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        child: ListTile(
          leading: FaIcon(FontAwesomeIcons.notesMedical),
          title: Text(
            '${preclinica.notas}',
            style: estiloDatos,
            textAlign: TextAlign.justify,
          ),
          subtitle: Text(
            'Notas Preclinica',
            style: _estiloSubt,
          ),
        ));
  }
}
