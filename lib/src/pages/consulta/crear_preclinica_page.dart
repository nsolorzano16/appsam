import 'package:appsam/src/blocs/preclinica_bloc.dart';
import 'package:appsam/src/blocs/provider.dart';
import 'package:appsam/src/models/consulta_model.dart';
import 'package:appsam/src/models/preclinica_model.dart';
import 'package:appsam/src/models/usuario_model.dart';
import 'package:appsam/src/utils/storage_util.dart';
import 'package:appsam/src/utils/utils.dart';
import 'package:appsam/src/widgets/drawer.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:progress_dialog/progress_dialog.dart';

class CrearPreclinicaPage extends StatefulWidget {
  static final String routeName = 'crear_preclinica';
  @override
  _CrearPreclinicaPageState createState() => _CrearPreclinicaPageState();
}

class _CrearPreclinicaPageState extends State<CrearPreclinicaPage> {
  PreclinicaBloc bloc = new PreclinicaBloc();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final UsuarioModel _usuario =
      usuarioModelFromJson(StorageUtil.getString('usuarioGlobal'));
  final ConsultaModel _consulta = new ConsultaModel();
  final Preclinica _preclinica = new Preclinica();
  @override
  void initState() {
    super.initState();
    StorageUtil.putString('ultimaPagina', CrearPreclinicaPage.routeName);
  }

  @override
  Widget build(BuildContext context) {
    PreclinicaBloc bloc = Provider.preclinicaBloc(context);
    return Scaffold(
        drawer: MenuWidget(),
        appBar: AppBar(
          title: Text('Nueva Preclinica'),
        ),
        body: Stack(
          children: <Widget>[_crearFormulario(_usuario)],
        ));
  }

  Widget _crearFormulario(UsuarioModel usuario) {
    return SingleChildScrollView(
        child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                _espacio(),
                _crearPeso(_usuario, _preclinica),
                _espacio(),
                _crearAltura(_usuario, _preclinica),
                _espacio(),
                _crearFrecuenciaRespiratoria(_usuario, _preclinica),
                _espacio(),
                _crearRitmoCardiaco(_usuario, _preclinica),
                _espacio(),
                _crearPresionSistolica(_usuario, _preclinica),
                _espacio(),
                _crearPresionDiastolica(_usuario, _preclinica),
                _espacio(),
                _crearBotones(_preclinica, bloc, usuario)
              ],
            )));
  }

  Widget _espacio() {
    return SizedBox(
      height: 10.0,
    );
  }

  Widget _crearPeso(UsuarioModel usuario, Preclinica preclinica) {
    MaskTextInputFormatter mask = new MaskTextInputFormatter(
        mask: '###.###', filter: {"#": RegExp(r'[0-9]')});
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0),
      child: TextFormField(
        inputFormatters: [mask],
        autovalidate: true,
        validator: isNumeric,
        onSaved: (value) => _preclinica.peso = int.parse(value),
        keyboardType: TextInputType.numberWithOptions(decimal: true),
        decoration: inputsDecorations('Peso', Icons.account_circle),
      ),
    );
  }

  String isNumeric(String s) {
    if (s.isEmpty) return 'Campo obligatorio';

    final n = num.tryParse(s);

    return (n == null) ? 'Ingrese valores correctos' : null;
  }

  Widget _crearAltura(UsuarioModel usuario, Preclinica preclinica) {
    MaskTextInputFormatter mask = new MaskTextInputFormatter(
        mask: '###.###', filter: {"#": RegExp(r'[0-9]')});
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0),
      child: TextFormField(
        inputFormatters: [mask],
        autovalidate: true,
        validator: isNumeric,
        onSaved: (value) => _preclinica.altura = double.parse(value),
        keyboardType: TextInputType.numberWithOptions(decimal: true),
        decoration: inputsDecorations('Altura', Icons.account_circle),
      ),
    );
  }

  Widget _crearFrecuenciaRespiratoria(
      UsuarioModel usuario, Preclinica preclinica) {
    MaskTextInputFormatter mask = new MaskTextInputFormatter(
        mask: '####', filter: {"#": RegExp(r'[0-9]')});
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0),
      child: TextFormField(
        inputFormatters: [mask],
        autovalidate: true,
        validator: isNumeric,
        onSaved: (value) =>
            _preclinica.frecuenciaRespiratoria = int.parse(value),
        keyboardType: TextInputType.number,
        decoration:
            inputsDecorations('Frecuencia Respiratoria', Icons.account_circle),
      ),
    );
  }

  Widget _crearRitmoCardiaco(UsuarioModel usuario, Preclinica preclinica) {
    MaskTextInputFormatter mask = new MaskTextInputFormatter(
        mask: '####', filter: {"#": RegExp(r'[0-9]')});
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0),
      child: TextFormField(
        inputFormatters: [mask],
        autovalidate: true,
        validator: isNumeric,
        onSaved: (value) => _preclinica.ritmoCardiaco = int.parse(value),
        keyboardType: TextInputType.number,
        decoration: inputsDecorations('Ritmo Cardiaco', Icons.account_circle),
      ),
    );
  }

  Widget _crearPresionSistolica(UsuarioModel usuario, Preclinica preclinica) {
    MaskTextInputFormatter mask = new MaskTextInputFormatter(
        mask: '###', filter: {"#": RegExp(r'[0-9]')});
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0),
      child: TextFormField(
        inputFormatters: [mask],
        autovalidate: true,
        validator: isNumeric,
        onSaved: (value) => _preclinica.presionSistolica = int.parse(value),
        keyboardType: TextInputType.number,
        decoration:
            inputsDecorations('Presion Sistolica', Icons.account_circle),
      ),
    );
  }

  Widget _crearPresionDiastolica(UsuarioModel usuario, Preclinica preclinica) {
    MaskTextInputFormatter mask = new MaskTextInputFormatter(
        mask: '###', filter: {"#": RegExp(r'[0-9]')});
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0),
      child: TextFormField(
        inputFormatters: [mask],
        autovalidate: true,
        validator: isNumeric,
        onSaved: (value) => _preclinica.presionDiastolica = int.parse(value),
        keyboardType: TextInputType.number,
        decoration:
            inputsDecorations('Presion Diastolica', Icons.account_circle),
      ),
    );
  }

  Widget _crearBotones(
      Preclinica _preclinica, PreclinicaBloc bloc, UsuarioModel usuario) {
    if (usuario != null) {
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
                  _formKey.currentState.reset();
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
                      mostrarFlushBar(
                          context,
                          Colors.redAccent,
                          'Información',
                          'Rellene todos los campos',
                          2,
                          FlushbarPosition.BOTTOM,
                          Icons.info,
                          Colors.black);
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
                      //_pr.show();

                      // Timer(Duration(seconds: 2), () {
                      //   _asistente.fechaNacimiento = picked;
                      //   bloc.addUser(_asistente);

                      //   _pr.hide();
                      //   _formKey.currentState.reset();
                      //   _txtControllerIdentificacion.text = '';
                      //   _txtControllerNombres.text = '';
                      //   _txtControllerPass.text = '';
                      //   _txtControllerPrimerApellido.text = '';
                      //   _controllerUsuario.text = '';
                      //   _inputFieldDateController.text = '';
                      // });
                    }
                  }))
        ],
      );
    } else {
      return Container();
    }
  }
}
