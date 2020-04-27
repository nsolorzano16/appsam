import 'package:appsam/src/blocs/examenGinecologico_bloc.dart';
import 'package:appsam/src/models/examenFisicoGinecologico_model.dart';
import 'package:appsam/src/models/paginados/preclinica_paginadoVM.dart';
import 'package:appsam/src/models/usuario_model.dart';
import 'package:appsam/src/utils/storage_util.dart';
import 'package:appsam/src/utils/utils.dart';
import 'package:appsam/src/widgets/drawer.dart';
import 'package:flushbar/flushbar.dart';
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
  bool quieroEditar = true;
  String labelBoton = 'Guardar';

  final TextEditingController _afuController = new TextEditingController();
  final TextEditingController _pelvisController = new TextEditingController();
  final TextEditingController _dorsoController = new TextEditingController();
  final TextEditingController _fcfController = new TextEditingController();
  final TextEditingController _apController = new TextEditingController();
  final TextEditingController _notasController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    StorageUtil.putString(
        'ultimaPagina', CrearExamenGinecologicoPage.routeName);
    _examenGinecologico.examenId = 0;
    _examenGinecologico.activo = true;
    _examenGinecologico.creadoPor = _usuario.userName;
    _examenGinecologico.creadoFecha = DateTime.now();
    _examenGinecologico.modificadoPor = _usuario.userName;
    _examenGinecologico.modificadoFecha = DateTime.now();
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
    _examenGinecologico.pacienteId = _preclinica.pacienteId;
    _examenGinecologico.doctorId = _preclinica.doctorId;
    _examenGinecologico.preclinicaId = _preclinica.preclinicaId;

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
          body: SingleChildScrollView(
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
                        IconButton(
                            icon: Icon(Icons.edit,
                                color: Theme.of(context).primaryColor),
                            onPressed: () {
                              if (!quieroEditar) {
                                setState(() {
                                  quieroEditar = true;
                                  labelBoton = 'Editar';
                                });
                              }
                            }),
                        IconButton(
                          icon: Icon(
                            Icons.delete,
                            color: Theme.of(context).primaryColor,
                          ),
                          onPressed: (!quieroEditar)
                              ? () => confirmAction(
                                  context, 'Desea eliminar el registro')
                              : () {},
                        )
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
          ),
        ),
        onWillPop: () async => false);
  }

  void _desactivar() async {
    if (_examenGinecologico.examenId != 0) {
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
      ExamenFisicoGinecologico _examenGinecologicoGuardado;
      _examenGinecologico.activo = false;
      _examenGinecologicoGuardado = await _examenGinecologicoBloc
          .updateExamenGinecologico(_examenGinecologico);
      if (_examenGinecologicoGuardado != null) {
        _pr.hide();
        mostrarFlushBar(context, Colors.green, 'Info', 'Datos Guardados', 2,
            FlushbarPosition.TOP, Icons.info, Colors.black);
        _examenGinecologico.examenId = 0;
        _examenGinecologico.activo = true;
        _afuController.text = '';
        _pelvisController.text = '';
        _dorsoController.text = '';
        _fcfController.text = '';
        _apController.text = '';
        _notasController.text = '';
        setState(() {
          quieroEditar = true;
          labelBoton = 'Guardar';
        });
      } else {
        mostrarFlushBar(context, Colors.red, 'Info', 'Ha ocurrido un error', 2,
            FlushbarPosition.TOP, Icons.info, Colors.white);
      }
    } else {
      print('nada');
    }
  }

  Widget _campoAfu() {
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0),
      child: TextFormField(
        controller: _afuController,
        onSaved: (value) => _examenGinecologico.afu = value,
        keyboardType: TextInputType.text,
        decoration: inputsDecorations('Afu', Icons.note),
        enabled: quieroEditar,
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
        enabled: quieroEditar,
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
        enabled: quieroEditar,
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
        enabled: quieroEditar,
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
        enabled: quieroEditar,
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
        enabled: quieroEditar,
      ),
    );
  }

  Widget _crearBotones(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        RaisedButton.icon(
            color: Theme.of(context).primaryColor,
            onPressed: (quieroEditar) ? () => _guardar(context) : null,
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
    if (_afuController.text.isEmpty &&
        _pelvisController.text.isEmpty &&
        _dorsoController.text.isEmpty &&
        _fcfController.text.isEmpty &&
        _apController.text.isEmpty &&
        _notasController.text.isEmpty) {
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

      _pr.hide();
      if (_examenGinecologicoGuardado != null) {
        mostrarFlushBar(context, Colors.green, 'Info', 'Datos Guardados', 2,
            FlushbarPosition.TOP, Icons.info, Colors.black);
        _examenGinecologico.examenId = _examenGinecologicoGuardado.examenId;
        _examenGinecologico.creadoFecha =
            _examenGinecologicoGuardado.creadoFecha;
        _examenGinecologico.creadoPor = _examenGinecologicoGuardado.creadoPor;
        _examenGinecologico.modificadoPor =
            _examenGinecologicoGuardado.modificadoPor;
        _examenGinecologicoGuardado.modificadoFecha =
            _examenGinecologicoGuardado.modificadoFecha;
        setState(() {
          quieroEditar = false;
          labelBoton = 'Editar';
        });
      } else {
        mostrarFlushBar(context, Colors.red, 'Info', 'Ha ocurrido un error', 2,
            FlushbarPosition.TOP, Icons.info, Colors.white);
      }
    }
  }

  showConfirmDialog(
      BuildContext context, String ruta, PreclinicaViewModel args) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text('Cancelar'),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = FlatButton(
      child: Text('Ok'),
      onPressed: () {
        Navigator.pushReplacementNamed(context, ruta, arguments: args);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Información"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text('Desea continuar a la siguiente pagina?'),
          Text('Esta acción no se podra deshacer.')
        ],
      ),
      elevation: 24.0,
      actions: [
        cancelButton,
        continueButton,
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

  void confirmAction(
    BuildContext context,
    String texto,
  ) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text('Cancelar'),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = FlatButton(
      child: Text('Ok'),
      onPressed: () {
        Navigator.pop(context);
        _desactivar();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Información"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(texto),
          Text('Esta acción no se podra deshacer.')
        ],
      ),
      elevation: 24.0,
      actions: [
        cancelButton,
        continueButton,
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
}
