import 'dart:async';
import 'package:appsam/src/blocs/pacientes_bloc/formPacientes_bloc.dart';
import 'package:appsam/src/blocs/pacientes_bloc/pacientes_bloc.dart';
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
import 'package:appsam/src/widgets/drawer.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:getflutter/getflutter.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:progress_dialog/progress_dialog.dart';

class EditarPacientePage extends StatefulWidget {
  static final String routeName = 'editar_paciente';

  final PacientesViewModel paciente;

  const EditarPacientePage({this.paciente});
  @override
  _EditarPacientePageState createState() => _EditarPacientePageState();
}

class _EditarPacientePageState extends State<EditarPacientePage> {
  final PacientesViewModel _pacienteGuardar = new PacientesViewModel();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  DateTime picked;

  TextEditingController _inputFieldDateController = new TextEditingController();
  final PacientesBloc pacientesBloc = new PacientesBloc();
  final FormPacientesBloc _formBloc = new FormPacientesBloc();
  final comboService = CombosService();

  UsuarioModel _usuario =
      usuarioModelFromJson(StorageUtil.getString('usuarioGlobal'));

  MaskTextInputFormatter maskTelefono1 = new MaskTextInputFormatter(
      mask: '####-####', filter: {"#": RegExp(r'[0-9]')});

  MaskTextInputFormatter maskTelefono2 = new MaskTextInputFormatter(
      mask: '####-####', filter: {"#": RegExp(r'[0-9]')});
  MaskTextInputFormatter maskIdentificacion = new MaskTextInputFormatter(
      mask: '#############', filter: {"#": RegExp(r'[0-9]')});

