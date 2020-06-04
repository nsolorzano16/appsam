import 'package:appsam/src/blocs/diagnosticos_bloc.dart';
import 'package:appsam/src/models/diagnosticos_model.dart';
import 'package:appsam/src/models/paginados/preclinica_paginadoVM.dart';
import 'package:appsam/src/models/usuario_model.dart';
import 'package:appsam/src/utils/storage_util.dart';
import 'package:appsam/src/utils/utils.dart';
import 'package:appsam/src/widgets/drawer.dart';
import 'package:appsam/src/widgets/firebaseMessageWrapper.dart';

import 'package:flutter/material.dart';
import 'package:getflutter/getflutter.dart';
import 'package:progress_dialog/progress_dialog.dart';

class CrearDiagnosticosPage extends StatefulWidget {
  static final String routeName = 'crear_diagnosticos';

  @override
  _CrearDiagnosticosPageState createState() => _CrearDiagnosticosPageState();
}

class _CrearDiagnosticosPageState extends State<CrearDiagnosticosPage> {
  final UsuarioModel _usuario =
      usuarioModelFromJson(StorageUtil.getString('usuarioGlobal'));
  final List<Diagnosticos> _listaDiagnosticos = new List<Diagnosticos>();
  final DiagnosticosBloc _diagnosticosBloc = new DiagnosticosBloc();

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final GlobalKey<FormState> _formkeyEditar = GlobalKey<FormState>();

  final _problemasClinicosController = new TextEditingController();
  final _editarproblemasClinicosController = new TextEditingController();

  final GlobalKey<ScaffoldState> mScaffoldState =
      new GlobalKey<ScaffoldState>();

  Future<List<Diagnosticos>> _diagnosticosFuture;

  @override
  void initState() {
    super.initState();
    StorageUtil.putString('ultimaPagina', CrearDiagnosticosPage.routeName);
  }

