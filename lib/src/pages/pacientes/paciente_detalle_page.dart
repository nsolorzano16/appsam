import 'package:appsam/src/widgets/firebaseMessageWrapper.dart';
import 'package:flutter/material.dart';
import 'package:getflutter/getflutter.dart';
import 'package:intl/intl.dart';

import 'package:appsam/src/models/paginados/pacientesPaginado_model.dart';
import 'package:appsam/src/pages/pacientes/edit_paciente_page.dart';
import 'package:appsam/src/utils/storage_util.dart';
import 'package:appsam/src/widgets/drawer.dart';

class PacienteDetalle extends StatefulWidget {
  static final String routeName = 'paciente_detalle';
  @override
  _PacienteDetalleState createState() => _PacienteDetalleState();
}

class _PacienteDetalleState extends State<PacienteDetalle> {
  @override
  void initState() {
    super.initState();
    StorageUtil.putString('ultimaPagina', PacienteDetalle.routeName);
  }

  @override
  Widget build(BuildContext context) {
    final PacientesViewModel _paciente =
        ModalRoute.of(context).settings.arguments;
    final _screenSize = MediaQuery.of(context).size;
    return WillPopScope(
        child: FirebaseMessageWrapper(
          child: Scaffold(
              appBar: AppBar(
                title: Text('${_paciente.nombres}'),
                actions: <Widget>[
                  IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EditarPacientePage(
                                      paciente: _paciente,
                                    )));
                      }),
                  IconButton(
                      icon: Icon(Icons.arrow_back_ios),
                      onPressed: () =>
                          Navigator.pushReplacementNamed(context, 'pacientes'))
                ],
              ),
              drawer: MenuWidget(),
              body: SingleChildScrollView(
                // physics: BouncingScrollPhysics(),
                child: Container(
                  margin: EdgeInsets.only(top: 5.0),
                  width: _screenSize.width,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      GFCard(
                        boxFit: BoxFit.cover,
                        title: GFListTile(
                          avatar: FadeInImage(
                              width: 100,
                              height: 100,
                              placeholder: AssetImage('assets/jar-loading.gif'),
                              image: NetworkImage(_paciente.fotoUrl)),
                          title: Text(
                            '${_paciente.nombres} ${_paciente.primerApellido} ${_paciente.segundoApellido}',
                          ),
                          subTitle: Text(
                            'Nombre Completo',
                          ),
                        ),
                        content: _detallePaciente(_paciente, context),
                      ),
                    ],
                  ),
                ),
              )),
        ),
        onWillPop: () async => false);
  }

  Widget _detallePaciente(PacientesViewModel paciente, BuildContext context) {
    final format = DateFormat.yMMMEd('es_Es');
    final _fechaNac = format.format(paciente.fechaNacimiento);
    // final _screenSize = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.only(top: 10.0, left: 5.0, right: 5.0, bottom: 10.0),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(
                'Información Personal',
                style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 30.0,
              )
            ],
          ),
          Divider(),
          Table(
            children: [
              TableRow(
                  children: [Text('Fecha de Nacimiento:'), Text('$_fechaNac')]),
              TableRow(children: [
                Text('Identificación:'),
                (paciente.identificacion != null)
                    ? Text('${paciente.identificacion}')
                    : Text('*****'),
              ]),
              TableRow(children: [
                Text('Email:'),
                (paciente.identificacion != null)
                    ? Text('${paciente.email}')
                    : Text('*****'),
              ]),
              TableRow(children: [
                Text('Edad:'),
                (paciente.edad != null)
                    ? Text('${paciente.edad}')
                    : Text('*****'),
              ]),
              TableRow(children: [
                Text('Sexo:'),
                Text((paciente.sexo == 'F') ? 'Femenino' : 'Masculino')
              ]),
              TableRow(children: [
                Text('Estado Civil:'),
                Text(_estadoCivil(paciente.estadoCivil)),
              ]),
              TableRow(children: [
                Text('Teléfono:'),
                Text('${paciente.telefono1}'),
              ]),
              TableRow(children: [
                Text('Contacto de Emergencia:'),
                Text('${paciente.nombreEmergencia}'),
              ]),
              TableRow(children: [
                Text('Tel. contacto de emergencia:'),
                Text('${paciente.telefonoEmergencia}'),
              ]),
              TableRow(children: [
                Text('Parentesco'),
                Text('${paciente.parentesco}'),
              ]),
              TableRow(children: [
                Text('Pais'),
                (paciente.pais != null)
                    ? Text('${paciente.pais}')
                    : Text('*****'),
              ]),
            ],
          ),
          Divider(),
          Row(
            children: <Widget>[
              Text(
                'Datos Generales',
                style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 30.0,
              )
            ],
          ),
          Divider(),
          Table(
            children: [
              TableRow(children: [
                Text('Escolaridad:'),
                Text('${paciente.escolaridad}'),
              ]),
              TableRow(children: [
                Text('Religion:'),
                Text('${paciente.religion}'),
              ]),
              TableRow(
                children: [
                  Text('Tipo de Sangre:'),
                  Text('${paciente.grupoSanguineo}'),
                ],
              ),
              TableRow(
                children: [
                  Text('Grupo Etnico:'),
                  Text('${paciente.grupoEtnico}'),
                ],
              ),
              TableRow(
                children: [
                  Text('Profesión:'),
                  Text('${paciente.profesion}'),
                ],
              ),
            ],
          ),
          Divider(),
          Row(
            children: <Widget>[
              Text(
                'Datos Referenciales',
                style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 30.0,
              )
            ],
          ),
          Divider(),
          Table(
            children: [
              TableRow(
                children: [
                  Text('Depto. de Nacimiento:'),
                  (paciente.departamento != null)
                      ? Text('${paciente.departamento}')
                      : Text('*****')
                ],
              ),
              TableRow(
                children: [
                  Text('Municipio de Nacimiento:'),
                  (paciente.municipio != null)
                      ? Text('${paciente.municipio}')
                      : Text('*****')
                ],
              ),
              TableRow(
                children: [
                  Text('Depto. de Residencia:'),
                  (paciente.departamentoResidencia != null)
                      ? Text('${paciente.departamentoResidencia}')
                      : Text('*****')
                ],
              ),
              TableRow(
                children: [
                  Text('Municipio de Residencia:'),
                  (paciente.municipioResidencia != null)
                      ? Text('${paciente.municipioResidencia}')
                      : Text('*****')
                ],
              ),
              TableRow(
                children: [
                  Text('Dirección:'),
                  (paciente.direccion != null)
                      ? Text('${paciente.direccion}')
                      : Text('*****')
                ],
              ),
            ],
          ),
          (paciente.menorDeEdad) ? _tablaMenorEdad(paciente) : Container(),
          Divider(),
          Row(
            children: <Widget>[
              Text(
                'Otra Información',
                style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 30.0,
              ),
            ],
          ),
          Divider(),
          Table(
            children: [
              TableRow(
                children: [
                  Text('Notas:'),
                  (paciente.notas != null)
                      ? Text('${paciente.notas}')
                      : Text('*****')
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _estadoCivil(String estadoCivil) {
    if (estadoCivil.contains('S')) {
      return 'Solter@';
    } else if (estadoCivil.contains('C')) {
      return 'Casad@';
    } else if (estadoCivil.contains('D')) {
      return 'Divorciad@';
    } else if (estadoCivil.contains('UL')) {
      return 'Union Libre';
    }
    return '';
  }

  Widget _tablaMenorEdad(PacientesViewModel paciente) {
    return Column(
      children: <Widget>[
        Divider(),
        Row(
          children: <Widget>[
            Text(
              'Datos Familiares',
              style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 30.0,
            )
          ],
        ),
        Divider(),
        Table(
          children: [
            TableRow(
              children: [
                Text('Nombre Madre:'),
                (paciente.nombreMadre != null)
                    ? Text('${paciente.nombreMadre}')
                    : Text('*****')
              ],
            ),
            TableRow(
              children: [
                Text('Identificación Madre:'),
                (paciente.identificacionMadre != null)
                    ? Text('${paciente.identificacionMadre}')
                    : Text('*****')
              ],
            ),
            TableRow(
              children: [
                Text('Nombre Padre:'),
                (paciente.nombrePadre != null)
                    ? Text('${paciente.nombrePadre}')
                    : Text('*****')
              ],
            ),
            TableRow(
              children: [
                Text('Identificación Padre:'),
                (paciente.identificacionPadre != null)
                    ? Text('${paciente.identificacionPadre}')
                    : Text('*****')
              ],
            ),
            TableRow(
              children: [
                Text('Carne de Vacuna:'),
                (paciente.carneVacuna != null)
                    ? Text('${paciente.carneVacuna}')
                    : Text('*****')
              ],
            ),
          ],
        ),
      ],
    );
  }
}
