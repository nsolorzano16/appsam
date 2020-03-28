import 'dart:async';

import 'package:appsam/src/blocs/pacientes_bloc/pacientes_bloc.dart';
import 'package:appsam/src/blocs/provider.dart';
import 'package:appsam/src/models/departamento_model.dart';
import 'package:appsam/src/models/escolaridad_model.dart';
import 'package:appsam/src/models/estadocivil_model.dart';
import 'package:appsam/src/models/grupoEtnico_model.dart';
import 'package:appsam/src/models/grupoSanguineo_model.dart';
import 'package:appsam/src/models/municipio_model.dart';
import 'package:appsam/src/models/paginados/pacientesPaginado_model.dart';
import 'package:appsam/src/models/pais_model.dart';
import 'package:appsam/src/models/parentesco_model.dart';
import 'package:appsam/src/models/profesion_model.dart';
import 'package:appsam/src/models/religion_model.dart';
import 'package:appsam/src/models/usuario_model.dart';
import 'package:appsam/src/providers/combos_service.dart';
import 'package:appsam/src/utils/storage_util.dart';
import 'package:appsam/src/utils/utils.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:progress_dialog/progress_dialog.dart';

class EditarPacientePage extends StatefulWidget {
  static final String routeName = 'editar_paciente';
  @override
  _EditarPacientePageState createState() => _EditarPacientePageState();
}

