import 'package:appsam/src/models/paginados/pacientesPaginado_model.dart';
import 'package:appsam/src/utils/storage_util.dart';
import 'package:appsam/src/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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

    return Scaffold(
        appBar: AppBar(
          title: Text('${_paciente.nombres}'),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  Navigator.pushNamed(context, 'editar_paciente',
                      arguments: _paciente);
                })
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
                Container(
                  padding: EdgeInsets.only(
                      left: _screenSize.width * 0.2,
                      right: _screenSize.width * 0.2,
                      top: 1.0,
                      bottom: 3.0),
                  child: Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0)),
                    child: Container(
                      padding: EdgeInsets.only(
                          left: 20.0, right: 20.0, top: 20.0, bottom: 20.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100.0),
                        child: FadeInImage(
                            width: 150,
                            height: 150,
                            placeholder: AssetImage('assets/jar-loading.gif'),
                            image: NetworkImage(_paciente.fotoUrl)),
                      ),
                    ),
                  ),
                ),
                _campoTexto(_paciente, Icons.email, context)
              ],
            ),
          ),
        ));
  }

  Widget _campoTexto(
      PacientesViewModel paciente, IconData icon, BuildContext context) {
    final format = DateFormat.yMMMEd('es_Es');
    final _fechaNac = format.format(paciente.fechaNacimiento);
    // final _screenSize = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.only(top: 10.0, left: 5.0, right: 5.0, bottom: 10.0),
      child: Card(
        elevation: 6.0,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        child: Column(
          children: <Widget>[
            Table(
              children: [
                TableRow(children: [
                  ListTile(
                      dense: true,
                      title: Text(
                          '${paciente.nombres} ${paciente.primerApellido} ${paciente.segundoApellido}'),
                      subtitle: Text('Nombre Completo')),
                  ListTile(
                    dense: true,
                    title: Text('${paciente.identificacion}'),
                    subtitle: Text('Identificación'),
                  ),
                ]),
                TableRow(children: [
                  ListTile(
                    dense: true,
                    title: Text('$_fechaNac'),
                    subtitle: Text('Fecha de Nacimiento'),
                  ),
                  ListTile(
                    dense: true,
                    title:
                        Text((paciente.sexo == 'F') ? 'Femenino' : 'Masculino'),
                    subtitle: Text('Sexo'),
                  ),
                ]),
                TableRow(children: [
                  ListTile(
                    dense: true,
                    title: Text(_estadoCivil(paciente.estadoCivil)),
                    subtitle: Text('Estado Civil'),
                  ),
                  ListTile(
                    dense: true,
                    title: (paciente.email != null)
                        ? Text('${paciente.email}')
                        : Text('*****'),
                    subtitle: Text('Email'),
                  ),
                ]),
                TableRow(children: [
                  ListTile(
                    dense: true,
                    title: Text('${paciente.telefono1}'),
                    subtitle: Text('Telefono'),
                  ),
                  ListTile(
                    dense: true,
                    title: (paciente.telefono2 != null)
                        ? Text('${paciente.telefono2}')
                        : Text('*****'),
                    subtitle: Text('Telefono Secundario'),
                  ),
                ]),
                TableRow(children: [
                  ListTile(
                    dense: true,
                    title: Text('${paciente.nombreEmergencia}'),
                    subtitle: Text('Contacto Emergencia'),
                  ),
                  ListTile(
                    dense: true,
                    title: Text('${paciente.telefonoEmergencia}'),
                    subtitle: Text('Telefono Contacto Emergencia'),
                  ),
                ]),
                TableRow(children: [
                  ListTile(
                    dense: true,
                    title: (paciente.pais != null)
                        ? Text('${paciente.pais}')
                        : Text('*****'),
                    subtitle: Text('Pais'),
                  ),
                  ListTile(
                    dense: true,
                    title: (paciente.profesion != null)
                        ? Text(
                            '${paciente.profesion}',
                            textAlign: TextAlign.justify,
                          )
                        : Text('*****'),
                    subtitle: Text('Profesión'),
                  ),
                ]),
                TableRow(children: [
                  ListTile(
                    dense: true,
                    title: (paciente.escolaridad != null)
                        ? Text('${paciente.escolaridad}')
                        : Text('*****'),
                    subtitle: Text('Escolaridad'),
                  ),
                  ListTile(
                    dense: true,
                    title: (paciente.religion != null)
                        ? Text(
                            '${paciente.religion}',
                            textAlign: TextAlign.justify,
                          )
                        : Text('*****'),
                    subtitle: Text('Religion'),
                  ),
                ]),
                TableRow(children: [
                  ListTile(
                    dense: true,
                    title: (paciente.grupoSanguineo != null)
                        ? Text('${paciente.grupoSanguineo}')
                        : Text('*****'),
                    subtitle: Text('Tipo de Sangre'),
                  ),
                  ListTile(
                    dense: true,
                    title: (paciente.grupoEtnico != null)
                        ? Text(
                            '${paciente.grupoEtnico}',
                            textAlign: TextAlign.justify,
                          )
                        : Text('*****'),
                    subtitle: Text('Grupo Etnico'),
                  ),
                ]),
                TableRow(children: [
                  ListTile(
                    dense: true,
                    title: (paciente.departamento != null)
                        ? Text('${paciente.departamento}')
                        : Text('*****'),
                    subtitle: Text('Departamento'),
                  ),
                  ListTile(
                    dense: true,
                    title: (paciente.municipio != null)
                        ? Text(
                            '${paciente.municipio}',
                            textAlign: TextAlign.justify,
                          )
                        : Text('*****'),
                    subtitle: Text('Municipio'),
                  ),
                ]),
                TableRow(children: [
                  ListTile(
                    dense: true,
                    title: (paciente.direccion != null)
                        ? Text('${paciente.direccion}')
                        : Text('*****'),
                    subtitle: Text('Dirección'),
                  ),
                  ListTile(
                    dense: true,
                    title: (paciente.lugarNacimiento != null)
                        ? Text(
                            '${paciente.lugarNacimiento}',
                            textAlign: TextAlign.justify,
                          )
                        : Text('*****'),
                    subtitle: Text('lugar Nacimiento'),
                  ),
                ]),
                TableRow(children: [
                  ListTile(
                    dense: true,
                    title: Text('${paciente.edad}'),
                    subtitle: Text('Edad'),
                  ),
                  ListTile(
                    dense: true,
                    title: Text(
                      '${paciente.notas}',
                      textAlign: TextAlign.justify,
                    ),
                    subtitle: Text('Notas Adicionales'),
                  ),
                ])
              ],
            ),
            (paciente.menorDeEdad) ? _tablaMenorEdad(paciente) : Container()
          ],
        ),
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
    return Table(
      children: [
        TableRow(children: [
          ListTile(
            dense: true,
            title: Text('${paciente.nombreMadre}'),
            subtitle: Text('Nombre Madre'),
          ),
          ListTile(
            dense: true,
            title: Text(
              '${paciente.identificacionMadre}',
              textAlign: TextAlign.justify,
            ),
            subtitle: Text('Identificación Madre'),
          ),
        ]),
        TableRow(children: [
          ListTile(
            dense: true,
            title: Text('${paciente.nombrePadre}'),
            subtitle: Text('Nombre Padre'),
          ),
          ListTile(
            dense: true,
            title: Text(
              '${paciente.identificacionPadre}',
              textAlign: TextAlign.justify,
            ),
            subtitle: Text('Identificación Padre'),
          ),
        ]),
        TableRow(children: [
          ListTile(
            dense: true,
            title: Text('${paciente.carneVacuna}'),
            subtitle: Text('Carné Vacuna'),
          ),
          Container()
        ])
      ],
    );
  }
}
