import 'package:appsam/src/widgets/firebaseMessageWrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:async';
import 'package:getflutter/getflutter.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:progress_dialog/progress_dialog.dart';

import 'package:appsam/src/blocs/asistentes_bloc/create_edit_asistentes.dart';
import 'package:appsam/src/blocs/provider.dart';
import 'package:appsam/src/models/usuario_model.dart';
import 'package:appsam/src/utils/storage_util.dart';
import 'package:appsam/src/utils/utils.dart';
import 'package:appsam/src/widgets/drawer.dart';

class CrearAsistentesPage extends StatefulWidget {
  static final String routeName = 'crear-editar-asistente';
  @override
  _CrearAsistentesPageState createState() => _CrearAsistentesPageState();
}

class _CrearAsistentesPageState extends State<CrearAsistentesPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  // bool _autoValidate = false;
  String _fecha = '';
  String _sexo = 'M';
  DateTime picked;
  TextEditingController _inputFieldDateController = new TextEditingController();
  TextEditingController _txtControllerPass = new TextEditingController();
  TextEditingController _controllerUsuario = new TextEditingController();
  TextEditingController _txtControllerNombres = new TextEditingController();
  TextEditingController _txtControllerPrimerApellido =
      new TextEditingController();
  TextEditingController _txtControllerIdentificacion =
      new TextEditingController();
  final UsuarioModel _usuario =
      usuarioModelFromJson(StorageUtil.getString('usuarioGlobal'));
  MaskTextInputFormatter maskIdentificacion = new MaskTextInputFormatter(
      mask: '#############', filter: {"#": RegExp(r'[0-9]')});

  @override
  void initState() {
    super.initState();
    StorageUtil.putString('ultimaPagina', CrearAsistentesPage.routeName);
  }

  @override
  Widget build(BuildContext context) {
    final UsuarioModel _asistente = ModalRoute.of(context).settings.arguments;
    final GlobalKey<ScaffoldState> _scaffoldKey =
        new GlobalKey<ScaffoldState>();

    MaskTextInputFormatter maskNumeroColegiado = new MaskTextInputFormatter(
        mask: '#######', filter: {"#": RegExp(r'[0-9]')});

    final bloc = Provider.crearEditarAsistentesBloc(context);
    return WillPopScope(
        child: FirebaseMessageWrapper(
          child: Scaffold(
              backgroundColor: colorFondoApp(),
              appBar: AppBar(
                key: _scaffoldKey,
                title: Text('Nuevo Asistente'),
                actions: <Widget>[
                  IconButton(
                      icon: Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                      ),
                      onPressed: () =>
                          Navigator.pushReplacementNamed(context, 'asistentes'))
                ],
              ),
              drawer: MenuWidget(),
              body: SingleChildScrollView(
                child: Form(
                    key: _formKey,
                    child: GFCard(
                      title: GFListTile(
                          color: Colors.red,
                          title: Text('Información Personal',
                              style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white)),
                          icon: FaIcon(FontAwesomeIcons.user,
                              color: Colors.white)),
                      content: Column(
                        children: <Widget>[
                          _espacio(),
                          _crearCampoNombre(_asistente),
                          _espacio(),
                          _crearCampoPrimerAppellido(_asistente),
                          _espacio(),
                          _crearCampoSegundoAppellido(_asistente),
                          _espacio(),
                          _crearCampoIdentificacion(
                              _asistente, maskIdentificacion),
                          _espacio(),
                          _crearFecha(context, bloc.fechaNacimientoStream,
                              bloc.changeFechaNacimiento),
                          _espacio(),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                  padding: EdgeInsets.only(left: 25),
                                  child: Text(
                                    'Genero',
                                    style: TextStyle(fontSize: 16.0),
                                  ))
                            ],
                          ),
                          _crearSexo('M', 'Masculino'),
                          _crearSexo('F', 'Femenino'),
                          _crearCampoTelefono1(_asistente),
                          _espacio(),
                          _crearCampoTelefono2(_asistente),
                          _espacio(),
                          _crearCampoColegioNumero(
                              _asistente, maskNumeroColegiado),
                          _espacio(),
                          _crearCampoEmail(_asistente),
                          _espacio(),
                          _crearCampoUsuario(_asistente),
                          _espacio(),
                          _crearCampoPassword(_asistente),
                          _espacio(),
                          _crearCampoNotas(_asistente),
                          _espacio(),
                          _crearBotones(_asistente, bloc),
                        ],
                      ),
                    )),
              )),
        ),
        onWillPop: () async => false);
  } // fin build

  String validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Ingrese email valido';
    else
      return null;
  }

  String validaTexto(String value) {
    if (value.length < 3) {
      return 'Campo obligatorio';
    } else {
      return null;
    }
  }

  _crearCampoNombre(UsuarioModel _asistente) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
      child: TextFormField(
        autovalidate: true,
        controller: _txtControllerNombres,
        validator: validaTexto,
        decoration: inputsDecorations('Nombre', Icons.person),
        onSaved: (value) => _asistente.nombres = value,
      ),
    );
  }

  _crearCampoPrimerAppellido(UsuarioModel _asistente) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
      child: TextFormField(
        autovalidate: true,
        validator: validaTexto,
        controller: _txtControllerPrimerApellido,
        decoration: inputsDecorations('Primer Apellido', Icons.person),
        onSaved: (value) => _asistente.primerApellido = value,
      ),
    );
  }

  _crearCampoSegundoAppellido(UsuarioModel _asistente) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
      child: TextFormField(
        autovalidate: true,
        validator: validaTexto,
        decoration: inputsDecorations('Segundo Apellido', Icons.person),
        onSaved: (value) => _asistente.segundoApellido = value,
      ),
    );
  }

  Widget _espacio() {
    return SizedBox(
      height: 10.0,
    );
  }

  _crearCampoIdentificacion(
      UsuarioModel _asistente, MaskTextInputFormatter mask) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
      child: TextFormField(
        controller: _txtControllerIdentificacion,
        autovalidate: true,
        maxLength: 13,
        inputFormatters: [
          LengthLimitingTextInputFormatter(13),
          WhitelistingTextInputFormatter.digitsOnly
        ],
        validator: (value) {
          if (value.length < 13) {
            return 'Campo obligatorio';
          } else {
            return null;
          }
        },
        keyboardType: TextInputType.number,
        decoration: inputsDecorations('Identificación', Icons.credit_card),
        onSaved: (value) => _asistente.identificacion = value,
      ),
    );
  }

  _crearCampoTelefono1(UsuarioModel _asistente) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
      child: TextFormField(
        autovalidate: true,
        validator: (value) {
          if (value.length < 8) {
            return 'Campo incompleto';
          } else {
            return null;
          }
        },
        keyboardType: TextInputType.number,
        inputFormatters: [
          LengthLimitingTextInputFormatter(8),
          WhitelistingTextInputFormatter.digitsOnly
        ],
        maxLength: 8,
        decoration: inputsDecorations('Teléfono', Icons.phone_android),
        onSaved: (value) => _asistente.telefono1 = value,
      ),
    );
  }

  _crearCampoTelefono2(UsuarioModel _asistente) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
      child: TextFormField(
        keyboardType: TextInputType.number,
        inputFormatters: [
          LengthLimitingTextInputFormatter(8),
          WhitelistingTextInputFormatter.digitsOnly
        ],
        maxLength: 8,
        decoration:
            inputsDecorations('Teléfono Secundario', Icons.phone_iphone),
        onSaved: (value) => _asistente.telefono2 = value,
      ),
    );
  }

  _crearCampoColegioNumero(
      UsuarioModel _asistente, MaskTextInputFormatter mask) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
      child: TextFormField(
        autovalidate: true,
        validator: validaTexto,
        inputFormatters: [mask],
        keyboardType: TextInputType.number,
        maxLength: 7,
        decoration:
            inputsDecorations('Numero Colegiado', FontAwesomeIcons.hashtag),
        onSaved: (value) => _asistente.colegioNumero = value,
      ),
    );
  }

  _crearCampoEmail(UsuarioModel _asistente) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
      child: TextFormField(
        autovalidate: true,
        validator: validateEmail,
        keyboardType: TextInputType.emailAddress,
        decoration: inputsDecorations('Email', Icons.email),
        onSaved: (value) => _asistente.email = value,
      ),
    );
  }

  Widget _crearCampoUsuario(UsuarioModel _asistente) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
      child: TextFormField(
        autovalidate: true,
        validator: validaTexto,
        controller: _controllerUsuario,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          suffixIcon: IconButton(
              icon: Icon(
                Icons.replay,
                color: Colors.blue,
              ),
              onPressed: () {
                final String val = generateUser(
                    _txtControllerNombres.text,
                    _txtControllerPrimerApellido.text,
                    _txtControllerIdentificacion.text);
                _controllerUsuario.text = val.toLowerCase();
              }),
          prefixIcon: Icon(
            Icons.person,
            color: Colors.red,
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
          labelText: 'Usuario',
          isDense: true,
        ),
        onSaved: (value) => _asistente.userName = value,
      ),
    );
  }

  Widget _crearCampoPassword(UsuarioModel _asistente) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
      child: TextFormField(
        validator: validaTexto,
        controller: _txtControllerPass,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
            suffixIcon: IconButton(
                icon: Icon(
                  Icons.replay,
                  color: Colors.blue,
                ),
                onPressed: () {
                  final String val =
                      generatePassword(true, true, true, false, 8);
                  _txtControllerPass.text = val;
                }),
            prefixIcon: Icon(
              Icons.lock,
              color: Colors.red,
            ),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
            labelText: 'Contraseña',
            isDense: true),
        onSaved: (value) => _asistente.password = value,
      ),
    );
  }

  _crearCampoNotas(UsuarioModel _asistente) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
      child: TextFormField(
        maxLines: 2,
        decoration: inputsDecorations('Notas', Icons.note),
        onSaved: (value) => _asistente.notas = value,
      ),
    );
  }

  Widget _crearFecha(
      BuildContext context, Stream stream, Function(String) func) {
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0),
      child: TextFormField(
        keyboardType: TextInputType.number,
        enableInteractiveSelection: false,
        controller: _inputFieldDateController,
        decoration: inputsDecorations('Fecha Nacimiento', Icons.calendar_today),
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
          _selectDate(context);
        },
      ),
    );
  }

