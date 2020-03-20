import 'dart:async';

import 'package:appsam/src/blocs/pacientes_bloc.dart';
import 'package:appsam/src/blocs/provider.dart';
import 'package:appsam/src/models/estadocivil_model.dart';
import 'package:appsam/src/models/paciente_model.dart';
import 'package:appsam/src/models/parentesco_model.dart';
import 'package:appsam/src/models/tiposangre_model.dart';
import 'package:appsam/src/models/usuario_model.dart';
import 'package:appsam/src/utils/storage_util.dart';
import 'package:appsam/src/utils/utils.dart';
import 'package:appsam/src/widgets/drawer.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
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
  String _sexo = 'M';
  DateTime picked;
  String _tipoSangre = 'A+';
  String _estadoCivil = 'S';
  String _parentesco = 'otro';
  bool _menorDeEdad = false;
  Paciente _paciente = new Paciente();

  TextEditingController _inputFieldDateController = new TextEditingController();
  final PacientesBloc pacientesBloc = new PacientesBloc();
  FocusNode myFocusNode;

  @override
  void dispose() {
    super.dispose();

    myFocusNode.dispose();
  }

  @override
  void initState() {
    super.initState();
    StorageUtil.putString('ultimaPagina', CrearPacientePage.routeName);
    myFocusNode = FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    final UsuarioModel _usuario = ModalRoute.of(context).settings.arguments;
    _paciente.menorDeEdad = false;
    _paciente.sexo = _sexo;
    _paciente.estadoCivil = _estadoCivil;
    _paciente.tipoDeSangre = _tipoSangre;

    MaskTextInputFormatter maskTelefono1 = new MaskTextInputFormatter(
        mask: '####-####', filter: {"#": RegExp(r'[0-9]')});

    MaskTextInputFormatter maskTelefono2 = new MaskTextInputFormatter(
        mask: '####-####', filter: {"#": RegExp(r'[0-9]')});
    final blocPacientes = Provider.pacientesBloc(context);

    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text('Nuevo Paciente'),
        ),
        drawer: MenuWidget(),
        body: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.only(
                top: 10.0, left: 10.0, right: 10.0, bottom: 10.0),
            child: Card(
              elevation: 6.0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0)),
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 15,
                  ),
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
                          _crearCampoIdentificacion(_paciente),
                          _espacio(),
                          _crearFecha(context, _paciente),
                          _espacio(),
                          _crearCampoEstadoCivil(_paciente),
                          _espacio(),
                          _crearCampoTipoSangre(_paciente),
                          _espacio(),
                          _texto('Genero'),
                          _crearSexo('M', 'Masculino', _paciente),
                          _crearSexo('F', 'Femenino', _paciente),
                          _crearCampoTelefono1(maskTelefono1, _paciente),
                          _espacio(),
                          _crearCampoNombreEmergencia(_paciente),
                          _espacio(),
                          _crearCampoTelefonoEmergencia(
                              maskTelefono2, _paciente),
                          _espacio(),
                          _crearCampoParentesco(_paciente),
                          _espacio(),
                          _crearCampoMenorDeEdad(
                            _paciente,
                          ),
                          _espacio(),
                          _crearCamposMenorDeEdad(_paciente, _menorDeEdad),
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
          ),
        ));
  } // fin build

  String validaTexto(String value) {
    if (value.length <= 3) {
      return 'Campo obligatorio';
    } else {
      return null;
    }
  }

  Widget _crearCampoNombre(Paciente _paciente) {
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0),
      child: TextFormField(
        autovalidate: true,
        focusNode: myFocusNode,
        validator: validaTexto,
        onSaved: (value) => _paciente.nombres = value,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.account_circle,
              color: Colors.redAccent,
            ),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
            labelText: 'Nombres',
            isDense: true),
      ),
    );
  }

  Widget _crearCampoPrimerApellido(Paciente _paciente) {
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0),
      child: TextFormField(
        autovalidate: true,
        validator: validaTexto,
        onSaved: (value) => _paciente.primerApellido = value,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.account_circle,
              color: Colors.redAccent,
            ),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
            labelText: 'Primer Apellido',
            isDense: true),
      ),
    );
  }

  Widget _crearCampoSegundoApellido(Paciente _paciente) {
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0),
      child: TextFormField(
        autovalidate: true,
        validator: validaTexto,
        onSaved: (value) => _paciente.segundoApellido = value,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.account_circle,
              color: Colors.redAccent,
            ),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
            labelText: 'Segundo Apellido',
            isDense: true),
      ),
    );
  }

  Widget _espacio() {
    return SizedBox(
      height: 8.0,
    );
  }

  Widget _crearCampoIdentificacion(Paciente _paciente) {
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0),
      child: TextFormField(
        autovalidate: true,
        validator: validaTexto,
        onSaved: (value) => _paciente.identificacion = value,
        maxLength: 13,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.credit_card,
              color: Colors.redAccent,
            ),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
            labelText: 'Identificación',
            isDense: true,
            hintText: 'Sin guiones'),
      ),
    );
  }

  Widget _crearFecha(BuildContext context, Paciente _paciente) {
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0),
      child: TextFormField(
        autovalidate: true,
        validator: validaTexto,
        enableInteractiveSelection: false,
        controller: _inputFieldDateController,
        decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.calendar_today,
              color: Colors.red,
            ),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
            labelText: 'Fecha de Nacimiento',
            isDense: true),
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
          _selectDate(context, _paciente);
        },
        //onChanged: blocPacientes.onChangeFechaNacimiento,
      ),
    );
  }

  _selectDate(BuildContext context, Paciente _paciente) async {
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

  _crearSexo(value, String title, Paciente _paciente) {
    return RadioListTile(
        title: (Text(title)),
        value: value,
        groupValue: _sexo,
        onChanged: (value) {
          _sexo = value;
          _paciente.sexo = _sexo;
          setState(() {});
        });
  }

  _crearCampoTelefono1(MaskTextInputFormatter mask, Paciente _paciente) {
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0),
      child: TextFormField(
        autovalidate: true,
        validator: validaTexto,
        onSaved: (value) => _paciente.telefono1 = value,
        keyboardType: TextInputType.number,
        inputFormatters: [mask],
        decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.phone,
              color: Colors.redAccent,
            ),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
            labelText: 'Teléfono',
            isDense: true),
      ),
    );
  }

  Widget _crearCampoNombreEmergencia(Paciente _paciente) {
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0),
      child: TextFormField(
        autovalidate: true,
        validator: validaTexto,
        onSaved: (value) => _paciente.nombreEmergencia = value,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.account_circle,
              color: Colors.redAccent,
            ),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
            labelText: 'Contacto Emergencia',
            isDense: true),
      ),
    );
  }

  _crearCampoTelefonoEmergencia(
      MaskTextInputFormatter mask, Paciente _paciente) {
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0),
      child: TextFormField(
        autovalidate: true,
        validator: validaTexto,
        onSaved: (value) => _paciente.telefonoEmergencia = value,
        keyboardType: TextInputType.number,
        inputFormatters: [mask],
        decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.phone,
              color: Colors.redAccent,
            ),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
            labelText: 'Teléfono contacto emergencia',
            isDense: true),
      ),
    );
  }

  Widget _crearCampoParentesco(Paciente _paciente) {
    final parentescoLista = new List<ParentescoModel>();
    parentescoLista.add(new ParentescoModel(texto: 'Hij@', valor: 'hij@'));
    parentescoLista.add(new ParentescoModel(texto: 'Madre', valor: 'madre'));
    parentescoLista.add(new ParentescoModel(texto: 'Padre', valor: 'padre'));
    parentescoLista.add(new ParentescoModel(texto: 'Otro', valor: 'otro'));

    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0),
      child: InputDecorator(
          decoration: InputDecoration(
            labelText: 'Parentesco',
            isDense: true,
            prefixIcon: Icon(Icons.face, color: Colors.red),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
          ),
          child: DropdownButtonHideUnderline(
              child: DropdownButton(
            value: _parentesco,
            isDense: true,
            onChanged: (value) {
              setState(() {
                _parentesco = value;
                _paciente.parentesco = _parentesco;
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

  Widget _crearCampoEstadoCivil(Paciente _paciente) {
    final estadoCivilLista = new List<EstadoCivilModel>();
    estadoCivilLista.add(new EstadoCivilModel(texto: 'Solter@', valor: 'S'));
    estadoCivilLista.add(new EstadoCivilModel(texto: 'Casad@', valor: 'C'));
    estadoCivilLista.add(new EstadoCivilModel(texto: 'Divorciad@', valor: 'D'));
    estadoCivilLista
        .add(new EstadoCivilModel(texto: 'Union Libre', valor: 'UL'));

    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0),
      child: InputDecorator(
          decoration: InputDecoration(
            labelText: 'Estado Civil',
            isDense: true,
            prefixIcon: Icon(Icons.face, color: Colors.red),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
          ),
          child: DropdownButtonHideUnderline(
              child: DropdownButton(
            value: _estadoCivil,
            isDense: true,
            onChanged: (value) {
              setState(() {
                _estadoCivil = value;
                _paciente.estadoCivil = _estadoCivil;
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

  Widget _crearCampoTipoSangre(Paciente _paciente) {
    final tipoSangreLista = new List<TipoSangreModel>();
    tipoSangreLista.add(new TipoSangreModel(texto: 'A+', valor: 'A+'));
    tipoSangreLista.add(new TipoSangreModel(texto: 'A-', valor: 'A-'));
    tipoSangreLista.add(new TipoSangreModel(texto: 'O+', valor: 'O+'));
    tipoSangreLista.add(new TipoSangreModel(texto: 'O-', valor: 'O-'));
    tipoSangreLista.add(new TipoSangreModel(texto: 'B+', valor: 'B+'));
    tipoSangreLista.add(new TipoSangreModel(texto: 'B-', valor: 'B-'));
    tipoSangreLista.add(new TipoSangreModel(texto: 'AB+', valor: 'AB+'));
    tipoSangreLista.add(new TipoSangreModel(texto: 'AB-', valor: 'AB-'));
    tipoSangreLista.add(new TipoSangreModel(
        texto: 'EL PACIENTE NO SABE', valor: 'EL PACIENTE NO SABE'));

    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0),
      child: InputDecorator(
          decoration: InputDecoration(
            labelText: 'Tipo de Sangre',
            isDense: true,
            prefixIcon: Icon(Icons.face, color: Colors.red),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
          ),
          child: DropdownButtonHideUnderline(
              child: DropdownButton(
            value: _tipoSangre,
            isDense: true,
            onChanged: (value) {
              setState(() {
                _tipoSangre = value;
                _paciente.tipoDeSangre = _tipoSangre;
              });
            },
            items: tipoSangreLista.map((p) {
              return DropdownMenuItem(
                value: p.valor,
                child: Text(p.texto),
              );
            }).toList(),
          ))),
    );
  }

  Widget _crearCampoMenorDeEdad(
    Paciente _paciente,
  ) {
    return SwitchListTile(
        title: Text('Menor de Edad'),
        value: _menorDeEdad,
        onChanged: (value) {
          _menorDeEdad = value;
          _paciente.menorDeEdad = _menorDeEdad;
          setState(() {
            print(value);
          });
        });
  }

  Widget _crearCamposMenorDeEdad(Paciente _paciente, bool esMenorEdad) {
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

  Widget _crearCampoNombreMadre(Paciente _paciente) {
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0),
      child: TextFormField(
        onSaved: (value) => _paciente.nombreMadre = value,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.account_circle,
              color: Colors.redAccent,
            ),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
            labelText: 'Nombre Madre',
            isDense: true),
      ),
    );
  }

  Widget _crearCampoIdentificacionMadre(Paciente _paciente) {
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0),
      child: TextFormField(
        onSaved: (value) => _paciente.identificacionMadre = value,
        maxLength: 13,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.credit_card,
              color: Colors.redAccent,
            ),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
            labelText: 'Identificación Madre',
            isDense: true,
            hintText: 'Sin guiones'),
      ),
    );
  }

  Widget _crearCampoNombrePadre(Paciente _paciente) {
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0),
      child: TextFormField(
        onSaved: (value) => _paciente.nombrePadre = value,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.account_circle,
              color: Colors.redAccent,
            ),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
            labelText: 'Nombre Padre',
            isDense: true),
      ),
    );
  }

  Widget _crearCampoIdentificacionPadre(Paciente _paciente) {
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0),
      child: TextFormField(
        onSaved: (value) => _paciente.identificacionPadre = value,
        maxLength: 13,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.credit_card,
              color: Colors.redAccent,
            ),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
            labelText: 'Identificación Padre',
            isDense: true,
            hintText: 'Sin guiones'),
      ),
    );
  }

  Widget _crearCampoNotas(Paciente _paciente) {
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0),
      child: TextFormField(
        onSaved: (value) => _paciente.notas = value,
        keyboardType: TextInputType.text,
        maxLines: 2,
        decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.credit_card,
            color: Colors.redAccent,
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
          labelText: 'Notas',
          isDense: true,
        ),
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

  Widget _crearCampoCarneVacuna(Paciente _paciente) {
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0),
      child: TextFormField(
        onSaved: (value) => _paciente.carneVacuna = value,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.account_circle,
              color: Colors.redAccent,
            ),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
            labelText: 'Carné Vacuna',
            isDense: true),
      ),
    );
  }

  Widget _crearBotones(
      Paciente _paciente,
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

  void _guardaPaciente(
      PacientesBloc blocPaciente,
      BuildContext context,
      Paciente _paciente,
      UsuarioModel _usuario,
      GlobalKey<ScaffoldState> _scaffoldKey) async {
    //_paciente.pacienteId = 0;
    _paciente.activo = true;
    _paciente.creadoPor = _usuario.userName;
    _paciente.creadoFecha = DateTime.now();
    _paciente.modificadoPor = _usuario.userName;
    _paciente.modificadoFecha = DateTime.now();

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
      //_paciente.pacienteId = 0;
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
      print(pacienteToJson(_paciente));
      print('============');
      final bool resp = await blocPaciente.addPaciente(_paciente);
      _pr.hide();
      if (resp) {
        mostrarFlushBar(
            context,
            Colors.green,
            'Info',
            'Paciente creado correctamente',
            3,
            FlushbarPosition.TOP,
            Icons.info,
            Colors.black);
        Timer(Duration(seconds: 3), () {
          Navigator.pushReplacementNamed(context, 'home');
        });
      } else {
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          backgroundColor: Colors.red,
          content: Row(
            children: <Widget>[
              Icon(Icons.error),
              Text('Ha ocurrido un error o el paciente ya existe')
            ],
          ),
          duration: Duration(seconds: 3),
        ));
      }
      _formKey.currentState.reset();

      // Future.delayed(Duration(seconds: 2)).then((value) {
      //   _pr.hide();
      //   if (resp) {
      //     _scaffoldKey.currentState.showSnackBar(SnackBar(
      //       content: Text('Assign a GlobalKey to the Scaffold'),
      //       duration: Duration(seconds: 2),
      //     ));
      //     _formKey.currentState.reset();
      //     Navigator.pushReplacementNamed(context, 'home');
      //   } else {
      //     mostrarFlushBar(context, Colors.red, 'Error',
      //         'Ha occurrido un error ó el paciente ya existe', 3);
      //     _formKey.currentState.reset();
      //   }
      // });
    }
  }
}
