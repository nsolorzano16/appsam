import 'package:appsam/src/models/paginados/pacientesPaginado_model.dart';
import 'package:flutter/material.dart';
import 'package:getflutter/getflutter.dart';
import 'package:appsam/src/extensions/string_ext.dart';

import 'package:intl/intl.dart';

class PacienteDetail extends StatelessWidget {
  final PacientesViewModel _paciente;

  const PacienteDetail({@required paciente}) : _paciente = paciente;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: GFCard(
        elevation: 3,
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
    );
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
          _itemInfo(_paciente.identificacion, 'Identificación'),
          _itemInfo(_paciente.email, 'Email'),
          _itemInfo('$_fechaNac', 'Fecha de nacimiento'),
          _itemInfo(_paciente.edad.toString(), 'Edad'),
          _itemInfo((paciente.sexo == 'F') ? 'Femenino' : 'Masculino', 'Sexo'),
          _itemInfo(_estadoCivil(paciente.estadoCivil), 'Estado civil'),
          _itemInfo('${paciente.telefono1}', 'Teléfono:'),
          _itemInfo('${paciente.nombreEmergencia}', 'Contacto de Emergencia:'),
          _itemInfo(
              '${paciente.telefonoEmergencia}', 'Tel. contacto de emergencia:'),
          _itemInfo('${paciente.parentesco}', 'Parentesco'),
          _itemInfo('${paciente.pais}', 'Pais'),
          Divider(),
          Row(
            children: <Widget>[
              Text(
                'Datos Generales',
                style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Divider(),
          _itemInfo(_paciente.escolaridad.capitalize(), 'Escolaridad'),
          _itemInfo('${paciente.religion}'.capitalize(), 'Religion'),
          _itemInfo(
              '${paciente.grupoSanguineo}'.capitalize(), 'Tipo de Sangre'),
          _itemInfo('${paciente.grupoEtnico}'.capitalize(), 'Grupo Etnico'),
          _itemInfo('${paciente.profesion}'.capitalize(), 'Profesión'),
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
          _itemInfo('${paciente.departamento}', 'Depto. de Nacimiento'),
          _itemInfo('${paciente.municipio}', 'Municipio de Nacimiento'),
          _itemInfo(
              '${paciente.departamentoResidencia}', 'Depto. de Residencia'),
          _itemInfo(
              '${paciente.municipioResidencia}', 'Municipio de Residencia'),
          _itemInfo('${paciente.direccion}', 'Dirección'),
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
          _itemInfo('${paciente.notas}', 'Notas'),
        ],
      ),
    );
  }

  Container _itemInfo(String title, String subtitle) {
    return Container(
      width: double.infinity,
      height: 50,
      child: ListTile(
        contentPadding: EdgeInsets.all(2),
        title: Text(title),
        subtitle: Text(subtitle),
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
        _itemInfo('${paciente.nombreMadre}', 'Nombre Madre'),
        _itemInfo('${paciente.identificacionMadre}', 'Identificación Madre:'),
        _itemInfo('${paciente.nombrePadre}', 'Nombre Padre:'),
        _itemInfo('${paciente.identificacionPadre}', 'Identificación Padre:'),
        _itemInfo('${paciente.carneVacuna}', 'Carne de Vacuna:'),
      ],
    );
  }
}
