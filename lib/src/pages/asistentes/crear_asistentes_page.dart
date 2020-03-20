import 'dart:async';

import 'package:appsam/src/blocs/asistentes_bloc/create_edit_asistentes.dart';
import 'package:appsam/src/blocs/provider.dart';
import 'package:appsam/src/models/usuario_model.dart';
import 'package:appsam/src/utils/storage_util.dart';
import 'package:appsam/src/utils/utils.dart';
import 'package:appsam/src/widgets/drawer.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:progress_dialog/progress_dialog.dart';

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
  TextEditingController _controllerUsuario = new TextEditingController();
  TextEditingController _txtControllerPass = new TextEditingController();
  TextEditingController _txtControllerNombres = new TextEditingController();
  TextEditingController _txtControllerPrimerApellido =
      new TextEditingController();
  TextEditingController _txtControllerIdentificacion =
      new TextEditingController();

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

    MaskTextInputFormatter maskTelefono1 = new MaskTextInputFormatter(
        mask: '####-####', filter: {"#": RegExp(r'[0-9]')});
    MaskTextInputFormatter maskTelefono2 = new MaskTextInputFormatter(
        mask: '####-####', filter: {"#": RegExp(r'[0-9]')});
    MaskTextInputFormatter maskIdentificacion = new MaskTextInputFormatter(
        mask: '####-####-#####', filter: {"#": RegExp(r'[0-9]')});
    final bloc = Provider.crearEditarAsistentesBloc(context);

    return Scaffold(
        appBar: AppBar(
          key: _scaffoldKey,
          title: Text('Nuevo Asistente'),
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
                          _crearCampoNombre(_asistente),
                          _espacio(),
                          _crearCampoPrimerAppellido(_asistente),
                          _espacio(),
                          _crearCampoSegundoAppellido(_asistente),
                          _espacio(),
                          _crearCampoIdentificacion(
                              maskIdentificacion, _asistente),
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
                          _crearCampoTelefono1(maskTelefono1, _asistente),
                          _espacio(),
                          _crearCampoTelefono2(maskTelefono2, _asistente),
                          _espacio(),
                          _crearCampoColegioNumero(_asistente),
                          _espacio(),
                          _crearCampoEmail(_asistente),
                          _espacio(),
                          _crearCampoUsuario(_asistente),
                          _espacio(),
                          _crearCampoPassword(_asistente),
                          _espacio(),
                          _crearCampoNotas(_asistente),
                          _crearBotones(_asistente, bloc),
                        ],
                      )),
                ],
              ),
            ),
          ),
        ));
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
    if (value.length <= 3) {
      return 'mas de 3 caracteres';
    } else {
      return null;
    }
  }

  _crearCampoNombre(UsuarioModel _asistente) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
      child: TextFormField(
        controller: _txtControllerNombres,
        validator: validaTexto,
        decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.person,
            color: Colors.red,
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
          labelText: 'Nombres',
        ),
        onSaved: (value) => _asistente.nombres = value,
      ),
    );
  }

  _crearCampoPrimerAppellido(UsuarioModel _asistente) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
      child: TextFormField(
        validator: validaTexto,
        controller: _txtControllerPrimerApellido,
        decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.person,
            color: Colors.red,
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
          labelText: 'Primer Apellido',
        ),
        onSaved: (value) => _asistente.primerApellido = value,
      ),
    );
  }

  _crearCampoSegundoAppellido(UsuarioModel _asistente) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
      child: TextFormField(
        validator: validaTexto,
        decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.person,
            color: Colors.red,
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
          labelText: 'Segundo apellido',
        ),
        onSaved: (value) => _asistente.segundoApellido = value,
      ),
    );
  }

  Widget _espacio() {
    return SizedBox(
      height: 8.0,
    );
  }

  _crearCampoIdentificacion(
      MaskTextInputFormatter mask, UsuarioModel _asistente) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
      child: TextFormField(
        controller: _txtControllerIdentificacion,
        validator: (value) {
          if (value.length <= 13) {
            return 'Campo incompleto';
          } else {
            return null;
          }
        },
        keyboardType: TextInputType.number,
        inputFormatters: [mask],
        decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.credit_card,
            color: Colors.red,
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
          labelText: 'Identificación',
        ),
        onSaved: (value) => _asistente.identificacion = value,
      ),
    );
  }

  _crearCampoTelefono1(MaskTextInputFormatter mask, UsuarioModel _asistente) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
      child: TextFormField(
        validator: (value) {
          if (value.length <= 8) {
            return 'Campo incompleto';
          } else {
            return null;
          }
        },
        keyboardType: TextInputType.number,
        inputFormatters: [mask],
        decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.phone_android,
            color: Colors.red,
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
          labelText: 'Teléfono',
        ),
        onSaved: (value) => _asistente.telefono1 = value,
      ),
    );
  }

  _crearCampoTelefono2(MaskTextInputFormatter mask, UsuarioModel _asistente) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
      child: TextFormField(
        keyboardType: TextInputType.number,
        inputFormatters: [mask],
        decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.phone_iphone,
            color: Colors.red,
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
          labelText: 'Teléfono secundario',
        ),
        onSaved: (value) => _asistente.telefono2 = value,
      ),
    );
  }

  _crearCampoColegioNumero(UsuarioModel _asistente) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
      child: TextFormField(
        decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.confirmation_number,
            color: Colors.red,
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
          labelText: 'Numero colegiado',
        ),
        onSaved: (value) => _asistente.colegioNumero = value,
      ),
    );
  }

  _crearCampoEmail(UsuarioModel _asistente) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
      child: TextFormField(
        validator: validateEmail,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.email,
            color: Colors.red,
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
          labelText: 'Email',
        ),
        onSaved: (value) => _asistente.email = value,
      ),
    );
  }

  Widget _crearCampoUsuario(UsuarioModel _asistente) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
      child: TextFormField(
        validator: validaTexto,
        readOnly: true,
        controller: _controllerUsuario,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          suffixIcon: IconButton(
              icon: Icon(Icons.replay),
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
              icon: Icon(Icons.replay),
              onPressed: () {
                final String val = generatePassword(true, true, true, false, 8);
                _txtControllerPass.text = val;
              }),
          prefixIcon: Icon(
            Icons.lock,
            color: Colors.red,
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
          labelText: 'Contraseña',
        ),
        onSaved: (value) => _asistente.password = value,
      ),
    );
  }

  _crearCampoNotas(UsuarioModel _asistente) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
      child: TextFormField(
        maxLines: 2,
        decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.confirmation_number,
            color: Colors.red,
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
          labelText: 'Notas',
        ),
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
        decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.calendar_today,
            color: Colors.red,
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
          labelText: 'Fecha de Nacimiento',
        ),
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
          _selectDate(context);
        },
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
    final UsuarioModel _user =
        usuarioModelFromJson(StorageUtil.getString('usuarioGlobal'));
    if (_user != null) {
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
                  Navigator.pop(context);
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
                  onPressed: () {
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
                            padding: EdgeInsets.all(8.0),
                            child: CircularProgressIndicator()),
                        maxProgress: 100.0,
                        progressTextStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 13.0,
                            fontWeight: FontWeight.w400),
                        messageTextStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 19.0,
                            fontWeight: FontWeight.w600),
                      );
                      _pr.show();
                      Timer(Duration(seconds: 2), () {
                        _asistente.fechaNacimiento = picked;
                        bloc.addUser(_asistente);

                        _pr.hide();
                        _formKey.currentState.reset();
                        _txtControllerIdentificacion.text = '';
                        _txtControllerNombres.text = '';
                        _txtControllerPass.text = '';
                        _txtControllerPrimerApellido.text = '';
                        _controllerUsuario.text = '';
                        _inputFieldDateController.text = '';
                      });
                    }
                  }))
        ],
      );
    } else {
      return Container();
    }
  }
}