// se modifico la fecha final como el dia actual
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
      setState(() {
        var format = DateFormat('dd/MM/yyyy');
        _fecha = format.format(picked);

        _inputFieldDateController.text = _fecha;
      });
    }
  }

  _crearSexo(value, String title) {
    return RadioListTile(
        title: (Text(title)),
        value: value,
        groupValue: _sexo,
        onChanged: (value) {
          setState(() {
            _sexo = value;
            print(value);
          });
        });
  }

  Widget _crearBotones(
      UsuarioModel _asistente, CrearEditarAsistentesBloc bloc) {
    if (_usuario != null) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 25.0, bottom: 10.0),
            child: RaisedButton.icon(
                elevation: 5.0,
                textColor: Colors.white,
                color: Colors.blueGrey,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0)),
                onPressed: () {
                  Navigator.pushReplacementNamed(context, 'asistentes');
                },
                icon: Icon(Icons.clear),
                label: Text('Cancelar')),
          ),
          Padding(
              padding: EdgeInsets.only(right: 25.0, bottom: 10.0),
              child: RaisedButton.icon(
                  elevation: 5.0,
                  textColor: Colors.white,
                  color: Theme.of(context).primaryColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0)),
                  icon: Icon(Icons.save),
                  label: Text('Guardar'),
                  onPressed: () => _guardar(_asistente, bloc)))
        ],
      );
    } else {
      return Container();
    }
  }

  void _guardar(UsuarioModel _asistente, CrearEditarAsistentesBloc bloc) async {
    if (!_formKey.currentState.validate()) {
      mostrarFlushBar(context, Colors.redAccent, 'Información',
          'Rellene todos los campos', 2, Icons.info, Colors.black);
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
      _asistente.fechaNacimiento = picked;
      _asistente.identificacion = maskIdentificacion.getMaskedText();
      print(usuarioModelToJson(_asistente));
      final resp = await bloc.addUser(_asistente);
      await _pr.hide();
      if (resp) {
        _formKey.currentState.reset();
        _txtControllerIdentificacion.text = '';

        _txtControllerNombres.text = '';
        _txtControllerPass.text = '';
        _txtControllerPrimerApellido.text = '';
        _controllerUsuario.text = '';
        _inputFieldDateController.text = '';
        Navigator.pushReplacementNamed(context, 'asistentes');
      } else {
        mostrarFlushBar(
            context,
            Colors.red,
            'Info',
            'Ha ocurrido un error o el usuario ya existe, revise el correo,identificación, usuario, colegio numero, ó email.',
            5,
            Icons.info,
            Colors.white);
      }
    }
  }
}