  @override
  void initState() {
    super.initState();
    StorageUtil.putString('ultimaPagina', EditarPacientePage.routeName);
    _formBloc.onChangeNombres(widget.paciente.nombres);
    _formBloc.onChangePrimerApellido(widget.paciente.primerApellido);
    _formBloc.onChangeSegundoApellido(widget.paciente.segundoApellido);
    _formBloc.onChangeIdentificacion(widget.paciente.identificacion);
    _formBloc.onChangeFechaNacimiento(widget.paciente.fechaNacimiento);
    _formBloc.onChangeEstadoCivil(widget.paciente.estadoCivil);
    _formBloc.onChangeTelefono1(widget.paciente.telefono1);
    _formBloc.onChangeSexo(widget.paciente.sexo);
    _formBloc.onChangeProfesionId(widget.paciente.profesionId);
    _formBloc.onChangeEscolaridadId(widget.paciente.escolaridadId);
    _formBloc.onChangeReligionId(widget.paciente.religionId);
    _formBloc.onChangeGrupoSanguineoId(widget.paciente.grupoSanguineoId);
    _formBloc.onChangeGrupoEtnicoId(widget.paciente.grupoEtnicoId);
    _formBloc.onChangePaisId(widget.paciente.paisId);
    _formBloc.onChangeDepartamentoId(widget.paciente.departamentoId);
    _formBloc.onChangeMunicipioId(widget.paciente.municipioId);
    _formBloc.onChangeDepartamentoResidenciaId(
        widget.paciente.departamentoResidenciaId);
    _formBloc
        .onChangeMunicipioResidenciaId(widget.paciente.municipioResidenciaId);
    _formBloc.onChangeDireccion(widget.paciente.direccion);
    _formBloc.onChangeNombreEmergencia(widget.paciente.nombreEmergencia);
    _formBloc.onChangeTelefonoEmergencia(widget.paciente.telefonoEmergencia);
    _formBloc.onChangeParentesco(widget.paciente.parentesco);
    _formBloc.onChangeMenorDeEdad(widget.paciente.menorDeEdad);
    _formBloc.onChangeNombreMadre(widget.paciente.nombreMadre);
    _formBloc.onChangeIdentificacionMadre(widget.paciente.identificacionMadre);
    _formBloc.onChangeNombrePadre(widget.paciente.nombrePadre);
    _formBloc.onChangeIdentificacionPadre(widget.paciente.identificacionPadre);
    _formBloc.onChangeCarneVacuna(widget.paciente.carneVacuna);
    _formBloc.onChangeNotas(widget.paciente.notas);
    pacientesBloc.cargarMunicipios(_formBloc.departamentoId);
    pacientesBloc.cargarMunicipiosResi(_formBloc.departamentoResidenciaId);

    var formato = DateFormat('dd/MM/yyyy');
    final _fechaNaci = formato.format(widget.paciente.fechaNacimiento);
    _inputFieldDateController.text = _fechaNaci;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Paciente'),
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
                content: _formParteUno(widget.paciente),
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
                content: _formParteCuatro(widget.paciente),
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

  Widget _formParteUno(PacientesViewModel paciente) {
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
        _crearFecha(context, paciente),
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
        _siElPais(),
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

  Widget _siElPais() {
    if (_formBloc.paisId == 83) {
      return Column(
        children: <Widget>[
          _espacio(),
          _crearDropDownDepartamento(),
          _espacio(),
          _crearDropDownMunicipio(_formBloc.departamentoId),
          _espacio(),
          _crearDropDownDepartamentoResidencia(),
          _espacio(),
          _crearDropDownMunicipioResidencia(_formBloc.departamentoResidenciaId),
          _espacio()
        ],
      );
    } else {
      return Container();
    }
  }

  Widget _formParteCuatro(PacientesViewModel _paciente) {
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
        _crearBotones(pacientesBloc, context, _paciente, _usuario)
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

  Widget _crearFecha(BuildContext context, PacientesViewModel _paciente) {
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
      setState(() {
        _inputFieldDateController.text = format.format(picked);
      });
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
                onChanged: (value) {
                  _formBloc.onChangeParentesco(value);
                  FocusScope.of(context).requestFocus(FocusNode());
                },
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
                onChanged: (value) {
                  _formBloc.onChangeEstadoCivil(value);
                  FocusScope.of(context).requestFocus(FocusNode());
                },
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
            onSaved: _formBloc.onChangeIdentificacionPadre,
            maxLength: 13,
            keyboardType: TextInputType.number,
            decoration: inputsDecorations('Identificación Padre', Icons.person),
            onChanged: _formBloc.onChangeIdentificacionPadre,
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
                    onChanged: (value) {
                      _formBloc.onChangeProfesionId(value);
                      FocusScope.of(context).requestFocus(FocusNode());
                    },
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
                    onChanged: (value) {
                      _formBloc.onChangePaisId(value);
                      setState(() {});
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
                    onChanged: (value) {
                      _formBloc.onChangeEscolaridadId(value);
                      FocusScope.of(context).requestFocus(FocusNode());
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
                    onChanged: (value) {
                      _formBloc.onChangeReligionId(value);
                      FocusScope.of(context).requestFocus(FocusNode());
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
                    onChanged: (value) {
                      _formBloc.onChangeGrupoSanguineoId(value);
                      FocusScope.of(context).requestFocus(FocusNode());
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
                    onChanged: (value) {
                      _formBloc.onChangeGrupoEtnicoId(value);
                      FocusScope.of(context).requestFocus(FocusNode());
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
                      FocusScope.of(context).requestFocus(FocusNode());
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
                          ? (value) => valorMunicipio(value)
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

  void valorMunicipio(int value) {
    _formBloc.onChangeMunicipioId(value);
    FocusScope.of(context).requestFocus(FocusNode());
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
                      FocusScope.of(context).requestFocus(FocusNode());
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
                      icon: (pacientesBloc.cargandoMunicipiosResi)
                          ? Container(
                              height: 12.0,
                              width: 12.0,
                              child: CircularProgressIndicator(),
                            )
                          : Icon(Icons.arrow_drop_down),
                      isDense: true,
                      value: _formBloc.municipioResidenciaId,
                      onChanged: (!pacientesBloc.cargando)
                          ? (value) => valorMunicipioResi(value)
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

  void valorMunicipioResi(int value) {
    _formBloc.onChangeMunicipioResidenciaId(value);
    FocusScope.of(context).requestFocus(FocusNode());
  }

  Widget _crearBotones(
    PacientesBloc blocPaciente,
    BuildContext context,
    PacientesViewModel _paciente,
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
    PacientesViewModel _paciente,
    UsuarioModel _usuario,
  ) async {
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
      print(_formBloc.estadoCivil);
      _pacienteGuardar.pacienteId = _paciente.pacienteId;
      _pacienteGuardar.doctorId = _paciente.doctorId;
      _pacienteGuardar.paisId = _formBloc.paisId;
      _pacienteGuardar.profesionId = _formBloc.profesionId;
      _pacienteGuardar.escolaridadId = _formBloc.escolaridadId;
      _pacienteGuardar.religionId = _formBloc.religionId;
      _pacienteGuardar.grupoSanguineoId = _formBloc.grupoSanguineoId;
      _pacienteGuardar.grupoEtnicoId = _formBloc.grupoEtnicoId;
      _pacienteGuardar.departamentoId = _formBloc.departamentoId;
      _pacienteGuardar.municipioId = _formBloc.municipioId;
      _pacienteGuardar.departamentoResidenciaId =
          _formBloc.departamentoResidenciaId;
      _pacienteGuardar.municipioResidenciaId = _formBloc.municipioResidenciaId;

      _pacienteGuardar.nombres = _formBloc.nombres;
      _pacienteGuardar.primerApellido = _formBloc.primerApellido;
      _pacienteGuardar.segundoApellido = _formBloc.segundoApellido;
      _pacienteGuardar.identificacion = _formBloc.identificacion;
      _pacienteGuardar.email = _paciente.email;
      _pacienteGuardar.sexo = _formBloc.sexo;
      _pacienteGuardar.fechaNacimiento = _formBloc.fechaNacimiento;
      _pacienteGuardar.estadoCivil = _formBloc.estadoCivil;
      _pacienteGuardar.edad = _paciente.edad;
      _pacienteGuardar.direccion = _formBloc.direccion;
      _pacienteGuardar.telefono1 = _formBloc.telefono1;
      _pacienteGuardar.telefono2 = _paciente.telefono2;
      _pacienteGuardar.nombreEmergencia = _formBloc.nombreEmergencia;
      _pacienteGuardar.telefonoEmergencia = _formBloc.telefonoEmergencia;
      _pacienteGuardar.parentesco = _formBloc.parentesco;
      _pacienteGuardar.menorDeEdad = _formBloc.menorDeEdad;
      _pacienteGuardar.nombreMadre = _formBloc.nombreMadre;
      _pacienteGuardar.identificacionMadre = _formBloc.identificacionMadre;
      _pacienteGuardar.nombrePadre = _formBloc.nombrePadre;
      _pacienteGuardar.identificacionPadre = _formBloc.identificacionPadre;
      _pacienteGuardar.carneVacuna = _formBloc.carneVacuna;
      _pacienteGuardar.fotoUrl = _paciente.fotoUrl;
      _pacienteGuardar.pais = _paciente.pais;
      _pacienteGuardar.profesion = _paciente.profesion;
      _pacienteGuardar.escolaridad = _paciente.escolaridad;
      _pacienteGuardar.religion = _paciente.religion;
      _pacienteGuardar.grupoSanguineo = _paciente.grupoSanguineo;
      _pacienteGuardar.grupoEtnico = _paciente.grupoEtnico;
      _pacienteGuardar.departamento = _paciente.departamento;
      _pacienteGuardar.municipio = _paciente.municipio;
      _pacienteGuardar.departamentoResidencia =
          _paciente.departamentoResidencia;
      _pacienteGuardar.municipioResidencia = _paciente.municipioResidencia;
      _pacienteGuardar.activo = _paciente.activo;
      _pacienteGuardar.creadoPor = _paciente.creadoPor;
      _pacienteGuardar.creadoFecha = _paciente.creadoFecha;
      _pacienteGuardar.modificadoPor = _usuario.userName;
      _pacienteGuardar.modificadoFecha = DateTime.now();
      _pacienteGuardar.notas = _formBloc.notas;

      if (_pacienteGuardar.paisId != 83) {
        _pacienteGuardar.departamentoId = null;
        _pacienteGuardar.municipioId = null;
        _pacienteGuardar.departamentoResidenciaId = null;
        _pacienteGuardar.municipioResidenciaId = null;
      }
      //print(pacientesViewModelToJson(_pacienteGuardar));

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
      _formKey.currentState.reset();
      final PacientesViewModel resp =
          await blocPaciente.updatePaciente(_pacienteGuardar);
      _pr.hide();

      if (resp != null) {
        mostrarFlushBar(
            context,
            Colors.green,
            'Info',
            'Paciente editado correctamente',
            3,
            FlushbarPosition.TOP,
            Icons.info,
            Colors.black);
        Timer(Duration(seconds: 3), () {
          Navigator.pushReplacementNamed(context, 'paciente_detalle',
              arguments: resp);
        });
      } else {
        mostrarFlushBar(
            context,
            Colors.red,
            'Info',
            'Ha ocurrido un error o el paciente ya existe',
            3,
            FlushbarPosition.BOTTOM,
            Icons.info,
            Colors.black);
      }
    }
  }
}
