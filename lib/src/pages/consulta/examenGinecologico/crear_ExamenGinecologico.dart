import 'package:appsam/src/blocs/examenGinecologico_bloc.dart';
import 'package:appsam/src/models/examenFisicoGinecologico_model.dart';
import 'package:appsam/src/models/paginados/preclinica_paginadoVM.dart';
import 'package:appsam/src/models/usuario_model.dart';
import 'package:appsam/src/utils/storage_util.dart';
import 'package:appsam/src/utils/utils.dart';
import 'package:appsam/src/widgets/drawer.dart';

import 'package:flutter/material.dart';
import 'package:getflutter/getflutter.dart';
import 'package:progress_dialog/progress_dialog.dart';

class CrearExamenGinecologicoPage extends StatefulWidget {
  static final String routeName = 'crear_examen_ginecologico';
  @override
  _CrearExamenGinecologicoPageState createState() =>
      _CrearExamenGinecologicoPageState();
}

class _CrearExamenGinecologicoPageState
    extends State<CrearExamenGinecologicoPage> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final ExamenFisicoGinecologico _examenGinecologico =
      new ExamenFisicoGinecologico();

  final _examenGinecologicoBloc = new ExamenGinecologicoBloc();
  final UsuarioModel _usuario =
      usuarioModelFromJson(StorageUtil.getString('usuarioGlobal'));

  final TextEditingController _afuController = new TextEditingController();
  final TextEditingController _pelvisController = new TextEditingController();
  final TextEditingController _dorsoController = new TextEditingController();
  final TextEditingController _fcfController = new TextEditingController();
  final TextEditingController _apController = new TextEditingController();
  final TextEditingController _notasController = new TextEditingController();

  Future<ExamenFisicoGinecologico> _examenGinecologicoFuture;
  String labelBoton = 'Guardar';

  @override
  void initState() {
    super.initState();
    StorageUtil.putString(
        'ultimaPagina', CrearExamenGinecologicoPage.routeName);
  }

  @override
  void dispose() {
    super.dispose();
    _afuController.dispose();
    _pelvisController.dispose();
    _dorsoController.dispose();
    _fcfController.dispose();
    _apController.dispose();
    _notasController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final PreclinicaViewModel _preclinica =
        ModalRoute.of(context).settings.arguments;

    _examenGinecologicoFuture =
        _examenGinecologicoBloc.getExamenFisicoGinecologico(
            _preclinica.pacienteId,
            _preclinica.doctorId,
            _preclinica.preclinicaId);

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
            future: _examenGinecologicoFuture,
            builder: (BuildContext context,
                AsyncSnapshot<ExamenFisicoGinecologico> snapshot) {
              final x = snapshot.data;
              if (snapshot.connectionState == ConnectionState.done) {
                if (x != null) {
                  _examenGinecologico.examenId = x.examenId;
                  _examenGinecologico.pacienteId = x.pacienteId;
                  _examenGinecologico.doctorId = x.doctorId;
                  _examenGinecologico.preclinicaId = x.preclinicaId;
                  _examenGinecologico.activo = x.activo;
                  _examenGinecologico.creadoPor = x.creadoPor;
                  _examenGinecologico.creadoFecha = x.creadoFecha;
                  _examenGinecologico.modificadoPor = _usuario.userName;
                  _examenGinecologico.modificadoFecha = DateTime.now();

                  _afuController.text = x.afu;
                  _pelvisController.text = x.pelvis;
                  _dorsoController.text = x.dorso;
                  _fcfController.text = x.fcf;
                  _apController.text = x.ap;
                  _notasController.text = x.notas;

                  return _formExamenGinecologico(context);
                } else {
                  _examenGinecologico.examenId = 0;
                  _examenGinecologico.pacienteId = _preclinica.pacienteId;
                  _examenGinecologico.doctorId = _preclinica.doctorId;
                  _examenGinecologico.preclinicaId = _preclinica.preclinicaId;
                  _examenGinecologico.activo = true;
                  _examenGinecologico.creadoPor = _usuario.userName;
                  _examenGinecologico.creadoFecha = new DateTime.now();
                  _examenGinecologico.modificadoPor = _usuario.userName;
                  _examenGinecologico.modificadoFecha = new DateTime.now();

                  return _formExamenGinecologico(context);
                }
              } else {
                return loadingIndicator(context);
              }
            },
          ),
        ),
        onWillPop: () async => false);
  }

  SingleChildScrollView _formExamenGinecologico(BuildContext context) {
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
                    'Examen Ginecológico',
                    style: TextStyle(fontSize: 16.0),
                  ),
                ],
              ),
            ),
            content: Form(
                key: _formkey,
                child: Column(
                  children: <Widget>[
                    _campoAfu(),
                    _campoPelvis(),
                    _campoDorso(),
                    _campoFcf(),
                    _campoAp(),
                    _campoNotas(),
                    _crearBotones(context)
                  ],
                )),
          )
        ],
      ),
    );
  }

  Widget _campoAfu() {
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0),
      child: TextFormField(
        controller: _afuController,
        onSaved: (value) => _examenGinecologico.afu = value,
        keyboardType: TextInputType.text,
        decoration: inputsDecorations('Afu', Icons.note),
      ),
    );
  }

  Widget _campoPelvis() {
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0),
      child: TextFormField(
        controller: _pelvisController,
        onSaved: (value) => _examenGinecologico.pelvis = value,
        keyboardType: TextInputType.text,
        decoration: inputsDecorations('Pelvis', Icons.note),
      ),
    );
  }

  Widget _campoDorso() {
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0),
      child: TextFormField(
        controller: _dorsoController,
        onSaved: (value) => _examenGinecologico.dorso = value,
        keyboardType: TextInputType.text,
        decoration: inputsDecorations('Dorso', Icons.note),
      ),
    );
  }

  Widget _campoFcf() {
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0),
      child: TextFormField(
        controller: _fcfController,
        onSaved: (value) => _examenGinecologico.fcf = value,
        keyboardType: TextInputType.text,
        decoration: inputsDecorations('Fcf', Icons.note),
      ),
    );
  }

  Widget _campoAp() {
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0),
      child: TextFormField(
        controller: _apController,
        onSaved: (value) => _examenGinecologico.ap = value,
        keyboardType: TextInputType.text,
        decoration: inputsDecorations('Ap', Icons.note),
      ),
    );
  }

  Widget _campoNotas() {
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0),
      child: TextFormField(
        controller: _notasController,
        maxLines: 2,
        onSaved: (value) => _examenGinecologico.notas = value,
        keyboardType: TextInputType.text,
        decoration: inputsDecorations('Notas Adicionales', Icons.note),
      ),
    );
  }

  Widget _crearBotones(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        RaisedButton.icon(
            color: Theme.of(context).primaryColor,
            onPressed: (_examenGinecologico.examenId == 0)
                ? null
                : () => _confirmDesactivar(context),
            textColor: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            icon: Icon(
              Icons.delete,
              color: Colors.white,
            ),
            label: Container(
              width: 60.0,
              child: Text(
                'Eliminar',
                textAlign: TextAlign.center,
              ),
            )),
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
            label: Container(
              width: 60.0,
              child: Text(
                labelBoton,
                textAlign: TextAlign.center,
              ),
            ))
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
    if (_afuController.text.isEmpty &&
        _pelvisController.text.isEmpty &&
        _dorsoController.text.isEmpty &&
        _fcfController.text.isEmpty &&
        _apController.text.isEmpty &&
        _notasController.text.isEmpty) {
      mostrarFlushBar(context, Colors.black, 'Info',
          'El formulario no puede estar vacio', 3, Icons.info, Colors.white);
    } else {
      _formkey.currentState.save();
      await _pr.show();

      ExamenFisicoGinecologico _examenGinecologicoGuardado;
      if (_examenGinecologico.examenId == 0) {
        //guarda
        _examenGinecologicoGuardado = await _examenGinecologicoBloc
            .addExamenGinecologico(_examenGinecologico);
      } else {
        // edita
        _examenGinecologicoGuardado = await _examenGinecologicoBloc
            .updateExamenGinecologico(_examenGinecologico);
      }

      await _pr.hide();
      if (_examenGinecologicoGuardado != null) {
        mostrarFlushBar(context, Colors.green, 'Info', 'Datos Guardados', 2,
            Icons.info, Colors.black);
        _examenGinecologico.examenId = _examenGinecologicoGuardado.examenId;
        _examenGinecologico.creadoFecha =
            _examenGinecologicoGuardado.creadoFecha;
        _examenGinecologico.creadoPor = _examenGinecologicoGuardado.creadoPor;
        _examenGinecologico.modificadoPor =
            _examenGinecologicoGuardado.modificadoPor;
        _examenGinecologicoGuardado.modificadoFecha =
            _examenGinecologicoGuardado.modificadoFecha;
        setState(() {
          labelBoton = 'Editar';
        });
      } else {
        mostrarFlushBar(context, Colors.red, 'Info', 'Ha ocurrido un error', 2,
            Icons.info, Colors.white);
      }
    }
  }

  void _confirmDesactivar(BuildContext context) {
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Información"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text('Desea completar esta acción?'),
        ],
      ),
      elevation: 24.0,
      actions: [
        FlatButton(
            onPressed: () => Navigator.pop(context), child: Text('Cancelar')),
        FlatButton(
            onPressed: () {
              Navigator.pop(context);
              _desactivar(context);
            },
            child: Text('Aceptar'))
      ],
    );

    // show the dialog
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
        barrierDismissible: false);
  }

  void _desactivar(BuildContext context) async {
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

    _formkey.currentState.save();
    await _pr.show();
    ExamenFisicoGinecologico _examenGuardado;
    _examenGinecologico.activo = false;
    _examenGinecologico.modificadoPor = _usuario.userName;
    _examenGuardado = await _examenGinecologicoBloc
        .updateExamenGinecologico(_examenGinecologico);

    if (_examenGuardado != null) {
      await _pr.hide();
      mostrarFlushBar(context, Colors.green, 'Info', 'Datos Guardados', 2,
          Icons.info, Colors.black);

      _afuController.text = '';
      _pelvisController.text = '';
      _dorsoController.text = '';
      _fcfController.text = '';
      _apController.text = '';
      _notasController.text = '';

      _examenGinecologico.examenId = 0;
      _examenGinecologico.activo = true;
      _examenGinecologico.creadoFecha = DateTime.now();
      _examenGinecologico.creadoPor = _usuario.userName;
      _examenGinecologico.modificadoPor = _usuario.userName;
      _examenGuardado.modificadoFecha = DateTime.now();

      setState(() {
        labelBoton = 'Guardar';
      });
    } else {
      mostrarFlushBar(context, Colors.red, 'Info', 'Ha ocurrido un error', 2,
          Icons.info, Colors.white);
    }
  }
}
