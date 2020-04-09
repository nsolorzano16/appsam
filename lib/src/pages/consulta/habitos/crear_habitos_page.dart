import 'package:appsam/src/blocs/habitos_bloc.dart';
import 'package:appsam/src/utils/utils.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:getflutter/getflutter.dart';

import 'package:appsam/src/models/habitos_model.dart';
import 'package:appsam/src/models/paginados/preclinica_paginadoVM.dart';
import 'package:appsam/src/models/usuario_model.dart';
import 'package:appsam/src/widgets/drawer.dart';
import 'package:appsam/src/utils/storage_util.dart';
import 'package:progress_dialog/progress_dialog.dart';

class CrearHabitosPage extends StatefulWidget {
  static final String routeName = 'crear_habitos';
  @override
  _CrearHabitosPageState createState() => _CrearHabitosPageState();
}

class _CrearHabitosPageState extends State<CrearHabitosPage> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final Habitos _habitos = new Habitos();
  final UsuarioModel _usuario =
      usuarioModelFromJson(StorageUtil.getString('usuarioGlobal'));
  final _habitosBloc = new HabitosBloc();
  bool quieroEditar = true;
  String labelBoton = 'Guardar';
  bool _consumeCafe = false;
  bool _consumeCigarros = false;
  int _tazasCafe = 0;
  int _cantidadCigarros = 0;

  @override
  void initState() {
    super.initState();
    StorageUtil.putString('ultimaPagina', CrearHabitosPage.routeName);
    _habitos.habitoId = 0;
    _habitos.activo = true;
    _habitos.creadoPor = _usuario.userName;
    _habitos.creadoFecha = DateTime.now();
    _habitos.modificadoPor = _usuario.userName;
    _habitos.modificadoFecha = DateTime.now();
    _habitos.cafe = _consumeCafe;
    _habitos.cigarrillo = _consumeCigarros;
    _habitos.tazasCafe = _tazasCafe;
    _habitos.cantidadCigarrillo = _cantidadCigarros;
  }

  @override
  Widget build(BuildContext context) {
    final PreclinicaViewModel _preclinica =
        ModalRoute.of(context).settings.arguments;
    _habitos.pacienteId = _preclinica.pacienteId;
    _habitos.doctorId = _preclinica.doctorId;

    return Scaffold(
      appBar: AppBar(
        title: Text('Consulta'),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.arrow_forward_ios),
              onPressed: () {
                showConfirmDialog(
                    context, 'crear_historial_gineco', _preclinica);
              })
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Text(
                      'Habitos',
                      style: TextStyle(fontSize: 16.0),
                    ),
                    IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          if (!quieroEditar) {
                            setState(() {
                              quieroEditar = true;
                              labelBoton = 'Editar';
                            });
                          }
                        })
                  ],
                ),
              ),
              content: Form(
                  key: _formkey,
                  child: Column(
                    children: <Widget>[
                      _campoConsumeCafe(),
                      (_consumeCafe) ? _campoTazasCafe() : Container(),
                      _campoConsumeCigarrillos(),
                      (_consumeCigarros)
                          ? _campoCantidadCigarros()
                          : Container(),
                      _campoNotas(),
                      _crearBotones(context)
                    ],
                  )),
            )
          ],
        ),
      ),
    );
  }

  Widget _campoConsumeCafe() {
    return SwitchListTile(
        title: Text('Consume usted café'),
        value: _consumeCafe,
        onChanged: (quieroEditar)
            ? (value) {
                setState(() {
                  _consumeCafe = value;
                  _habitos.cafe = value;
                  if (!value) {
                    _tazasCafe = 0;
                    _habitos.tazasCafe = 0;
                  }
                });
              }
            : null);
  }

  Widget _campoConsumeCigarrillos() {
    return SwitchListTile(
        title: Text('Consume usted cigarrillos'),
        value: _consumeCigarros,
        onChanged: (quieroEditar)
            ? (value) {
                setState(() {
                  _consumeCigarros = value;
                  _habitos.cigarrillo = value;
                  if (!value) {
                    _cantidadCigarros = 0;
                    _habitos.cantidadCigarrillo = 0;
                  }
                });
              }
            : null);
  }

  Widget _campoTazasCafe() {
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0),
      child: TextFormField(
        initialValue: _tazasCafe.toString(),
        onSaved: (value) => _habitos.tazasCafe = int.parse(value),
        keyboardType: TextInputType.number,
        decoration:
            inputsDecorations('Numero de tazas de café', Icons.free_breakfast),
        enabled: quieroEditar,
      ),
    );
  }

  Widget _campoCantidadCigarros() {
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0),
      child: TextFormField(
        initialValue: _cantidadCigarros.toString(),
        onSaved: (value) => _habitos.cantidadCigarrillo = int.parse(value),
        keyboardType: TextInputType.number,
        decoration:
            inputsDecorations('Cantidad de cigarrillos', Icons.smoking_rooms),
        enabled: quieroEditar,
      ),
    );
  }

  Widget _campoNotas() {
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0),
      child: TextFormField(
        initialValue: _habitos.notas,
        onSaved: (value) => _habitos.notas = value,
        keyboardType: TextInputType.text,
        maxLines: 2,
        decoration: inputsDecorations('Notas adicionales', Icons.note),
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
    _formkey.currentState.save();
    await _pr.show();
    Habitos _habitosGuardado;
    if (_habitos.habitoId == 0) {
      //guarda
      _habitosGuardado = await _habitosBloc.addHabitos(_habitos);
    } else {
      // edita
      _habitosGuardado = await _habitosBloc.updateHabitos(_habitos);
    }

    if (_habitosGuardado != null) {
      _pr.hide();
      mostrarFlushBar(context, Colors.green, 'Info', 'Datos Guardados', 2,
          FlushbarPosition.TOP, Icons.info, Colors.black);
      _habitos.habitoId = _habitosGuardado.habitoId;
      _habitos.creadoFecha = _habitosGuardado.creadoFecha;
      _habitos.modificadoFecha = _habitosGuardado.modificadoFecha;
      _consumeCafe = _habitosGuardado.cafe;
      _consumeCigarros = _habitosGuardado.cigarrillo;
      _tazasCafe = _habitosGuardado.tazasCafe;
      _cantidadCigarros = _habitosGuardado.cantidadCigarrillo;
      _habitos.notas = _habitosGuardado.notas;

      setState(() {
        quieroEditar = false;
        labelBoton = 'Editar';
      });
    } else {
      mostrarFlushBar(context, Colors.red, 'Info', 'Ha ocurrido un error', 2,
          FlushbarPosition.TOP, Icons.info, Colors.black);
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
