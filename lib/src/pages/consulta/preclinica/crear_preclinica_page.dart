import 'dart:async';
import 'dart:math';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:getflutter/getflutter.dart';

import 'package:appsam/src/blocs/preclinica_bloc.dart';
import 'package:appsam/src/models/paginados/pacientesPaginado_model.dart';
import 'package:appsam/src/models/preclinica_model.dart';
import 'package:appsam/src/models/usuario_model.dart';
import 'package:appsam/src/utils/storage_util.dart';
import 'package:appsam/src/utils/utils.dart';

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

  final Preclinica _preclinica = new Preclinica();

  @override
  void initState() {
    super.initState();
    StorageUtil.putString('ultimaPagina', CrearPreclinicaPage.routeName);
  }

  @override
  Widget build(BuildContext context) {
    final PacientesViewModel _paciente =
        ModalRoute.of(context).settings.arguments;
    return Scaffold(
        appBar: AppBar(
          title: Text('Nueva Preclinica'),
        ),
        body: Stack(
          children: <Widget>[_crearFormulario(_usuario, _paciente)],
        ));
  }

  Widget _crearFormulario(UsuarioModel usuario, PacientesViewModel paciente) {
    return SingleChildScrollView(
        child: Column(
      children: <Widget>[
        GFCard(
          title: GFListTile(
            avatar: ClipRRect(
              borderRadius: BorderRadius.circular(100.0),
              child: FadeInImage(
                  width: 100,
                  height: 100,
                  placeholder: AssetImage('assets/jar-loading.gif'),
                  image: NetworkImage(paciente.fotoUrl)),
            ),
            title: Text(
                '${paciente.nombres} ${paciente.primerApellido} ${paciente.segundoApellido}'),
            subTitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Identificación: ${paciente.identificacion}'),
                Text('Edad: ${paciente.edad}')
              ],
            ),
          ),
        ),
        GFCard(
          elevation: 6.0,
          boxFit: BoxFit.cover,
          title: GFListTile(
              color: Colors.red,
              title: Text('Preclinica',
                  style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white)),
              icon: FaIcon(FontAwesomeIcons.user, color: Colors.white)),
          content: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  _espacio(),
                  _crearPeso(_preclinica),
                  _espacio(),
                  _crearAltura(_preclinica),
                  _espacio(),
                  _crearFrecuenciaRespiratoria(_preclinica),
                  _espacio(),
                  _crearRitmoCardiaco(_preclinica),
                  _espacio(),
                  _crearPresionSistolica(_preclinica),
                  _espacio(),
                  _crearPresionDiastolica(_preclinica),
                  _espacio(),
                  _crearNotas(_preclinica),
                  _crearBotones(_preclinica, bloc, paciente)
                ],
              )),
        ),
      ],
    ));
  }

  Widget _espacio() {
    return SizedBox(
      height: 10.0,
    );
  }

  Widget _crearPeso(Preclinica preclinica) {
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0),
      child: TextFormField(
        autovalidate: true,
        validator: isNumeric,
        onSaved: (value) => _preclinica.peso = double.parse(value),
        keyboardType: TextInputType.numberWithOptions(decimal: true),
        decoration: inputsDecorations('Peso', Icons.account_circle,
            hintTexto: 'Libras'),
      ),
    );
  }

  String isNumeric(String s) {
    if (s.isEmpty) return 'Campo obligatorio';

    final n = num.tryParse(s);

    return (n == null) ? 'Ingrese valores correctos' : null;
  }

  Widget _crearAltura(Preclinica preclinica) {
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0),
      child: TextFormField(
        autovalidate: true,
        validator: isNumeric,
        onSaved: (value) => _preclinica.altura = double.parse(value),
        keyboardType: TextInputType.numberWithOptions(decimal: true),
        decoration: inputsDecorations('Altura', Icons.account_circle,
            hintTexto: 'Centimetros'),
      ),
    );
  }

  Widget _crearFrecuenciaRespiratoria(Preclinica preclinica) {
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0),
      child: TextFormField(
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

  Widget _crearRitmoCardiaco(Preclinica preclinica) {
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0),
      child: TextFormField(
        autovalidate: true,
        validator: isNumeric,
        onSaved: (value) => _preclinica.ritmoCardiaco = int.parse(value),
        keyboardType: TextInputType.number,
        decoration: inputsDecorations('Ritmo Cardiaco', Icons.account_circle),
      ),
    );
  }

  Widget _crearPresionSistolica(Preclinica preclinica) {
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0),
      child: TextFormField(
        autovalidate: true,
        validator: isNumeric,
        onSaved: (value) => _preclinica.presionSistolica = int.parse(value),
        keyboardType: TextInputType.number,
        decoration:
            inputsDecorations('Presion Sistolica', Icons.account_circle),
      ),
    );
  }

  Widget _crearPresionDiastolica(Preclinica preclinica) {
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0),
      child: TextFormField(
        autovalidate: true,
        validator: isNumeric,
        onSaved: (value) => _preclinica.presionDiastolica = int.parse(value),
        keyboardType: TextInputType.number,
        decoration:
            inputsDecorations('Presion Diastolica', Icons.account_circle),
      ),
    );
  }

  Widget _crearNotas(Preclinica preclinica) {
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0),
      child: TextFormField(
        maxLines: 2,
        onSaved: (value) => _preclinica.notas = value,
        keyboardType: TextInputType.text,
        decoration: inputsDecorations('Notas', Icons.note),
      ),
    );
  }

  Widget _crearBotones(Preclinica _preclinica, PreclinicaBloc bloc,
      PacientesViewModel paciente) {
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

                    _guardaConsulta(paciente);
                    _formKey.currentState.reset();
                  }
                }))
      ],
    );
  }

  void _guardaConsulta(PacientesViewModel paciente) async {
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
    _preclinica.preclinicaId = 0;
    _preclinica.pacienteId = paciente.pacienteId;
    _preclinica.doctorId = paciente.doctorId;
    _preclinica.atendida = false;
    _preclinica.activo = true;
    _preclinica.creadoPor = _usuario.userName;
    _preclinica.creadoFecha = DateTime.now();
    _preclinica.modificadoPor = _usuario.userName;
    _preclinica.modificadoFecha = DateTime.now();
    double pesoKg = _preclinica.peso / 2.2;
    double alturaMts = _preclinica.altura / 100;

    _preclinica.altura = _preclinica.altura / 100;
    _preclinica.iMc = pesoKg / pow(alturaMts, 2);

    final bool resp = await bloc.addPreclinica(_preclinica);

    _pr.hide();
    if (resp) {
      mostrarFlushBar(
          context,
          Colors.green,
          'Info',
          'Preclinica creada correctamente',
          3,
          FlushbarPosition.TOP,
          Icons.info,
          Colors.black);
      Timer(Duration(seconds: 3), () {
        Navigator.pushReplacementNamed(context, 'home');
      });
    } else {
      mostrarFlushBar(context, Colors.red, 'Info', 'Ha ocurrido un error', 3,
          FlushbarPosition.BOTTOM, Icons.info, Colors.black);
    }
  }
}
