import 'package:appsam/src/blocs/farmacos_bloc.dart';
import 'package:appsam/src/models/farmacosUsoActual_model.dart';
import 'package:appsam/src/models/paginados/preclinica_paginadoVM.dart';
import 'package:appsam/src/models/usuario_model.dart';
import 'package:appsam/src/utils/storage_util.dart';
import 'package:appsam/src/utils/utils.dart';
import 'package:appsam/src/widgets/drawer.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';

class CrearFarmacosUsoActualPage extends StatefulWidget {
  static final String routeName = 'crear_farmacos_uso_actual';
  @override
  _CrearFarmacosUsoActualPageState createState() =>
      _CrearFarmacosUsoActualPageState();
}

class _CrearFarmacosUsoActualPageState
    extends State<CrearFarmacosUsoActualPage> {
  final UsuarioModel _usuario =
      usuarioModelFromJson(StorageUtil.getString('usuarioGlobal'));
  final List<FarmacosUsoActual> _listaFarmacos = new List<FarmacosUsoActual>();
  final FarmacosUsoActualBloc _farmacosBloc = new FarmacosUsoActualBloc();

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final GlobalKey<FormState> _formkeyEditar = GlobalKey<FormState>();
  final _nombreController = new TextEditingController();
  final _concentracionController = new TextEditingController();
  final _dosisController = new TextEditingController();
  final _tiempoController = new TextEditingController();
  final _notasController = new TextEditingController();

  final _editarnombreController = new TextEditingController();
  final _editarconcentracionController = new TextEditingController();
  final _editardosisController = new TextEditingController();
  final _editartiempoController = new TextEditingController();
  final _editarnotasController = new TextEditingController();

  int i = 0;

  final GlobalKey<ScaffoldState> mScaffoldState =
      new GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
    StorageUtil.putString('ultimaPagina', CrearFarmacosUsoActualPage.routeName);
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
            IconButton(
                icon: Icon(Icons.arrow_forward_ios),
                onPressed: () {
                  showConfirmDialog(
                      context, 'crear_examen_fisico', _preclinica);
                })
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
                  title: Text('Farmacos de Uso Actual'),
                  subtitle: Text('Click en el boton \"+\" para agregar'),
                )),
            Divider(
              thickness: 2.0,
              indent: 20.0,
              endIndent: 20.0,
            ),
            Flexible(
              child: ListView(
                children: items(_listaFarmacos),
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _dialogAdd(context, _preclinica),
          child: Icon(Icons.add),
        ));
  }

  List<Widget> items(List<FarmacosUsoActual> lista) {
    return lista.map((f) {
      i++;
      return Column(
        children: <Widget>[
          ExpansionTile(
            title: Text('Nombre: ${f.nombre}'),
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
                      _dialogEdit(context, f, i);
                    }),
                IconButton(
                  icon: Icon(
                    Icons.delete,
                    color: Theme.of(context).primaryColor,
                    size: 16.0,
                  ),
                  onPressed: () => _desactivar(f),
                )
              ],
            ),
            children: <Widget>[
              Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.all(10.0),
                  child: Table(
                    children: [
                      TableRow(children: [
                        Text('Concentracion'),
                        Text(
                          f.concentracion,
                          textAlign: TextAlign.justify,
                        )
                      ]),
                      TableRow(children: [
                        Text('Dosis'),
                        Text(
                          f.dosis,
                          textAlign: TextAlign.justify,
                        )
                      ]),
                      TableRow(children: [
                        Text('Tiempo'),
                        Text(
                          f.tiempo,
                          textAlign: TextAlign.justify,
                        )
                      ]),
                      TableRow(children: [
                        Text('Notas'),
                        Text(
                          f.notas,
                          textAlign: TextAlign.justify,
                        )
                      ])
                    ],
                  ))
            ],
          ),
        ],
      );
    }).toList();
  }

  void _dialogAdd(BuildContext context, PreclinicaViewModel preclinica) {
    final _farmaco = new FarmacosUsoActual();
    _farmaco.farmacoId = 0;
    _farmaco.doctorId = preclinica.doctorId;
    _farmaco.pacienteId = preclinica.pacienteId;
    _farmaco.activo = true;
    _farmaco.creadoPor = _usuario.userName;
    _farmaco.creadoFecha = DateTime.now();
    _farmaco.modificadoPor = _usuario.userName;
    _farmaco.modificadoFecha = _usuario.modificadoFecha;
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  _formularioAgregar(_farmaco, context),
                ],
              ),
            ),
          );
        },
        barrierDismissible: false);
  }

  void _dialogEdit(BuildContext context, FarmacosUsoActual farmaco, int index) {
    _editarnombreController.text = farmaco.nombre;
    _editarconcentracionController.text = farmaco.concentracion;
    _editardosisController.text = farmaco.dosis;
    _editartiempoController.text = farmaco.tiempo;
    _editarnotasController.text = farmaco.notas;
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  _formularioEditar(farmaco, context, index),
                ],
              ),
            ),
          );
        },
        barrierDismissible: false);
  }

  _campoNombreFarmaco(FarmacosUsoActual farmaco) {
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0, top: 10.0),
      child: TextFormField(
        initialValue: farmaco.nombre,
        onSaved: (value) => farmaco.nombre = value,
        controller: _nombreController,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(hintText: 'Nombre'),
      ),
    );
  }

  _campoConcentracion(FarmacosUsoActual farmaco) {
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0, top: 10.0),
      child: TextFormField(
        initialValue: farmaco.concentracion,
        onSaved: (value) => farmaco.concentracion = value,
        controller: _concentracionController,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(hintText: 'Concentración'),
      ),
    );
  }

  _campoDosis(FarmacosUsoActual farmaco) {
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0, top: 10.0),
      child: TextFormField(
        initialValue: farmaco.dosis,
        onSaved: (value) => farmaco.dosis = value,
        controller: _dosisController,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(hintText: 'Dosis'),
      ),
    );
  }

  _campoTiempo(FarmacosUsoActual farmaco) {
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0, top: 10.0),
      child: TextFormField(
        initialValue: farmaco.tiempo,
        onSaved: (value) => farmaco.tiempo = value,
        controller: _tiempoController,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(hintText: 'Tiempo'),
      ),
    );
  }

  _campoNotas(FarmacosUsoActual farmaco) {
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0, top: 10.0),
      child: TextFormField(
        controller: _notasController,
        initialValue: farmaco.notas,
        onSaved: (value) => farmaco.notas = value,
        maxLines: 2,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(hintText: 'Notas adicionales'),
      ),
    );
  }

  _campoNombreFarmacoEditar(FarmacosUsoActual farmaco) {
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0, top: 10.0),
      child: TextFormField(
        controller: _editarnombreController,
        onSaved: (value) => farmaco.nombre = value,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(hintText: 'Nombre'),
      ),
    );
  }

  _campoConcentracionEditar(FarmacosUsoActual farmaco) {
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0, top: 10.0),
      child: TextFormField(
        controller: _editarconcentracionController,
        onSaved: (value) => farmaco.concentracion = value,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(hintText: 'Concentración'),
      ),
    );
  }

  _campoDosisEditar(FarmacosUsoActual farmaco) {
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0, top: 10.0),
      child: TextFormField(
        controller: _editardosisController,
        onSaved: (value) => farmaco.dosis = value,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(hintText: 'Dosis'),
      ),
    );
  }

  _campoTiempoEditar(FarmacosUsoActual farmaco) {
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0, top: 10.0),
      child: TextFormField(
        controller: _editartiempoController,
        onSaved: (value) => farmaco.tiempo = value,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(hintText: 'Tiempo'),
      ),
    );
  }

  _campoNotasEditar(FarmacosUsoActual farmaco) {
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0, top: 10.0),
      child: TextFormField(
        controller: _editarnotasController,
        onSaved: (value) => farmaco.notas = value,
        maxLines: 2,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(hintText: 'Notas adicionales'),
      ),
    );
  }

  Widget _formularioAgregar(FarmacosUsoActual farmaco, BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5.0),
      child: Form(
          key: _formkey,
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 3.0),
                child: Text(
                  'Nota: *El formulario no puede estar vacio*',
                  style: TextStyle(color: Colors.red),
                ),
              ),
              _campoNombreFarmaco(farmaco),
              _campoConcentracion(farmaco),
              _campoDosis(farmaco),
              _campoTiempo(farmaco),
              _campoNotas(farmaco),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  FlatButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Cancelar')),
                  FlatButton(
                      onPressed: () => _guardar(farmaco, context),
                      child: Text('Guardar'))
                ],
              )
            ],
          )),
    );
  }

  Widget _formularioEditar(
      FarmacosUsoActual farmaco, BuildContext context, int index) {
    return Container(
      padding: EdgeInsets.all(5.0),
      child: Form(
          key: _formkeyEditar,
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 3.0),
                child: Text(
                  'Nota: *El formulario no puede estar vacio*',
                  style: TextStyle(color: Colors.red),
                ),
              ),
              _campoNombreFarmacoEditar(farmaco),
              _campoConcentracionEditar(farmaco),
              _campoDosisEditar(farmaco),
              _campoTiempoEditar(farmaco),
              _campoNotasEditar(farmaco),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  FlatButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Cancelar')),
                  FlatButton(
                      onPressed: () => _editar(farmaco, context, index),
                      child: Text('Editar'))
                ],
              )
            ],
          )),
    );
  }

  void _editar(
      FarmacosUsoActual farmaco, BuildContext context, int index) async {
    if (_editarnombreController.text.isEmpty &&
        _editarconcentracionController.text.isEmpty &&
        _editardosisController.text.isEmpty &&
        _editartiempoController.text.isEmpty &&
        _editarnotasController.text.isEmpty) {
    } else {
      _formkeyEditar.currentState.save();

      _editarnombreController.text = '';
      _editarconcentracionController.text = '';
      _editardosisController.text = '';
      _editartiempoController.text = '';
      _editarnotasController.text = '';
      final item = _listaFarmacos.firstWhere(
          (item) => item.farmacoId == farmaco.farmacoId,
          orElse: null);
      if (item != null) {
        item.nombre = farmaco.nombre;
        item.concentracion = farmaco.concentracion;
        item.dosis = farmaco.dosis;
        item.tiempo = farmaco.tiempo;
        item.notas = farmaco.notas;
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

  void _guardar(FarmacosUsoActual farmaco, BuildContext context) async {
    if (_nombreController.text.isEmpty &&
        _concentracionController.text.isEmpty &&
        _dosisController.text.isEmpty &&
        _tiempoController.text.isEmpty &&
        _notasController.text.isEmpty) {
    } else {
      _formkey.currentState.save();
      _listaFarmacos.add(farmaco);
      _nombreController.text = '';
      _concentracionController.text = '';
      _dosisController.text = '';
      _tiempoController.text = '';
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
    final List<FarmacosUsoActual> lista =
        await _farmacosBloc.addListaFarmacos(_listaFarmacos);

    _pr.hide();
    if (lista != null) {
      _listaFarmacos.replaceRange(0, _listaFarmacos.length, lista);
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
    final List<FarmacosUsoActual> lista =
        await _farmacosBloc.updateListaFarmacos(_listaFarmacos);
    _pr.hide();

    if (lista != null) {
      _listaFarmacos.replaceRange(0, _listaFarmacos.length, lista);
    } else {
      mostrarFlushBar(context, Colors.red, 'Info', 'Ha ocurrido un error', 3,
          FlushbarPosition.BOTTOM, Icons.info, Colors.black);
    }
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
        builder: (BuildContext context) {
          return alert;
        },
        barrierDismissible: false);
  }

  void _desactivar(FarmacosUsoActual f) async {
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
    bool resp = await _farmacosBloc.desactivar(f);
    _listaFarmacos.remove(f);
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
}