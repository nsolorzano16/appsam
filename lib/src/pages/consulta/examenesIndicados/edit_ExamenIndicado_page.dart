import 'package:appsam/src/blocs/examenes_bloc.dart';
import 'package:appsam/src/models/examenCategoria_model.dart';
import 'package:appsam/src/models/examenDetalle_model.dart';
import 'package:appsam/src/models/examenTipo_model.dart';
import 'package:appsam/src/models/examenesIndicados_viewmodel.dart';
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

class EditarExamenIndicadoPage extends StatefulWidget {
  static final String routeName = 'editar_examen_indicado';
  final ExamenesIndicadosViewModel examen;
  final PreclinicaViewModel preclinica;

  const EditarExamenIndicadoPage({this.examen, this.preclinica});

  @override
  _EditarExamenIndicadoPageState createState() =>
      _EditarExamenIndicadoPageState();
}

class _EditarExamenIndicadoPageState extends State<EditarExamenIndicadoPage> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final ExamenesIndicadosViewModel _examen = new ExamenesIndicadosViewModel();

  final _examenesBloc = new ExamenesBloc();
  final UsuarioModel _usuario =
      usuarioModelFromJson(StorageUtil.getString('usuarioGlobal'));

  final _combosService = new CombosService();
  final _comboModel = new ListCombosExamenes(
      listCategorias: [], listExamenDetalle: [], listExamenTipo: []);

  final TextEditingController _nombreController = new TextEditingController();
  final TextEditingController _notasController = new TextEditingController();

  String labelBoton = 'Editar';

  @override
  void initState() {
    super.initState();
    StorageUtil.putString('ultimaPagina', EditarExamenIndicadoPage.routeName);
    _examen.examenIndicadoId = widget.examen.examenIndicadoId;
    _examen.pacienteId = widget.examen.pacienteId;
    _examen.doctorId = widget.examen.doctorId;
    _examen.preclinicaId = widget.examen.preclinicaId;
    _examen.activo = widget.examen.activo;
    _examen.creadoPor = widget.examen.creadoPor;
    _examen.creadoFecha = widget.examen.creadoFecha;
    _examen.modificadoPor = _usuario.userName;
    _examen.modificadoFecha = DateTime.now();
    _comboModel.examenCategoriaId = widget.examen.examenCategoriaId;
    _comboModel.examenTipoId = widget.examen.examenTipoId;
    _comboModel.examenDetalleId = (widget.examen.examenDetalleId != 0)
        ? widget.examen.examenDetalleId
        : null;
    _nombreController.text = widget.examen.nombre;
    _notasController.text = widget.examen.notas;
  }

  @override
  void dispose() {
    super.dispose();
    _examenesBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                          context, 'examenes_indicados',
                          arguments: widget.preclinica))
                ],
              ),
              drawer: MenuWidget(),
              body: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    GFCard(
                      title: GFListTile(
                          color: Colors.red,
                          title: Text('Editar examen',
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
                            _crearDropDownExamenTipo(
                                _comboModel.examenCategoriaId),
                            _crearDropDownExamenDetalle(
                                _comboModel.examenCategoriaId,
                                _comboModel.examenTipoId),
                            _campoNombre(),
                            _espacio(),
                            _campoNotas(),
                            _crearBotones(context, widget.preclinica)
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
        final lista = snapshot.data;
        if (lista != null) {
          return Padding(
            padding: EdgeInsets.only(left: 8.0, right: 8.0),
            child: InputDecorator(
              decoration:
                  inputsDecorations('Examen categoria', FontAwesomeIcons.flask),
              child: StreamBuilder(
                stream: _examenesBloc.combosListStream,
                initialData: _comboModel,
                builder: (BuildContext context,
                    AsyncSnapshot<ListCombosExamenes> snapshot) {
                  final categoria = snapshot.data;
                  return DropdownButtonHideUnderline(
                      child: DropdownButton(
                    value: categoria.examenCategoriaId,
                    isDense: true,
                    onChanged: (value) async {
                      _comboModel.examenCategoriaId = value;

                      final listaTipos =
                          await _combosService.getTiposExamenes(value);

                      _comboModel.listExamenTipo.clear();
                      _comboModel.listExamenTipo.addAll(listaTipos);
                      _comboModel.listExamenDetalle.clear();
                      _comboModel.examenTipoId = null;
                      _examenesBloc.onChangeCombosList(_comboModel);

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
                  ));
                },
              ),
            ),
          );
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }

  Widget _crearDropDownExamenTipo(int categoriaId) {
    return FutureBuilder(
      future: _combosService.getTiposExamenes(categoriaId),
      builder: (BuildContext context,
          AsyncSnapshot<List<ExamenTipoModel>> snapshot) {
        if (snapshot.hasData) {
          _comboModel.listExamenTipo.clear();
          _comboModel.listExamenTipo.addAll(snapshot.data);
          _examenesBloc.onChangeCombosList(_comboModel);
        }
        return StreamBuilder(
          stream: _examenesBloc.combosListStream,
          builder: (BuildContext context,
              AsyncSnapshot<ListCombosExamenes> snapshot) {
            if (snapshot.data == null) {
              return CircularProgressIndicator();
            } else {
              final lista = snapshot.data.listExamenTipo;
              return Padding(
                  padding: EdgeInsets.only(left: 8.0, right: 8.0),
                  child: InputDecorator(
                      decoration: inputsDecorations(
                          'Tipo de examen', FontAwesomeIcons.flask),
                      child: DropdownButtonHideUnderline(
                          child: DropdownButton(
                        icon: Icon(Icons.arrow_drop_down),
                        isDense: true,
                        value: snapshot.data.examenTipoId,
                        onChanged: (value) async {
                          _comboModel.examenTipoId = value;
                          final detalles =
                              await _combosService.getDetalleExamenes(
                                  value, _comboModel.examenCategoriaId);
                          _comboModel.listExamenDetalle.clear();
                          _comboModel.listExamenDetalle.addAll(detalles);
                          _comboModel.examenDetalleId = null;

                          _examenesBloc.onChangeCombosList(_comboModel);

                          FocusScope.of(context).requestFocus(FocusNode());
                        },
                        items: (lista.length == 0)
                            ? []
                            : lista.map((x) {
                                return DropdownMenuItem(
                                  value: x.examenTipoId,
                                  child: Text(
                                    x.nombre,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                );
                              }).toList(),
                      ))));
            }
          },
        );
      },
    );
  }

  Widget _crearDropDownExamenDetalle(int categoriaId, int tipoId) {
    return FutureBuilder(
      future: _combosService.getDetalleExamenes(tipoId, categoriaId),
      builder: (BuildContext context,
          AsyncSnapshot<List<ExamenDetalleModel>> snapshot) {
        if (snapshot.hasData) {
          _comboModel.listExamenDetalle.clear();
          _comboModel.listExamenDetalle.addAll(snapshot.data);
          _examenesBloc.onChangeCombosList(_comboModel);
        }
        return StreamBuilder(
          stream: _examenesBloc.combosListStream,
          builder: (BuildContext context,
              AsyncSnapshot<ListCombosExamenes> snapshot) {
            if (snapshot.data == null) {
              return CircularProgressIndicator();
            } else {
              final lista = snapshot.data.listExamenDetalle;
              return Padding(
                  padding: EdgeInsets.only(left: 8.0, right: 8.0),
                  child: InputDecorator(
                      decoration: inputsDecorations(
                          'Examen Detalle', FontAwesomeIcons.flask),
                      child: DropdownButtonHideUnderline(
                          child: DropdownButton(
                        isExpanded: true,
                        icon: Icon(Icons.arrow_drop_down),
                        isDense: true,
                        value: snapshot.data.examenDetalleId,
                        onChanged: (value) {
                          _comboModel.examenDetalleId = value;
                          _examenesBloc.onChangeCombosList(_comboModel);
                          FocusScope.of(context).requestFocus(FocusNode());
                        },
                        items: (lista.length == 0)
                            ? []
                            : lista.map((x) {
                                return DropdownMenuItem(
                                  value: x.examenDetalleId,
                                  child: Text(
                                    x.nombre,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                );
                              }).toList(),
                      ))));
            }
          },
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
    if (_comboModel.examenTipoId == null) {
      mostrarFlushBar(context, Colors.black, 'Info',
          'Seleccione el tipo de examen', 2, Icons.info, Colors.white);
    } else {
      _formkey.currentState.save();
      _examen.examenCategoriaId = _comboModel.examenCategoriaId;
      _examen.examenTipoId = _comboModel.examenTipoId;
      _examen.examenDetalleId = (_comboModel.examenDetalleId == null)
          ? 0
          : _comboModel.examenDetalleId;
      await _pr.show();

      ExamenesIndicadosViewModel _examenIndicadoGuard;

      //guarda
      _examenIndicadoGuard = await _examenesBloc.updateExamen(_examen);

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
