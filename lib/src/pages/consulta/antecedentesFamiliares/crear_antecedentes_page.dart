import 'package:appsam/src/blocs/antecedentes_bloc.dart';
import 'package:appsam/src/models/antecedentesFamiliaresPersonales_model.dart';
import 'package:appsam/src/models/paginados/preclinica_paginadoVM.dart';
import 'package:appsam/src/models/usuario_model.dart';
import 'package:appsam/src/utils/storage_util.dart';
import 'package:appsam/src/utils/utils.dart';
import 'package:appsam/src/widgets/drawer.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:getflutter/getflutter.dart';
import 'package:progress_dialog/progress_dialog.dart';

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
  bool quieroEditar = true;
  String labelBoton = 'Guardar';

  final _antPatologicosFamiCtrl = new TextEditingController();
  final _antPatologicosPersCtrl = new TextEditingController();
  final _antNoPatologicosFamiCtrl = new TextEditingController();
  final _antNoPatologicosPersCtrl = new TextEditingController();
  final _antInmunoAlergicosCtrl = new TextEditingController();
  @override
  void initState() {
    super.initState();
    StorageUtil.putString('ultimaPagina', CrearAntecedentesPage.routeName);
    _antecedentes.antecedentesFamiliaresPersonalesId = 0;
    _antecedentes.activo = true;
    _antecedentes.creadoPor = _usuario.userName;
    _antecedentes.creadoFecha = DateTime.now();
    _antecedentes.modificadoPor = _usuario.userName;
    _antecedentes.modificadoFecha = DateTime.now();
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
    _antecedentes.pacienteId = _preclinica.pacienteId;
    _antecedentes.doctorId = _preclinica.doctorId;
    return Scaffold(
      appBar: AppBar(
        title: Text('Consulta'),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.arrow_forward_ios,
              color: Colors.white,
            ),
            tooltip: 'Siguiente pagina',
            onPressed: () {
              showConfirmDialog(context, 'crear_habitos', _preclinica);
            },
          )
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
                      'Antecedentes Personales',
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
                      onPressed: (!quieroEditar) ? _desactivar : () {},
                    )
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
      ),
    );
  }

  void _desactivar() async {
    if (_antecedentes.antecedentesFamiliaresPersonalesId != 0) {
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
      AntecedentesFamiliaresPersonales _antecedentesGuardado;
      _antecedentes.activo = false;
      _antecedentesGuardado =
          await _antecedentesBloc.updateAntecedentes(_antecedentes);
      if (_antecedentesGuardado != null) {
        _pr.hide();
        mostrarFlushBar(context, Colors.green, 'Info', 'Datos Guardados', 2,
            FlushbarPosition.TOP, Icons.info, Colors.black);
        _antecedentes.antecedentesFamiliaresPersonalesId = 0;
        _antecedentes.activo = true;
        _antPatologicosFamiCtrl.text = '';
        _antPatologicosPersCtrl.text = '';
        _antNoPatologicosFamiCtrl.text = '';
        _antNoPatologicosPersCtrl.text = '';
        _antInmunoAlergicosCtrl.text = '';
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
        enabled: quieroEditar,
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
        enabled: quieroEditar,
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
        enabled: quieroEditar,
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
        enabled: quieroEditar,
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
}
