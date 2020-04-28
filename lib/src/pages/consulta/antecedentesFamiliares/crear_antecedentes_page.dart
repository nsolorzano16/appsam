import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:getflutter/getflutter.dart';
import 'package:progress_dialog/progress_dialog.dart';

import 'package:appsam/src/blocs/antecedentes_bloc.dart';
import 'package:appsam/src/models/antecedentesFamiliaresPersonales_model.dart';
import 'package:appsam/src/models/paginados/preclinica_paginadoVM.dart';
import 'package:appsam/src/models/usuario_model.dart';
import 'package:appsam/src/utils/storage_util.dart';
import 'package:appsam/src/utils/utils.dart';
import 'package:appsam/src/widgets/drawer.dart';

class CrearAntecedentesPage extends StatefulWidget {
  static final String routeName = 'crear_antecedentes';
  @override
  _CrearAntecedentesPageState createState() => _CrearAntecedentesPageState();
}

class _CrearAntecedentesPageState extends State<CrearAntecedentesPage> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final AntecedentesFamiliaresPersonales _antecedentes =
      new AntecedentesFamiliaresPersonales();

  final _antecedentesBloc = new AntecedentesFamiliaresBloc();
  final UsuarioModel _usuario =
      usuarioModelFromJson(StorageUtil.getString('usuarioGlobal'));

  final _antPatologicosFamiCtrl = new TextEditingController();
  final _antPatologicosPersCtrl = new TextEditingController();
  final _antNoPatologicosFamiCtrl = new TextEditingController();
  final _antNoPatologicosPersCtrl = new TextEditingController();
  final _antInmunoAlergicosCtrl = new TextEditingController();

  Future<AntecedentesFamiliaresPersonales> _antecedentesFuture;
  String labelBoton = 'Guardar';

  @override
  void initState() {
    super.initState();
    StorageUtil.putString('ultimaPagina', CrearAntecedentesPage.routeName);
  }

  @override
  void dispose() {
    super.dispose();
    _antPatologicosFamiCtrl.dispose();
    _antPatologicosPersCtrl.dispose();
    _antNoPatologicosFamiCtrl.dispose();
    _antNoPatologicosPersCtrl.dispose();
    _antInmunoAlergicosCtrl.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final PreclinicaViewModel _preclinica =
        ModalRoute.of(context).settings.arguments;

    _antecedentesFuture = _antecedentesBloc.getAntecedente(
        _preclinica.pacienteId, _preclinica.doctorId);

    return WillPopScope(
        child: Scaffold(
          appBar: AppBar(
            title: Text('Consulta'),
            actions: <Widget>[
              IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                  ),
                  onPressed: () => Navigator.pushReplacementNamed(
                      context, 'menu_consulta',
                      arguments: _preclinica))
            ],
          ),
          drawer: MenuWidget(),
          body: FutureBuilder(
            future: _antecedentesFuture,
            builder: (BuildContext context,
                AsyncSnapshot<AntecedentesFamiliaresPersonales> snapshot) {
              final x = snapshot.data;
              if (snapshot.connectionState == ConnectionState.done) {
                if (x != null) {
                  _antecedentes.pacienteId = x.pacienteId;
                  _antecedentes.doctorId = x.doctorId;
                  _antecedentes.preclinicaId = x.preclinicaId;
                  _antecedentes.antecedentesFamiliaresPersonalesId =
                      x.antecedentesFamiliaresPersonalesId;
                  _antecedentes.activo = x.activo;
                  _antecedentes.creadoPor = x.creadoPor;
                  _antecedentes.creadoFecha = x.creadoFecha;
                  _antecedentes.modificadoPor = _usuario.userName;
                  _antecedentes.modificadoFecha = DateTime.now();
                  _antPatologicosFamiCtrl.text =
                      x.antecedentesPatologicosFamiliares;
                  _antPatologicosPersCtrl.text =
                      x.antecedentesPatologicosPersonales;
                  _antNoPatologicosFamiCtrl.text =
                      x.antecedentesNoPatologicosFamiliares;
                  _antNoPatologicosPersCtrl.text =
                      x.antecedentesNoPatologicosPersonales;
                  _antInmunoAlergicosCtrl.text =
                      x.antecedentesInmunoAlergicosPersonales;
                  return _antecedentesForm(context);
                } else {
                  _antecedentes.pacienteId = _preclinica.pacienteId;
                  _antecedentes.doctorId = _preclinica.doctorId;
                  _antecedentes.preclinicaId = _preclinica.preclinicaId;
                  _antecedentes.antecedentesFamiliaresPersonalesId = 0;
                  _antecedentes.activo = true;
                  _antecedentes.creadoPor = _usuario.userName;
                  _antecedentes.creadoFecha = DateTime.now();
                  _antecedentes.modificadoPor = _usuario.userName;
                  _antecedentes.modificadoFecha = DateTime.now();
                  return _antecedentesForm(context);
                }
              } else {
                return loadingIndicator(context);
              }
            },
          ),
        ),
        onWillPop: () async => false);
  }

  SingleChildScrollView _antecedentesForm(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          GFCard(
            elevation: 6.0,
            title: GFListTile(
              title: Row(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Text(
                    'Antecedentes Personales',
                    style: TextStyle(fontSize: 16.0),
                  ),
                ],
              ),
            ),
            content: Form(
                key: _formkey,
                child: Column(
                  children: <Widget>[
                    _campoAntecedentesPatologicosFamiliares(),
                    _campoAntecedentesPatologicosPersonales(),
                    _campoAntecedentesNoPatologicosFamiliares(),
                    _campoAntecedentesNoPatologicosPersonales(),
                    _campoAntecedentesInmunoAlergicosPersonales(),
                    _crearBotones(context),
                  ],
                )),
          )
        ],
      ),
    );
  }

  Widget _campoAntecedentesPatologicosFamiliares() {
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0),
      child: TextFormField(
        controller: _antPatologicosFamiCtrl,
        onSaved: (value) =>
            _antecedentes.antecedentesPatologicosFamiliares = value,
        maxLines: 3,
        keyboardType: TextInputType.text,
        decoration: inputsDecorations(
            'Antecedentes Patologicos Familiares', Icons.note),
      ),
    );
  }

  Widget _campoAntecedentesPatologicosPersonales() {
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0),
      child: TextFormField(
        controller: _antPatologicosPersCtrl,
        onSaved: (value) =>
            _antecedentes.antecedentesPatologicosPersonales = value,
        maxLines: 3,
        keyboardType: TextInputType.text,
        decoration: inputsDecorations(
            'Antecedentes Patologicos Personales', Icons.note),
      ),
    );
  }

  _campoAntecedentesNoPatologicosFamiliares() {
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0),
      child: TextFormField(
        controller: _antNoPatologicosFamiCtrl,
        onSaved: (value) =>
            _antecedentes.antecedentesNoPatologicosFamiliares = value,
        maxLines: 3,
        keyboardType: TextInputType.text,
        decoration: inputsDecorations(
            'Antecedentes No Patologicos Familiares', Icons.note),
      ),
    );
  }

  _campoAntecedentesNoPatologicosPersonales() {
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0),
      child: TextFormField(
        controller: _antNoPatologicosPersCtrl,
        onSaved: (value) =>
            _antecedentes.antecedentesNoPatologicosPersonales = value,
        maxLines: 3,
        keyboardType: TextInputType.text,
        decoration: inputsDecorations(
            'Antecedentes No Patologicos Personales', Icons.note),
      ),
    );
  }

  _campoAntecedentesInmunoAlergicosPersonales() {
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0),
      child: TextFormField(
        controller: _antInmunoAlergicosCtrl,
        onSaved: (value) =>
            _antecedentes.antecedentesInmunoAlergicosPersonales = value,
        maxLines: 3,
        keyboardType: TextInputType.text,
        decoration:
            inputsDecorations('Antecedentes Inmuno Alergicos', Icons.note),
      ),
    );
  }

  Widget _crearBotones(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        RaisedButton.icon(
            color: Theme.of(context).primaryColor,
            onPressed: () => _guardar(context),
            textColor: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            icon: Icon(
              Icons.save,
              color: Colors.white,
            ),
            label: Text(labelBoton))
      ],
    );
  }

  void _guardar(BuildContext context) async {
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
    if (_antPatologicosFamiCtrl.text.isEmpty &&
        _antPatologicosPersCtrl.text.isEmpty &&
        _antNoPatologicosFamiCtrl.text.isEmpty &&
        _antNoPatologicosPersCtrl.text.isEmpty &&
        _antInmunoAlergicosCtrl.text.isEmpty) {
      mostrarFlushBar(
          context,
          Colors.black,
          'Info',
          'El formulario no puede estar vacio',
          3,
          FlushbarPosition.BOTTOM,
          Icons.info,
          Colors.white);
    } else {
      _formkey.currentState.save();
      await _pr.show();

      AntecedentesFamiliaresPersonales _antecedentesGuardado;
      if (_antecedentes.antecedentesFamiliaresPersonalesId == 0) {
        //guarda
        _antecedentesGuardado =
            await _antecedentesBloc.addAntecedentes(_antecedentes);
      } else {
        // edita
        _antecedentesGuardado =
            await _antecedentesBloc.updateAntecedentes(_antecedentes);
      }

      if (_antecedentesGuardado != null) {
        _pr.hide();
        mostrarFlushBar(context, Colors.green, 'Info', 'Datos Guardados', 2,
            FlushbarPosition.TOP, Icons.info, Colors.black);
        _antecedentes.antecedentesFamiliaresPersonalesId =
            _antecedentesGuardado.antecedentesFamiliaresPersonalesId;
        _antecedentes.creadoFecha = _antecedentesGuardado.creadoFecha;
        _antecedentes.creadoPor = _antecedentesGuardado.creadoPor;
        _antecedentes.modificadoPor = _antecedentesGuardado.modificadoPor;
        _antecedentesGuardado.modificadoFecha =
            _antecedentesGuardado.modificadoFecha;
        setState(() {
          labelBoton = 'Editar';
        });
      } else {
        mostrarFlushBar(context, Colors.red, 'Info', 'Ha ocurrido un error', 2,
            FlushbarPosition.TOP, Icons.info, Colors.white);
      }
    }
  }
}
