import 'package:appsam/src/widgets/firebaseMessageWrapper.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:getflutter/getflutter.dart';
import 'package:progress_dialog/progress_dialog.dart';

import 'package:appsam/src/blocs/habitos_bloc.dart';
import 'package:appsam/src/utils/utils.dart';
import 'package:appsam/src/models/habitos_model.dart';
import 'package:appsam/src/models/paginados/preclinica_paginadoVM.dart';
import 'package:appsam/src/models/usuario_model.dart';
import 'package:appsam/src/widgets/drawer.dart';
import 'package:appsam/src/utils/storage_util.dart';

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

  final TextEditingController _tazasCafeController =
      new TextEditingController();
  final TextEditingController _cantidadCigarrosController =
      new TextEditingController();
  final TextEditingController _notasController = new TextEditingController();

  Future<Habitos> _habitosFuture;
  String labelBoton = 'Guardar';

  @override
  void initState() {
    super.initState();
    StorageUtil.putString('ultimaPagina', CrearHabitosPage.routeName);
  }

  @override
  void dispose() {
    super.dispose();
    _habitosBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final PreclinicaViewModel _preclinica =
        ModalRoute.of(context).settings.arguments;

    _habitosFuture =
        _habitosBloc.getHabito(_preclinica.pacienteId, _preclinica.doctorId);

    _habitos.pacienteId = _preclinica.pacienteId;
    _habitos.doctorId = _preclinica.doctorId;
    _habitos.preclinicaId = _preclinica.preclinicaId;

    return WillPopScope(
        child: FirebaseMessageWrapper(
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
              future: _habitosFuture,
              builder: (BuildContext context, AsyncSnapshot<Habitos> snapshot) {
                final x = snapshot.data;
                if (snapshot.connectionState == ConnectionState.done) {
                  if (x != null) {
                    _habitosBloc.onChangeLabelBoton('Editar');
                    _habitos.habitoId = x.habitoId;
                    _habitos.activo = x.activo;
                    _habitos.creadoPor = x.creadoPor;
                    _habitos.creadoFecha = x.creadoFecha;
                    _habitos.modificadoPor = _usuario.userName;
                    _habitos.modificadoFecha = DateTime.now();

                    _habitos.cafe = x.cafe;
                    _habitos.cigarrillo = x.cigarrillo;
                    _habitos.tazasCafe = x.tazasCafe;
                    _habitos.cantidadCigarrillo = x.cantidadCigarrillo;
                    _habitosBloc.onChangeConsumeCafe(_habitos.cafe);
                    _habitosBloc.onChangeConsumeCigarrillo(_habitos.cigarrillo);

                    _tazasCafeController.text = x.tazasCafe.toString();
                    _cantidadCigarrosController.text =
                        x.cantidadCigarrillo.toString();
                    _notasController.text = x.notas;
                    return _habitosForm(context);
                  } else {
                    _habitosBloc.onChangeConsumeCafe(false);
                    _habitosBloc.onChangeConsumeCigarrillo(false);
                    _habitosBloc.onChangeLabelBoton('Guardar');
                    _habitos.habitoId = 0;
                    _habitos.activo = true;
                    _habitos.creadoPor = _usuario.userName;
                    _habitos.creadoFecha = DateTime.now();
                    _habitos.modificadoPor = _usuario.userName;
                    _habitos.modificadoFecha = DateTime.now();

                    _habitos.cafe = _habitosBloc.consumeCafe;
                    _habitos.cigarrillo = _habitosBloc.consumeCigarrillo;
                    _habitos.tazasCafe = 0;
                    _habitos.cantidadCigarrillo = 0;
                    _tazasCafeController.text = '0';
                    _cantidadCigarrosController.text = '0';
                    _notasController.text = '';
                    return _habitosForm(context);
                  }
                } else {
                  return loadingIndicator(context);
                }
              },
            ),
          ),
        ),
        onWillPop: () async => false);
  }

  SingleChildScrollView _habitosForm(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          GFCard(
            elevation: 6.0,
            title: GFListTile(
                color: Colors.red,
                title: Text('Habitos',
                    style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
                icon: FaIcon(FontAwesomeIcons.user, color: Colors.white)),
            content: Form(
                key: _formkey,
                child: Column(
                  children: <Widget>[
                    _campoConsumeCafe(),
                    _campoTazasCafe(),
                    _campoConsumeCigarrillos(),
                    _campoCantidadCigarros(),
                    _campoNotas(),
                    _crearBotones(context)
                  ],
                )),
          )
        ],
      ),
    );
  }

  Widget _campoConsumeCafe() {
    return StreamBuilder(
      stream: _habitosBloc.consumeCafeStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return SwitchListTile(
            title: Text('Consume usted café'),
            value: _habitosBloc.consumeCafe,
            onChanged: (value) {
              _habitosBloc.onChangeConsumeCafe(value);
              _habitos.cafe = value;
              if (!value) {
                _tazasCafeController.text = '0';
                _habitos.tazasCafe = 0;
              }
            });
      },
    );
  }

  Widget _campoConsumeCigarrillos() {
    return StreamBuilder(
      stream: _habitosBloc.consumeCigarrilloStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return SwitchListTile(
            title: Text('Consume usted cigarrillos'),
            value: _habitosBloc.consumeCigarrillo,
            onChanged: (value) {
              _habitosBloc.onChangeConsumeCigarrillo(value);
              _habitos.cigarrillo = value;
              if (!value) {
                _cantidadCigarrosController.text = '0';
                _habitos.cantidadCigarrillo = 0;
              }
            });
      },
    );
  }

  Widget _campoTazasCafe() {
    return StreamBuilder(
      stream: _habitosBloc.consumeCafeStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Padding(
          padding: EdgeInsets.only(left: 8.0, right: 8.0),
          child: TextFormField(
            controller: _tazasCafeController,
            onSaved: (value) => _habitos.tazasCafe = int.parse(value),
            keyboardType: TextInputType.number,
            decoration: inputsDecorations(
                'Numero de tazas de café', Icons.free_breakfast),
            enabled: _habitosBloc.consumeCafe,
          ),
        );
      },
    );
  }

  Widget _campoCantidadCigarros() {
    return StreamBuilder(
      stream: _habitosBloc.consumeCigarrilloStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Padding(
          padding: EdgeInsets.only(left: 8.0, right: 8.0),
          child: TextFormField(
            controller: _cantidadCigarrosController,
            onSaved: (value) => _habitos.cantidadCigarrillo = int.parse(value),
            keyboardType: TextInputType.number,
            decoration: inputsDecorations(
                'Cantidad de cigarrillos', Icons.smoking_rooms),
            enabled: _habitosBloc.consumeCigarrillo,
          ),
        );
      },
    );
  }

  Widget _campoNotas() {
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0),
      child: TextFormField(
        controller: _notasController,
        onSaved: (value) => _habitos.notas = value,
        keyboardType: TextInputType.text,
        maxLines: 2,
        decoration: inputsDecorations('Notas adicionales', Icons.note),
      ),
    );
  }

  Widget _crearBotones(BuildContext context) {
    return StreamBuilder(
      stream: _habitosBloc.labelBotonStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
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
                label: Text(_habitosBloc.labelBoton))
          ],
        );
      },
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
      await _pr.hide();
      mostrarFlushBar(context, Colors.green, 'Info', 'Datos Guardados', 2,
          Icons.info, Colors.black);
      _habitos.activo = true;
      _habitos.habitoId = _habitosGuardado.habitoId;
      _habitos.creadoFecha = _habitosGuardado.creadoFecha;
      _habitos.modificadoFecha = _habitosGuardado.modificadoFecha;
      _habitosBloc.onChangeConsumeCafe(_habitosGuardado.cafe);
      _habitosBloc.onChangeConsumeCigarrillo(_habitosGuardado.cigarrillo);

      _tazasCafeController.text = _habitosGuardado.tazasCafe.toString();
      _cantidadCigarrosController.text =
          _habitosGuardado.cantidadCigarrillo.toString();
      _habitos.notas = _habitosGuardado.notas;
      _habitosBloc.onChangeLabelBoton('Editar');
    } else {
      mostrarFlushBar(context, Colors.red, 'Info', 'Ha ocurrido un error', 2,
          Icons.info, Colors.black);
    }
  }
}
