import 'dart:async';
import 'package:appsam/src/models/municipio_model.dart';
import 'package:appsam/src/models/user_model.dart';
import 'package:appsam/src/widgets/firebaseMessageWrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:getflutter/getflutter.dart';
import 'package:intl/intl.dart';

import 'package:progress_dialog/progress_dialog.dart';

import 'package:appsam/src/blocs/pacientes_bloc/pacientes_bloc.dart';
import 'package:appsam/src/models/departamento_model.dart';
import 'package:appsam/src/models/escolaridad_model.dart';
import 'package:appsam/src/models/estadocivil_model.dart';
import 'package:appsam/src/models/grupoEtnico_model.dart';
import 'package:appsam/src/models/grupoSanguineo_model.dart';

import 'package:appsam/src/models/paginados/pacientesPaginado_model.dart';
import 'package:appsam/src/models/pais_model.dart';
import 'package:appsam/src/models/parentesco_model.dart';
import 'package:appsam/src/models/profesion_model.dart';
import 'package:appsam/src/models/religion_model.dart';
import 'package:appsam/src/providers/combos_service.dart';
import 'package:appsam/src/utils/storage_util.dart';
import 'package:appsam/src/utils/utils.dart';
import 'package:appsam/src/widgets/drawer.dart';

class EditarPacientePage extends StatefulWidget {
  static final String routeName = 'editar_paciente';

  final PacientesViewModel paciente;

  const EditarPacientePage({this.paciente});
  @override
  _EditarPacientePageState createState() => _EditarPacientePageState();
}

