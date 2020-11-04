import 'package:appsam/src/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:getflutter/getflutter.dart';
import 'package:intl/intl.dart';
import 'package:progress_dialog/progress_dialog.dart';

import 'package:appsam/src/blocs/asistentes_bloc/create_edit_asistentes.dart';
import 'package:appsam/src/utils/utils.dart';

class FormEditarPage extends StatefulWidget {
  @override
  _FormEditarPageState createState() => _FormEditarPageState();
}

class _FormEditarPageState extends State<FormEditarPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  // bool _autoValidate = false;

  TextEditingController _inputFieldDateController = new TextEditingController();

  final bloc = new CrearEditarAsistentesBloc();

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final UserModel _asistente = ModalRoute.of(context).settings.arguments;

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
                _crearCampoIdentificacion(_asistente),
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
                _crearCampoColegioNumero(_asistente),
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

  void _guardar(UserModel _asistente, CrearEditarAsistentesBloc bloc) async {
    if (!_formKey.currentState.validate()) {
      mostrarFlushBar(context, Colors.black, 'Info',
          'El formulario no puede estar vacio', 3, Icons.info, Colors.white);
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

  _crearCampoNombre(UserModel _asistente) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
      child: TextFormField(
        initialValue: _asistente.nombres,
        autovalidate: true,
        validator: validaTexto,
        decoration: inputsDecorations('Nombres', Icons.person),
        onSaved: (value) => _asistente.nombres = value,
      ),
    );
  }

  _crearCampoPrimerAppellido(UserModel _asistente) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
      child: TextFormField(
        initialValue: _asistente.primerApellido,
        autovalidate: true,
        validator: validaTexto,
        decoration: inputsDecorations('Primer Apellido', Icons.person),
        onSaved: (value) => _asistente.primerApellido = value,
      ),
    );
  }

  _crearCampoSegundoAppellido(UserModel _asistente) {
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

  _crearCampoIdentificacion(UserModel _asistente) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
      child: TextFormField(
        initialValue: _asistente.identificacion,
        inputFormatters: [
          LengthLimitingTextInputFormatter(13),
          FilteringTextInputFormatter.digitsOnly,
        ],
        autovalidateMode: AutovalidateMode.always,
        maxLength: 13,
        validator: (value) {
          if (value.length < 13) {
            return 'Campo obligatorio';
          } else {
            return null;
          }
        },
        keyboardType: TextInputType.number,
        decoration: inputsDecorations('Identificación sa', Icons.credit_card),
        onSaved: (value) => _asistente.identificacion = value,
      ),
    );
  }

  _crearCampoTelefono1(UserModel _asistente) {
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
        initialValue: _asistente.phoneNumber,
        keyboardType: TextInputType.number,
        inputFormatters: [
          LengthLimitingTextInputFormatter(8),
          WhitelistingTextInputFormatter.digitsOnly
        ],
        maxLength: 8,
        decoration: inputsDecorations('Teléfono', Icons.phone_android),
        onSaved: (value) => _asistente.phoneNumber = value,
      ),
    );
  }

  _crearCampoTelefono2(UserModel _asistente) {
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

  _crearCampoColegioNumero(UserModel _asistente) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
      child: TextFormField(
        inputFormatters: [
          LengthLimitingTextInputFormatter(13),
          WhitelistingTextInputFormatter.digitsOnly
        ],
        autovalidate: true,
        validator: validaTexto,
        maxLength: 7,
        decoration:
            inputsDecorations('Numero Colegiado', FontAwesomeIcons.hashtag),
        initialValue:
            (_asistente.colegioNumero != null) ? _asistente.colegioNumero : '',
        onSaved: (value) => _asistente.colegioNumero = value,
      ),
    );
  }

  Widget _crearCampoUsuario(UserModel _asistente) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
      child: TextFormField(
        autovalidate: true,
        validator: validaTexto,
        initialValue: _asistente.userName,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
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

  _crearCampoEmail(UserModel _asistente) {
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

  _crearCampoNotas(UserModel _asistente) {
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

  Widget _crearFecha(BuildContext context, UserModel _asistente) {
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

  _selectDate(BuildContext context, UserModel _asistente) async {
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

  _crearSexo(value, String title, UserModel _asistente) {
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
