import 'package:appsam/src/blocs/preclinica_bloc.dart';

import 'package:appsam/src/utils/utils.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:getflutter/getflutter.dart';
import 'package:intl/intl.dart';

import 'package:appsam/src/models/paginados/preclinica_paginadoVM.dart';
import 'package:appsam/src/utils/storage_util.dart';
import 'package:appsam/src/widgets/drawer.dart';
import 'package:progress_dialog/progress_dialog.dart';

class PreclinicaDetallePage extends StatelessWidget {
  static final String routeName = 'preclinica_detalle';

  final PreclinicaBloc _preclinicaBloc = new PreclinicaBloc();

  @override
  Widget build(BuildContext context) {
    StorageUtil.putString('ultimaPagina', PreclinicaDetallePage.routeName);

    final PreclinicaViewModel _preclinica =
        ModalRoute.of(context).settings.arguments;
    //final _screenSize = MediaQuery.of(context).size;
    return WillPopScope(
        child: Scaffold(
          appBar: AppBar(
            title: Text('Preclinica Detalle'),
            actions: <Widget>[
              IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () => Navigator.pushNamed(
                      context, 'editar_preclinica',
                      arguments: _preclinica))
            ],
          ),
          drawer: MenuWidget(),
          body: Stack(
            children: <Widget>[
              SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    _crearDatosPaciente(_preclinica),
                    _crearDatosPreclinica(_preclinica),
                    _crearNotasPreclinica(_preclinica),
                    _crearNotasPaciente(_preclinica),
                  ],
                ),
              )
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
// set up the AlertDialog
              AlertDialog alert = AlertDialog(
                title: Text("Información"),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      'Al confirmar esta acción la preclinica se cambiara a estado \"Atendida\"',
                      textAlign: TextAlign.center,
                    ),
                    Text('Desea completar esta acción?'),
                  ],
                ),
                elevation: 24.0,
                actions: [
                  FlatButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Cancelar')),
                  FlatButton(
                      onPressed: () {
                        Navigator.pop(context);
                        updatePreclinicaAndGoToDetalleConsulta(
                            _preclinica, context);
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
            },
            child: FaIcon(FontAwesomeIcons.notesMedical),
            backgroundColor: Theme.of(context).primaryColor,
          ),
        ),
        onWillPop: () async => false);
  }

  Widget _crearDatosPaciente(PreclinicaViewModel preclinica) {
    return GFCard(
      elevation: 5.0,
      title: GFListTile(
        avatar: ClipRRect(
          borderRadius: BorderRadius.circular(100.0),
          child: FadeInImage(
              width: 100,
              height: 100,
              placeholder: AssetImage('assets/jar-loading.gif'),
              image: NetworkImage(preclinica.fotoUrl)),
        ),
        title: Text(
            '${preclinica.nombres} ${preclinica.primerApellido} ${preclinica.segundoApellido}'),
        subTitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Identificación: ${preclinica.identificacion}'),
          ],
        ),
      ),
      content: Table(children: _camposPaciente(preclinica)),
    );
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

  Widget _crearDatosPreclinica(PreclinicaViewModel preclinica) {
    return GFCard(
      elevation: 5.0,
      content: _infoPreclinica(preclinica),
    );
  }

  Widget _infoPreclinica(PreclinicaViewModel preclinica) {
    return Table(children: _camposPreclinica(preclinica));
  }

  List<TableRow> _camposPreclinica(PreclinicaViewModel preclinica) {
    final TextStyle _estiloSubt =
        new TextStyle(fontSize: 12.0, color: Colors.grey);
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
        new TextStyle(fontSize: 12.0, color: Colors.grey);
    final TextStyle estiloDatos =
        new TextStyle(fontSize: 14.0, color: Colors.black);

    return GFCard(
      elevation: 5.0,
      padding: EdgeInsets.symmetric(horizontal: 6.0, vertical: 4.0),
      content: ListTile(
        leading: FaIcon(
          FontAwesomeIcons.stickyNote,
          color: Colors.red,
        ),
        title: Text(
          '${preclinica.notasPaciente}',
          style: estiloDatos,
        ),
        subtitle: Text(
          'Notas Paciente',
          style: _estiloSubt,
          textAlign: TextAlign.justify,
        ),
      ),
    );
  }

  Widget _crearNotasPreclinica(PreclinicaViewModel preclinica) {
    final TextStyle _estiloSubt =
        new TextStyle(fontSize: 12.0, color: Colors.grey);
    final TextStyle estiloDatos =
        new TextStyle(fontSize: 14.0, color: Colors.black);
    return GFCard(
        elevation: 5.0,
        padding: EdgeInsets.symmetric(horizontal: 6.0, vertical: 4.0),
        content: ListTile(
          leading: FaIcon(
            FontAwesomeIcons.stickyNote,
            color: Colors.red,
          ),
          title: (preclinica.notas != null)
              ? Text(
                  '${preclinica.notas}',
                  style: estiloDatos,
                  textAlign: TextAlign.justify,
                )
              : Text('*****'),
          subtitle: Text(
            'Notas Preclinica',
            style: _estiloSubt,
          ),
        ));
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
      _pr.hide();

      Navigator.pushReplacementNamed(context, 'menu_consulta',
          arguments: preclinicaEdit);
    } else {
      mostrarFlushBar(context, Colors.red, 'Info', 'Ha ocurrido un error', 2,
          FlushbarPosition.TOP, Icons.info, Colors.white);
    }
  }
}
