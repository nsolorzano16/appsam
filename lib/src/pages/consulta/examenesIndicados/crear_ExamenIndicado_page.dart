import 'package:appsam/src/blocs/examenes_bloc.dart';
import 'package:appsam/src/models/examenCategoria_model.dart';
import 'package:appsam/src/models/examenIndicado_Model.dart';
import 'package:appsam/src/models/paginados/preclinica_paginadoVM.dart';
import 'package:appsam/src/models/usuario_model.dart';
import 'package:appsam/src/providers/combos_service.dart';
import 'package:appsam/src/utils/storage_util.dart';
import 'package:appsam/src/utils/utils.dart';
import 'package:appsam/src/widgets/drawer.dart';
import 'package:appsam/src/widgets/firebaseMessageWrapper.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:getflutter/getflutter.dart';
import 'package:progress_dialog/progress_dialog.dart';

class CrearExamenIndicadoPage extends StatefulWidget {
  static final String routeName = 'crear_examen_indicado';
  @override
  _CrearExamenIndicadoPageState createState() =>
      _CrearExamenIndicadoPageState();
}

class _CrearExamenIndicadoPageState extends State<CrearExamenIndicadoPage> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final ExamenIndicadoModel _examen = new ExamenIndicadoModel();
  int _examenCategoriaId = 1;
  int _examenTipoId = 1;
  int _examenDetalleId = 1;
  final ExamenesBlocNoti blocNoti = ExamenesBlocNoti();

  bool _habilitarNombre = true;

  final UsuarioModel _usuario =
      usuarioModelFromJson(StorageUtil.getString('usuarioGlobal'));

  final _combosService = new CombosService();

  final TextEditingController _nombreController = new TextEditingController();
  final TextEditingController _notasController = new TextEditingController();

  String labelBoton = 'Guardar';

  @override
  void initState() {
    super.initState();
    StorageUtil.putString('ultimaPagina', CrearExamenIndicadoPage.routeName);
    blocNoti.getTiposExamenes(_examenCategoriaId);
    blocNoti.getDetalleExamenes(_examenTipoId, _examenCategoriaId);
    _examen.examenIndicadoId = 0;
    _examen.activo = true;
    _examen.creadoPor = _usuario.userName;
    _examen.creadoFecha = DateTime.now();
    _examen.modificadoPor = _usuario.userName;
    _examen.modificadoFecha = DateTime.now();
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _notasController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final PreclinicaViewModel _preclinica =
        ModalRoute.of(context).settings.arguments;
    _examen.pacienteId = _preclinica.pacienteId;
    _examen.preclinicaId = _preclinica.preclinicaId;
    _examen.doctorId = _preclinica.doctorId;

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
                          context, 'examenes_indicados',
                          arguments: _preclinica))
                ],
              ),
              drawer: MenuWidget(),
              body: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    GFCard(
                      title: GFListTile(
                          color: Colors.red,
                          title: Text('Nuevo examen',
                              style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white)),
                          icon: FaIcon(FontAwesomeIcons.user,
                              color: Colors.white)),
                      elevation: 6.0,
                      content: Form(
                          key: _formkey,
                          child: Column(children: <Widget>[
                            _crearDropDownExamenCategoria(),
                            _crearDropDownExamenTipo(),
                            _crearDropDownExamenDetalle(),
                            _campoNombre(),
                            _espacio(),
                            _campoNotas(),
                            _crearBotones(context, _preclinica),
                          ])),
                    )
                  ],
                ),
              )),
        ),
        onWillPop: () async => false);
  }

  Widget _crearDropDownExamenCategoria() {
    return FutureBuilder(
      future: _combosService.getCategoriasExamenes(),
      builder: (BuildContext context,
          AsyncSnapshot<List<ExamenCategoriaModel>> snapshot) {
        if (!snapshot.hasData)
          return Center(
            child: CircularProgressIndicator(),
          );
        final lista = snapshot.data;
        return Padding(
          padding: EdgeInsets.only(left: 8.0, right: 8.0),
          child: InputDecorator(
            decoration:
                inputsDecorations('Examen categoria', FontAwesomeIcons.flask),
            child: DropdownButtonHideUnderline(
              child: DropdownButton(
                value: _examenCategoriaId,
                isDense: true,
                onChanged: (value) {
                  blocNoti.clearList();
                  blocNoti.getTiposExamenes(value);
                  _examenCategoriaId = value;
                  _examenTipoId = null;
                  _examenDetalleId = null;
                  FocusScope.of(context).requestFocus(FocusNode());
                },
                items: lista.map((x) {
                  return DropdownMenuItem(
                    value: x.examenCategoriaId,
                    child: Text(
                      x.nombre,
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _crearDropDownExamenTipo() {
    return AnimatedBuilder(
      animation: blocNoti,
      builder: (BuildContext context, Widget child) {
        return (blocNoti.loading)
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Padding(
                padding: EdgeInsets.only(left: 8.0, right: 8.0),
                child: InputDecorator(
                  decoration:
                      inputsDecorations('Examen Tipo', FontAwesomeIcons.flask),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton(
                      isExpanded: true,
                      icon: Icon(Icons.arrow_drop_down),
                      isDense: true,
                      value: _examenTipoId,
                      onChanged: (value) {
                        _examenTipoId = value;
                        _examenDetalleId = null;
                        blocNoti.getDetalleExamenes(value, _examenCategoriaId);
                        setState(() {
                          if (value == 12) {
                            _habilitarNombre = false;
                          } else {
                            _habilitarNombre = true;
                          }
                        });
                      },
                      items: blocNoti.listaTipos
                          .map(
                            (t) => DropdownMenuItem(
                              value: t.examenTipoId,
                              child: Text(
                                t.nombre,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ),
              );
      },
    );
  }

  Widget _crearDropDownExamenDetalle() {
    return AnimatedBuilder(
      animation: blocNoti,
      builder: (BuildContext context, Widget child) {
        return (blocNoti.loadingDetalles)
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Padding(
                padding: EdgeInsets.only(left: 8.0, right: 8.0),
                child: InputDecorator(
                  decoration: inputsDecorations(
                      'Examen Detalle', FontAwesomeIcons.flask),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton(
                      isExpanded: true,
                      icon: Icon(Icons.arrow_drop_down),
                      isDense: true,
                      value: _examenDetalleId,
                      onChanged: (value) {
                        _examenDetalleId = value;
                        setState(() {});
                      },
                      items: blocNoti.listaDetalles
                          .map(
                            (t) => DropdownMenuItem(
                              value: t.examenDetalleId,
                              child: Text(
                                '${t.nombre.toLowerCase()}',
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ),
              );
      },
    );
  }

  _campoNombre() {
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0),
      child: TextFormField(
        controller: _nombreController,
        onSaved: (value) => _examen.nombre = value,
        keyboardType: TextInputType.text,
        decoration: inputsDecorations('Nombre', Icons.note),
        readOnly: _habilitarNombre,
      ),
    );
  }

  String validaTexto(String value) {
    if (value.length < 3) {
      return 'Campo obligatorio';
    } else {
      return null;
    }
  }

  Widget _espacio() {
    return SizedBox(
      height: 10.0,
    );
  }

  _campoNotas() {
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0),
      child: TextFormField(
        controller: _notasController,
        onSaved: (value) => _examen.notas = value,
        maxLines: 2,
        keyboardType: TextInputType.text,
        decoration: inputsDecorations('Notas adicionales', Icons.note),
      ),
    );
  }

  Widget _crearBotones(BuildContext context, PreclinicaViewModel preclinica) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        RaisedButton.icon(
            color: Theme.of(context).primaryColor,
            onPressed: () => _guardar(context, preclinica),
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
    if (_examenTipoId == null) {
      mostrarFlushBar(context, Colors.black, 'Info',
          'Seleccione el tipo de examen', 2, Icons.info, Colors.white);
    } else {
      _formkey.currentState.save();
      _examen.examenCategoriaId = _examenCategoriaId;
      _examen.examenTipoId = _examenTipoId;
      _examen.examenDetalleId = _examenDetalleId == null ? 0 : _examenDetalleId;
      await _pr.show();

      ExamenIndicadoModel _examenIndicadoGuard =
          await blocNoti.addExamen(_examen);
      if (_examenIndicadoGuard != null) {
        await _pr.hide();
        mostrarFlushBar(context, Colors.green, 'Info', 'Datos Guardados', 1,
            Icons.info, Colors.black);
        Future.delayed(Duration(seconds: 1)).then((_) =>
            Navigator.pushReplacementNamed(context, 'examenes_indicados',
                arguments: preclinica));
      } else {
        await _pr.hide();
        mostrarFlushBar(context, Colors.red, 'Info', 'Ha ocurrido un error', 2,
            Icons.info, Colors.white);
      }
    }
  }
}