class _EditarPacientePageState extends State<EditarPacientePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  DateTime picked;

  // String _paciente.estadoCivil = 'S';
  // String _paciente.parentesco = 'otro';
  // int _paciente.profesion = 1;
  // int _paciente.paisId = 83;
  // int paciente.escolaridadId = 11;
  // int paciente.religionId = 5;
  // int paciente.grupoSanguineoId = 9;
  // int paciente.grupoEtnicoId = 11;
  // int paciente.departamentoId = 8;
  // int _municipio;

  // bool _paciente.menorDeEdad = false;

  TextEditingController _inputFieldDateController = new TextEditingController();
  final PacientesBloc pacientesBloc = new PacientesBloc();
  final comboService = CombosService();
  FocusNode myFocusNode;

  @override
  void dispose() {
    super.dispose();

    myFocusNode.dispose();
    pacientesBloc.dispose();
  }

  @override
  void initState() {
    super.initState();
    StorageUtil.putString('ultimaPagina', EditarPacientePage.routeName);
    myFocusNode = FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    final UsuarioModel _usuario =
        usuarioModelFromJson(StorageUtil.getString('usuarioGlobal'));
    final PacientesViewModel _paciente =
        ModalRoute.of(context).settings.arguments;

    MaskTextInputFormatter maskTelefono1 = new MaskTextInputFormatter(
        mask: '####-####', filter: {"#": RegExp(r'[0-9]')});

    MaskTextInputFormatter maskTelefono2 = new MaskTextInputFormatter(
        mask: '####-####', filter: {"#": RegExp(r'[0-9]')});
    MaskTextInputFormatter maskIdentificacion = new MaskTextInputFormatter(
        mask: '#############', filter: {"#": RegExp(r'[0-9]')});
    final blocPacientes = Provider.pacientesBloc(context);
    blocPacientes.cargarMunicipios(_paciente.departamentoId);

    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text('Editar Paciente'),
        ),
        body: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.only(
                top: 10.0, left: 10.0, right: 10.0, bottom: 10.0),
            child: Column(
              children: <Widget>[
                _espacio(),
                Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        _crearCampoNombre(_paciente),
                        _espacio(),
                        _crearCampoPrimerApellido(_paciente),
                        _espacio(),
                        _crearCampoSegundoApellido(_paciente),
                        _espacio(),
                        _crearFecha(context, _paciente),
                        _espacio(),
                        _crearCampoEstadoCivil(_paciente),
                        _espacio(),
                        _crearDropDownProfesion(_paciente),
                        _espacio(),
                        _crearDropDownPais(_paciente),
                        _espacio(),
                        (_paciente.paisId == 83)
                            ? _crearDropDownDepartamento(
                                blocPacientes, _paciente)
                            : Container(),
                        _espacio(),
                        (_paciente.paisId == 83)
                            ? _crearDropDownMunicipio(_paciente.departamentoId,
                                blocPacientes, _paciente)
                            : Container(),
                        _espacio(),
                        _crearDropDownEscolaridad(_paciente),
                        _espacio(),
                        _crearDropDownReligion(_paciente),
                        _espacio(),
                        _crearDropDownGrupSanguineo(_paciente),
                        _espacio(),
                        _crearDropDownGrupoEtnico(_paciente),
                        _espacio(),
                        _texto('Genero'),
                        _crearSexo('M', 'Masculino', _paciente),
                        _crearSexo('F', 'Femenino', _paciente),
                        _crearCampoTelefono1(maskTelefono1, _paciente),
                        _espacio(),
                        _crearCampoNombreEmergencia(_paciente),
                        _espacio(),
                        _crearCampoTelefonoEmergencia(maskTelefono2, _paciente),
                        _espacio(),
                        _crearCampoParentesco(_paciente),
                        _espacio(),
                        _crearCampoMenorDeEdad(
                          _paciente,
                        ),
                        _espacio(),
                        _crearCamposMenorDeEdad(
                            _paciente, _paciente.menorDeEdad),
                        _espacio(),
                        _crearCampoNotas(_paciente),
                        _espacio(),
                        _crearBotones(_paciente, blocPacientes, context,
                            _usuario, _scaffoldKey)
                      ],
                    ))
              ],
            ),
          ),
        ));
  } // fin build

  String validaTexto(String value) {
    if (value.length < 3) {
      return 'Campo obligatorio';
    } else {
      return null;
    }
  }

  Widget _crearCampoNombre(PacientesViewModel _paciente) {
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0),
      child: TextFormField(
        initialValue: _paciente.nombres,
        autovalidate: true,
        focusNode: myFocusNode,
        validator: validaTexto,
        onSaved: (value) => _paciente.nombres = value,
        keyboardType: TextInputType.text,
        decoration: inputsDecorations('Nombres', Icons.person),
      ),
    );
  }

  Widget _crearCampoPrimerApellido(PacientesViewModel _paciente) {
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0),
      child: TextFormField(
        initialValue: _paciente.primerApellido,
        autovalidate: true,
        validator: validaTexto,
        onSaved: (value) => _paciente.primerApellido = value,
        keyboardType: TextInputType.text,
        decoration: inputsDecorations('Primer Apellido', Icons.person),
      ),
    );
  }

  Widget _crearCampoSegundoApellido(PacientesViewModel _paciente) {
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0),
      child: TextFormField(
        initialValue: _paciente.segundoApellido,
        autovalidate: true,
        validator: validaTexto,
        onSaved: (value) => _paciente.segundoApellido = value,
        keyboardType: TextInputType.text,
        decoration: inputsDecorations('Segundo Apellido', Icons.person),
      ),
    );
  }

  Widget _espacio() {
    return SizedBox(
      height: 10.0,
    );
  }

  Widget _crearCampoIdentificacion(
      PacientesViewModel _paciente, TextInputFormatter mask) {
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0),
      child: TextFormField(
          autovalidate: true,
          validator: validaTexto,
          inputFormatters: [mask],
          onSaved: (value) => _paciente.identificacion = value,
          maxLength: 13,
          keyboardType: TextInputType.number,
          decoration: inputsDecorations('Identificación', Icons.credit_card)),
    );
  }

  Widget _crearFecha(BuildContext context, PacientesViewModel _paciente) {
    var formato = DateFormat('dd/MM/yyyy');
    final _fechaNaci = formato.format(_paciente.fechaNacimiento);
    _inputFieldDateController.text = _fechaNaci;
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0),
      child: TextFormField(
        autovalidate: true,
        validator: validaTexto,
        enableInteractiveSelection: false,
        controller: _inputFieldDateController,
        decoration:
            inputsDecorations('Fecha de Nacimiento', Icons.calendar_today),
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
          _selectDate(context, _paciente);
        },
        //onChanged: blocPacientes.onChangeFechaNacimiento,
      ),
    );
  }

  _selectDate(BuildContext context, PacientesViewModel _paciente) async {
    picked = await showDatePicker(
        context: context,
        initialDate: new DateTime.now(),
        firstDate: new DateTime(1950),
        lastDate: new DateTime(2050),
        locale: Locale('es', 'ES'));

    if (picked != null) {
      var format = DateFormat('dd/MM/yyyy');
      _paciente.fechaNacimiento = picked;
      _inputFieldDateController.text = format.format(picked);
    }
  }

  _crearSexo(value, String title, PacientesViewModel _paciente) {
    return RadioListTile(
        title: (Text(title)),
        value: value,
        groupValue: _paciente.sexo,
        onChanged: (value) {
          _paciente.sexo = value;
          _paciente.sexo = _paciente.sexo;
          setState(() {});
        });
  }

  _crearCampoTelefono1(
      MaskTextInputFormatter mask, PacientesViewModel _paciente) {
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0),
      child: TextFormField(
        initialValue: _paciente.telefono1,
        autovalidate: true,
        validator: validaTexto,
        onSaved: (value) => _paciente.telefono1 = value,
        keyboardType: TextInputType.number,
        inputFormatters: [mask],
        decoration: inputsDecorations('Teléfono', Icons.phone_android),
      ),
    );
  }

  Widget _crearCampoNombreEmergencia(PacientesViewModel _paciente) {
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0),
      child: TextFormField(
        initialValue: _paciente.nombreEmergencia,
        autovalidate: true,
        validator: validaTexto,
        onSaved: (value) => _paciente.nombreEmergencia = value,
        keyboardType: TextInputType.text,
        decoration: inputsDecorations('Contacto Emergencia', Icons.person),
      ),
    );
  }

  _crearCampoTelefonoEmergencia(
      MaskTextInputFormatter mask, PacientesViewModel _paciente) {
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0),
      child: TextFormField(
        initialValue: _paciente.telefonoEmergencia,
        autovalidate: true,
        validator: validaTexto,
        onSaved: (value) => _paciente.telefonoEmergencia = value,
        keyboardType: TextInputType.number,
        inputFormatters: [mask],
        decoration:
            inputsDecorations('Teléfono Contacto Emergencia', Icons.phone),
      ),
    );
  }

  Widget _crearCampoParentesco(PacientesViewModel _paciente) {
    final parentescoLista = new List<ParentescoModel>();
    parentescoLista.add(new ParentescoModel(texto: 'Hij@', valor: 'hij@'));
    parentescoLista.add(new ParentescoModel(texto: 'Madre', valor: 'madre'));
    parentescoLista.add(new ParentescoModel(texto: 'Padre', valor: 'padre'));
    parentescoLista.add(new ParentescoModel(texto: 'Otro', valor: 'otro'));

    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0),
      child: InputDecorator(
          decoration: inputsDecorations('Parentesco', Icons.people),
          child: DropdownButtonHideUnderline(
              child: DropdownButton(
            value: _paciente.parentesco,
            isDense: true,
            onChanged: (value) {
              setState(() {
                _paciente.parentesco = value;
              });
            },
            items: parentescoLista.map((p) {
              return DropdownMenuItem(
                value: p.valor,
                child: Text(p.texto),
              );
            }).toList(),
          ))),
    );
  }

  Widget _crearCampoEstadoCivil(PacientesViewModel _paciente) {
    final estadoCivilLista = new List<EstadoCivilModel>();
    estadoCivilLista.add(new EstadoCivilModel(texto: 'Solter@', valor: 'S'));
    estadoCivilLista.add(new EstadoCivilModel(texto: 'Casad@', valor: 'C'));
    estadoCivilLista.add(new EstadoCivilModel(texto: 'Divorciad@', valor: 'D'));
    estadoCivilLista
        .add(new EstadoCivilModel(texto: 'Union Libre', valor: 'UL'));

    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0),
      child: InputDecorator(
          decoration: inputsDecorations('Estado Civil', Icons.face),
          child: DropdownButtonHideUnderline(
              child: DropdownButton(
            value: _paciente.estadoCivil,
            isDense: true,
            onChanged: (value) {
              setState(() {
                _paciente.estadoCivil = value;
              });
            },
            items: estadoCivilLista.map((p) {
              return DropdownMenuItem(
                value: p.valor,
                child: Text(p.texto),
              );
            }).toList(),
          ))),
    );
  }

  Widget _crearCampoMenorDeEdad(
    PacientesViewModel _paciente,
  ) {
    return SwitchListTile(
        title: Text('Menor de Edad'),
        value: _paciente.menorDeEdad,
        onChanged: (value) {
          _paciente.menorDeEdad = value;
          setState(() {
            print(value);
          });
        });
  }

  Widget _crearCamposMenorDeEdad(
      PacientesViewModel _paciente, bool esMenorEdad) {
    if (esMenorEdad) {
      return Container(
        child: Column(
          children: <Widget>[
            _crearCampoNombreMadre(_paciente),
            _espacio(),
            _crearCampoIdentificacionMadre(_paciente),
            _espacio(),
            _crearCampoNombrePadre(_paciente),
            _espacio(),
            _crearCampoIdentificacionPadre(_paciente),
            _espacio(),
            _crearCampoCarneVacuna(_paciente),
          ],
        ),
      );
    } else {
      return Container();
    }
  }

  Widget _crearCampoNombreMadre(PacientesViewModel _paciente) {
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0),
      child: TextFormField(
        initialValue: _paciente.nombreMadre,
        onSaved: (value) => _paciente.nombreMadre = value,
        keyboardType: TextInputType.text,
        decoration: inputsDecorations('Nombre Madre', Icons.person),
      ),
    );
  }

  Widget _crearCampoIdentificacionMadre(PacientesViewModel _paciente) {
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0),
      child: TextFormField(
        initialValue: _paciente.identificacionMadre,
        onSaved: (value) => _paciente.identificacionMadre = value,
        maxLength: 13,
        keyboardType: TextInputType.number,
        decoration: inputsDecorations('Identificación Madre', Icons.person),
      ),
    );
  }

  Widget _crearCampoNombrePadre(PacientesViewModel _paciente) {
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0),
      child: TextFormField(
        initialValue: _paciente.nombrePadre,
        onSaved: (value) => _paciente.nombrePadre = value,
        keyboardType: TextInputType.text,
        decoration: inputsDecorations('Nombre Padre', Icons.person),
      ),
    );
  }

  Widget _crearCampoIdentificacionPadre(PacientesViewModel _paciente) {
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0),
      child: TextFormField(
        initialValue: _paciente.identificacionPadre,
        onSaved: (value) => _paciente.identificacionPadre = value,
        maxLength: 13,
        keyboardType: TextInputType.number,
        decoration: inputsDecorations('Identificación Padre', Icons.person),
      ),
    );
  }

  Widget _crearCampoNotas(PacientesViewModel _paciente) {
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0),
      child: TextFormField(
        initialValue: _paciente.notas,
        onSaved: (value) => _paciente.notas = value,
        keyboardType: TextInputType.text,
        maxLines: 2,
        decoration: inputsDecorations('Notas', Icons.note),
      ),
    );
  }

  Widget _texto(String texto) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
            padding: EdgeInsets.only(left: 25),
            child: Text(
              texto,
              style: TextStyle(fontSize: 16.0),
            ))
      ],
    );
  }

  Widget _crearCampoCarneVacuna(PacientesViewModel _paciente) {
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0),
      child: TextFormField(
        initialValue: _paciente.carneVacuna,
        onSaved: (value) => _paciente.carneVacuna = value,
        keyboardType: TextInputType.text,
        decoration: inputsDecorations('Carné de Vacuna', Icons.person),
      ),
    );
  }

  Widget _crearBotones(
      PacientesViewModel _paciente,
      PacientesBloc blocPaciente,
      BuildContext context,
      UsuarioModel _usuario,
      GlobalKey<ScaffoldState> _scaffoldKey) {
    return Padding(
        padding: EdgeInsets.only(right: 25.0, bottom: 10.0),
        child: RaisedButton.icon(
            elevation: 5.0,
            textColor: Colors.white,
            color: Theme.of(context).primaryColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            icon: Icon(Icons.save),
            label: Text('Guardar'),
            onPressed: () => _guardaPaciente(
                blocPaciente, context, _paciente, _usuario, _scaffoldKey)));
  }

  Widget _crearDropDownProfesion(PacientesViewModel paciente) {
    return FutureBuilder(
      future: comboService.getProfesiones(),
      builder:
          (BuildContext context, AsyncSnapshot<List<ProfesionModel>> snapshot) {
        final lista = snapshot.data;

        if (lista != null) {
          return Padding(
            padding: EdgeInsets.only(left: 8.0, right: 8.0),
            child: InputDecorator(
                decoration: inputsDecorations('Profesión', Icons.people),
                child: DropdownButtonHideUnderline(
                    child: DropdownButton(
                  value: paciente.profesionId,
                  isDense: true,
                  onChanged: (value) {
                    setState(() {
                      paciente.profesionId = value;
                    });
                  },
                  items: lista.map((x) {
                    return DropdownMenuItem(
                      value: x.profesionId,
                      child: Text(x.nombre),
                    );
                  }).toList(),
                ))),
          );
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }

  Widget _crearDropDownPais(PacientesViewModel paciente) {
    return FutureBuilder(
      future: comboService.getPaises(),
      builder: (BuildContext context, AsyncSnapshot<List<PaisModel>> snapshot) {
        final lista = snapshot.data;

        if (lista != null) {
          return Padding(
            padding: EdgeInsets.only(left: 8.0, right: 8.0),
            child: InputDecorator(
                decoration: inputsDecorations('Pais', Icons.people),
                child: DropdownButtonHideUnderline(
                    child: DropdownButton(
                  value: paciente.paisId,
                  isDense: true,
                  onChanged: (value) {
                    setState(() {
                      paciente.paisId = value;
                    });
                  },
                  items: lista.map((x) {
                    return DropdownMenuItem(
                      value: x.paisId,
                      child: Text(
                        x.nombre,
                        overflow: TextOverflow.ellipsis,
                      ),
                    );
                  }).toList(),
                ))),
          );
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }

  Widget _crearDropDownEscolaridad(PacientesViewModel paciente) {
    return FutureBuilder(
      future: comboService.getEscolaridades(),
      builder: (BuildContext context,
          AsyncSnapshot<List<EscolaridadModel>> snapshot) {
        final lista = snapshot.data;

        if (lista != null) {
          return Padding(
            padding: EdgeInsets.only(left: 8.0, right: 8.0),
            child: InputDecorator(
                decoration: inputsDecorations('Escolaridad', Icons.people),
                child: DropdownButtonHideUnderline(
                    child: DropdownButton(
                  value: paciente.escolaridadId,
                  isDense: true,
                  onChanged: (value) {
                    setState(() {
                      paciente.escolaridadId = value;
                    });
                  },
                  items: lista.map((x) {
                    return DropdownMenuItem(
                      value: x.escolaridadId,
                      child: Text(
                        x.nombre,
                        overflow: TextOverflow.ellipsis,
                      ),
                    );
                  }).toList(),
                ))),
          );
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }

  Widget _crearDropDownReligion(PacientesViewModel paciente) {
    return FutureBuilder(
      future: comboService.getReligiones(),
      builder:
          (BuildContext context, AsyncSnapshot<List<ReligionModel>> snapshot) {
        final lista = snapshot.data;
        if (lista != null) {
          return Padding(
            padding: EdgeInsets.only(left: 8.0, right: 8.0),
            child: InputDecorator(
                decoration: inputsDecorations('Religion', Icons.people),
                child: DropdownButtonHideUnderline(
                    child: DropdownButton(
                  value: paciente.religionId,
                  isDense: true,
                  onChanged: (value) {
                    setState(() {
                      paciente.religionId = value;
                    });
                  },
                  items: lista.map((x) {
                    return DropdownMenuItem(
                      value: x.religionId,
                      child: Text(
                        x.nombre,
                        overflow: TextOverflow.ellipsis,
                      ),
                    );
                  }).toList(),
                ))),
          );
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }

  Widget _crearDropDownGrupSanguineo(PacientesViewModel paciente) {
    return FutureBuilder(
      future: comboService.getGrupoSanguineos(),
      builder: (BuildContext context,
          AsyncSnapshot<List<GrupoSanguineoModel>> snapshot) {
        final lista = snapshot.data;
        if (lista != null) {
          return Padding(
            padding: EdgeInsets.only(left: 8.0, right: 8.0),
            child: InputDecorator(
                decoration: inputsDecorations('Tipo de Sangre', Icons.people),
                child: DropdownButtonHideUnderline(
                    child: DropdownButton(
                  value: paciente.grupoSanguineoId,
                  isDense: true,
                  onChanged: (value) {
                    setState(() {
                      paciente.grupoSanguineoId = value;
                    });
                  },
                  items: lista.map((x) {
                    return DropdownMenuItem(
                      value: x.grupoSanguineoId,
                      child: Text(
                        x.nombre,
                        overflow: TextOverflow.ellipsis,
                      ),
                    );
                  }).toList(),
                ))),
          );
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }

  Widget _crearDropDownGrupoEtnico(PacientesViewModel paciente) {
    return FutureBuilder(
      future: comboService.getGruposEtnicos(),
      builder: (BuildContext context,
          AsyncSnapshot<List<GrupoEtnicoModel>> snapshot) {
        final lista = snapshot.data;
        if (lista != null) {
          return Padding(
            padding: EdgeInsets.only(left: 8.0, right: 8.0),
            child: InputDecorator(
                decoration: inputsDecorations('Grupo Etnico', Icons.people),
                child: DropdownButtonHideUnderline(
                    child: DropdownButton(
                  value: paciente.grupoEtnicoId,
                  isDense: true,
                  onChanged: (value) {
                    setState(() {
                      paciente.grupoEtnicoId = value;
                    });
                  },
                  items: lista.map((x) {
                    return DropdownMenuItem(
                      value: x.grupoEtnicoId,
                      child: Text(
                        x.nombre,
                        overflow: TextOverflow.ellipsis,
                      ),
                    );
                  }).toList(),
                ))),
          );
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }

  Widget _crearDropDownDepartamento(
      PacientesBloc bloc, PacientesViewModel paciente) {
    return FutureBuilder(
      future: comboService.getDepartamentos(),
      builder: (BuildContext context,
          AsyncSnapshot<List<DepartamentoModel>> snapshot) {
        final lista = snapshot.data;
        if (lista != null) {
          return Padding(
            padding: EdgeInsets.only(left: 8.0, right: 8.0),
            child: InputDecorator(
                decoration: inputsDecorations('Departamento', Icons.map),
                child: DropdownButtonHideUnderline(
                    child: DropdownButton(
                  value: paciente.departamentoId,
                  isDense: true,
                  onChanged: (value) {
                    paciente.departamentoId = value;
                    _crearDropDownMunicipio(
                        paciente.departamentoId, bloc, paciente);
                    setState(() {});
                  },
                  items: lista.map((x) {
                    return DropdownMenuItem(
                      value: x.departamentoId,
                      child: Text(
                        x.nombre,
                        overflow: TextOverflow.ellipsis,
                      ),
                    );
                  }).toList(),
                ))),
          );
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }

  Widget _crearDropDownMunicipio(
      int deptoId, PacientesBloc bloq, PacientesViewModel paciente) {
    return StreamBuilder(
      stream: bloq.municipiosListStream,
      builder:
          (BuildContext context, AsyncSnapshot<List<MunicipioModel>> snapshot) {
        if (snapshot.data == null) {
          return CircularProgressIndicator();
        } else {
          final lista = snapshot.data;

          return Padding(
              padding: EdgeInsets.only(left: 8.0, right: 8.0),
              child: InputDecorator(
                  decoration: inputsDecorations('Municipio', Icons.map),
                  child: DropdownButtonHideUnderline(
                      child: DropdownButton(
                    isDense: true,
                    value: (_existMunicipio(lista, paciente.municipioId))
                        ? paciente.municipioId
                        : null,
                    onChanged: (!bloq.cargando)
                        ? (value) {
                            setState(() {
                              paciente.municipioId = value;
                            });
                          }
                        : null,
                    items: lista.map((x) {
                      return DropdownMenuItem(
                        value: x.municipioId,
                        child: Text(
                          x.nombre,
                          overflow: TextOverflow.ellipsis,
                        ),
                      );
                    }).toList(),
                  ))));
        }
      },
    );
  }

  bool _existMunicipio(List<MunicipioModel> lista, int id) {
    var existe = false;
    lista.forEach((m) {
      if (m.municipioId == id) {
        existe = true;
      }
    });
    return existe;
  }

  void _guardaPaciente(
      PacientesBloc blocPaciente,
      BuildContext context,
      PacientesViewModel _paciente,
      UsuarioModel _usuario,
      GlobalKey<ScaffoldState> _scaffoldKey) async {
    _paciente.activo = true;
    _paciente.modificadoPor = _usuario.userName;
    _paciente.modificadoFecha = DateTime.now();

    if (_paciente.paisId != 83) {
      _paciente.departamentoId = null;
      _paciente.municipioId = null;
    }

    if (!_formKey.currentState.validate()) {
      Flushbar(
        title: 'Información',
        message: 'Rellene todos los campos',
        duration: Duration(seconds: 2),
        icon: Icon(
          Icons.info,
        ),
      )..show(context);
    } else {
      _formKey.currentState.save();
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
      _inputFieldDateController.text = "";

      blocPaciente.updatePaciente(_paciente).then((p) {
        _formKey.currentState.reset();

        _pr.hide();
        if (p != null) {
          Navigator.pushReplacementNamed(context, 'pacientes');
        } else {
          mostrarFlushBar(
              context,
              Colors.red,
              'Info',
              'Ha ocurrido un error al editar paciente',
              3,
              FlushbarPosition.BOTTOM,
              Icons.info,
              Colors.black);
        }
      });
    }
  }
}
