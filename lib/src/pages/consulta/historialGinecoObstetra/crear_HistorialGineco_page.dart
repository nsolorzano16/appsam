import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:getflutter/getflutter.dart';
import 'package:intl/intl.dart';
import 'package:progress_dialog/progress_dialog.dart';

import 'package:appsam/src/models/paginados/preclinica_paginadoVM.dart';
import 'package:appsam/src/utils/utils.dart';
import 'package:appsam/src/widgets/drawer.dart';
import 'package:appsam/src/blocs/historialGineco_bloc.dart';
import 'package:appsam/src/models/historialGinecoObstetra_model.dart';
import 'package:appsam/src/models/usuario_model.dart';
import 'package:appsam/src/utils/storage_util.dart';

class CrearHistorialGinecoObstetraPage extends StatefulWidget {
  static final String routeName = 'crear_historial_gineco';
  @override
  _CrearHistorialGinecoObstetraPageState createState() =>
      _CrearHistorialGinecoObstetraPageState();
}

class _CrearHistorialGinecoObstetraPageState
    extends State<CrearHistorialGinecoObstetraPage> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final HistorialGinecoObstetra _historial = new HistorialGinecoObstetra();
  final UsuarioModel _usuario =
      usuarioModelFromJson(StorageUtil.getString('usuarioGlobal'));
  final _historialBloc = new HistorialGinecoObstetraBloc();
  bool quieroEditar = true;
  String labelBoton = 'Guardar';
  DateTime pickedMenarquia;
  DateTime pickedFur;
  DateTime pickedMenopausia;

  TextEditingController _menarquiaController = new TextEditingController();
  TextEditingController _furController = new TextEditingController();
  TextEditingController _sgController = new TextEditingController();
  TextEditingController _gController = new TextEditingController();
  TextEditingController _pController = new TextEditingController();
  TextEditingController _cController = new TextEditingController();
  TextEditingController _hvController = new TextEditingController();
  TextEditingController _fppController = new TextEditingController();
  TextEditingController _ucController = new TextEditingController();
  TextEditingController _menopausiaController = new TextEditingController();
  TextEditingController _anticonceptivoController = new TextEditingController();
  TextEditingController _vacunacionController = new TextEditingController();
  TextEditingController _notasController = new TextEditingController();
  @override
  void initState() {
    super.initState();
    StorageUtil.putString(
        'ultimaPagina', CrearHistorialGinecoObstetraPage.routeName);
    _historial.historialId = 0;
    _historial.activo = true;
    _historial.creadoPor = _usuario.userName;
    _historial.creadoFecha = DateTime.now();
    _historial.modificadoPor = _usuario.userName;
    _historial.modificadoFecha = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    final PreclinicaViewModel _preclinica =
        ModalRoute.of(context).settings.arguments;
    _historial.pacienteId = _preclinica.pacienteId;
    _historial.doctorId = _preclinica.doctorId;
    _historial.preclinicaId = _preclinica.preclinicaId;

    return WillPopScope(
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
          body: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                GFCard(
                  elevation: 6.0,
                  title: GFListTile(
                    title: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Text(
                          'Historial Gineco Obstetra',
                          style: TextStyle(fontSize: 16.0),
                        ),
                        IconButton(
                            icon: Icon(
                              Icons.edit,
                              color: Theme.of(context).primaryColor,
                            ),
                            onPressed: () {
                              if (!quieroEditar) {
                                setState(() {
                                  quieroEditar = true;
                                  labelBoton = 'Editar';
                                });
                              }
                            }),
                        IconButton(
                          icon: Icon(
                            Icons.delete,
                            color: Theme.of(context).primaryColor,
                          ),
                          onPressed: (!quieroEditar)
                              ? () => confirmAction(
                                  context, 'Desea eliminar el registro')
                              : () {},
                        )
                      ],
                    ),
                  ),
                  content: Form(
                      key: _formkey,
                      child: Column(
                        children: <Widget>[
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Expanded(child: _campoMenarquia(context)),
                              Container(
                                  margin: EdgeInsets.only(bottom: 25.0),
                                  child: IconButton(
                                      icon: Icon(
                                        Icons.delete,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                      onPressed: (quieroEditar)
                                          ? () {
                                              _menarquiaController.text = '';
                                              pickedMenarquia = null;
                                              _historial.menarquia = null;
                                              setState(() {});
                                            }
                                          : null))
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Expanded(child: _campoFur(context)),
                              Container(
                                  margin: EdgeInsets.only(bottom: 25.0),
                                  child: IconButton(
                                      icon: Icon(
                                        Icons.delete,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                      onPressed: (quieroEditar)
                                          ? () {
                                              _furController.text = '';
                                              pickedFur = null;
                                              _historial.fur = null;
                                              setState(() {});
                                            }
                                          : null))
                            ],
                          ),
                          _campoSG(),
                          _campoG(),
                          _campoP(),
                          _campoC(),
                          _campoHV(),
                          _campoFPP(),
                          _campoUC(),
                          Row(
                            children: <Widget>[
                              Expanded(child: _campoFechaMenopausia()),
                              Container(
                                  margin: EdgeInsets.only(bottom: 25.0),
                                  child: IconButton(
                                      icon: Icon(
                                        Icons.delete,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                      onPressed: (quieroEditar)
                                          ? () {
                                              _menopausiaController.text = '';
                                              pickedMenopausia = null;
                                              _historial.fechaMenopausia = null;
                                              setState(() {});
                                            }
                                          : null))
                            ],
                          ),
                          _campoAnticonceptivo(),
                          _campoVacunacion(),
                          _campoNotas(),
                          _crearBotones(context)
                        ],
                      )),
                ),
              ],
            ),
          ),
        ),
        onWillPop: () async => false);
  }

  void _desactivar() async {
    if (_historial.historialId != 0) {
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
      HistorialGinecoObstetra _historialGuardado;
      _historial.activo = false;
      _historialGuardado = await _historialBloc.updateHistorial(_historial);
      if (_historialGuardado != null) {
        _pr.hide();
        mostrarFlushBar(context, Colors.green, 'Info', 'Datos Guardados', 2,
            FlushbarPosition.TOP, Icons.info, Colors.black);
        _historial.historialId = 0;
        _historial.activo = true;
        // limpia controllers
        _menarquiaController.text = '';
        _furController.text = '';
        _sgController.text = '';
        _gController.text = '';
        _pController.text = '';
        _cController.text = '';
        _hvController.text = '';
        _fppController.text = '';
        _ucController.text = '';
        _menopausiaController.text = '';
        _anticonceptivoController.text = '';
        _vacunacionController.text = '';
        _notasController.text = '';

        setState(() {
          quieroEditar = true;
          labelBoton = 'Guardar';
        });
      } else {
        mostrarFlushBar(context, Colors.red, 'Info', 'Ha ocurrido un error', 2,
            FlushbarPosition.TOP, Icons.info, Colors.white);
      }
    } else {
      print('nada');
    }
  }

  Widget _campoMenarquia(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0),
      child: TextFormField(
        enableInteractiveSelection: false,
        controller: _menarquiaController,
        decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            prefixIcon: Icon(
              Icons.calendar_today,
              color: Colors.redAccent,
            ),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
            labelText: 'Menarquia',
            helperText: '',
            hintText: '',
            isDense: true),
        enabled: quieroEditar,
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
          selectDateMenarquia(context);
        },
      ),
    );
  }

  void selectDateMenarquia(BuildContext context) async {
    pickedMenarquia = await showDatePicker(
        context: context,
        initialDate: new DateTime.now(),
        firstDate: new DateTime(1930),
        lastDate: new DateTime(2050),
        locale: Locale('es', 'ES'));

    if (pickedMenarquia != null) {
      var format = DateFormat('dd/MM/yyyy');
      _historial.menarquia = pickedMenarquia;
      _menarquiaController.text = format.format(pickedMenarquia);
      setState(() {});
    }
  }

  Widget _campoFur(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0),
      child: TextFormField(
        enableInteractiveSelection: false,
        controller: _furController,
        decoration: inputsDecorations('Fur', Icons.calendar_today),
        enabled: quieroEditar,
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
          selectDateFur(context);
        },
      ),
    );
  }

  void selectDateFur(BuildContext context) async {
    pickedFur = await showDatePicker(
        context: context,
        initialDate: new DateTime.now(),
        firstDate: new DateTime(1930),
        lastDate: new DateTime(2050),
        locale: Locale('es', 'ES'));

    if (pickedFur != null) {
      var format = DateFormat('dd/MM/yyyy');
      _historial.fur = pickedFur;
      _furController.text = format.format(pickedFur);
      setState(() {});
    }
  }

  Widget _campoSG() {
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0),
      child: TextFormField(
        controller: _sgController,
        onSaved: (value) => _historial.sg = value,
        keyboardType: TextInputType.text,
        decoration: inputsDecorations('SG', Icons.insert_drive_file),
        enabled: quieroEditar,
      ),
    );
  }

  Widget _campoG() {
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0),
      child: TextFormField(
        controller: _gController,
        onSaved: (value) => _historial.g = value,
        keyboardType: TextInputType.text,
        decoration: inputsDecorations('G', Icons.insert_drive_file),
        enabled: quieroEditar,
      ),
    );
  }

  Widget _campoP() {
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0),
      child: TextFormField(
        controller: _pController,
        onSaved: (value) => _historial.p = value,
        keyboardType: TextInputType.text,
        decoration: inputsDecorations('P', Icons.insert_drive_file),
        enabled: quieroEditar,
      ),
    );
  }

  Widget _campoC() {
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0),
      child: TextFormField(
        controller: _cController,
        onSaved: (value) => _historial.c = value,
        keyboardType: TextInputType.text,
        decoration: inputsDecorations('C', Icons.insert_drive_file),
        enabled: quieroEditar,
      ),
    );
  }

  Widget _campoHV() {
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0),
      child: TextFormField(
        controller: _hvController,
        onSaved: (value) => _historial.hv = value,
        keyboardType: TextInputType.text,
        decoration: inputsDecorations('HV', Icons.insert_drive_file),
        enabled: quieroEditar,
      ),
    );
  }

  Widget _campoFPP() {
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0),
      child: TextFormField(
        controller: _fppController,
        onSaved: (value) => _historial.fpp = value,
        keyboardType: TextInputType.text,
        decoration: inputsDecorations('FPP', Icons.insert_drive_file),
        enabled: quieroEditar,
      ),
    );
  }

  Widget _campoUC() {
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0),
      child: TextFormField(
        controller: _ucController,
        onSaved: (value) => _historial.uc = value,
        keyboardType: TextInputType.text,
        decoration: inputsDecorations('UC', Icons.insert_drive_file),
        enabled: quieroEditar,
      ),
    );
  }

  Widget _campoFechaMenopausia() {
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0),
      child: TextFormField(
        enableInteractiveSelection: false,
        controller: _menopausiaController,
        enabled: quieroEditar,
        decoration: inputsDecorations('Fecha Menopausia', Icons.calendar_today),
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
          selectDateMenopausia(context);
        },
      ),
    );
  }

  void selectDateMenopausia(BuildContext context) async {
    pickedMenopausia = await showDatePicker(
        context: context,
        initialDate: new DateTime.now(),
        firstDate: new DateTime(1930),
        lastDate: new DateTime(2050),
        locale: Locale('es', 'ES'));

    if (pickedMenopausia != null) {
      var format = DateFormat('dd/MM/yyyy');
      _historial.fechaMenopausia = pickedMenopausia;
      _menopausiaController.text = format.format(pickedMenopausia);
      setState(() {});
    }
  }

  Widget _campoAnticonceptivo() {
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0),
      child: TextFormField(
        controller: _anticonceptivoController,
        onSaved: (value) => _historial.anticonceptivo = value,
        keyboardType: TextInputType.text,
        decoration:
            inputsDecorations('Anticonceptivo', Icons.insert_drive_file),
        enabled: quieroEditar,
      ),
    );
  }

  Widget _campoVacunacion() {
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0),
      child: TextFormField(
        controller: _vacunacionController,
        onSaved: (value) => _historial.vacunacion = value,
        keyboardType: TextInputType.text,
        decoration: inputsDecorations('Vacunacion', Icons.insert_drive_file),
        enabled: quieroEditar,
      ),
    );
  }

  Widget _campoNotas() {
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0),
      child: TextFormField(
        controller: _notasController,
        maxLines: 2,
        onSaved: (value) => _historial.notas = value,
        keyboardType: TextInputType.text,
        decoration: inputsDecorations('Notas Adicionales', Icons.note),
        enabled: quieroEditar,
      ),
    );
  }

  Widget _crearBotones(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        RaisedButton.icon(
            color: Theme.of(context).primaryColor,
            onPressed: (quieroEditar) ? () => _guardar(context) : null,
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
    if (_menarquiaController.text.isEmpty &&
        _furController.text.isEmpty &&
        _sgController.text.isEmpty &&
        _gController.text.isEmpty &&
        _pController.text.isEmpty &&
        _cController.text.isEmpty &&
        _hvController.text.isEmpty &&
        _fppController.text.isEmpty &&
        _ucController.text.isEmpty &&
        _menopausiaController.text.isEmpty &&
        _anticonceptivoController.text.isEmpty &&
        _vacunacionController.text.isEmpty &&
        _notasController.text.isEmpty) {
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
      await _pr.show();

      HistorialGinecoObstetra _historialGuardado;
      if (_historial.historialId == 0) {
        //guarda
        _historialGuardado = await _historialBloc.addHistorial(_historial);
      } else {
        // edita
        _historialGuardado = await _historialBloc.updateHistorial(_historial);
      }

      if (_historialGuardado != null) {
        _pr.hide();
        mostrarFlushBar(context, Colors.green, 'Info', 'Datos Guardados', 2,
            FlushbarPosition.TOP, Icons.info, Colors.black);
        _historial.historialId = _historialGuardado.historialId;
        setState(() {
          quieroEditar = false;
          labelBoton = 'Editar';
        });
      } else {
        mostrarFlushBar(context, Colors.red, 'Info', 'Ha ocurrido un error', 2,
            FlushbarPosition.TOP, Icons.info, Colors.white);
      }
    }
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
