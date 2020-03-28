import 'dart:async';

import 'package:appsam/src/blocs/pacientes_bloc/formPacientes_bloc.dart';
import 'package:appsam/src/blocs/pacientes_bloc/pacientes_bloc.dart';
import 'package:appsam/src/blocs/provider.dart';
import 'package:appsam/src/models/departamento_model.dart';
import 'package:appsam/src/models/escolaridad_model.dart';
import 'package:appsam/src/models/estadocivil_model.dart';
import 'package:appsam/src/models/grupoEtnico_model.dart';
import 'package:appsam/src/models/grupoSanguineo_model.dart';
import 'package:appsam/src/models/municipio_model.dart';
import 'package:appsam/src/models/pacientes_model.dart';
import 'package:appsam/src/models/pais_model.dart';
import 'package:appsam/src/models/parentesco_model.dart';
import 'package:appsam/src/models/profesion_model.dart';
import 'package:appsam/src/models/religion_model.dart';
import 'package:appsam/src/models/usuario_model.dart';
import 'package:appsam/src/providers/combos_service.dart';
import 'package:appsam/src/utils/storage_util.dart';
import 'package:appsam/src/utils/utils.dart';
import 'package:appsam/src/widgets/drawer.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:getflutter/getflutter.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:progress_dialog/progress_dialog.dart';

class CrearPacientePage extends StatefulWidget {
  static final String routeName = 'crear_paciente';
  @override
  _CrearPacientePageState createState() => _CrearPacientePageState();
}