class _EditarPacientePageState extends State<EditarPacientePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  UserModel _usuario =
      userModelFromJson(StorageUtil.getString('usuarioGlobal'));

  DateTime picked;

  TextEditingController _fechaNacimientoController =
      new TextEditingController();
  final PacientesBloc pacientesBloc = new PacientesBloc();

  final comboService = CombosService();

  @override
  void dispose() {
    pacientesBloc.dispose();

    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    StorageUtil.putString('ultimaPagina', EditarPacientePage.routeName);
    var formato = DateFormat('dd/MM/yyyy');
    final _fechaNaci = formato.format(widget.paciente.fechaNacimiento);
    _fechaNacimientoController.text = _fechaNaci;
    pacientesBloc.cargarMunicipios(widget.paciente.departamentoId);
    pacientesBloc
        .cargarMunicipiosResi(widget.paciente.departamentoResidenciaId);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: FirebaseMessageWrapper(
          child: Scaffold(
            backgroundColor: colorFondoApp(),
            appBar: AppBar(
              title: Text('Editar Paciente'),
              actions: <Widget>[
                IconButton(
                    icon: Icon(Icons.arrow_back_ios),
                    onPressed: () => (pacientesBloc.cargando ||
                            pacientesBloc.cargandoMunicipiosResi)
                        ? {}
                        : Navigator.pushReplacementNamed(context, 'pacientes'))
              ],
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
                          icon: FaIcon(FontAwesomeIcons.user,
                              color: Colors.white)),
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
                          icon: FaIcon(FontAwesomeIcons.user,
                              color: Colors.white)),
                      content: _formParteDos(),
                    ),
                    GFCard(
                      elevation: 6.0,
                      boxFit: BoxFit.cover,
                      title: GFListTile(
                          color: Colors.red,
                          title: Text('Ubicación ',
                              style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white)),
                          icon: FaIcon(FontAwesomeIcons.user,
                              color: Colors.white)),
                      content: _formParteCinco(),
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
                          icon: FaIcon(FontAwesomeIcons.user,
                              color: Colors.white)),
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
                          icon: FaIcon(FontAwesomeIcons.user,
                              color: Colors.white)),
                      content: _formParteCuatro(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        onWillPop: () async => false);
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
        _crearCampoIdentificacion(),
        _espacio(),
        _crearFecha(context),
        _espacio(),
        _crearCampoEstadoCivil(),
        _espacio(),
        _crearCampoTelefono1(),
        _espacio(),
        _crearCampoEmail(),
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
        _crearCampoDireccion(),
        _espacio(),
        _crearCampoNombreEmergencia(),
        _espacio(),
        _crearCampoTelefonoEmergencia(),
        _espacio(),
        _crearCampoParentesco(),
        _espacio(),
      ],
    );
  }

  Widget _formParteCinco() {
    return Column(
      children: <Widget>[
        _espacio(),
        (widget.paciente.paisId == 83)
            ? _crearDropDownDepartamento()
            : Container(),
        _espacio(),
        (widget.paciente.paisId == 83)
            ? _crearDropDownMunicipio()
            : Container(),
        _espacio(),
        _crearDropDownDepartamentoResidencia(),
        _espacio(),
        _crearDropDownMunicipioResidencia(),
        _espacio()
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
        _crearBotones(context)
      ],
    );
  }

  Widget _crearCampoNombre() {
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0),
      child: TextFormField(
        initialValue: widget.paciente.nombres,
        autovalidate: true,
        validator: validaTexto,
        keyboardType: TextInputType.text,
        decoration: inputsDecorations('Nombres', Icons.person),
        onChanged: (value) => widget.paciente.nombres = value,
        onSaved: (value) => widget.paciente.nombres = value,
      ),
    );
  }

  Widget _crearCampoPrimerApellido() {
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0),
      child: TextFormField(
        initialValue: widget.paciente.primerApellido,
        autovalidate: true,
        validator: validaTexto,
        keyboardType: TextInputType.text,
        decoration: inputsDecorations('Primer Apellido', Icons.person),
        onChanged: (value) => widget.paciente.primerApellido = value,
        onSaved: (value) => widget.paciente.primerApellido = value,
      ),
    );
  }

  Widget _crearCampoSegundoApellido() {
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0),
      child: TextFormField(
        initialValue: widget.paciente.segundoApellido,
        autovalidate: true,
        validator: validaTexto,
        keyboardType: TextInputType.text,
        decoration: inputsDecorations('Segundo Apellido', Icons.person),
        onChanged: (value) => widget.paciente.segundoApellido = value,
        onSaved: (value) => widget.paciente.segundoApellido = value,
      ),
    );
  }

  Widget _crearCampoIdentificacion() {
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0),
      child: TextFormField(
        initialValue: widget.paciente.identificacion,
        inputFormatters: [
          LengthLimitingTextInputFormatter(13),
          WhitelistingTextInputFormatter.digitsOnly
        ],
        maxLength: 13,
        keyboardType: TextInputType.number,
        decoration: inputsDecorations('Identificación', Icons.credit_card),
        onChanged: (value) => widget.paciente.identificacion = value,
        onSaved: (value) => widget.paciente.identificacion = value,
        enabled: false,
      ),
    );
  }

  Widget _crearFecha(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0),
      child: TextFormField(
        autovalidate: true,
        validator: validaTexto,
        enableInteractiveSelection: false,
        controller: _fechaNacimientoController,
        decoration:
            inputsDecorations('Fecha de Nacimiento', Icons.calendar_today),
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
          _selectDate(context);
        },
      ),
    );
  }

  _selectDate(BuildContext context) async {
    picked = await showDatePicker(
        helpText: 'Seleccione fecha.',
        errorFormatText: 'Fecha invalida',
        fieldLabelText: 'Ingrese fecha',
        initialDatePickerMode: DatePickerMode.year,
        context: context,
        initialDate: new DateTime.now(),
        firstDate: new DateTime(1930),
        lastDate: new DateTime.now(),
        locale: Locale('es', 'ES'));

    if (picked != null) {
      var format = DateFormat('dd/MM/yyyy');

      _fechaNacimientoController.text = format.format(picked);
      widget.paciente.fechaNacimiento = picked;
    }
  }

  Widget _crearCampoEstadoCivil() {
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
            value: widget.paciente.estadoCivil,
            isDense: true,
            onChanged: (value) {
              setState(() {
                widget.paciente.estadoCivil = value;
                FocusScope.of(context).requestFocus(FocusNode());
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

  _crearCampoTelefono1() {
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0),
      child: TextFormField(
        initialValue: widget.paciente.telefono1,
        autovalidate: true,
        validator: validaTexto,
        keyboardType: TextInputType.number,
        inputFormatters: [
          LengthLimitingTextInputFormatter(8),
          WhitelistingTextInputFormatter.digitsOnly
        ],
        maxLength: 8,
        decoration: inputsDecorations('Teléfono', Icons.phone_android),
        onChanged: (value) => widget.paciente.telefono1 = value,
        onSaved: (value) => widget.paciente.telefono1 = value,
      ),
    );
  }

  _crearCampoEmail() {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
      child: TextFormField(
        initialValue: widget.paciente.email,
        keyboardType: TextInputType.emailAddress,
        decoration: inputsDecorations('Email', Icons.email),
        onChanged: (value) => widget.paciente.email = value,
        onSaved: (value) => widget.paciente.email = value,
      ),
    );
  }

  String validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Ingrese email valido';
    else
      return null;
  }

  Widget _espacio() {
    return SizedBox(
      height: 10.0,
    );
  }

  _crearSexo(value, String title) {
    return RadioListTile(
        title: (Text(title)),
        value: value,
        groupValue: widget.paciente.sexo,
        onChanged: (value) {
          setState(() {
            widget.paciente.sexo = value;
          });
        });
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
                child: DropdownButtonHideUnderline(
                    child: FittedBox(
                  fit: BoxFit.contain,
                  child: DropdownButton(
                    value: widget.paciente.profesionId,
                    isDense: true,
                    onChanged: (value) {
                      setState(() {
                        widget.paciente.profesionId = value;
                        FocusScope.of(context).requestFocus(FocusNode());
                      });
                    },
                    items: lista.map((x) {
                      return DropdownMenuItem(
                        value: x.profesionId,
                        child: Text(x.nombre),
                      );
                    }).toList(),
                  ),
                ))),
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
              child: DropdownButtonHideUnderline(
                  child: FittedBox(
                fit: BoxFit.contain,
                child: DropdownButton(
                  value: widget.paciente.escolaridadId,
                  isDense: true,
                  onChanged: (value) {
                    setState(() {
                      widget.paciente.escolaridadId = value;
                      FocusScope.of(context).requestFocus(FocusNode());
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
                ),
              )),
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
              child: DropdownButtonHideUnderline(
                  child: DropdownButton(
                value: widget.paciente.religionId,
                isDense: true,
                onChanged: (value) {
                  setState(() {
                    widget.paciente.religionId = value;
                    FocusScope.of(context).requestFocus(FocusNode());
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
              )),
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
              child: DropdownButtonHideUnderline(
                  child: DropdownButton(
                value: widget.paciente.grupoSanguineoId,
                isDense: true,
                onChanged: (value) {
                  setState(() {
                    widget.paciente.grupoSanguineoId = value;
                    FocusScope.of(context).requestFocus(FocusNode());
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
              )),
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
              child: DropdownButtonHideUnderline(
                  child: DropdownButton(
                value: widget.paciente.grupoEtnicoId,
                isDense: true,
                onChanged: (value) {
                  setState(() {
                    widget.paciente.grupoEtnicoId = value;
                    FocusScope.of(context).requestFocus(FocusNode());
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
              )),
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
        if (snapshot.hasData) {
          final lista = snapshot.data;
          return Padding(
            padding: EdgeInsets.only(left: 8.0, right: 8.0),
            child: InputDecorator(
              decoration:
                  inputsDecorations('Departamento de Nacimiento', Icons.map),
              child: DropdownButtonHideUnderline(
                  child: DropdownButton(
                value: widget.paciente.departamentoId,
                isDense: true,
                onChanged: (value) {
                  setState(() {
                    widget.paciente.departamentoId = value;
                    widget.paciente.municipioId = null;
                    pacientesBloc.cargarMunicipios(value);
                    FocusScope.of(context).requestFocus(FocusNode());
                  });
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
              )),
            ),
          );
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }

  Widget _crearDropDownMunicipio() {
    return StreamBuilder(
      stream: pacientesBloc.municipiosListStream,
      builder: (BuildContext context,
          AsyncSnapshot<List<MunicipioModel>> snapshotMuni) {
        if (!snapshotMuni.hasData) return CircularProgressIndicator();

        return (pacientesBloc.cargando)
            ? CircularProgressIndicator()
            : Padding(
                padding: EdgeInsets.only(left: 8.0, right: 8.0),
                child: InputDecorator(
                    decoration:
                        inputsDecorations('Municipio de Nacimiento', Icons.map),
                    child: DropdownButtonHideUnderline(
                        child: DropdownButton(
                      icon: Icon(Icons.arrow_drop_down),
                      isDense: true,
                      value: widget.paciente.municipioId,
                      onChanged: (value) {
                        widget.paciente.municipioId = value;
                        FocusScope.of(context).requestFocus(FocusNode());
                      },
                      items: snapshotMuni.data.map((x) {
                        return DropdownMenuItem(
                          value: x.municipioId,
                          child: Text(
                            x.nombre,
                            overflow: TextOverflow.ellipsis,
                          ),
                        );
                      }).toList(),
                    ))),
              );
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
              child: DropdownButtonHideUnderline(
                  child: FittedBox(
                fit: BoxFit.contain,
                child: DropdownButton(
                  value: widget.paciente.paisId,
                  isDense: true,
                  onChanged: (value) {
                    setState(() {
                      widget.paciente.paisId = value;
                      FocusScope.of(context).requestFocus(FocusNode());
                      widget.paciente.paisId = value;
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
                ),
              )),
            ),
          );
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }

  Widget _crearCampoNombreEmergencia() {
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0),
      child: TextFormField(
        initialValue: widget.paciente.nombreEmergencia,
        keyboardType: TextInputType.text,
        decoration: inputsDecorations('Contacto Emergencia', Icons.person),
        onChanged: (value) => widget.paciente.nombreEmergencia = value,
        onSaved: (value) => widget.paciente.nombreEmergencia = value,
      ),
    );
  }

  _crearCampoTelefonoEmergencia() {
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0),
      child: TextFormField(
        initialValue: widget.paciente.telefonoEmergencia,
        keyboardType: TextInputType.number,
        inputFormatters: [
          LengthLimitingTextInputFormatter(8),
          WhitelistingTextInputFormatter.digitsOnly
        ],
        maxLength: 8,
        decoration: inputsDecorations('Tel. Contacto Emergencia', Icons.phone),
        onChanged: (value) => widget.paciente.telefonoEmergencia = value,
        onSaved: (value) => widget.paciente.telefonoEmergencia = value,
      ),
    );
  }

  Widget _crearCampoParentesco() {
    final parentescoLista = new List<ParentescoModel>();
    parentescoLista
        .add(new ParentescoModel(texto: 'Familiar', valor: 'familiar'));
    parentescoLista.add(new ParentescoModel(texto: 'Amigo', valor: 'amigo'));
    parentescoLista
        .add(new ParentescoModel(texto: 'Conyugue', valor: 'conyugue'));
    parentescoLista
        .add(new ParentescoModel(texto: 'Hijo(a)', valor: 'hijo(a)'));
    parentescoLista.add(new ParentescoModel(texto: 'Otro', valor: 'otro'));

    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0),
      child: InputDecorator(
          decoration: inputsDecorations('Parentesco', Icons.people),
          child: DropdownButtonHideUnderline(
              child: DropdownButton(
            value: widget.paciente.parentesco,
            isDense: true,
            onChanged: (value) {
              setState(() {
                widget.paciente.parentesco = value;
                FocusScope.of(context).requestFocus(FocusNode());
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

  Widget _crearCampoMenorDeEdad() {
    return SwitchListTile(
        title: Text('Menor de Edad'),
        value: widget.paciente.menorDeEdad,
        onChanged: (value) {
          setState(() {
            widget.paciente.menorDeEdad = value;
          });
        });
  }

  Widget _crearCampoNombreMadre() {
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0),
      child: TextFormField(
        initialValue: widget.paciente.nombreMadre,
        keyboardType: TextInputType.text,
        decoration: inputsDecorations('Nombre Madre', Icons.person),
        onChanged: (value) => widget.paciente.nombreMadre = value,
        onSaved: (value) => widget.paciente.nombreMadre = value,
      ),
    );
  }

  Widget _crearCampoIdentificacionMadre() {
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0),
      child: TextFormField(
        initialValue: widget.paciente.identificacionMadre,
        inputFormatters: [
          LengthLimitingTextInputFormatter(13),
          WhitelistingTextInputFormatter.digitsOnly
        ],
        maxLength: 13,
        keyboardType: TextInputType.number,
        decoration: inputsDecorations('Identificación Madre', Icons.person),
        onChanged: (value) => widget.paciente.identificacionMadre = value,
        onSaved: (value) => widget.paciente.identificacionMadre = value,
      ),
    );
  }

  Widget _crearCampoNombrePadre() {
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0),
      child: TextFormField(
        initialValue: widget.paciente.nombrePadre,
        keyboardType: TextInputType.text,
        decoration: inputsDecorations('Nombre Padre', Icons.person),
        onChanged: (value) => widget.paciente.nombrePadre = value,
        onSaved: (value) => widget.paciente.nombrePadre = value,
      ),
    );
  }

  Widget _crearCampoIdentificacionPadre() {
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0),
      child: TextFormField(
        initialValue: widget.paciente.identificacionPadre,
        inputFormatters: [
          LengthLimitingTextInputFormatter(13),
          WhitelistingTextInputFormatter.digitsOnly
        ],
        maxLength: 13,
        keyboardType: TextInputType.number,
        decoration: inputsDecorations('Identificación Padre', Icons.person),
        onChanged: (value) => widget.paciente.identificacionPadre = value,
        onSaved: (value) => widget.paciente.identificacionPadre = value,
      ),
    );
  }

  Widget _crearCampoNotas() {
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0),
      child: TextFormField(
        initialValue: widget.paciente.notas,
        keyboardType: TextInputType.text,
        maxLines: 2,
        decoration: inputsDecorations('Notas', Icons.note),
        onChanged: (value) => widget.paciente.notas = value,
        onSaved: (value) => widget.paciente.notas = value,
      ),
    );
  }

  Widget _crearCampoDireccion() {
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0),
      child: TextFormField(
        initialValue: widget.paciente.direccion,
        keyboardType: TextInputType.text,
        maxLines: 3,
        decoration: inputsDecorations('Dirección', Icons.note),
        onChanged: (value) => widget.paciente.direccion = value,
        onSaved: (value) => widget.paciente.direccion = value,
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

  Widget _crearCampoCarneVacuna() {
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0),
      child: TextFormField(
        initialValue: widget.paciente.carneVacuna,
        keyboardType: TextInputType.text,
        decoration: inputsDecorations('Carné de Vacuna', Icons.person),
        onChanged: (value) => widget.paciente.carneVacuna = value,
        onSaved: (value) => widget.paciente.carneVacuna = value,
      ),
    );
  }

  Widget _crearDropDownDepartamentoResidencia() {
    return FutureBuilder(
      future: comboService.getDepartamentos(),
      builder: (BuildContext context,
          AsyncSnapshot<List<DepartamentoModel>> snapshot) {
        if (snapshot.hasData) {
          final lista = snapshot.data;
          return Padding(
            padding: EdgeInsets.only(left: 8.0, right: 8.0),
            child: InputDecorator(
              decoration:
                  inputsDecorations('Departamento de Residencia', Icons.map),
              child: DropdownButtonHideUnderline(
                  child: DropdownButton(
                value: widget.paciente.departamentoResidenciaId,
                isDense: true,
                onChanged: (value) {
                  setState(() {
                    widget.paciente.departamentoResidenciaId = value;
                    widget.paciente.municipioResidenciaId = null;
                    pacientesBloc.cargarMunicipiosResi(value);
                    FocusScope.of(context).requestFocus(FocusNode());
                  });
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
              )),
            ),
          );
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }

  Widget _crearDropDownMunicipioResidencia() {
    return StreamBuilder(
      stream: pacientesBloc.municipiosResiListStream,
      builder: (BuildContext context,
          AsyncSnapshot<List<MunicipioModel>> snapshotResi) {
        if (!snapshotResi.hasData) return CircularProgressIndicator();
        return (pacientesBloc.cargandoMunicipiosResi)
            ? CircularProgressIndicator()
            : Padding(
                padding: EdgeInsets.only(left: 8.0, right: 8.0),
                child: InputDecorator(
                  decoration:
                      inputsDecorations('Municipio de Residencia', Icons.map),
                  child: DropdownButtonHideUnderline(
                      child: DropdownButton(
                    icon: Icon(Icons.arrow_drop_down),
                    isDense: true,
                    value: widget.paciente.municipioResidenciaId,
                    onChanged: (value) {
                      setState(() {
                        widget.paciente.municipioResidenciaId = value;
                        FocusScope.of(context).requestFocus(FocusNode());
                      });
                    },
                    items: snapshotResi.data.map((x) {
                      return DropdownMenuItem(
                        value: x.municipioId,
                        child: Text(
                          x.nombre,
                          overflow: TextOverflow.ellipsis,
                        ),
                      );
                    }).toList(),
                  )),
                ));
      },
    );
  }

  Widget _crearBotones(
    BuildContext context,
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
            onPressed: () => _guardaPaciente(context)));
  }

  void _guardaPaciente(
    BuildContext context,
  ) async {
    if (!_formKey.currentState.validate()) {
      mostrarFlushBar(context, Colors.black, 'Información',
          'Rellene todos los campos', 2, Icons.info, Colors.white);
    } else {
      _formKey.currentState.save();
      widget.paciente.modificadoPor = _usuario.userName;
      widget.paciente.modificadoFecha = DateTime.now();

      if (widget.paciente.paisId != 83) {
        widget.paciente.departamentoId = null;
        widget.paciente.municipioId = null;
      }

      // imprimirJSON(widget.paciente);
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

      _formKey.currentState.reset();
      final PacientesViewModel resp =
          await pacientesBloc.updatePaciente(widget.paciente);

      if (resp != null) {
        await _pr.hide();

        mostrarFlushBar(context, Colors.green, 'Info',
            'Paciente editado correctamente', 3, Icons.info, Colors.black);
        Future.delayed(Duration(seconds: 3)).then((_) {
          Navigator.pushReplacementNamed(context, 'paciente_detalle',
              arguments: resp);
        });
      } else {
        await _pr.hide();

        mostrarFlushBar(
            context,
            Colors.red,
            'Info',
            'Ha ocurrido un error o el paciente ya existe, revise la identificación.',
            5,
            Icons.info,
            Colors.black);
      }
    }
  }
}
