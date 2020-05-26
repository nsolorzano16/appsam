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
  bool _dolorAusente;
  bool _dolorPresente;
  bool _dolorPresenteLeve;
  bool _dolorPresenteModerado;
  bool _dolorPresenteSevero;
  bool _excesoDePeso;
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

  String labelBoton = 'Guardar';

  @override
  void initState() {
    super.initState();
    StorageUtil.putString('ultimaPagina', CrearExamenFisicoPage.routeName);
    labelBoton = (widget.examen.examenFisicoId == 0) ? 'Guardar' : 'Editar';
    _dolorAusente = widget.examen.dolorAusente;
    _dolorPresente = widget.examen.dolorPresente;
    _dolorPresenteLeve = widget.examen.dolorPresenteLeve;
    _dolorPresenteModerado = widget.examen.dolorPresenteModerado;
    _dolorPresenteSevero = widget.examen.dolorPresenteSevero;
    _excesoDePeso = widget.examen.excesoDePeso;

    _aspectoGeneralController.text = (widget.examen.aspectoGeneral != null)
        ? widget.examen.aspectoGeneral
        : '';
    _edadAparenteController.text = (widget.examen.edadAparente != null)
        ? widget.examen.edadAparente.toString()
        : '';
    _marchaController.text =
        (widget.examen.marcha != null) ? widget.examen.marcha : '';
    _orientacionesController.text = (widget.examen.orientaciones != null)
        ? widget.examen.orientaciones
        : '';
    _pulsoController.text =
        (widget.examen.pulso != null) ? widget.examen.pulso : '';
    _pabdController.text =
        (widget.examen.pabd != null) ? widget.examen.pabd : '';
    _pToraxController.text =
        (widget.examen.ptorax != null) ? widget.examen.ptorax : '';
    _observacionesController.text = (widget.examen.observaciones != null)
        ? widget.examen.observaciones
        : '';
    _pesoIdealController.text = (widget.examen.pesoIdeal != null)
        ? widget.examen.pesoIdeal.toString()
        : '';
    _interpretacionController.text = (widget.examen.interpretacion != null)
        ? widget.examen.interpretacion
        : '';
    _librasABajarController.text = (widget.examen.librasABajar != null)
        ? widget.examen.librasABajar.toString()
        : '';
    _cabezaController.text =
        (widget.examen.cabeza != null) ? widget.examen.cabeza : '';
    _oidosController.text =
        (widget.examen.oidos != null) ? widget.examen.oidos : '';
    _ojosController.text =
        (widget.examen.ojos != null) ? widget.examen.ojos : '';
    _foController.text = (widget.examen.fo != null) ? widget.examen.fo : '';
    _narizController.text =
        (widget.examen.nariz != null) ? widget.examen.nariz : '';
    _orofaringeController.text =
        (widget.examen.oroFaringe != null) ? widget.examen.oroFaringe : '';
    _cuelloController.text =
        (widget.examen.cuello != null) ? widget.examen.cuello : '';
    _toraxController.text =
        (widget.examen.torax != null) ? widget.examen.torax : '';
    _mamasController.text =
        (widget.examen.mamas != null) ? widget.examen.mamas : '';
    _pulmonesController.text =
        (widget.examen.pulmones != null) ? widget.examen.pulmones : '';
    _corazonController.text =
        (widget.examen.corazon != null) ? widget.examen.corazon : '';
    _rotController.text = (widget.examen.rot != null) ? widget.examen.rot : '';
    _abdomenController.text =
        (widget.examen.abdomen != null) ? widget.examen.abdomen : '';
    _pielFonerasController.text =
        (widget.examen.pielfoneras != null) ? widget.examen.pielfoneras : '';
    _genitalesController.text =
        (widget.examen.genitales != null) ? widget.examen.genitales : '';
    _rectoProstaticoController.text = (widget.examen.rectoProstatico != null)
        ? widget.examen.rectoProstatico
        : '';
    _miembrosController.text =
        (widget.examen.miembros != null) ? widget.examen.miembros : '';
    _neuroligicoController.text =
        (widget.examen.neurologico != null) ? widget.examen.neurologico : '';
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
                      _formParte3(context),
                      _formParte4(context),
                      _formParte5(context),
                    ])),
            floatingActionButton: UnicornDialer(
                backgroundColor: Color.fromRGBO(255, 255, 255, 0.6),
                hasBackground: false,
                parentButtonBackground: Theme.of(context).primaryColor,
                orientation: UnicornOrientation.VERTICAL,
                parentButton: Icon(Icons.add),
                childButtons: botones(_preclinica)),
          ),
        ),
        onWillPop: () async => false);
  }

  List<UnicornButton> botones(PreclinicaViewModel preclinica) {
    var childButtons = List<UnicornButton>();

    childButtons.add(UnicornButton(
        currentButton: FloatingActionButton(
      heroTag: 'borrar',
      backgroundColor: Colors.redAccent,
      mini: true,
      child: Icon(Icons.delete),
      onPressed: () => _confirmDesactivar(context),
    )));

    childButtons.add(UnicornButton(
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
            _campoEdadAparente(),
            _campoCabeza(),
            _campoCuello(),
            _campoOrofaringe(),
            _campoOidos(),
            _campoOjos(),
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
            // 2
            _campoNariz(),
            _campoTorax(),
            _campoPtorax(),
            _campoCorazon(),
            _campoPulmones(),
            _campoMamas(),
            _campoAbdomen(),
          ],
        ),
      ),
    );
  }

  Widget _formParte3(BuildContext context) {
    return SingleChildScrollView(
      child: GFCard(
        elevation: 6.0,
        title: GFListTile(
            color: Colors.red,
            title: Text('Examen físico - página 3',
                style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
            icon: FaIcon(FontAwesomeIcons.user, color: Colors.white)),
        content: Column(
          children: <Widget>[
            // 3
            _campoGenitales(),
            _campoMiembros(),
            _campoRot(),
            _campoPielFoneras(),
            _campoNeurologico(),
            _campoOrientaciones(),
            _campoMarcha(),
          ],
        ),
      ),
    );
  }

  Widget _formParte4(BuildContext context) {
    return SingleChildScrollView(
      child: GFCard(
        elevation: 6.0,
        title: GFListTile(
            color: Colors.red,
            title: Text('Examen físico - página 4',
                style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
            icon: FaIcon(FontAwesomeIcons.user, color: Colors.white)),
        content: Column(
          children: <Widget>[
            // 4
            _campoFo(),
            _campoObservaciones(),
            _campoInterpretacion(),
            _campoRectoProstatico(),
            _campoPabd(),
            _campoPesoIdeal(),
            _campoLibrasABajar(),
          ],
        ),
      ),
    );
  }

  Widget _formParte5(BuildContext context) {
    return SingleChildScrollView(
      child: GFCard(
        elevation: 6.0,
        title: GFListTile(
            color: Colors.red,
            title: Text('Examen físico - página 5',
                style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
            icon: FaIcon(FontAwesomeIcons.user, color: Colors.white)),
        content: Column(
          children: <Widget>[
            // 5
            _campoExcesoDePeso(),
            _campoDolorAusente(),
            _campoDolorPresente(),
            _campoDolorPresenteLeve(),
            _campoDolorPresenteModerado(),
            _campoDolorPresenteSevero(),
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
        onSaved: (value) => widget.examen.aspectoGeneral = value,
        keyboardType: TextInputType.text,
        decoration: inputsDecorations('Aspecto General', Icons.person_outline),
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
      ),
    );
  }

  Widget _campoMarcha() {
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0),
      child: TextFormField(
        controller: _marchaController,
        onSaved: (value) => widget.examen.marcha = value,
        keyboardType: TextInputType.text,
        decoration: inputsDecorations('Marcha', Icons.person_outline),
      ),
    );
  }

  Widget _campoOrientaciones() {
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0),
      child: TextFormField(
        controller: _orientacionesController,
        onSaved: (value) => widget.examen.orientaciones = value,
        keyboardType: TextInputType.text,
        decoration: inputsDecorations('Orientaciones', Icons.person_outline),
      ),
    );
  }

  Widget _campoPabd() {
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0),
      child: TextFormField(
        controller: _pabdController,
        onSaved: (value) => widget.examen.pabd = value,
        keyboardType: TextInputType.text,
        decoration: inputsDecorations('Pabd', Icons.person_outline),
      ),
    );
  }

  Widget _campoPtorax() {
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0),
      child: TextFormField(
        controller: _pToraxController,
        onSaved: (value) => widget.examen.ptorax = value,
        keyboardType: TextInputType.text,
        decoration: inputsDecorations('Ptorax', Icons.person_outline),
      ),
    );
  }

  Widget _campoObservaciones() {
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0),
      child: TextFormField(
        controller: _observacionesController,
        onSaved: (value) => widget.examen.observaciones = value,
        keyboardType: TextInputType.text,
        decoration: inputsDecorations('Observaciones', Icons.person_outline),
      ),
    );
  }

  Widget _campoDolorAusente() {
    return SwitchListTile(
        title: Text('Dolor ausente'),
        value: _dolorAusente,
        onChanged: (value) {
          setState(() {
            _dolorAusente = value;
            widget.examen.dolorAusente = value;
          });
        });
  }

  Widget _campoDolorPresente() {
    return SwitchListTile(
        title: Text('Dolor presente'),
        value: _dolorPresente,
        onChanged: (value) {
          setState(() {
            _dolorPresente = value;
            widget.examen.dolorPresente = value;
          });
        });
  }

  Widget _campoDolorPresenteLeve() {
    return SwitchListTile(
        title: Text('Dolor presente leve'),
        value: _dolorPresenteLeve,
        onChanged: (value) {
          setState(() {
            _dolorPresenteLeve = value;
            widget.examen.dolorPresenteLeve = value;
          });
        });
  }

  Widget _campoDolorPresenteModerado() {
    return SwitchListTile(
        title: Text('Dolor presente moderado'),
        value: _dolorPresenteModerado,
        onChanged: (value) {
          setState(() {
            _dolorPresenteModerado = value;
            widget.examen.dolorPresenteModerado = value;
          });
        });
  }

  Widget _campoDolorPresenteSevero() {
    return SwitchListTile(
        title: Text('Dolor presente severo'),
        value: _dolorPresenteSevero,
        onChanged: (value) {
          setState(() {
            _dolorPresenteSevero = value;
            widget.examen.dolorPresenteSevero = value;
          });
        });
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
      ),
    );
  }

  Widget _campoInterpretacion() {
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0),
      child: TextFormField(
        controller: _interpretacionController,
        onSaved: (value) => widget.examen.interpretacion = value,
        keyboardType: TextInputType.text,
        decoration: inputsDecorations('Interpretación', Icons.person_outline),
      ),
    );
  }

  Widget _campoExcesoDePeso() {
    return SwitchListTile(
        title: Text('Exceso de peso'),
        value: _excesoDePeso,
        onChanged: (value) {
          setState(() {
            _excesoDePeso = value;
            widget.examen.excesoDePeso = value;
          });
        });
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
      ),
    );
  }

  Widget _campoCabeza() {
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0),
      child: TextFormField(
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
        controller: _ojosController,
        onSaved: (value) => widget.examen.ojos = value,
        keyboardType: TextInputType.text,
        decoration: inputsDecorations('Ojos', Icons.person_outline),
      ),
    );
  }

  Widget _campoFo() {
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0),
      child: TextFormField(
        controller: _foController,
        onSaved: (value) => widget.examen.fo = value,
        keyboardType: TextInputType.text,
        decoration: inputsDecorations('Fo', Icons.person_outline),
      ),
    );
  }

  Widget _campoNariz() {
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0),
      child: TextFormField(
        controller: _narizController,
        onSaved: (value) => widget.examen.nariz = value,
        keyboardType: TextInputType.text,
        decoration: inputsDecorations('Nariz', Icons.person_outline),
      ),
    );
  }

  Widget _campoOrofaringe() {
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0),
      child: TextFormField(
        controller: _orofaringeController,
        onSaved: (value) => widget.examen.oroFaringe = value,
        keyboardType: TextInputType.text,
        decoration: inputsDecorations('Orofaringe', Icons.person_outline),
      ),
    );
  }

  Widget _campoCuello() {
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0),
      child: TextFormField(
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
        controller: _toraxController,
        onSaved: (value) => widget.examen.torax = value,
        keyboardType: TextInputType.text,
        decoration: inputsDecorations('Torax', Icons.person_outline),
      ),
    );
  }

  Widget _campoMamas() {
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0),
      child: TextFormField(
        controller: _mamasController,
        onSaved: (value) => widget.examen.mamas = value,
        keyboardType: TextInputType.text,
        decoration: inputsDecorations('Mamas', Icons.person_outline),
      ),
    );
  }

  Widget _campoPulmones() {
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0),
      child: TextFormField(
        controller: _pulmonesController,
        onSaved: (value) => widget.examen.pulmones = value,
        keyboardType: TextInputType.text,
        decoration: inputsDecorations('Pulmones', Icons.person_outline),
      ),
    );
  }

  Widget _campoCorazon() {
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0),
      child: TextFormField(
        controller: _corazonController,
        onSaved: (value) => widget.examen.corazon = value,
        keyboardType: TextInputType.text,
        decoration: inputsDecorations('Corazón', Icons.person_outline),
      ),
    );
  }

  Widget _campoRot() {
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0),
      child: TextFormField(
        controller: _rotController,
        onSaved: (value) => widget.examen.rot = value,
        keyboardType: TextInputType.text,
        decoration: inputsDecorations('Rot', Icons.person_outline),
      ),
    );
  }

  Widget _campoAbdomen() {
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0),
      child: TextFormField(
        controller: _abdomenController,
        onSaved: (value) => widget.examen.abdomen = value,
        keyboardType: TextInputType.text,
        decoration: inputsDecorations('Abdomen', Icons.person_outline),
      ),
    );
  }

  Widget _campoPielFoneras() {
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0),
      child: TextFormField(
        controller: _pielFonerasController,
        onSaved: (value) => widget.examen.pielfoneras = value,
        keyboardType: TextInputType.text,
        decoration: inputsDecorations('Piel foneras', Icons.person_outline),
      ),
    );
  }

  Widget _campoGenitales() {
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0),
      child: TextFormField(
        controller: _genitalesController,
        onSaved: (value) => widget.examen.genitales = value,
        keyboardType: TextInputType.text,
        decoration: inputsDecorations('Genitales', Icons.person_outline),
      ),
    );
  }

  Widget _campoRectoProstatico() {
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0),
      child: TextFormField(
        controller: _rectoProstaticoController,
        onSaved: (value) => widget.examen.rectoProstatico = value,
        keyboardType: TextInputType.text,
        decoration: inputsDecorations('Recto prostatico', Icons.person_outline),
      ),
    );
  }

  Widget _campoMiembros() {
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0),
      child: TextFormField(
        controller: _miembrosController,
        onSaved: (value) => widget.examen.miembros = value,
        keyboardType: TextInputType.text,
        decoration: inputsDecorations('Miembros', Icons.person_outline),
      ),
    );
  }

  Widget _campoNeurologico() {
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0),
      child: TextFormField(
        controller: _neuroligicoController,
        onSaved: (value) => widget.examen.neurologico = value,
        keyboardType: TextInputType.text,
        decoration: inputsDecorations('Neurologico', Icons.person_outline),
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
    widget.examen.edadAparente = (_edadAparenteController.text.isEmpty)
        ? null
        : int.parse(_edadAparenteController.text);
    widget.examen.marcha = _marchaController.text;
    widget.examen.orientaciones = _orientacionesController.text;
    widget.examen.pulso = _pulsoController.text;
    widget.examen.pabd = _pabdController.text;
    widget.examen.ptorax = _pToraxController.text;
    widget.examen.observaciones = _observacionesController.text;
    widget.examen.pesoIdeal = (_pesoIdealController.text.isEmpty)
        ? null
        : int.parse(_pesoIdealController.text);
    widget.examen.interpretacion = (_interpretacionController.text.isEmpty)
        ? null
        : _interpretacionController.text;
    widget.examen.librasABajar = (_interpretacionController.text.isEmpty)
        ? null
        : int.parse(_librasABajarController.text);
    widget.examen.cabeza = _cabezaController.text;
    widget.examen.oidos = _oidosController.text;
    widget.examen.ojos = _ojosController.text;
    widget.examen.fo = _foController.text;
    widget.examen.nariz = _narizController.text;
    widget.examen.oroFaringe = _orofaringeController.text;
    widget.examen.cuello = _cuelloController.text;
    widget.examen.torax = _toraxController.text;
    widget.examen.mamas = _mamasController.text;
    widget.examen.pulmones = _pulmonesController.text;
    widget.examen.corazon = _corazonController.text;
    widget.examen.rot = _rotController.text;
    widget.examen.abdomen = _abdomenController.text;
    widget.examen.pielfoneras = _pielFonerasController.text;
    widget.examen.genitales = _genitalesController.text;
    widget.examen.rectoProstatico = _rectoProstaticoController.text;
    widget.examen.miembros = _miembrosController.text;
    widget.examen.neurologico = _neuroligicoController.text;
    widget.examen.dolorAusente = _dolorAusente;
    widget.examen.dolorPresente = _dolorPresente;
    widget.examen.dolorPresenteLeve = _dolorPresenteLeve;
    widget.examen.dolorPresenteModerado = _dolorPresenteModerado;
    widget.examen.dolorPresenteSevero = _dolorPresenteSevero;
    widget.examen.excesoDePeso = _excesoDePeso;
    widget.examen.imc = preclinica.imc;
    widget.examen.pulso = preclinica.ritmoCardiaco.toString();
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