class _CrearPacientePageState extends State<CrearPacientePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  DateTime picked;

  TextEditingController _inputFieldDateController = new TextEditingController();
  final PacientesBloc pacientesBloc = new PacientesBloc();
  final FormPacientesBloc _formBloc = new FormPacientesBloc();
  final comboService = CombosService();
  PacienteModel _paciente = new PacienteModel();
  UsuarioModel _usuario =
      usuarioModelFromJson(StorageUtil.getString('usuarioGlobal'));

  MaskTextInputFormatter maskTelefono1 = new MaskTextInputFormatter(
      mask: '####-####', filter: {"#": RegExp(r'[0-9]')});

  MaskTextInputFormatter maskTelefono2 = new MaskTextInputFormatter(
      mask: '####-####', filter: {"#": RegExp(r'[0-9]')});
  MaskTextInputFormatter maskIdentificacion = new MaskTextInputFormatter(
      mask: '#############', filter: {"#": RegExp(r'[0-9]')});

  @override
  void dispose() {
    super.dispose();

    pacientesBloc.dispose();
    _formBloc.dispose();
  }

  @override
  void initState() {
    super.initState();
    StorageUtil.putString('ultimaPagina', CrearPacientePage.routeName);
    _formBloc.onChangeEstadoCivil('S');
    _formBloc.onChangeSexo('M');
    _formBloc.onChangePaisId(83);
    _formBloc.onChangeProfesionId(1);
    _formBloc.onChangeEscolaridadId(11);
    _formBloc.onChangeReligionId(5);
    _formBloc.onChangeGrupoSanguineoId(9);
    _formBloc.onChangeGrupoEtnicoId(11);
    _formBloc.onChangeDepartamentoId(8);
    _formBloc.onChangeDepartamentoResidenciaId(8);

    pacientesBloc.cargarMunicipios(8);
    pacientesBloc.cargarMunicipiosResi(8);

    _formBloc.onChangeParentesco('otro');
    _formBloc.onChangeMenorDeEdad(false);
  }

  @override
  Widget build(BuildContext context) {
    // final bloc = Provider.pacientesBloc(context);
    // bloc.cargarMunicipios(_formBloc.departamentoId);
    // bloc.cargarMunicipiosResi(_formBloc.departamentoResidenciaId);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Nuevo Paciente'),
      ),
      drawer: MenuWidget(),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              GFCard(
                elevation: 6.0,
                boxFit: BoxFit.cover,
                title: GFListTile(
                    color: Colors.red,
                    title: Text('Información Personal',
                        style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                    icon: FaIcon(FontAwesomeIcons.user, color: Colors.white)),
                content: _formParteUno(),
              ),
              GFCard(
                elevation: 6.0,
                boxFit: BoxFit.cover,
                title: GFListTile(
                    color: Colors.red,
                    title: Text('Datos Generales',
                        style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                    icon: FaIcon(FontAwesomeIcons.user, color: Colors.white)),
                content: _formParteDos(),
              ),
              GFCard(
                elevation: 6.0,
                boxFit: BoxFit.cover,
                title: GFListTile(
                    color: Colors.red,
                    title: Text('Datos Referenciales',
                        style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                    icon: FaIcon(FontAwesomeIcons.user, color: Colors.white)),
                content: _formParteTres(),
              ),
              GFCard(
                elevation: 6.0,
                boxFit: BoxFit.cover,
                title: GFListTile(
                    color: Colors.red,
                    title: Text(
                        'En caso de ser menor de edad complete los campos ',
                        style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                    icon: FaIcon(FontAwesomeIcons.user, color: Colors.white)),
                content: _formParteCuatro(),
              ),
            ],
          ),
        ),
      ),
    );
  } // fin build

  String validaTexto(String value) {
    if (value.length < 3) {
      return 'Campo obligatorio';
    } else {
      return null;
    }
  }

  String validaIdentificacion(String value) {
    if (value.length < 13) {
      return 'Campo obligatorio';
    } else {
      return null;
    }
  }

  Widget _formParteUno() {
    return Column(
      children: <Widget>[
        _espacio(),
        _crearCampoNombre(),
        _espacio(),
        _crearCampoPrimerApellido(),
        _espacio(),
        _crearCampoSegundoApellido(),
        _espacio(),
        _crearCampoIdentificacion(maskIdentificacion),
        _espacio(),
        _crearFecha(context),
        _espacio(),
        _crearCampoEstadoCivil(),
        _espacio(),
        _crearCampoTelefono1(maskTelefono1),
        _espacio(),
      ],
    );
  }

  Widget _formParteDos() {
    return Column(
      children: <Widget>[
        _espacio(),
        _texto('Genero'),
        _crearSexo('M', 'Masculino'),
        _crearSexo('F', 'Femenino'),
        _espacio(),
        _crearDropDownProfesion(),
        _espacio(),
        _crearDropDownEscolaridad(),
        _espacio(),
        _crearDropDownReligion(),
        _espacio(),
        _crearDropDownGrupSanguineo(),
        _espacio(),
        _crearDropDownGrupoEtnico(),
        _espacio(),
        _crearDropDownPais(),
      ],
    );
  }

  Widget _formParteTres() {
    return Column(
      children: <Widget>[
        _espacio(),
        (_formBloc.paisId == 83) ? _crearDropDownDepartamento() : Container(),
        _espacio(),
        (_formBloc.paisId == 83)
            ? _crearDropDownMunicipio(_formBloc.departamentoId)
            : Container(),
        _espacio(),
        Divider(),
        _espacio(),
        (_formBloc.paisId == 83)
            ? _crearDropDownDepartamentoResidencia()
            : Container(),
        _espacio(),
        (_formBloc.paisId == 83)
            ? _crearDropDownMunicipioResidencia(
                _formBloc.departamentoResidenciaId)
            : Container(),
        _espacio(),
        _crearCampoDireccion(),
        _espacio(),
        _crearCampoNombreEmergencia(),
        _espacio(),
        _crearCampoTelefonoEmergencia(maskTelefono2),
        _espacio(),
        _crearCampoParentesco(),
        _espacio(),

        //_crearBotones(_paciente, blocPacientes, context, _usuario, _scaffoldKey)
      ],
    );
  }

  Widget _formParteCuatro() {
    return Column(
      children: <Widget>[
        _espacio(),
        _crearCampoMenorDeEdad(),
        _espacio(),
        _crearCampoNombreMadre(),
        _espacio(),
        _crearCampoIdentificacionMadre(),
        _espacio(),
        _crearCampoNombrePadre(),
        _espacio(),
        _crearCampoIdentificacionPadre(),
        _espacio(),
        _crearCampoCarneVacuna(),
        _espacio(),
        _crearCampoNotas(),
        _espacio(),
        _crearBotones(_paciente, pacientesBloc, context, _usuario)
      ],
    );
  }

  Widget _crearCampoNombre() {
    return StreamBuilder(
      stream: _formBloc.nombresStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Padding(
          padding: EdgeInsets.only(left: 8.0, right: 8.0),
          child: TextFormField(
            initialValue: _formBloc.nombres,
            autovalidate: true,
            validator: validaTexto,
            onSaved: _formBloc.onChangeNombres,
            keyboardType: TextInputType.text,
            decoration: inputsDecorations('Nombres', Icons.person),
            onChanged: _formBloc.onChangeNombres,
          ),
        );
      },
    );
  }

  Widget _crearCampoPrimerApellido() {
    return StreamBuilder(
      stream: _formBloc.primerApellidoStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Padding(
          padding: EdgeInsets.only(left: 8.0, right: 8.0),
          child: TextFormField(
            initialValue: _formBloc.primerApellido,
            autovalidate: true,
            validator: validaTexto,
            onSaved: _formBloc.onChangePrimerApellido,
            keyboardType: TextInputType.text,
            decoration: inputsDecorations('Primer Apellido', Icons.person),
            onChanged: _formBloc.onChangePrimerApellido,
          ),
        );
      },
    );
  }

  Widget _crearCampoSegundoApellido() {
    return StreamBuilder(
      stream: _formBloc.segundoApellidoStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Padding(
          padding: EdgeInsets.only(left: 8.0, right: 8.0),
          child: TextFormField(
            initialValue: _formBloc.segundoApellido,
            autovalidate: true,
            validator: validaTexto,
            onSaved: _formBloc.onChangeSegundoApellido,
            keyboardType: TextInputType.text,
            decoration: inputsDecorations('Segundo Apellido', Icons.person),
            onChanged: _formBloc.onChangeSegundoApellido,
          ),
        );
      },
    );
  }

  Widget _espacio() {
    return SizedBox(
      height: 10.0,
    );
  }

  Widget _crearCampoIdentificacion(TextInputFormatter mask) {
    return StreamBuilder(
      stream: _formBloc.identificacionStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Padding(
          padding: EdgeInsets.only(left: 8.0, right: 8.0),
          child: TextFormField(
            initialValue: _formBloc.identificacion,
            autovalidate: true,
            validator: validaIdentificacion,
            inputFormatters: [mask],
            onSaved: _formBloc.onChangeIdentificacion,
            maxLength: 13,
            keyboardType: TextInputType.number,
            decoration: inputsDecorations('Identificación', Icons.credit_card),
            onChanged: _formBloc.onChangeIdentificacion,
          ),
        );
      },
    );
  }