  @override
  void dispose() {
    _problemasClinicosController.dispose();
    _editarproblemasClinicosController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final PreclinicaViewModel _preclinica =
        ModalRoute.of(context).settings.arguments;

    _diagnosticosFuture = _diagnosticosBloc.getDiagnosticos(
        _preclinica.pacienteId, _preclinica.doctorId, _preclinica.preclinicaId);

    return WillPopScope(
        child: FirebaseMessageWrapper(
          child: Scaffold(
              key: mScaffoldState,
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
                future: _diagnosticosFuture,
                builder: (BuildContext context,
                    AsyncSnapshot<List<Diagnosticos>> snapshot) {
                  if (snapshot.hasData) {
                    _listaDiagnosticos.clear();
                    _listaDiagnosticos.addAll(snapshot.data);
                    return Column(
                      children: <Widget>[
                        Container(
                            alignment: Alignment.centerLeft,
                            padding: EdgeInsets.only(
                              left: 20.0,
                              top: 10.0,
                              right: 10.0,
                            ),
                            child: ListTile(
                              title: Text('Diagnosticos'),
                              subtitle:
                                  Text('Click en el boton \"+\" para agregar'),
                            )),
                        Divider(
                          thickness: 2.0,
                          indent: 20.0,
                          endIndent: 20.0,
                        ),
                        Flexible(
                            child: ListView(
                          children: items(_listaDiagnosticos),
                        ))
                      ],
                    );
                  } else {
                    return loadingIndicator(context);
                  }
                },
              ),
              floatingActionButton: FloatingActionButton(
                backgroundColor: Theme.of(context).primaryColor,
                onPressed: () => _dialogAdd(context, _preclinica),
                child: Icon(Icons.add),
              )),
        ),
        onWillPop: () async => false);
  } //fin build

  List<Widget> items(List<Diagnosticos> lista) {
    return lista.map((f) {
      return Column(
        children: <Widget>[
          ExpansionTile(
            title: Text(
              'Problema Clinico: ${f.problemasClinicos}',
              overflow: TextOverflow.ellipsis,
            ),
            leading: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                IconButton(
                    icon: Icon(
                      Icons.edit,
                      size: 16.0,
                      color: Theme.of(context).primaryColor,
                    ),
                    onPressed: () {
                      _dialogEdit(context, f);
                    }),
                IconButton(
                  icon: Icon(
                    Icons.delete,
                    color: Theme.of(context).primaryColor,
                    size: 16.0,
                  ),
                  onPressed: () =>
                      confirmAction(context, 'Desea eliminar el registro', f),
                )
              ],
            ),
            children: <Widget>[
              Container(
                  padding: EdgeInsets.all(10.0),
                  child: GFCard(
                    elevation: 3.0,
                    content: Text(
                      f.problemasClinicos,
                      textAlign: TextAlign.justify,
                    ),
                  ))
            ],
          ),
        ],
      );
    }).toList();
  }

  _campoProblemasClinicos(Diagnosticos diagnostico) {
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0, top: 10.0),
      child: TextFormField(
        initialValue: diagnostico.problemasClinicos,
        onSaved: (value) => diagnostico.problemasClinicos = value,
        controller: _problemasClinicosController,
        keyboardType: TextInputType.text,
        maxLines: 3,
        decoration: inputsDecorations('Problemas Clinicos', Icons.note),
      ),
    );
  }

  _campoProblemasClinicosEditar(Diagnosticos diagnostico) {
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0, top: 10.0),
      child: TextFormField(
        controller: _editarproblemasClinicosController,
        onSaved: (value) => diagnostico.problemasClinicos = value,
        maxLines: 3,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(hintText: 'Problemas Clinicos'),
      ),
    );
  }

  void _dialogAdd(BuildContext context, PreclinicaViewModel preclinica) {
    final _diagnostico = new Diagnosticos();
    _diagnostico.diagnosticoId = 0;
    _diagnostico.doctorId = preclinica.doctorId;
    _diagnostico.pacienteId = preclinica.pacienteId;
    _diagnostico.preclinicaId = preclinica.preclinicaId;
    _diagnostico.activo = true;
    _diagnostico.creadoPor = _usuario.userName;
    _diagnostico.creadoFecha = DateTime.now();
    _diagnostico.modificadoPor = _usuario.userName;
    _diagnostico.modificadoFecha = _usuario.modificadoFecha;
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  _formularioAgregar(_diagnostico, context),
                ],
              ),
            ),
          );
        },
        barrierDismissible: false);
  }

  void _dialogEdit(BuildContext context, Diagnosticos diagnostico) {
    _editarproblemasClinicosController.text = diagnostico.problemasClinicos;
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  _formularioEditar(diagnostico, context),
                ],
              ),
            ),
          );
        },
        barrierDismissible: false);
  }

  Widget _formularioAgregar(Diagnosticos diagnostico, BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5.0),
      child: Form(
          key: _formkey,
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 10.0),
                child: Text(
                  'Nota: *El formulario no puede estar vacio*',
                  style: TextStyle(color: Colors.red),
                ),
              ),
              _campoProblemasClinicos(diagnostico),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  FlatButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        'Cancelar',
                      )),
                  FlatButton(
                      onPressed: () => _guardar(diagnostico, context),
                      child: Text(
                        'Guardar',
                      ))
                ],
              )
            ],
          )),
    );
  }

  Widget _formularioEditar(Diagnosticos diagnostico, BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5.0),
      child: Form(
          key: _formkeyEditar,
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 10.0),
                child: Text(
                  'Nota: *El formulario no puede estar vacio*',
                  style: TextStyle(color: Colors.red),
                ),
              ),
              _campoProblemasClinicosEditar(diagnostico),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  FlatButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        'Cancelar',
                        style: TextStyle(color: Colors.blue),
                      )),
                  FlatButton(
                      onPressed: () => _editar(diagnostico, context),
                      child: Text(
                        'Editar',
                        style: TextStyle(color: Colors.blue),
                      ))
                ],
              )
            ],
          )),
    );
  }

  void _editar(Diagnosticos diagnostico, BuildContext context) async {
    if (_editarproblemasClinicosController.text.isEmpty) {
    } else {
      _formkeyEditar.currentState.save();

      _editarproblemasClinicosController.text = '';

      final item = _listaDiagnosticos.firstWhere(
          (item) => item.diagnosticoId == diagnostico.diagnosticoId,
          orElse: null);
      if (item != null) {
        item.problemasClinicos = diagnostico.problemasClinicos;
      }
      Navigator.pop(context);
      await editarBaseDatos(context);
      final snackBar = SnackBar(
          backgroundColor: Colors.green,
          content: Row(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Icon(Icons.info),
              Padding(
                padding: EdgeInsets.only(left: 5.0),
                child: Text('Datos guardados'),
              )
            ],
          ));
      mScaffoldState.currentState.showSnackBar(snackBar);

      setState(() {});
    }
  }

  void _guardar(Diagnosticos diagnostico, BuildContext context) async {
    if (_problemasClinicosController.text.isEmpty) {
    } else {
      _formkey.currentState.save();
      _listaDiagnosticos.add(diagnostico);
      _problemasClinicosController.text = '';

      Navigator.pop(context);
      await salvarBaseDatos(context);
      final snackBar = SnackBar(
          backgroundColor: Colors.green,
          content: Row(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Icon(Icons.info),
              Padding(
                padding: EdgeInsets.only(left: 5.0),
                child: Text('Datos guardados'),
              )
            ],
          ));
      mScaffoldState.currentState.showSnackBar(snackBar);

      setState(() {});
    }
  }

  salvarBaseDatos(BuildContext context) async {
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
    final List<Diagnosticos> lista =
        await _diagnosticosBloc.addListaDiagnosticos(_listaDiagnosticos);

    await _pr.hide();
    if (lista != null) {
      _listaDiagnosticos.replaceRange(0, _listaDiagnosticos.length, lista);
    } else {
      mostrarFlushBar(context, Colors.red, 'Info', 'Ha ocurrido un error', 3,
          Icons.info, Colors.black);
    }
  }

  editarBaseDatos(BuildContext context) async {
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
    final List<Diagnosticos> lista =
        await _diagnosticosBloc.updateListaDiagnosticos(_listaDiagnosticos);
    await _pr.hide();

    if (lista != null) {
      _listaDiagnosticos.replaceRange(0, _listaDiagnosticos.length, lista);
    } else {
      mostrarFlushBar(context, Colors.red, 'Info', 'Ha ocurrido un error', 3,
          Icons.info, Colors.black);
    }
  }

  void _desactivar(Diagnosticos f) async {
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
    f.activo = false;
    bool resp = await _diagnosticosBloc.desactivar(f);
    _listaDiagnosticos.remove(f);
    await _pr.hide();
    if (resp) {
      mostrarFlushBar(context, Colors.green, 'Info', 'Datos Guardados', 2,
          Icons.info, Colors.black);
    } else {
      mostrarFlushBar(context, Colors.red, 'Info', 'Ha ocurrido un error', 3,
          Icons.info, Colors.black);
    }
    setState(() {});
  }

  void confirmAction(BuildContext context, String texto, Diagnosticos f) {
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
        _desactivar(f);
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
        builder: (context) {
          return alert;
        },
        barrierDismissible: false);
  }
}
