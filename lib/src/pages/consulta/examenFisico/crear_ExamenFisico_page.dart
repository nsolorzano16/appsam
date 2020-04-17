import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:getflutter/getflutter.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:unicorndial/unicorndial.dart';

import 'package:appsam/src/blocs/examenFisico_bloc.dart';
import 'package:appsam/src/models/examenFisico_model.dart';
import 'package:appsam/src/models/paginados/preclinica_paginadoVM.dart';
import 'package:appsam/src/models/usuario_model.dart';
import 'package:appsam/src/utils/storage_util.dart';
import 'package:appsam/src/utils/utils.dart';
import 'package:appsam/src/widgets/drawer.dart';

class CrearExamenFisicoPage extends StatefulWidget {
  static final String routeName = 'crear_examen_fisico';

  @override
  _CrearExamenFisicoPageState createState() => _CrearExamenFisicoPageState();
}

class _CrearExamenFisicoPageState extends State<CrearExamenFisicoPage> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final ExamenFisico _examenFisico = new ExamenFisico();
  final UsuarioModel _usuario =
      usuarioModelFromJson(StorageUtil.getString('usuarioGlobal'));

  final ExamenFisicoBloc _examenFisicoBloc = new ExamenFisicoBloc();

  final TextEditingController _aspectoGeneralController =
      new TextEditingController();
  final TextEditingController _edadAparenteController =
      new TextEditingController();
  final TextEditingController _marchaController = new TextEditingController();
  final TextEditingController _orientacionesController =
      new TextEditingController();
  final TextEditingController _pulsoController = new TextEditingController();
  final TextEditingController _pabdController = new TextEditingController();
  final TextEditingController _pToraxController = new TextEditingController();
  final TextEditingController _observacionesController =
      new TextEditingController();
  bool _dolorAusente = false;
  bool _dolorPresente = false;
  bool _dolorPresenteLeve = false;
  bool _dolorPresenteModerado = false;
  bool _dolorPresenteSevero = false;
  bool _excesoDePeso = false;
  final TextEditingController _pesoIdealController =
      new TextEditingController();
  final TextEditingController _interpretacionController =
      new TextEditingController();
  final TextEditingController _librasABajarController =
      new TextEditingController();
  final TextEditingController _cabezaController = new TextEditingController();
  final TextEditingController _oidosController = new TextEditingController();
  final TextEditingController _ojosController = new TextEditingController();
  final TextEditingController _foController = new TextEditingController();
  final TextEditingController _narizController = new TextEditingController();
  final TextEditingController _orofaringeController =
      new TextEditingController();
  final TextEditingController _cuelloController = new TextEditingController();
  final TextEditingController _toraxController = new TextEditingController();
  final TextEditingController _mamasController = new TextEditingController();
  final TextEditingController _pulmonesController = new TextEditingController();
  final TextEditingController _corazonController = new TextEditingController();
  final TextEditingController _rotController = new TextEditingController();
  final TextEditingController _abdomenController = new TextEditingController();
  final TextEditingController _pielFonerasController =
      new TextEditingController();
  final TextEditingController _genitalesController =
      new TextEditingController();
  final TextEditingController _rectoProstaticoController =
      new TextEditingController();
  final TextEditingController _miembrosController = new TextEditingController();
  final TextEditingController _neuroligicoController =
      new TextEditingController();

  bool quieroEditar = true;
  String labelBoton = 'Guardar';

  @override
  void initState() {
    super.initState();
    StorageUtil.putString('ultimaPagina', CrearExamenFisicoPage.routeName);
    _examenFisico.examenFisicoId = 0;
    _examenFisico.activo = true;
    _examenFisico.creadoPor = _usuario.userName;
    _examenFisico.creadoFecha = DateTime.now();
    _examenFisico.modificadoPor = _usuario.userName;
    _examenFisico.modificadoFecha = DateTime.now();
  }

  @override
  void dispose() {
    super.dispose();
    _aspectoGeneralController.dispose();
    _edadAparenteController.dispose();
    _marchaController.dispose();
    _orientacionesController.dispose();
    _pulsoController.dispose();
    _pabdController.dispose();
    _pToraxController.dispose();
    _observacionesController.dispose();
    _pesoIdealController.dispose();
    _interpretacionController.dispose();
    _librasABajarController.dispose();
    _cabezaController.dispose();
    _oidosController.dispose();
    _ojosController.dispose();
    _foController.dispose();
    _narizController.dispose();
    _orofaringeController.dispose();
    _cuelloController.dispose();
    _toraxController.dispose();
    _mamasController.dispose();
    _pulmonesController.dispose();
    _corazonController.dispose();
    _rotController.dispose();
    _abdomenController.dispose();
    _pielFonerasController.dispose();
    _genitalesController.dispose();
    _rectoProstaticoController.dispose();
    _miembrosController.dispose();
    _neuroligicoController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final PreclinicaViewModel _preclinica =
        ModalRoute.of(context).settings.arguments;
    _examenFisico.pacienteId = _preclinica.pacienteId;
    _examenFisico.doctorId = _preclinica.doctorId;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text('Consulta'),
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
                setState(() {
                  index;
                });
              },
              items: [
                _formParte1(context),
                _formParte2(context),
                _formParte3(context),
                _formParte4(context),
                _formParte5(context),
                _formParte6(context),
              ])),
      floatingActionButton: UnicornDialer(
          backgroundColor: Color.fromRGBO(255, 255, 255, 0.6),
          hasBackground: false,
          parentButtonBackground: Theme.of(context).primaryColor,
          orientation: UnicornOrientation.VERTICAL,
          parentButton: Icon(Icons.add),
          childButtons: botones()),
    );
  }

  List<UnicornButton> botones() {
    var childButtons = List<UnicornButton>();

    childButtons.add(UnicornButton(
        currentButton: FloatingActionButton(
      heroTag: 'borrar',
      backgroundColor: Colors.redAccent,
      mini: true,
      child: Icon(Icons.delete),
      onPressed: (!quieroEditar)
          ? () => confirmAction(context, 'Desea eliminar el registro')
          : () {},
    )));

    childButtons.add(UnicornButton(
        currentButton: FloatingActionButton(
      heroTag: 'editar',
      backgroundColor: Colors.blue,
      mini: true,
      child: Icon(Icons.edit),
      onPressed: () {
        if (!quieroEditar) {
          setState(() {
            quieroEditar = true;
            labelBoton = 'Editar';
          });
        }
      },
    )));

    childButtons.add(UnicornButton(
        currentButton: FloatingActionButton(
      heroTag: 'guardar',
      backgroundColor: Colors.greenAccent,
      mini: true,
      child: Icon(Icons.save),
      onPressed: (quieroEditar) ? () => _guardar(context) : null,
    )));
    return childButtons;
  }

  Widget _formParte1(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: GFCard(
        elevation: 6.0,
        height: size.height * 0.82,
        title: GFListTile(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Text(
                'Examen Físico - página 1',
                style: TextStyle(fontSize: 16.0),
              ),
            ],
          ),
        ),
        content: Column(
          children: <Widget>[
            _campoAspectoGeneral(),
            _campoEdadAparente(),
            _campoMarcha(),
            _campoOrientaciones(),
            _campoPulso(),
            _campoPabd(),
          ],
        ),
      ),
    );
  }

  Widget _formParte2(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: GFCard(
        elevation: 6.0,
        height: size.height * 0.82,
        title: GFListTile(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Text(
                'Examen Físico - página 2',
                style: TextStyle(fontSize: 16.0),
              ),
            ],
          ),
        ),
        content: Column(
          children: <Widget>[
            _campoPtorax(),
            _campoObservaciones(),
            _campoInterpretacion(),
            _campoCabeza(),
            _campoOidos(),
            _campoOjos(),
          ],
        ),
      ),
    );
  }

  Widget _formParte3(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: GFCard(
        elevation: 6.0,
        height: size.height * 0.82,
        title: GFListTile(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Text(
                'Examen Físico - página 3',
                style: TextStyle(fontSize: 16.0),
              ),
            ],
          ),
        ),
        content: Column(
          children: <Widget>[
            _campoFo(),
            _campoNariz(),
            _campoOrofaringe(),
            _campoCuello(),
            _campoTorax(),
            _campoMamas(),
          ],
        ),
      ),
    );
  }

  Widget _formParte4(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: GFCard(
        elevation: 6.0,
        height: size.height * 0.82,
        title: GFListTile(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Text(
                'Examen Físico - página 4',
                style: TextStyle(fontSize: 16.0),
              ),
            ],
          ),
        ),
        content: Column(
          children: <Widget>[
            _campoPulmones(),
            _campoCorazon(),
            _campoRot(),
            _campoAbdomen(),
            _campoPielFoneras(),
            _campoGenitales(),
          ],
        ),
      ),
    );
  }

  Widget _formParte5(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: GFCard(
        elevation: 6.0,
        height: size.height * 0.82,
        title: GFListTile(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Text(
                'Examen Físico - página 5',
                style: TextStyle(fontSize: 16.0),
              ),
            ],
          ),
        ),
        content: Column(
          children: <Widget>[
            _campoRectoProstatico(),
            _campoMiembros(),
            _campoNeurologico(),
            _campoDolorAusente(),
            _campoDolorPresente(),
            _campoDolorPresenteLeve(),
            _campoDolorPresenteModerado(),
          ],
        ),
      ),
    );
  }

  Widget _formParte6(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: GFCard(
        elevation: 6.0,
        height: size.height * 0.82,
        title: GFListTile(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Text(
                'Examen Físico - página 6',
                style: TextStyle(fontSize: 16.0),
              ),
            ],
          ),
        ),
        content: Column(
          children: <Widget>[
            _campoDolorPresenteSevero(),
            _campoExcesoDePeso(),
            _campoPesoIdeal(),
            _campoLibrasABajar(),
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
        controller: _aspectoGeneralController,
        onSaved: (value) => _examenFisico.aspectoGeneral = value,
        keyboardType: TextInputType.text,
        decoration: inputsDecorations('Aspecto General', Icons.person_outline),
        enabled: quieroEditar,
      ),
    );
  }

  Widget _campoEdadAparente() {
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0),
      child: TextFormField(
        inputFormatters: <TextInputFormatter>[
          WhitelistingTextInputFormatter.digitsOnly
        ],
        controller: _edadAparenteController,
        keyboardType: TextInputType.number,
        decoration: inputsDecorations('Edad Aparente', Icons.person_outline),
        enabled: quieroEditar,
      ),
    );
  }

  Widget _campoMarcha() {
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0),
      child: TextFormField(
        controller: _marchaController,
        onSaved: (value) => _examenFisico.marcha = value,
        keyboardType: TextInputType.text,
        decoration: inputsDecorations('Marcha', Icons.person_outline),
        enabled: quieroEditar,
      ),
    );
  }

  Widget _campoOrientaciones() {
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0),
      child: TextFormField(
        controller: _orientacionesController,
        onSaved: (value) => _examenFisico.orientaciones = value,
        keyboardType: TextInputType.text,
        decoration: inputsDecorations('Orientaciones', Icons.person_outline),
        enabled: quieroEditar,
      ),
    );
  }

  Widget _campoPulso() {
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0),
      child: TextFormField(
        controller: _pulsoController,
        onSaved: (value) => _examenFisico.pulso = value,
        keyboardType: TextInputType.text,
        decoration: inputsDecorations('Pulso', Icons.person_outline),
        enabled: quieroEditar,
      ),
    );
  }

  Widget _campoPabd() {
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0),
      child: TextFormField(
        controller: _pabdController,
        onSaved: (value) => _examenFisico.pabd = value,
        keyboardType: TextInputType.text,
        decoration: inputsDecorations('Pabd', Icons.person_outline),
        enabled: quieroEditar,
      ),
    );
  }

  Widget _campoPtorax() {
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0),
      child: TextFormField(
        controller: _pToraxController,
        onSaved: (value) => _examenFisico.ptorax = value,
        keyboardType: TextInputType.text,
        decoration: inputsDecorations('Ptorax', Icons.person_outline),
        enabled: quieroEditar,
      ),
    );
  }

  Widget _campoObservaciones() {
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0),
      child: TextFormField(
        controller: _observacionesController,
        onSaved: (value) => _examenFisico.observaciones = value,
        keyboardType: TextInputType.text,
        decoration: inputsDecorations('Observaciones', Icons.person_outline),
        enabled: quieroEditar,
      ),
    );
  }

  Widget _campoDolorAusente() {
    return SwitchListTile(
        title: Text('Dolor ausente'),
        value: _dolorAusente,
        onChanged: (quieroEditar)
            ? (value) {
                setState(() {
                  _dolorAusente = value;
                  _examenFisico.dolorAusente = value;
                });
              }
            : null);
  }

  Widget _campoDolorPresente() {
    return SwitchListTile(
        title: Text('Dolor presente'),
        value: _dolorPresente,
        onChanged: (quieroEditar)
            ? (value) {
                setState(() {
                  _dolorPresente = value;
                  _examenFisico.dolorPresente = value;
                });
              }
            : null);
  }

  Widget _campoDolorPresenteLeve() {
    return SwitchListTile(
        title: Text('Dolor presente leve'),
        value: _dolorPresenteLeve,
        onChanged: (quieroEditar)
            ? (value) {
                setState(() {
                  _dolorPresenteLeve = value;
                  _examenFisico.dolorPresenteLeve = value;
                });
              }
            : null);
  }

  Widget _campoDolorPresenteModerado() {
    return SwitchListTile(
        title: Text('Dolor presente moderado'),
        value: _dolorPresenteModerado,
        onChanged: (quieroEditar)
            ? (value) {
                setState(() {
                  _dolorPresenteModerado = value;
                  _examenFisico.dolorPresenteModerado = value;
                });
              }
            : null);
  }

  Widget _campoDolorPresenteSevero() {
    return SwitchListTile(
        title: Text('Dolor presente severo'),
        value: _dolorPresenteSevero,
        onChanged: (quieroEditar)
            ? (value) {
                setState(() {
                  _dolorPresenteSevero = value;
                  _examenFisico.dolorPresenteSevero = value;
                });
              }
            : null);
  }

  Widget _campoPesoIdeal() {
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0),
      child: TextFormField(
        inputFormatters: <TextInputFormatter>[
          WhitelistingTextInputFormatter.digitsOnly
        ],
        controller: _pesoIdealController,
        keyboardType: TextInputType.number,
        decoration: inputsDecorations('Peso Ideal', Icons.person_outline),
        enabled: quieroEditar,
      ),
    );
  }

  Widget _campoInterpretacion() {
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0),
      child: TextFormField(
        controller: _interpretacionController,
        onSaved: (value) => _examenFisico.interpretacion = value,
        keyboardType: TextInputType.text,
        decoration: inputsDecorations('Interpretación', Icons.person_outline),
        enabled: quieroEditar,
      ),
    );
  }

  Widget _campoExcesoDePeso() {
    return SwitchListTile(
        title: Text('Exceso de peso'),
        value: _excesoDePeso,
        onChanged: (quieroEditar)
            ? (value) {
                setState(() {
                  _excesoDePeso = value;
                  _examenFisico.excesoDePeso = value;
                });
              }
            : null);
  }

  Widget _campoLibrasABajar() {
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0),
      child: TextFormField(
        inputFormatters: <TextInputFormatter>[
          WhitelistingTextInputFormatter.digitsOnly
        ],
        controller: _librasABajarController,
        keyboardType: TextInputType.number,
        decoration: inputsDecorations('Libras a bajar', Icons.person_outline),
        enabled: quieroEditar,
      ),
    );
  }

  Widget _campoCabeza() {
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0),
      child: TextFormField(
        controller: _cabezaController,
        onSaved: (value) => _examenFisico.cabeza = value,
        keyboardType: TextInputType.text,
        decoration: inputsDecorations('Cabeza', Icons.person_outline),
        enabled: quieroEditar,
      ),
    );
  }

  Widget _campoOidos() {
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0),
      child: TextFormField(
        controller: _oidosController,
        onSaved: (value) => _examenFisico.oidos = value,
        keyboardType: TextInputType.text,
        decoration: inputsDecorations('Oidos', Icons.person_outline),
        enabled: quieroEditar,
      ),
    );
  }

  Widget _campoOjos() {
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0),
      child: TextFormField(
        controller: _ojosController,
        onSaved: (value) => _examenFisico.ojos = value,
        keyboardType: TextInputType.text,
        decoration: inputsDecorations('Ojos', Icons.person_outline),
        enabled: quieroEditar,
      ),
    );
  }

  Widget _campoFo() {
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0),
      child: TextFormField(
        controller: _foController,
        onSaved: (value) => _examenFisico.fo = value,
        keyboardType: TextInputType.text,
        decoration: inputsDecorations('Fo', Icons.person_outline),
        enabled: quieroEditar,
      ),
    );
  }

  Widget _campoNariz() {
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0),
      child: TextFormField(
        controller: _narizController,
        onSaved: (value) => _examenFisico.nariz = value,
        keyboardType: TextInputType.text,
        decoration: inputsDecorations('Nariz', Icons.person_outline),
        enabled: quieroEditar,
      ),
    );
  }

  Widget _campoOrofaringe() {
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0),
      child: TextFormField(
        controller: _orofaringeController,
        onSaved: (value) => _examenFisico.oroFaringe = value,
        keyboardType: TextInputType.text,
        decoration: inputsDecorations('Orofaringe', Icons.person_outline),
        enabled: quieroEditar,
      ),
    );
  }

  Widget _campoCuello() {
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0),
      child: TextFormField(
        controller: _cuelloController,
        onSaved: (value) => _examenFisico.cuello = value,
        keyboardType: TextInputType.text,
        decoration: inputsDecorations('Cuello', Icons.person_outline),
        enabled: quieroEditar,
      ),
    );
  }

  Widget _campoTorax() {
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0),
      child: TextFormField(
        controller: _toraxController,
        onSaved: (value) => _examenFisico.torax = value,
        keyboardType: TextInputType.text,
        decoration: inputsDecorations('Torax', Icons.person_outline),
        enabled: quieroEditar,
      ),
    );
  }

  Widget _campoMamas() {
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0),
      child: TextFormField(
        controller: _mamasController,
        onSaved: (value) => _examenFisico.mamas = value,
        keyboardType: TextInputType.text,
        decoration: inputsDecorations('Mamas', Icons.person_outline),
        enabled: quieroEditar,
      ),
    );
  }

  Widget _campoPulmones() {
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0),
      child: TextFormField(
        controller: _pulmonesController,
        onSaved: (value) => _examenFisico.pulmones = value,
        keyboardType: TextInputType.text,
        decoration: inputsDecorations('Pulmones', Icons.person_outline),
        enabled: quieroEditar,
      ),
    );
  }

  Widget _campoCorazon() {
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0),
      child: TextFormField(
        controller: _corazonController,
        onSaved: (value) => _examenFisico.corazon = value,
        keyboardType: TextInputType.text,
        decoration: inputsDecorations('Corazón', Icons.person_outline),
        enabled: quieroEditar,
      ),
    );
  }

  Widget _campoRot() {
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0),
      child: TextFormField(
        controller: _rotController,
        onSaved: (value) => _examenFisico.rot = value,
        keyboardType: TextInputType.text,
        decoration: inputsDecorations('Rot', Icons.person_outline),
        enabled: quieroEditar,
      ),
    );
  }

  Widget _campoAbdomen() {
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0),
      child: TextFormField(
        controller: _abdomenController,
        onSaved: (value) => _examenFisico.abdomen = value,
        keyboardType: TextInputType.text,
        decoration: inputsDecorations('Abdomen', Icons.person_outline),
        enabled: quieroEditar,
      ),
    );
  }

  Widget _campoPielFoneras() {
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0),
      child: TextFormField(
        controller: _pielFonerasController,
        onSaved: (value) => _examenFisico.pielfoneras = value,
        keyboardType: TextInputType.text,
        decoration: inputsDecorations('Piel foneras', Icons.person_outline),
        enabled: quieroEditar,
      ),
    );
  }

  Widget _campoGenitales() {
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0),
      child: TextFormField(
        controller: _genitalesController,
        onSaved: (value) => _examenFisico.genitales = value,
        keyboardType: TextInputType.text,
        decoration: inputsDecorations('Genitales', Icons.person_outline),
        enabled: quieroEditar,
      ),
    );
  }

  Widget _campoRectoProstatico() {
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0),
      child: TextFormField(
        controller: _rectoProstaticoController,
        onSaved: (value) => _examenFisico.rectoProstatico = value,
        keyboardType: TextInputType.text,
        decoration: inputsDecorations('Recto prostatico', Icons.person_outline),
        enabled: quieroEditar,
      ),
    );
  }

  Widget _campoMiembros() {
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0),
      child: TextFormField(
        controller: _miembrosController,
        onSaved: (value) => _examenFisico.miembros = value,
        keyboardType: TextInputType.text,
        decoration: inputsDecorations('Miembros', Icons.person_outline),
        enabled: quieroEditar,
      ),
    );
  }

  Widget _campoNeurologico() {
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0),
      child: TextFormField(
        controller: _neuroligicoController,
        onSaved: (value) => _examenFisico.neurologico = value,
        keyboardType: TextInputType.text,
        decoration: inputsDecorations('Neurologico', Icons.person_outline),
        enabled: quieroEditar,
      ),
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
    if (_aspectoGeneralController.text.isEmpty &&
        _edadAparenteController.text.isEmpty &&
        _marchaController.text.isEmpty &&
        _orientacionesController.text.isEmpty &&
        _pulsoController.text.isEmpty &&
        _pabdController.text.isEmpty &&
        _pToraxController.text.isEmpty &&
        _observacionesController.text.isEmpty &&
        _pesoIdealController.text.isEmpty &&
        _interpretacionController.text.isEmpty &&
        _librasABajarController.text.isEmpty &&
        _cabezaController.text.isEmpty &&
        _oidosController.text.isEmpty &&
        _ojosController.text.isEmpty &&
        _foController.text.isEmpty &&
        _narizController.text.isEmpty &&
        _orofaringeController.text.isEmpty &&
        _cuelloController.text.isEmpty &&
        _toraxController.text.isEmpty &&
        _mamasController.text.isEmpty &&
        _pulmonesController.text.isEmpty &&
        _corazonController.text.isEmpty &&
        _rotController.text.isEmpty &&
        _abdomenController.text.isEmpty &&
        _pielFonerasController.text.isEmpty &&
        _genitalesController.text.isEmpty &&
        _rectoProstaticoController.text.isEmpty &&
        _miembrosController.text.isEmpty &&
        _neuroligicoController.text.isEmpty) {
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
      obtenerValores();
      await _pr.show();

      ExamenFisico _examenFisicoGuardado;

      if (_examenFisico.examenFisicoId == 0) {
        //guarda
        _examenFisicoGuardado =
            await _examenFisicoBloc.addExamenFisico(_examenFisico);
      } else {
        _examenFisicoGuardado =
            await _examenFisicoBloc.updateExamenFisico(_examenFisico);
      }
      _pr.hide();

      if (_examenFisicoGuardado != null) {
        mostrarFlushBar(context, Colors.green, 'Info', 'Datos Guardados', 2,
            FlushbarPosition.TOP, Icons.info, Colors.black);
        _examenFisico.examenFisicoId = _examenFisicoGuardado.examenFisicoId;
        _examenFisico.creadoFecha = _examenFisicoGuardado.creadoFecha;
        _examenFisico.creadoPor = _examenFisicoGuardado.creadoPor;
        _examenFisico.modificadoPor = _examenFisicoGuardado.modificadoPor;
        _examenFisicoGuardado.modificadoFecha =
            _examenFisicoGuardado.modificadoFecha;
        setState(() {
          quieroEditar = false;
        });
      } else {
        mostrarFlushBar(context, Colors.red, 'Info', 'Ha ocurrido un error', 2,
            FlushbarPosition.TOP, Icons.info, Colors.white);
      }
    }
  }

  void _desactivar() async {
    if (_examenFisico.examenFisicoId != 0) {
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
      ExamenFisico _examenFisicoGuardado;
      _examenFisico.activo = false;
      _examenFisicoGuardado =
          await _examenFisicoBloc.updateExamenFisico(_examenFisico);
      _pr.hide();
      if (_examenFisicoGuardado != null) {
        mostrarFlushBar(context, Colors.green, 'Info', 'Datos Guardados', 2,
            FlushbarPosition.TOP, Icons.info, Colors.black);
        _examenFisico.examenFisicoId = 0;
        _examenFisico.activo = true;
        // limpiar todo
        limpiar();
        setState(() {
          quieroEditar = true;
        });
      } else {
        mostrarFlushBar(context, Colors.red, 'Info', 'Ha ocurrido un error', 2,
            FlushbarPosition.TOP, Icons.info, Colors.white);
      }
    } else {
      print('nada');
    }
  }

  void obtenerValores() {
    _examenFisico.aspectoGeneral = _aspectoGeneralController.text;
    _examenFisico.edadAparente = (_edadAparenteController.text.isEmpty)
        ? null
        : int.parse(_edadAparenteController.text);
    _examenFisico.marcha = _marchaController.text;
    _examenFisico.orientaciones = _orientacionesController.text;
    _examenFisico.pulso = _pulsoController.text;
    _examenFisico.pabd = _pabdController.text;
    _examenFisico.ptorax = _pToraxController.text;
    _examenFisico.observaciones = _observacionesController.text;
    _examenFisico.pesoIdeal = (_pesoIdealController.text.isEmpty)
        ? null
        : int.parse(_pesoIdealController.text);
    _examenFisico.interpretacion = (_interpretacionController.text.isEmpty)
        ? null
        : _interpretacionController.text;
    _examenFisico.librasABajar = (_interpretacionController.text.isEmpty)
        ? null
        : int.parse(_librasABajarController.text);
    _examenFisico.cabeza = _cabezaController.text;
    _examenFisico.oidos = _oidosController.text;
    _examenFisico.ojos = _ojosController.text;
    _examenFisico.fo = _foController.text;
    _examenFisico.nariz = _narizController.text;
    _examenFisico.oroFaringe = _orofaringeController.text;
    _examenFisico.cuello = _cuelloController.text;
    _examenFisico.torax = _toraxController.text;
    _examenFisico.mamas = _mamasController.text;
    _examenFisico.pulmones = _pulmonesController.text;
    _examenFisico.corazon = _corazonController.text;
    _examenFisico.rot = _rotController.text;
    _examenFisico.abdomen = _abdomenController.text;
    _examenFisico.pielfoneras = _pielFonerasController.text;
    _examenFisico.genitales = _genitalesController.text;
    _examenFisico.rectoProstatico = _rectoProstaticoController.text;
    _examenFisico.miembros = _miembrosController.text;
    _examenFisico.neurologico = _neuroligicoController.text;
  }

  void limpiar() {
    _aspectoGeneralController.text = '';
    _edadAparenteController.text = '';
    _marchaController.text = '';
    _orientacionesController.text = '';
    _pulsoController.text = '';
    _pabdController.text = '';
    _pToraxController.text = '';
    _observacionesController.text = '';
    _pesoIdealController.text = '';
    _interpretacionController.text = '';
    _librasABajarController.text = '';
    _cabezaController.text = '';
    _oidosController.text = '';
    _ojosController.text = '';
    _foController.text = '';
    _narizController.text = '';
    _orofaringeController.text = '';
    _cuelloController.text = '';
    _toraxController.text = '';
    _mamasController.text = '';
    _pulmonesController.text = '';
    _corazonController.text = '';
    _rotController.text = '';
    _abdomenController.text = '';
    _pielFonerasController.text = '';
    _genitalesController.text = '';
    _rectoProstaticoController.text = '';
    _miembrosController.text = '';
    _neuroligicoController.text = '';
    _dolorAusente = false;
    _dolorPresente = false;
    _dolorPresenteLeve = false;
    _dolorPresenteModerado = false;
    _dolorPresenteSevero = false;
    _excesoDePeso = false;
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