// TODO: arreglar fecha de nacimiento
  Widget _crearFecha(BuildContext context) {
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
          _selectDate(context);
        },
        //onChanged: blocPacientes.onChangeFechaNacimiento,
      ),
    );
  }

  _selectDate(BuildContext context) async {
    picked = await showDatePicker(
        context: context,
        initialDate: new DateTime.now(),
        firstDate: new DateTime(1950),
        lastDate: new DateTime(2050),
        locale: Locale('es', 'ES'));

    if (picked != null) {
      var format = DateFormat('dd/MM/yyyy');
      _formBloc.onChangeFechaNacimiento(picked);
      _inputFieldDateController.text = format.format(picked);
    }
  }

  _crearSexo(value, String title) {
    return StreamBuilder(
      stream: _formBloc.sexoStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return RadioListTile(
            title: (Text(title)),
            value: value,
            groupValue: _formBloc.sexo,
            onChanged: (value) {
              _formBloc.onChangeSexo(value);
              //setState(() {});
            });
      },
    );
  }

  _crearCampoTelefono1(MaskTextInputFormatter mask) {
    return StreamBuilder(
      stream: _formBloc.telefono1Stream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Padding(
          padding: EdgeInsets.only(left: 8.0, right: 8.0),
          child: TextFormField(
            initialValue: _formBloc.telefono1,
            autovalidate: true,
            validator: validaTexto,
            onSaved: _formBloc.onChangeTelefono1,
            keyboardType: TextInputType.number,
            inputFormatters: [mask],
            decoration: inputsDecorations('Teléfono', Icons.phone_android),
            onChanged: _formBloc.onChangeTelefono1,
          ),
        );
      },
    );
  }

  Widget _crearCampoNombreEmergencia() {
    return StreamBuilder(
        stream: _formBloc.nombreEmergenciaStream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return Padding(
            padding: EdgeInsets.only(left: 8.0, right: 8.0),
            child: TextFormField(
              initialValue: _formBloc.nombreEmergencia,
              autovalidate: true,
              validator: validaTexto,
              onSaved: _formBloc.onChangeNombreEmergencia,
              keyboardType: TextInputType.text,
              decoration:
                  inputsDecorations('Contacto Emergencia', Icons.person),
              onChanged: _formBloc.onChangeNombreEmergencia,
            ),
          );
        });
  }

  _crearCampoTelefonoEmergencia(MaskTextInputFormatter mask) {
    return StreamBuilder(
      stream: _formBloc.telefonoEmergenciaStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Padding(
          padding: EdgeInsets.only(left: 8.0, right: 8.0),
          child: TextFormField(
            initialValue: _formBloc.telefonoEmergencia,
            autovalidate: true,
            validator: validaTexto,
            onSaved: _formBloc.onChangeTelefonoEmergencia,
            keyboardType: TextInputType.number,
            inputFormatters: [mask],
            decoration:
                inputsDecorations('Teléfono Contacto Emergencia', Icons.phone),
            onChanged: _formBloc.onChangeTelefonoEmergencia,
          ),
        );
      },
    );
  }

  Widget _crearCampoParentesco() {
    final parentescoLista = new List<ParentescoModel>();
    parentescoLista.add(new ParentescoModel(texto: 'Hij@', valor: 'hij@'));
    parentescoLista.add(new ParentescoModel(texto: 'Madre', valor: 'madre'));
    parentescoLista.add(new ParentescoModel(texto: 'Padre', valor: 'padre'));
    parentescoLista.add(new ParentescoModel(texto: 'Otro', valor: 'otro'));

    return StreamBuilder(
      stream: _formBloc.parentescoStream,
      initialData: 'otro',
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Padding(
          padding: EdgeInsets.only(left: 8.0, right: 8.0),
          child: InputDecorator(
              decoration: inputsDecorations('Parentesco', Icons.people),
              child: DropdownButtonHideUnderline(
                  child: DropdownButton(
                value: _formBloc.parentesco,
                isDense: true,
                onChanged: _formBloc.onChangeParentesco,
                items: parentescoLista.map((p) {
                  return DropdownMenuItem(
                    value: p.valor,
                    child: Text(p.texto),
                  );
                }).toList(),
              ))),
        );
      },
    );
  }

  Widget _crearCampoEstadoCivil() {
    final estadoCivilLista = new List<EstadoCivilModel>();
    estadoCivilLista.add(new EstadoCivilModel(texto: 'Solter@', valor: 'S'));
    estadoCivilLista.add(new EstadoCivilModel(texto: 'Casad@', valor: 'C'));
    estadoCivilLista.add(new EstadoCivilModel(texto: 'Divorciad@', valor: 'D'));
    estadoCivilLista
        .add(new EstadoCivilModel(texto: 'Union Libre', valor: 'UL'));

    return StreamBuilder(
      stream: _formBloc.estadoCivilStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Padding(
          padding: EdgeInsets.only(left: 8.0, right: 8.0),
          child: InputDecorator(
              decoration: inputsDecorations('Estado Civil', Icons.face),
              child: DropdownButtonHideUnderline(
                  child: DropdownButton(
                value: _formBloc.estadoCivil,
                isDense: true,
                onChanged: _formBloc.onChangeEstadoCivil,
                items: estadoCivilLista.map((p) {
                  return DropdownMenuItem(
                    value: p.valor,
                    child: Text(p.texto),
                  );
                }).toList(),
              ))),
        );
      },
    );
  }

  Widget _crearCampoMenorDeEdad() {
    return StreamBuilder(
      stream: _formBloc.menorDeEdadStream,
      initialData: false,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return SwitchListTile(
            title: Text('Menor de Edad'),
            value: _formBloc.menorDeEdad,
            onChanged: _formBloc.onChangeMenorDeEdad);
      },
    );
  }

  Widget _crearCampoNombreMadre() {
    return StreamBuilder(
      stream: _formBloc.nombreMadreStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Padding(
          padding: EdgeInsets.only(left: 8.0, right: 8.0),
          child: TextFormField(
            initialValue: _formBloc.nombreMadre,
            onSaved: _formBloc.onChangeNombreMadre,
            keyboardType: TextInputType.text,
            decoration: inputsDecorations('Nombre Madre', Icons.person),
            onChanged: _formBloc.onChangeNombreMadre,
          ),
        );
      },
    );
  }

  Widget _crearCampoIdentificacionMadre() {
    return StreamBuilder(
      stream: _formBloc.identificacionStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Padding(
          padding: EdgeInsets.only(left: 8.0, right: 8.0),
          child: TextFormField(
            initialValue: _formBloc.identificacionMadre,
            onSaved: _formBloc.onChangeIdentificacionMadre,
            maxLength: 13,
            keyboardType: TextInputType.number,
            decoration: inputsDecorations('Identificación Madre', Icons.person),
            onChanged: _formBloc.onChangeIdentificacionMadre,
          ),
        );
      },
    );
  }

  Widget _crearCampoNombrePadre() {
    return StreamBuilder(
      stream: _formBloc.nombrePadreStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Padding(
          padding: EdgeInsets.only(left: 8.0, right: 8.0),
          child: TextFormField(
            initialValue: _formBloc.nombrePadre,
            onSaved: _formBloc.onChangeNombrePadre,
            keyboardType: TextInputType.text,
            decoration: inputsDecorations('Nombre Padre', Icons.person),
            onChanged: _formBloc.onChangeNombrePadre,
          ),
        );
      },
    );
  }

  Widget _crearCampoIdentificacionPadre() {
    return StreamBuilder(
      stream: _formBloc.identificacionPadreStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Padding(
          padding: EdgeInsets.only(left: 8.0, right: 8.0),
          child: TextFormField(
            initialValue: _formBloc.identificacionPadre,
            onSaved: _formBloc.onChangeNombrePadre,
            maxLength: 13,
            keyboardType: TextInputType.number,
            decoration: inputsDecorations('Identificación Padre', Icons.person),
            onChanged: _formBloc.onChangeNombrePadre,
          ),
        );
      },
    );
  }

  Widget _crearCampoNotas() {
    return StreamBuilder(
      stream: _formBloc.notasStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Padding(
          padding: EdgeInsets.only(left: 8.0, right: 8.0),
          child: TextFormField(
            initialValue: _formBloc.notas,
            onSaved: _formBloc.onChangeNotas,
            keyboardType: TextInputType.text,
            maxLines: 2,
            decoration: inputsDecorations('Notas', Icons.note),
            onChanged: _formBloc.onChangeNotas,
          ),
        );
      },
    );
  }

  Widget _crearCampoDireccion() {
    return StreamBuilder(
      stream: _formBloc.direccionStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Padding(
          padding: EdgeInsets.only(left: 8.0, right: 8.0),
          child: TextFormField(
            initialValue: _formBloc.direccion,
            onSaved: _formBloc.onChangeDireccion,
            keyboardType: TextInputType.text,
            maxLines: 3,
            decoration: inputsDecorations('Dirección', Icons.note),
            onChanged: _formBloc.onChangeDireccion,
          ),
        );
      },
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

  Widget _crearCampoCarneVacuna() {
    return StreamBuilder(
      stream: _formBloc.carneVacunaStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Padding(
          padding: EdgeInsets.only(left: 8.0, right: 8.0),
          child: TextFormField(
            initialValue: _formBloc.carneVacuna,
            onSaved: _formBloc.onChangeCarneVacuna,
            keyboardType: TextInputType.text,
            decoration: inputsDecorations('Carné de Vacuna', Icons.person),
            onChanged: _formBloc.onChangeCarneVacuna,
          ),
        );
      },
    );
  }

  Widget _crearDropDownProfesion() {
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
              child: StreamBuilder(
                stream: _formBloc.profesionIdStream,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  return DropdownButtonHideUnderline(
                      child: DropdownButton(
                    value: _formBloc.profesionId,
                    isDense: true,
                    onChanged: _formBloc.onChangeProfesionId,
                    items: lista.map((x) {
                      return DropdownMenuItem(
                        value: x.profesionId,
                        child: Text(x.nombre),
                      );
                    }).toList(),
                  ));
                },
              ),
            ),
          );
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }

  Widget _crearDropDownPais() {
    return FutureBuilder(
      future: comboService.getPaises(),
      builder: (BuildContext context, AsyncSnapshot<List<PaisModel>> snapshot) {
        final lista = snapshot.data;
        if (lista != null) {
          return Padding(
            padding: EdgeInsets.only(left: 8.0, right: 8.0),
            child: InputDecorator(
              decoration: inputsDecorations('Pais', Icons.people),
              child: StreamBuilder(
                stream: _formBloc.paisIdStream,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  return DropdownButtonHideUnderline(
                      child: DropdownButton(
                    value: _formBloc.paisId,
                    isDense: true,
                    onChanged: _formBloc.onChangePaisId,
                    items: lista.map((x) {
                      return DropdownMenuItem(
                        value: x.paisId,
                        child: Text(
                          x.nombre,
                          overflow: TextOverflow.ellipsis,
                        ),
                      );
                    }).toList(),
                  ));
                },
              ),
            ),
          );
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }

  Widget _crearDropDownEscolaridad() {
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
              child: StreamBuilder(
                stream: _formBloc.escolaridadIdStream,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  return DropdownButtonHideUnderline(
                      child: DropdownButton(
                    value: _formBloc.escolaridadId,
                    isDense: true,
                    onChanged: _formBloc.onChangeEscolaridadId,
                    items: lista.map((x) {
                      return DropdownMenuItem(
                        value: x.escolaridadId,
                        child: Text(
                          x.nombre,
                          overflow: TextOverflow.ellipsis,
                        ),
                      );
                    }).toList(),
                  ));
                },
              ),
            ),
          );
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }

  Widget _crearDropDownReligion() {
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
              child: StreamBuilder(
                stream: _formBloc.religionIdStream,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  return DropdownButtonHideUnderline(
                      child: DropdownButton(
                    value: _formBloc.religionId,
                    isDense: true,
                    onChanged: _formBloc.onChangeReligionId,
                    items: lista.map((x) {
                      return DropdownMenuItem(
                        value: x.religionId,
                        child: Text(
                          x.nombre,
                          overflow: TextOverflow.ellipsis,
                        ),
                      );
                    }).toList(),
                  ));
                },
              ),
            ),
          );
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }

  Widget _crearDropDownGrupSanguineo() {
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
              child: StreamBuilder(
                stream: _formBloc.grupoSanguineoIdStream,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  return DropdownButtonHideUnderline(
                      child: DropdownButton(
                    value: _formBloc.grupoSanguineoId,
                    isDense: true,
                    onChanged: _formBloc.onChangeGrupoSanguineoId,
                    items: lista.map((x) {
                      return DropdownMenuItem(
                        value: x.grupoSanguineoId,
                        child: Text(
                          x.nombre,
                          overflow: TextOverflow.ellipsis,
                        ),
                      );
                    }).toList(),
                  ));
                },
              ),
            ),
          );
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }

  Widget _crearDropDownGrupoEtnico() {
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
              child: StreamBuilder(
                stream: _formBloc.grupoEtnicoIdStream,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  return DropdownButtonHideUnderline(
                      child: DropdownButton(
                    value: _formBloc.grupoEtnicoId,
                    isDense: true,
                    onChanged: _formBloc.onChangeGrupoEtnicoId,
                    items: lista.map((x) {
                      return DropdownMenuItem(
                        value: x.grupoEtnicoId,
                        child: Text(
                          x.nombre,
                          overflow: TextOverflow.ellipsis,
                        ),
                      );
                    }).toList(),
                  ));
                },
              ),
            ),
          );
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }

  Widget _crearDropDownDepartamento() {
    return FutureBuilder(
      future: comboService.getDepartamentos(),
      builder: (BuildContext context,
          AsyncSnapshot<List<DepartamentoModel>> snapshot) {
        final lista = snapshot.data;
        if (lista != null) {
          return Padding(
            padding: EdgeInsets.only(left: 8.0, right: 8.0),
            child: InputDecorator(
              decoration:
                  inputsDecorations('Departamento de Nacimiento', Icons.map),
              child: StreamBuilder(
                stream: _formBloc.departamentoIdStream,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  return DropdownButtonHideUnderline(
                      child: DropdownButton(
                    value: _formBloc.departamentoId,
                    isDense: true,
                    onChanged: (value) {
                      _formBloc.onChangeDepartamentoId(value);
                      pacientesBloc.cargarMunicipios(_formBloc.departamentoId);
                      _formBloc.onChangeMunicipioId(null);
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
                  ));
                },
              ),
            ),
          );
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }

  Widget _crearDropDownMunicipio(int deptoId) {
    return StreamBuilder(
      stream: pacientesBloc.municipiosListStream,
      builder:
          (BuildContext context, AsyncSnapshot<List<MunicipioModel>> snapshot) {
        if (snapshot.data == null) {
          return CircularProgressIndicator();
        } else {
          final lista = snapshot.data;
          return Padding(
              padding: EdgeInsets.only(left: 8.0, right: 8.0),
              child: InputDecorator(
                decoration:
                    inputsDecorations('Municipio de Nacimiento', Icons.map),
                child: StreamBuilder(
                  stream: _formBloc.municipioIdStream,
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    return DropdownButtonHideUnderline(
                        child: DropdownButton(
                      icon: (pacientesBloc.cargando)
                          ? Container(
                              height: 12.0,
                              width: 12.0,
                              child: CircularProgressIndicator(),
                            )
                          : Icon(Icons.arrow_drop_down),
                      isDense: true,
                      value: _formBloc.municipioId,
                      onChanged: (!pacientesBloc.cargando)
                          ? _formBloc.onChangeMunicipioId
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
                    ));
                  },
                ),
              ));
        }
      },
    );
  }

  Widget _crearDropDownDepartamentoResidencia() {
    return FutureBuilder(
      future: comboService.getDepartamentos(),
      builder: (BuildContext context,
          AsyncSnapshot<List<DepartamentoModel>> snapshot) {
        final lista = snapshot.data;
        if (lista != null) {
          return Padding(
            padding: EdgeInsets.only(left: 8.0, right: 8.0),
            child: InputDecorator(
              decoration:
                  inputsDecorations('Departamento de Residencia', Icons.map),
              child: StreamBuilder(
                stream: _formBloc.departamendoResidenciaIdStream,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  return DropdownButtonHideUnderline(
                      child: DropdownButton(
                    value: _formBloc.departamentoResidenciaId,
                    isDense: true,
                    onChanged: (value) {
                      _formBloc.onChangeDepartamentoResidenciaId(value);
                      pacientesBloc.cargarMunicipiosResi(
                          _formBloc.departamentoResidenciaId);
                      _formBloc.onChangeMunicipioResidenciaId(null);
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
                  ));
                },
              ),
            ),
          );
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }

  Widget _crearDropDownMunicipioResidencia(int deptoId) {
    return StreamBuilder(
      stream: pacientesBloc.municipiosResiListStream,
      builder:
          (BuildContext context, AsyncSnapshot<List<MunicipioModel>> snapshot) {
        if (snapshot.data == null) {
          return CircularProgressIndicator();
        } else {
          final lista = snapshot.data;
          return Padding(
              padding: EdgeInsets.only(left: 8.0, right: 8.0),
              child: InputDecorator(
                decoration:
                    inputsDecorations('Municipio de Residencia', Icons.map),
                child: StreamBuilder(
                  stream: _formBloc.municipioResidenciaIdStream,
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    return DropdownButtonHideUnderline(
                        child: DropdownButton(
                      icon: (pacientesBloc.cargando)
                          ? Container(
                              height: 12.0,
                              width: 12.0,
                              child: CircularProgressIndicator(),
                            )
                          : Icon(Icons.arrow_drop_down),
                      isDense: true,
                      value: _formBloc.municipioResidenciaId,
                      onChanged: (!pacientesBloc.cargando)
                          ? _formBloc.onChangeMunicipioResidenciaId
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
                    ));
                  },
                ),
              ));
        }
      },
    );
  }

  Widget _crearBotones(
    PacienteModel _paciente,
    PacientesBloc blocPaciente,
    BuildContext context,
    UsuarioModel _usuario,
  ) {
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
            onPressed: () =>
                _guardaPaciente(blocPaciente, context, _paciente, _usuario)));
  }

  void _guardaPaciente(
    PacientesBloc blocPaciente,
    BuildContext context,
    PacienteModel _paciente,
    UsuarioModel _usuario,
  ) async {
    _paciente.activo = true;
    _paciente.creadoPor = _usuario.userName;
    _paciente.creadoFecha = DateTime.now();
    _paciente.modificadoPor = _usuario.userName;
    _paciente.modificadoFecha = DateTime.now();
    _paciente.doctorId = _usuario.usuarioId;
    _paciente.pacienteId = 0;
    _paciente.nombres = _formBloc.nombres;
    _paciente.primerApellido = _formBloc.primerApellido;
    _paciente.segundoApellido = _formBloc.segundoApellido;
    _paciente.identificacion = _formBloc.identificacion;
    _paciente.fechaNacimiento = _formBloc.fechaNacimiento;
    _paciente.estadoCivil = _formBloc.estadoCivil;
    _paciente.telefono1 = _formBloc.telefono1;
    _paciente.sexo = _formBloc.sexo;
    _paciente.profesionId = _formBloc.profesionId;
    _paciente.escolaridadId = _formBloc.escolaridadId;
    _paciente.religionId = _formBloc.religionId;
    _paciente.grupoSanguineoId = _formBloc.grupoSanguineoId;
    _paciente.grupoEtnicoId = _formBloc.grupoEtnicoId;
    _paciente.paisId = _formBloc.paisId;
    _paciente.departamentoId = _formBloc.departamentoId;
    _paciente.municipioId = _formBloc.municipioId;
    _paciente.departamentoResidenciaId = _formBloc.departamentoResidenciaId;
    _paciente.municipioResidenciaId = _formBloc.municipioResidenciaId;
    _paciente.direccion = _formBloc.direccion;
    _paciente.nombreEmergencia = _formBloc.nombreEmergencia;
    _paciente.telefonoEmergencia = _formBloc.telefonoEmergencia;
    _paciente.parentesco = _formBloc.parentesco;
    _paciente.menorDeEdad = _formBloc.menorDeEdad;
    _paciente.nombreMadre = _formBloc.nombreMadre;
    _paciente.identificacionMadre = _formBloc.identificacionMadre;
    _paciente.nombrePadre = _formBloc.nombrePadre;
    _paciente.identificacionPadre = _formBloc.identificacionPadre;

    _paciente.notas = _formBloc.notas;

    if (_paciente.paisId != 83) {
      _paciente.departamentoId = null;
      _paciente.municipioId = null;
      _paciente.departamentoResidenciaId = null;
      _paciente.municipioResidenciaId = null;
    }

    if (!_formKey.currentState.validate()) {
      mostrarFlushBar(
          context,
          Colors.black,
          'Información',
          'Rellene todos los campos',
          2,
          FlushbarPosition.BOTTOM,
          Icons.info,
          Colors.white);
    } else {
      _formKey.currentState.save();

      print(pacienteModelToJson(_paciente));
      // final ProgressDialog _pr = new ProgressDialog(
      //   context,
      //   type: ProgressDialogType.Normal,
      //   isDismissible: false,
      //   showLogs: false,
      // );
      // _pr.update(
      //   progress: 50.0,
      //   message: "Espere...",
      //   progressWidget: Container(
      //       padding: EdgeInsets.all(8.0), child: CircularProgressIndicator()),
      //   maxProgress: 100.0,
      //   progressTextStyle: TextStyle(
      //       color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
      //   messageTextStyle: TextStyle(
      //       color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600),
      // );
      // await _pr.show();
      // _inputFieldDateController.text = "";

      // //final bool resp = await blocPaciente.addPaciente(_paciente);
      // final bool resp = true;
      // _pr.hide();
      // if (resp) {
      //   mostrarFlushBar(
      //       context,
      //       Colors.green,
      //       'Info',
      //       'Paciente creado correctamente',
      //       3,
      //       FlushbarPosition.TOP,
      //       Icons.info,
      //       Colors.black);
      //   Timer(Duration(seconds: 3), () {
      //     Navigator.pushReplacementNamed(context, 'home');
      //   });
      // } else {
      //   mostrarFlushBar(
      //       context,
      //       Colors.red,
      //       'Info',
      //       'Ha ocurrido un error o el paciente ya existe',
      //       3,
      //       FlushbarPosition.BOTTOM,
      //       Icons.info,
      //       Colors.black);
      // }
      // _formKey.currentState.reset();
    }
  }
}
