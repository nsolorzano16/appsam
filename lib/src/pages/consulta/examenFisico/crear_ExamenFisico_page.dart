import 'package:appsam/src/widgets/firebaseMessageWrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:getflutter/getflutter.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:unicorndial/unicorndial.dart';

import 'package:appsam/src/blocs/examenFisico_bloc.dart';
import 'package:appsam/src/models/examenFisico_model.dart';
import 'package:appsam/src/models/paginados/preclinica_paginadoVM.dart';
import 'package:appsam/src/utils/storage_util.dart';
import 'package:appsam/src/utils/utils.dart';
import 'package:appsam/src/widgets/drawer.dart';

class CrearExamenFisicoPage extends StatefulWidget {
  static final String routeName = 'crear_examen_fisico';
  final ExamenFisico examen;
  final PreclinicaViewModel preclinica;

  const CrearExamenFisicoPage(
      {@required this.examen, @required this.preclinica});

  @override
  _CrearExamenFisicoPageState createState() => _CrearExamenFisicoPageState();
}

class _CrearExamenFisicoPageState extends State<CrearExamenFisicoPage> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  final ExamenFisicoBloc _examenFisicoBloc = new ExamenFisicoBloc();

  final TextEditingController _aspectoGeneralController =
      new TextEditingController();

  final TextEditingController _cabezaController = new TextEditingController();
  final TextEditingController _oidosController = new TextEditingController();
  final TextEditingController _ojosController = new TextEditingController();
  final TextEditingController _cuelloController = new TextEditingController();
  final TextEditingController _toraxController = new TextEditingController();
  final TextEditingController _abdomenController = new TextEditingController();
  final TextEditingController _pielFanerasController =
      new TextEditingController();
  final TextEditingController _genitalesController =
      new TextEditingController();
  final TextEditingController _neuroligicoController =
      new TextEditingController();
  final TextEditingController _bocaController = new TextEditingController();
  final TextEditingController _columnaVertebralController =
      new TextEditingController();

  final TextEditingController _miembrosInferioresSuperioresController =
      new TextEditingController();

  final TextEditingController _narizController = new TextEditingController();
  final TextEditingController _notasController = new TextEditingController();

  String labelBoton = 'Guardar';

  @override
  void initState() {
    super.initState();
    StorageUtil.putString('ultimaPagina', CrearExamenFisicoPage.routeName);
    labelBoton = (widget.examen.examenFisicoId == 0) ? 'Guardar' : 'Editar';

    _aspectoGeneralController.text = (widget.examen.aspectoGeneral != null)
        ? widget.examen.aspectoGeneral
        : 'Sin alteraciones';

    _cabezaController.text = (widget.examen.cabeza != null)
        ? widget.examen.cabeza
        : 'Sin alteraciones';
    _oidosController.text = (widget.examen.oidos != null)
        ? widget.examen.oidos
        : 'Sin alteraciones';
    _ojosController.text =
        (widget.examen.ojos != null) ? widget.examen.ojos : 'Sin alteraciones';

    _cuelloController.text = (widget.examen.cuello != null)
        ? widget.examen.cuello
        : 'Sin alteraciones';
    _toraxController.text = (widget.examen.torax != null)
        ? widget.examen.torax
        : 'Sin alteraciones';

    _abdomenController.text = (widget.examen.abdomen != null)
        ? widget.examen.abdomen
        : 'Sin alteraciones';
    _pielFanerasController.text = (widget.examen.pielFaneras != null)
        ? widget.examen.pielFaneras
        : 'Sin alteraciones';
    _genitalesController.text = (widget.examen.genitales != null)
        ? widget.examen.genitales
        : 'Sin alteraciones';

    _neuroligicoController.text = (widget.examen.neurologico != null)
        ? widget.examen.neurologico
        : 'Sin alteraciones';

    _bocaController.text =
        (widget.examen.boca != null) ? widget.examen.boca : 'Sin alteraciones';

    _columnaVertebralController.text =
        (widget.examen.columnaVertebralRegionLumbar != null)
            ? widget.examen.columnaVertebralRegionLumbar
            : 'Sin alteraciones';

    _miembrosInferioresSuperioresController.text =
        (widget.examen.miembrosInferioresSuperiores != null)
            ? widget.examen.miembrosInferioresSuperiores
            : 'Sin alteraciones';

    _narizController.text = (widget.examen.nariz != null)
        ? widget.examen.nariz
        : 'Sin alteraciones';

    _notasController.text = (widget.examen.notas != null)
        ? widget.examen.notas
        : 'Sin alteraciones';
  }

  @override
  void dispose() {
    _aspectoGeneralController.dispose();

    _cabezaController.dispose();
    _oidosController.dispose();
    _ojosController.dispose();
    _cuelloController.dispose();
    _toraxController.dispose();
    _abdomenController.dispose();
    _pielFanerasController.dispose();
    _genitalesController.dispose();
    _neuroligicoController.dispose();
    _bocaController.dispose();
    _columnaVertebralController.dispose();
    _miembrosInferioresSuperioresController.dispose();
    _narizController.dispose();
    _notasController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final PreclinicaViewModel _preclinica = widget.preclinica;

    final size = MediaQuery.of(context).size;

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
            body: Form(
                key: _formkey,
                child: GFCarousel(
                    pagerSize: 11.0,
                    enableInfiniteScroll: false,
                    activeIndicator: Colors.red,
                    viewportFraction: 1.0,
                    pagination: true,
                    height: size.height,
                    onPageChanged: (index) {
                      setState(() {});
                    },
                    items: [
                      _formParte1(context),
                      _formParte2(context),
                    ])),
            floatingActionButton: UnicornDialer(
                backgroundColor: Color.fromRGBO(255, 255, 255, 0.6),
                hasBackground: false,
                parentButtonBackground: Theme.of(context).primaryColor,
                orientation: UnicornOrientation.VERTICAL,
                parentButton: Icon(Icons.menu),
                childButtons: botones(_preclinica)),
          ),
        ),
        onWillPop: () async => false);
  }

  List<UnicornButton> botones(PreclinicaViewModel preclinica) {
    var childButtons = List<UnicornButton>();

    childButtons.add(UnicornButton(
        hasLabel: true,
        labelText: 'Eliminar',
        currentButton: FloatingActionButton(
          heroTag: 'borrar',
          backgroundColor: Colors.redAccent,
          mini: true,
          child: Icon(Icons.delete),
          onPressed: () => (widget.examen.examenFisicoId != 0)
              ? _confirmDesactivar(context)
              : null,
        )));

    childButtons.add(UnicornButton(
        hasLabel: true,
        labelText: 'Guardar',
        currentButton: FloatingActionButton(
          heroTag: 'guardar',
          backgroundColor: Colors.greenAccent,
          mini: true,
          child: Icon(Icons.save),
          onPressed: () => _guardar(context, preclinica),
        )));
    return childButtons;
  }

  Widget _formParte1(BuildContext context) {
    return SingleChildScrollView(
      child: GFCard(
        elevation: 6.0,
        title: GFListTile(
            color: Colors.red,
            title: Text('Examen físico - página 1',
                style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
            icon: FaIcon(FontAwesomeIcons.user, color: Colors.white)),
        content: Column(
          children: <Widget>[
            _campoAspectoGeneral(),
            _campoPielFaneras(),
            _campoCabeza(),
            _campoOidos(),
            _campoOjos(),
            _campoNariz(),
            _campoBoca(),
          ],
        ),
      ),
    );
  }

  Widget _formParte2(BuildContext context) {
    return SingleChildScrollView(
      child: GFCard(
        elevation: 6.0,
        title: GFListTile(
            color: Colors.red,
            title: Text('Examen físico - página 2',
                style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
            icon: FaIcon(FontAwesomeIcons.user, color: Colors.white)),
        content: Column(
          children: <Widget>[
            _campoCuello(),
            _campoTorax(),
            _campoAbdomen(),
            _campoColumnaVertebral(),
            _campoMiembrosInferioresSuperiores(),
            _campoGenitales(),
            _campoNeurologico(),
            _campoNotas(),
          ],
        ),
      ),
    );
  }

  String isNumeric(String s) {
    // if (s.isEmpty) return 'Campo obligatorio';
    final n = num.tryParse(s);
    return (n == null) ? 'Ingrese valores correctos' : null;
  }

  Widget _campoAspectoGeneral() {
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0),
      child: TextFormField(
        maxLines: 2,
        controller: _aspectoGeneralController,
        onSaved: (value) => widget.examen.aspectoGeneral = value,
        keyboardType: TextInputType.text,
        decoration: inputsDecorations('Aspecto General', Icons.person_outline),
      ),
    );
  }

  Widget _campoNariz() {
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0),
      child: TextFormField(
        maxLines: 2,
        controller: _narizController,
        onSaved: (value) => widget.examen.nariz = value,
        keyboardType: TextInputType.text,
        decoration: inputsDecorations('Nariz', Icons.person_outline),
      ),
    );
  }

  Widget _campoCabeza() {
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0),
      child: TextFormField(
        maxLines: 2,
        controller: _cabezaController,
        onSaved: (value) => widget.examen.cabeza = value,
        keyboardType: TextInputType.text,
        decoration: inputsDecorations('Cabeza', Icons.person_outline),
      ),
    );
  }

  Widget _campoOidos() {
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0),
      child: TextFormField(
        maxLines: 2,
        controller: _oidosController,
        onSaved: (value) => widget.examen.oidos = value,
        keyboardType: TextInputType.text,
        decoration: inputsDecorations('Oidos', Icons.person_outline),
      ),
    );
  }

  Widget _campoOjos() {
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0),
      child: TextFormField(
        maxLines: 2,
        controller: _ojosController,
        onSaved: (value) => widget.examen.ojos = value,
        keyboardType: TextInputType.text,
        decoration: inputsDecorations('Ojos', Icons.person_outline),
      ),
    );
  }

  Widget _campoMiembrosInferioresSuperiores() {
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0),
      child: TextFormField(
        maxLines: 2,
        controller: _miembrosInferioresSuperioresController,
        onSaved: (value) => widget.examen.miembrosInferioresSuperiores = value,
        keyboardType: TextInputType.text,
        decoration: inputsDecorations(
            'Miembros inferiores y superiores', Icons.person_outline),
      ),
    );
  }

  Widget _campoBoca() {
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0),
      child: TextFormField(
        maxLines: 2,
        controller: _bocaController,
        onSaved: (value) => widget.examen.boca = value,
        keyboardType: TextInputType.text,
        decoration: inputsDecorations('Boca', Icons.person_outline),
      ),
    );
  }

  Widget _campoCuello() {
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0),
      child: TextFormField(
        maxLines: 2,
        controller: _cuelloController,
        onSaved: (value) => widget.examen.cuello = value,
        keyboardType: TextInputType.text,
        decoration: inputsDecorations('Cuello', Icons.person_outline),
      ),
    );
  }

  Widget _campoTorax() {
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0),
      child: TextFormField(
        maxLines: 2,
        controller: _toraxController,
        onSaved: (value) => widget.examen.torax = value,
        keyboardType: TextInputType.text,
        decoration: inputsDecorations('Torax', Icons.person_outline),
      ),
    );
  }

  Widget _campoAbdomen() {
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0),
      child: TextFormField(
        maxLines: 2,
        controller: _abdomenController,
        onSaved: (value) => widget.examen.abdomen = value,
        keyboardType: TextInputType.text,
        decoration: inputsDecorations('Abdomen', Icons.person_outline),
      ),
    );
  }

  Widget _campoColumnaVertebral() {
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0),
      child: TextFormField(
        maxLines: 2,
        controller: _columnaVertebralController,
        onSaved: (value) => widget.examen.columnaVertebralRegionLumbar = value,
        keyboardType: TextInputType.text,
        decoration: inputsDecorations(
            'Columna vertebral region lumbar', Icons.person_outline),
      ),
    );
  }

  Widget _campoPielFaneras() {
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0),
      child: TextFormField(
        maxLines: 2,
        controller: _pielFanerasController,
        onSaved: (value) => widget.examen.pielFaneras = value,
        keyboardType: TextInputType.text,
        decoration: inputsDecorations('Piel faneras', Icons.person_outline),
      ),
    );
  }

  Widget _campoGenitales() {
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0),
      child: TextFormField(
        maxLines: 2,
        controller: _genitalesController,
        onSaved: (value) => widget.examen.genitales = value,
        keyboardType: TextInputType.text,
        decoration: inputsDecorations('Genitales', Icons.person_outline),
      ),
    );
  }

  Widget _campoNeurologico() {
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0),
      child: TextFormField(
        maxLines: 2,
        controller: _neuroligicoController,
        onSaved: (value) => widget.examen.neurologico = value,
        keyboardType: TextInputType.text,
        decoration: inputsDecorations('Neurologico', Icons.person_outline),
      ),
    );
  }

  Widget _campoNotas() {
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0),
      child: TextFormField(
        maxLines: 2,
        controller: _notasController,
        onSaved: (value) => widget.examen.notas = value,
        keyboardType: TextInputType.text,
        decoration:
            inputsDecorations('Notas adicionales', Icons.person_outline),
      ),
    );
  }

  void _guardar(BuildContext context, PreclinicaViewModel preclinica) async {
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
    if (_aspectoGeneralController.text.isEmpty &&
        _cabezaController.text.isEmpty &&
        _oidosController.text.isEmpty &&
        _ojosController.text.isEmpty &&
        _cuelloController.text.isEmpty &&
        _toraxController.text.isEmpty &&
        _abdomenController.text.isEmpty &&
        _pielFanerasController.text.isEmpty &&
        _genitalesController.text.isEmpty &&
        _neuroligicoController.text.isEmpty &&
        _bocaController.text.isEmpty &&
        _columnaVertebralController.text.isEmpty &&
        _miembrosInferioresSuperioresController.text.isEmpty &&
        _narizController.text.isEmpty &&
        _notasController.text.isEmpty) {
      mostrarFlushBar(context, Colors.black, 'Info',
          'El formulario no puede estar vacio', 3, Icons.info, Colors.white);
    } else {
      _formkey.currentState.save();
      obtenerValores(preclinica);
      await _pr.show();

      ExamenFisico _examenFisicoGuardado;

      if (widget.examen.examenFisicoId == 0) {
        //guarda
        _examenFisicoGuardado =
            await _examenFisicoBloc.addExamenFisico(widget.examen);
      } else {
        _examenFisicoGuardado =
            await _examenFisicoBloc.updateExamenFisico(widget.examen);
      }
      await _pr.hide();

      if (_examenFisicoGuardado != null) {
        mostrarFlushBar(context, Colors.green, 'Info', 'Datos Guardados', 2,
            Icons.info, Colors.black);
        widget.examen.examenFisicoId = _examenFisicoGuardado.examenFisicoId;
        widget.examen.creadoFecha = _examenFisicoGuardado.creadoFecha;
        widget.examen.creadoPor = _examenFisicoGuardado.creadoPor;
        widget.examen.modificadoPor = _examenFisicoGuardado.modificadoPor;
        widget.examen.modificadoFecha = _examenFisicoGuardado.modificadoFecha;
      } else {
        mostrarFlushBar(context, Colors.red, 'Info', 'Ha ocurrido un error', 2,
            Icons.info, Colors.white);
      }
    }
  }

  void obtenerValores(PreclinicaViewModel preclinica) {
    widget.examen.aspectoGeneral = _aspectoGeneralController.text;
    widget.examen.cabeza = _cabezaController.text;
    widget.examen.oidos = _oidosController.text;
    widget.examen.ojos = _ojosController.text;
    widget.examen.cuello = _cuelloController.text;
    widget.examen.torax = _toraxController.text;
    widget.examen.abdomen = _abdomenController.text;
    widget.examen.pielFaneras = _pielFanerasController.text;
    widget.examen.genitales = _genitalesController.text;
    widget.examen.neurologico = _neuroligicoController.text;
    widget.examen.boca = _bocaController.text;
    widget.examen.columnaVertebralRegionLumbar =
        _columnaVertebralController.text;
    widget.examen.miembrosInferioresSuperiores =
        _miembrosInferioresSuperioresController.text;
    widget.examen.nariz = _narizController.text;
    widget.examen.notas = _notasController.text;
  }

  void limpiar() {
    _aspectoGeneralController.text = '';

    _cabezaController.text = '';
    _oidosController.text = '';
    _ojosController.text = '';
    _cuelloController.text = '';
    _toraxController.text = '';
    _abdomenController.text = '';
    _pielFanerasController.text = '';
    _genitalesController.text = '';
    _neuroligicoController.text = '';
    _bocaController.text = '';
    _columnaVertebralController.text = '';
    _miembrosInferioresSuperioresController.text = '';
    _narizController.text = '';
    _notasController.text = '';
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
    ExamenFisico _examenGuardado;
    widget.examen.activo = false;

    _examenGuardado = await _examenFisicoBloc.updateExamenFisico(widget.examen);

    if (_examenGuardado != null) {
      await _pr.hide();
      mostrarFlushBar(context, Colors.green, 'Info', 'Datos Guardados', 2,
          Icons.info, Colors.black);

      limpiar();

      widget.examen.examenFisicoId = 0;
      widget.examen.activo = true;
      widget.examen.creadoFecha = DateTime.now();
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
