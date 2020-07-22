import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:getflutter/getflutter.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:progress_dialog/progress_dialog.dart';

import 'package:appsam/src/blocs/asistentes_bloc/create_edit_asistentes.dart';
import 'package:appsam/src/models/usuario_model.dart';
import 'package:appsam/src/utils/utils.dart';

class FormEditarPage extends StatefulWidget {
  @override
  _FormEditarPageState createState() => _FormEditarPageState();
}

class _FormEditarPageState extends State<FormEditarPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  // bool _autoValidate = false;

  TextEditingController _inputFieldDateController = new TextEditingController();
  TextEditingController _txtControllerIdentificacion =
      new TextEditingController();

  TextEditingController _controllerUsuario = new TextEditingController();
  TextEditingController _txtControllerNombres = new TextEditingController();
  TextEditingController _txtControllerPrimerApellido =
      new TextEditingController();
  final bloc = new CrearEditarAsistentesBloc();

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final UsuarioModel _asistente = ModalRoute.of(context).settings.arguments;

    MaskTextInputFormatter maskNumeroColegiado = new MaskTextInputFormatter(
        mask: '#######', filter: {"#": RegExp(r'[0-9]')});
    MaskTextInputFormatter maskIdentificacion = new MaskTextInputFormatter(
        mask: '#############', filter: {"#": RegExp(r'[0-9]')});
    _txtControllerIdentificacion.text = _asistente.identificacion;
    _txtControllerNombres.text = _asistente.nombres;
    _txtControllerPrimerApellido.text = _asistente.primerApellido;
    _controllerUsuario.text = _asistente.userName;

    return SingleChildScrollView(
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
                icon: FaIcon(FontAwesomeIcons.user, color: Colors.white)),
            content: Column(
              children: <Widget>[
                _espacio(),
                _crearCampoNombre(_asistente),
                _espacio(),
                _crearCampoPrimerAppellido(_asistente),
                _espacio(),
                _crearCampoSegundoAppellido(_asistente),
                _espacio(),
                _crearCampoIdentificacion(_asistente, maskIdentificacion),
                _espacio(),
                _crearFecha(context, _asistente),
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
                _crearSexo('M', 'Masculino', _asistente),
                _crearSexo('F', 'Femenino', _asistente),
                _crearCampoTelefono1(_asistente),
                _espacio(),
                _crearCampoTelefono2(_asistente),
                _espacio(),
                _crearCampoColegioNumero(_asistente, maskNumeroColegiado),
                _espacio(),
                _crearCampoEmail(_asistente),
                _crearCampoUsuario(_asistente),
                _espacio(),
                _crearCampoNotas(_asistente),
                _espacio(),
                Row(
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
                            Navigator.pushReplacementNamed(
                                context, 'asistentes');
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
                )
              ],
            ),
          )),
    );
  }

  void _guardar(UsuarioModel _asistente, CrearEditarAsistentesBloc bloc) async {
    if (!_formKey.currentState.validate()) {
      mostrarFlushBar(context, Colors.black, 'Info',
          'El formulario no puede estar vacio', 3, Icons.info, Colors.white);
    } else {
      _formKey.currentState.save();
      _asistente.identificacion = _txtControllerIdentificacion.text;
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
      final user = await bloc.updateUser(_asistente);

      if (user != null) {
        await _pr.hide();
        Navigator.pushReplacementNamed(context, 'asistente_detalle',
            arguments: user);
      } else {
        await _pr.hide();
        mostrarFlushBar(
            context,
            Colors.red,
            'Info',
            'Ha ocurrido un error o el usuario ya existe, revise el correo,identificación, usuario, colegio numero, ó email.',
            4,
            Icons.info,
            Colors.white);
      }
    }
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
        decoration: inputsDecorations('Nombres', Icons.person),
        onSaved: (value) => _asistente.nombres = value,
      ),
    );
  }

  _crearCampoPrimerAppellido(UsuarioModel _asistente) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
      child: TextFormField(
        autovalidate: true,
        controller: _txtControllerPrimerApellido,
        validator: validaTexto,
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
        initialValue: _asistente.segundoApellido,
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
        inputFormatters: [mask],
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
        initialValue: _asistente.telefono1,
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
        initialValue:
            (_asistente.telefono2 != null) ? _asistente.telefono2 : '',
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
        maxLength: 7,
        inputFormatters: [mask],
        decoration:
            inputsDecorations('Numero Colegiado', FontAwesomeIcons.hashtag),
        initialValue:
            (_asistente.colegioNumero != null) ? _asistente.colegioNumero : '',
        onSaved: (value) => _asistente.colegioNumero = value,
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

  _crearCampoEmail(UsuarioModel _asistente) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
      child: TextFormField(
        initialValue: (_asistente.email != null) ? _asistente.email : '',
        autovalidate: true,
        validator: validateEmail,
        keyboardType: TextInputType.emailAddress,
        decoration: inputsDecorations('Email', Icons.email),
        onSaved: (value) => _asistente.email = value,
      ),
    );
  }

  _crearCampoNotas(UsuarioModel _asistente) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
      child: TextFormField(
        initialValue: (_asistente.notas != null) ? _asistente.notas : '',
        maxLines: 2,
        decoration: inputsDecorations('Notas', Icons.note),
        onSaved: (value) => _asistente.notas = value,
      ),
    );
  }

  Widget _crearFecha(BuildContext context, UsuarioModel _asistente) {
    var formato = DateFormat('dd/MM/yyyy');
    final _fechaNaci = formato.format(_asistente.fechaNacimiento);
    _inputFieldDateController.text = _fechaNaci;
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0),
      child: TextFormField(
        keyboardType: TextInputType.number,
        enableInteractiveSelection: false,
        controller: _inputFieldDateController,
        decoration:
            inputsDecorations('Fecha de Nacimiento', Icons.calendar_today),
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
          _selectDate(context, _asistente);
        },
      ),
    );
  }

  _selectDate(BuildContext context, UsuarioModel _asistente) async {
    DateTime picked = await showDatePicker(
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
        final _fecha = format.format(picked);

        _asistente.fechaNacimiento = picked;

        _inputFieldDateController.text = _fecha;
      });
    }
  }

  _crearSexo(value, String title, UsuarioModel _asistente) {
    return RadioListTile(
        title: (Text(title)),
        value: value,
        groupValue: _asistente.sexo,
        onChanged: (value) {
          setState(() {
            _asistente.sexo = value;
            print(value);
          });
        });
  }
}
