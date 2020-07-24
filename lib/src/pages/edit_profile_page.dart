import 'package:appsam/src/utils/storage_util.dart';
import 'package:appsam/src/widgets/drawer.dart';
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

class EditarMiPerfilPage extends StatefulWidget {
  static final String routeName = 'editar_mi_perfil_page';

  final UsuarioModel usuario;

  const EditarMiPerfilPage({@required this.usuario});

  @override
  _EditarMiPerfilPageState createState() => _EditarMiPerfilPageState();
}

class _EditarMiPerfilPageState extends State<EditarMiPerfilPage> {
  UsuarioModel get usuario => widget.usuario;
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
    MaskTextInputFormatter maskNumeroColegiado = new MaskTextInputFormatter(
        mask: '#######', filter: {"#": RegExp(r'[0-9]')});

    _txtControllerIdentificacion.text = usuario.identificacion;
    _txtControllerNombres.text = usuario.nombres;
    _txtControllerPrimerApellido.text = usuario.primerApellido;
    _controllerUsuario.text = usuario.userName;

    return WillPopScope(
        child: Scaffold(
          backgroundColor: colorFondoApp(),
          appBar: AppBar(
            title: Text('Editar mi información'),
            actions: <Widget>[
              IconButton(
                  icon: Icon(Icons.arrow_back_ios),
                  onPressed: () =>
                      Navigator.pushReplacementNamed(context, 'my-profile'))
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
                      icon: FaIcon(FontAwesomeIcons.user, color: Colors.white)),
                  content: Column(
                    children: <Widget>[
                      _espacio(),
                      _crearCampoNombre(),
                      _espacio(),
                      _crearCampoPrimerAppellido(),
                      _espacio(),
                      _crearCampoSegundoAppellido(),
                      _espacio(),
                      _crearFecha(context),
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
                      _crearCampoTelefono1(),
                      _espacio(),
                      _crearCampoTelefono2(),
                      _espacio(),
                      _crearCampoColegioNumero(maskNumeroColegiado),
                      _espacio(),
                      _crearCampoEmail(),
                      _espacio(),
                      _crearCampoNotas(),
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
                                      context, 'my-profile');
                                },
                                icon: Icon(Icons.clear),
                                label: Text('Cancelar')),
                          ),
                          Padding(
                              padding:
                                  EdgeInsets.only(right: 25.0, bottom: 10.0),
                              child: RaisedButton.icon(
                                  elevation: 5.0,
                                  textColor: Colors.white,
                                  color: Theme.of(context).primaryColor,
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(20.0)),
                                  icon: Icon(Icons.save),
                                  label: Text('Guardar'),
                                  onPressed: () => _guardar(bloc)))
                        ],
                      )
                    ],
                  ),
                )),
          ),
        ),
        onWillPop: () async => false);
  }

  void _guardar(CrearEditarAsistentesBloc bloc) async {
    if (!_formKey.currentState.validate()) {
      mostrarFlushBar(context, Colors.black, 'Info',
          'El formulario no puede estar vacio', 3, Icons.info, Colors.white);
    } else {
      _formKey.currentState.save();
      usuario.identificacion = _txtControllerIdentificacion.text;
      final ProgressDialog _pr = new ProgressDialog(
        context,
        type: ProgressDialogType.Normal,
        isDismissible: false,
        showLogs: false,
      );
      _pr.update(
        progress: 50.0,
        message: "Sera redirigido a la pagina de inicio de sesion.",
        progressWidget: Container(
            padding: EdgeInsets.all(8.0), child: CircularProgressIndicator()),
        maxProgress: 100.0,
        progressTextStyle: TextStyle(
            color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
        messageTextStyle: TextStyle(
            color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600),
      );
      await _pr.show();
      final user = await bloc.updateUser(usuario);

      if (user != null) {
        await _pr.hide();
        StorageUtil.removeUsuario();

        //WebNotificicationsStream.instance.dispose();
        Navigator.pushReplacementNamed(context, 'login');
      } else {
        await _pr.hide();
        mostrarFlushBar(
            context,
            Colors.red,
            'Info',
            'Ha ocurrido un error, revise el correo, colegio numero, ó email.',
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

  _crearCampoNombre() {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
      child: TextFormField(
        autovalidate: true,
        controller: _txtControllerNombres,
        validator: validaTexto,
        decoration: inputsDecorations('Nombres', Icons.person),
        onSaved: (value) => usuario.nombres = value,
      ),
    );
  }

  _crearCampoPrimerAppellido() {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
      child: TextFormField(
        autovalidate: true,
        controller: _txtControllerPrimerApellido,
        validator: validaTexto,
        decoration: inputsDecorations('Primer Apellido', Icons.person),
        onSaved: (value) => usuario.primerApellido = value,
      ),
    );
  }

  _crearCampoSegundoAppellido() {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
      child: TextFormField(
        autovalidate: true,
        validator: validaTexto,
        initialValue: usuario.segundoApellido,
        decoration: inputsDecorations('Segundo Apellido', Icons.person),
        onSaved: (value) => usuario.segundoApellido = value,
      ),
    );
  }

  Widget _espacio() {
    return SizedBox(
      height: 10.0,
    );
  }

  _crearCampoTelefono1() {
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
        initialValue: usuario.telefono1,
        keyboardType: TextInputType.number,
        inputFormatters: [
          LengthLimitingTextInputFormatter(8),
          WhitelistingTextInputFormatter.digitsOnly
        ],
        maxLength: 8,
        decoration: inputsDecorations('Teléfono', Icons.phone_android),
        onSaved: (value) => usuario.telefono1 = value,
      ),
    );
  }

  _crearCampoTelefono2() {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
      child: TextFormField(
        keyboardType: TextInputType.number,
        inputFormatters: [
          LengthLimitingTextInputFormatter(8),
          WhitelistingTextInputFormatter.digitsOnly
        ],
        maxLength: 8,
        initialValue: (usuario.telefono2 != null) ? usuario.telefono2 : '',
        decoration:
            inputsDecorations('Teléfono Secundario', Icons.phone_iphone),
        onSaved: (value) => usuario.telefono2 = value,
      ),
    );
  }

  _crearCampoColegioNumero(MaskTextInputFormatter mask) {
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
            (usuario.colegioNumero != null) ? usuario.colegioNumero : '',
        onSaved: (value) => usuario.colegioNumero = value,
      ),
    );
  }

  _crearCampoEmail() {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
      child: TextFormField(
        initialValue: (usuario.email != null) ? usuario.email : '',
        autovalidate: true,
        validator: validateEmail,
        keyboardType: TextInputType.emailAddress,
        decoration: inputsDecorations('Email', Icons.email),
        onSaved: (value) => usuario.email = value,
      ),
    );
  }

  _crearCampoNotas() {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
      child: TextFormField(
        initialValue: (usuario.notas != null) ? usuario.notas : '',
        maxLines: 2,
        decoration: inputsDecorations('Notas', Icons.note),
        onSaved: (value) => usuario.notas = value,
      ),
    );
  }

  Widget _crearFecha(BuildContext context) {
    var formato = DateFormat('dd/MM/yyyy');
    final _fechaNaci = formato.format(usuario.fechaNacimiento);
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
          _selectDate(context);
        },
      ),
    );
  }

  _selectDate(BuildContext context) async {
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

        usuario.fechaNacimiento = picked;

        _inputFieldDateController.text = _fecha;
      });
    }
  }

  _crearSexo(value, String title) {
    return RadioListTile(
        title: (Text(title)),
        value: value,
        groupValue: usuario.sexo,
        onChanged: (value) {
          setState(() {
            usuario.sexo = value;
            print(value);
          });
        });
  }
}
