import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';

import 'package:appsam/src/blocs/notas_bloc.dart';
import 'package:appsam/src/models/notas_model.dart';
import 'package:appsam/src/models/paginados/preclinica_paginadoVM.dart';
import 'package:appsam/src/models/usuario_model.dart';
import 'package:appsam/src/utils/storage_util.dart';
import 'package:appsam/src/utils/utils.dart';
import 'package:appsam/src/widgets/drawer.dart';
import 'package:getflutter/getflutter.dart';
import 'package:progress_dialog/progress_dialog.dart';

class CrearNotasPage extends StatefulWidget {
  static final String routeName = 'crear_notas';
  @override
  _CrearNotasPageState createState() => _CrearNotasPageState();
}

class _CrearNotasPageState extends State<CrearNotasPage> {
  final UsuarioModel _usuario =
      usuarioModelFromJson(StorageUtil.getString('usuarioGlobal'));
  final List<Notas> _listaNotas = new List<Notas>();
  final NotasBloc _notasBloc = new NotasBloc();

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final GlobalKey<FormState> _formkeyEditar = GlobalKey<FormState>();

  final _notasController = new TextEditingController();
  final _editarNotasController = new TextEditingController();

  final GlobalKey<ScaffoldState> mScaffoldState =
      new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    StorageUtil.putString('ultimaPagina', CrearNotasPage.routeName);
  }

  @override
  Widget build(BuildContext context) {
    final PreclinicaViewModel _preclinica =
        ModalRoute.of(context).settings.arguments;

    return Scaffold(
        key: mScaffoldState,
        appBar: AppBar(
          title: Text('Consulta'),
          actions: <Widget>[
            IconButton(icon: Icon(Icons.arrow_forward_ios), onPressed: () {})
          ],
        ),
        drawer: MenuWidget(),
        body: Column(
          children: <Widget>[
            Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(
                  left: 20.0,
                  top: 10.0,
                  right: 10.0,
                ),
                child: ListTile(
                  title: Text('Notas'),
                  subtitle: Text('Click en el boton \"+\" para agregar'),
                )),
            Divider(
              thickness: 2.0,
              indent: 20.0,
              endIndent: 20.0,
            ),
            Flexible(
                child: ListView(
              children: items(_listaNotas),
            ))
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Theme.of(context).primaryColor,
          onPressed: () => _dialogAdd(context, _preclinica),
          child: Icon(Icons.add),
        ));
  } //fin build

  List<Widget> items(List<Notas> lista) {
    return lista.map((f) {
      return Column(
        children: <Widget>[
          ExpansionTile(
            title: Text(
              'Nota: ${f.notas}',
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
                      f.notas,
                      textAlign: TextAlign.justify,
                    ),
                  ))
            ],
          ),
        ],
      );
    }).toList();
  }

  _campoNotas(Notas nota) {
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0, top: 10.0),
      child: TextFormField(
        initialValue: nota.notas,
        onSaved: (value) => nota.notas = value,
        controller: _notasController,
        keyboardType: TextInputType.text,
        maxLines: 3,
        decoration: inputsDecorations('Nota', Icons.note),
      ),
    );
  }

  _campoNotasEditar(Notas nota) {
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0, top: 10.0),
      child: TextFormField(
        controller: _editarNotasController,
        onSaved: (value) => nota.notas = value,
        maxLines: 3,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(hintText: 'Nota'),
      ),
    );
  }

  void _dialogAdd(BuildContext context, PreclinicaViewModel preclinica) {
    final _nota = new Notas();
    _nota.notaId = 0;
    _nota.doctorId = preclinica.doctorId;
    _nota.pacienteId = preclinica.pacienteId;
    _nota.activo = true;
    _nota.creadoPor = _usuario.userName;
    _nota.creadoFecha = DateTime.now();
    _nota.modificadoPor = _usuario.userName;
    _nota.modificadoFecha = _usuario.modificadoFecha;
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  _formularioAgregar(_nota, context),
                ],
              ),
            ),
          );
        },
        barrierDismissible: false);
  }

  void _dialogEdit(BuildContext context, Notas nota) {
    _editarNotasController.text = nota.notas;
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  _formularioEditar(nota, context),
                ],
              ),
            ),
          );
        },
        barrierDismissible: false);
  }

  Widget _formularioAgregar(Notas nota, BuildContext context) {
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
              _campoNotas(nota),
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
                      onPressed: () => _guardar(nota, context),
                      child: Text(
                        'Guardar',
                        style: TextStyle(color: Colors.blue),
                      ))
                ],
              )
            ],
          )),
    );
  }

  Widget _formularioEditar(Notas nota, BuildContext context) {
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
              _campoNotasEditar(nota),
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
                      onPressed: () => _editar(nota, context),
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

  void _editar(Notas nota, BuildContext context) async {
    if (_editarNotasController.text.isEmpty) {
    } else {
      _formkeyEditar.currentState.save();

      _editarNotasController.text = '';

      final item = _listaNotas.firstWhere((item) => item.notaId == nota.notaId,
          orElse: null);
      if (item != null) {
        item.notas = nota.notas;
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

  void _guardar(Notas nota, BuildContext context) async {
    if (_notasController.text.isEmpty) {
    } else {
      _formkey.currentState.save();
      _listaNotas.add(nota);
      _notasController.text = '';

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
    final List<Notas> lista = await _notasBloc.addListaNotas(_listaNotas);

    _pr.hide();
    if (lista != null) {
      _listaNotas.replaceRange(0, _listaNotas.length, lista);
    } else {
      mostrarFlushBar(context, Colors.red, 'Info', 'Ha ocurrido un error', 3,
          FlushbarPosition.BOTTOM, Icons.info, Colors.black);
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
    final List<Notas> lista = await _notasBloc.updateListaNotas(_listaNotas);
    _pr.hide();

    if (lista != null) {
      _listaNotas.replaceRange(0, _listaNotas.length, lista);
    } else {
      mostrarFlushBar(context, Colors.red, 'Info', 'Ha ocurrido un error', 3,
          FlushbarPosition.BOTTOM, Icons.info, Colors.black);
    }
  }

  void _desactivar(Notas f) async {
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
    bool resp = await _notasBloc.desactivar(f);
    _listaNotas.remove(f);
    _pr.hide();
    if (resp) {
      mostrarFlushBar(context, Colors.green, 'Info', 'Datos Guardados', 2,
          FlushbarPosition.TOP, Icons.info, Colors.black);
    } else {
      mostrarFlushBar(context, Colors.red, 'Info', 'Ha ocurrido un error', 3,
          FlushbarPosition.BOTTOM, Icons.info, Colors.black);
    }
    setState(() {});
  }

  void confirmAction(BuildContext context, String texto, Notas f) {
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
}
