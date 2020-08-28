import 'package:appsam/src/blocs/consulta_bloc.dart';
import 'package:appsam/src/models/consultaGeneral_model.dart';
import 'package:appsam/src/models/paginados/preclinica_paginadoVM.dart';
import 'package:appsam/src/models/user_model.dart';
import 'package:appsam/src/utils/storage_util.dart';
import 'package:appsam/src/utils/utils.dart';
import 'package:appsam/src/widgets/firebaseMessageWrapper.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:getflutter/getflutter.dart';
import 'package:progress_dialog/progress_dialog.dart';

class CrearConsultaGeneralPage extends StatefulWidget {
  static final String routeName = 'crear_consulta_general';

  @override
  _CrearConsultaGeneralPageState createState() =>
      _CrearConsultaGeneralPageState();
}

class _CrearConsultaGeneralPageState extends State<CrearConsultaGeneralPage> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final ConsultaGeneralModel _consultaGeneral = new ConsultaGeneralModel();

  final _consultaBloc = new ConsultaBloc();
  final UserModel _usuario =
      userModelFromJson(StorageUtil.getString('usuarioGlobal'));

  final TextEditingController _motivoConsultaController =
      new TextEditingController();
  final TextEditingController _fogController = new TextEditingController();
  final TextEditingController _heaController = new TextEditingController();
  final TextEditingController _notasController = new TextEditingController();

  Future<ConsultaGeneralModel> _consultaFuture;
  String labelBoton = 'Guardar';

  @override
  void initState() {
    super.initState();
    StorageUtil.putString('ultimaPagina', CrearConsultaGeneralPage.routeName);
  }

  @override
  void dispose() {
    _motivoConsultaController.dispose();
    _fogController.dispose();
    _heaController.dispose();
    _notasController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final PreclinicaViewModel _preclinica =
        ModalRoute.of(context).settings.arguments;

    _consultaFuture = _consultaBloc.getConsultaGeneral(
        _preclinica.pacienteId, _preclinica.doctorId, _preclinica.preclinicaId);

    return WillPopScope(
        child: FirebaseMessageWrapper(
          child: Scaffold(
            backgroundColor: colorFondoApp(),
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
            body: FutureBuilder(
              future: _consultaFuture,
              builder: (BuildContext context,
                  AsyncSnapshot<ConsultaGeneralModel> snapshot) {
                final x = snapshot.data;
                if (snapshot.connectionState == ConnectionState.done) {
                  if (x != null) {
                    _consultaGeneral.consultaId = x.consultaId;
                    _consultaGeneral.pacienteId = x.pacienteId;
                    _consultaGeneral.doctorId = x.doctorId;
                    _consultaGeneral.preclinicaId = x.preclinicaId;
                    _consultaGeneral.activo = x.activo;
                    _consultaGeneral.creadoPor = x.creadoPor;
                    _consultaGeneral.creadoFecha = x.creadoFecha;
                    _consultaGeneral.modificadoPor = _usuario.userName;
                    _consultaGeneral.modificadoFecha = new DateTime.now();

                    _motivoConsultaController.text = x.motivoConsulta;
                    _fogController.text = x.fog;
                    _heaController.text = x.hea;
                    _notasController.text = x.notas;
                    return _consultaForm(context);
                  } else {
                    _consultaGeneral.consultaId = 0;
                    _consultaGeneral.pacienteId = _preclinica.pacienteId;
                    _consultaGeneral.doctorId = _preclinica.doctorId;
                    _consultaGeneral.preclinicaId = _preclinica.preclinicaId;
                    _consultaGeneral.activo = true;
                    _consultaGeneral.creadoPor = _usuario.userName;
                    _consultaGeneral.creadoFecha = new DateTime.now();
                    _consultaGeneral.modificadoPor = _usuario.userName;
                    _consultaGeneral.modificadoFecha = new DateTime.now();
                    return _consultaForm(context);
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

  SingleChildScrollView _consultaForm(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          GFCard(
            elevation: 6.0,
            title: GFListTile(
                color: Colors.red,
                title: Text('Consulta General',
                    style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
                icon: FaIcon(FontAwesomeIcons.user, color: Colors.white)),
            content: Form(
                key: _formkey,
                child: Column(
                  children: <Widget>[
                    _campoMotivoConsulta(),
                    _campoHea(),
                    _espacio(),
                    _campoFog(),
                    _espacio(),
                    _campoNotas(),
                    _crearBotones(context),
                  ],
                )),
          )
        ],
      ),
    );
  }

  Widget _campoMotivoConsulta() {
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0),
      child: TextFormField(
        controller: _motivoConsultaController,
        onSaved: (value) => _consultaGeneral.motivoConsulta = value,
        maxLines: 3,
        keyboardType: TextInputType.text,
        decoration: inputsDecorations('Motivo de consulta', Icons.note),
      ),
    );
  }

  Widget _espacio() {
    return SizedBox(
      height: 8.0,
    );
  }

  Widget _campoFog() {
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0),
      child: TextFormField(
        controller: _fogController,
        onSaved: (value) => _consultaGeneral.fog = value,
        maxLines: 2,
        keyboardType: TextInputType.text,
        decoration: inputsDecorations('Fog', Icons.note,
            helperTexto: 'Funciones Orgánicas Generales'),
      ),
    );
  }

  Widget _campoHea() {
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0),
      child: TextFormField(
        controller: _heaController,
        onSaved: (value) => _consultaGeneral.hea = value,
        maxLines: 2,
        keyboardType: TextInputType.text,
        decoration: inputsDecorations('HEA', Icons.note,
            helperTexto: 'Historia de la enfermedad actual'),
      ),
    );
  }

  Widget _campoNotas() {
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0),
      child: TextFormField(
        controller: _notasController,
        onSaved: (value) => _consultaGeneral.notas = value,
        maxLines: 2,
        keyboardType: TextInputType.text,
        decoration: inputsDecorations('Notas', Icons.note),
      ),
    );
  }

  Widget _crearBotones(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        RaisedButton.icon(
            color: Theme.of(context).primaryColor,
            onPressed: (_consultaGeneral.consultaId == 0)
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
    if (_motivoConsultaController.text.isEmpty &&
        _fogController.text.isEmpty &&
        _heaController.text.isEmpty &&
        _notasController.text.isEmpty) {
      mostrarFlushBar(context, Colors.black, 'Info',
          'El formulario no puede estar vacio', 3, Icons.info, Colors.white);
    } else {
      _formkey.currentState.save();
      await _pr.show();

      ConsultaGeneralModel _consultaGeneralGuardada;
      if (_consultaGeneral.consultaId == 0) {
        //guarda
        _consultaGeneralGuardada =
            await _consultaBloc.addConsultaGeneral(_consultaGeneral);
      } else {
        // edita
        _consultaGeneralGuardada =
            await _consultaBloc.updateConsultaGeneral(_consultaGeneral);
      }

      if (_consultaGeneralGuardada != null) {
        await _pr.hide();
        mostrarFlushBar(context, Colors.green, 'Info', 'Datos Guardados', 2,
            Icons.info, Colors.black);
        _consultaGeneral.consultaId = _consultaGeneralGuardada.consultaId;
        _consultaGeneral.creadoFecha = _consultaGeneralGuardada.creadoFecha;
        _consultaGeneral.creadoPor = _consultaGeneralGuardada.creadoPor;
        _consultaGeneral.modificadoPor = _consultaGeneralGuardada.modificadoPor;
        _consultaGeneralGuardada.modificadoFecha =
            _consultaGeneralGuardada.modificadoFecha;

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
    ConsultaGeneralModel _consultaGeneralGuardada;
    _consultaGeneral.activo = false;
    _consultaGeneral.modificadoPor = _usuario.userName;
    _consultaGeneralGuardada =
        await _consultaBloc.updateConsultaGeneral(_consultaGeneral);

    if (_consultaGeneralGuardada != null) {
      await _pr.hide();
      mostrarFlushBar(context, Colors.green, 'Info', 'Datos Guardados', 2,
          Icons.info, Colors.black);
      _motivoConsultaController.text = '';
      _fogController.text = '';
      _heaController.text = '';
      _notasController.text = '';
      _consultaGeneral.consultaId = 0;
      _consultaGeneral.activo = true;
      _consultaGeneral.creadoFecha = DateTime.now();
      _consultaGeneral.creadoPor = _usuario.userName;
      _consultaGeneral.modificadoPor = _usuario.userName;
      _consultaGeneralGuardada.modificadoFecha = DateTime.now();

      setState(() {
        labelBoton = 'Guardar';
      });
    } else {
      mostrarFlushBar(context, Colors.red, 'Info', 'Ha ocurrido un error', 2,
          Icons.info, Colors.white);
    }
  }
}
