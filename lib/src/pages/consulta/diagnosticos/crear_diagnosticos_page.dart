import 'package:appsam/src/blocs/diagnosticos_bloc.dart';
import 'package:appsam/src/models/diagnosticos_model.dart';
import 'package:appsam/src/models/paginados/preclinica_paginadoVM.dart';
import 'package:appsam/src/models/user_model.dart';
import 'package:appsam/src/utils/storage_util.dart';
import 'package:appsam/src/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:getflutter/getflutter.dart';
import 'package:progress_dialog/progress_dialog.dart';

class CrearDiagnosticosPage extends StatefulWidget {
  final int cieId;
  final String enfermedad;
  final PreclinicaViewModel preclinica;

  const CrearDiagnosticosPage(
      {Key key, this.cieId, this.enfermedad, this.preclinica})
      : super(key: key);

  @override
  _CrearDiagnosticosPageState createState() => _CrearDiagnosticosPageState();
}

class _CrearDiagnosticosPageState extends State<CrearDiagnosticosPage> {
  int get _cieId => widget.cieId;
  String get _enfermedad => widget.enfermedad;
  PreclinicaViewModel get _preclinica => widget.preclinica;
  final UserModel _usuario =
      userModelFromJson(StorageUtil.getString('usuarioGlobal'));
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final TextEditingController _problemaClinicoController =
      new TextEditingController();

  Diagnosticos _diagnostico = Diagnosticos();
  DiagnosticosBloc _diagnosticosBloc = DiagnosticosBloc();

  @override
  void initState() {
    _diagnostico.diagnosticoId = 0;
    _diagnostico.cieId = _cieId;
    _diagnostico.doctorId = _usuario.id;
    _diagnostico.preclinicaId = _preclinica.preclinicaId;
    _diagnostico.pacienteId = _preclinica.pacienteId;

    _diagnostico.creadoFecha = DateTime.now();
    _diagnostico.creadoPor = _diagnostico.modificadoPor = _usuario.userName;
    _diagnostico.modificadoFecha = DateTime.now();
    _diagnostico.notas = '';
    _diagnostico.activo = true;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorFondoApp(),
      appBar: AppBar(
        title: Text('Crear Diagnostico'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            GFCard(
              elevation: 6.0,
              title: GFListTile(
                  color: Colors.red,
                  title: Text(
                    "Problemas Clinicos",
                    style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  icon: FaIcon(FontAwesomeIcons.user, color: Colors.white)),
              content: Form(
                key: _formkey,
                child: Column(
                  children: <Widget>[
                    _campoDescripcionEnfermedad(_enfermedad),
                    _campoProblemaClinico(),
                    _crearBotones()
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _campoDescripcionEnfermedad(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 15.0),
      child: Text(
        'Enfermedad: ${text.toLowerCase()}',
        textAlign: TextAlign.justify,
        style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget _campoProblemaClinico() {
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0),
      child: TextFormField(
        controller: _problemaClinicoController,
        //onSaved: (value) => _consultaGeneral.motivoConsulta = value,
        maxLines: 4,
        keyboardType: TextInputType.text,
        decoration: inputsDecorations('Problema Clínico', Icons.note),
      ),
    );
  }

  Widget _crearBotones() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        RaisedButton.icon(
            color: Theme.of(context).primaryColor,
            onPressed: _guardar,
            textColor: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            icon: Icon(
              Icons.save,
              color: Colors.white,
            ),
            label: Text('Guardar'))
      ],
    );
  }

  void _guardar() async {
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

    if (_problemaClinicoController.text.isEmpty) {
      mostrarFlushBar(context, Colors.black, 'Info',
          'El formulario no puede estar vacio', 3, Icons.info, Colors.white);
    } else {
      _formkey.currentState.save();
      _diagnostico.problemasClinicos = _problemaClinicoController.text;

      await _pr.show();
      Diagnosticos _diagnoGuardado =
          await _diagnosticosBloc.addDiagnostico(_diagnostico);
      if (_diagnoGuardado != null) {
        await _pr.hide();

        Navigator.pushReplacementNamed(context, 'diagnosticos',
            arguments: _preclinica);
      } else {
        await _pr.hide();
        mostrarFlushBar(context, Colors.red, 'Info', 'Ha ocurrido un error', 2,
            Icons.info, Colors.white);
      }
    }
  }
}
