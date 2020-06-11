import 'package:appsam/src/widgets/firebaseMessageWrapper.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:getflutter/getflutter.dart';
import 'package:intl/intl.dart';
import 'package:progress_dialog/progress_dialog.dart';

import 'package:appsam/src/models/paginados/preclinica_paginadoVM.dart';
import 'package:appsam/src/utils/utils.dart';
import 'package:appsam/src/widgets/drawer.dart';
import 'package:appsam/src/blocs/historialGineco_bloc.dart';
import 'package:appsam/src/models/historialGinecoObstetra_model.dart';
import 'package:appsam/src/utils/storage_util.dart';

class CrearHistorialGinecoObstetraPage extends StatefulWidget {
  static final String routeName = 'crear_historial_gineco';
  final HistorialGinecoObstetra historial;
  final PreclinicaViewModel preclinica;

  const CrearHistorialGinecoObstetraPage(
      {@required this.historial, @required this.preclinica});

  @override
  _CrearHistorialGinecoObstetraPageState createState() =>
      _CrearHistorialGinecoObstetraPageState();
}

class _CrearHistorialGinecoObstetraPageState
    extends State<CrearHistorialGinecoObstetraPage> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  final _historialBloc = new HistorialGinecoObstetraBloc();

  String labelBoton = 'Guardar';
  DateTime pickedFum;

  TextEditingController _fumController = new TextEditingController();
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
    labelBoton = (widget.historial.historialId == 0) ? 'Guardar' : 'Editar';

    var format = DateFormat('dd/MM/yyyy');

    _fumController.text = (widget.historial.fum != null)
        ? format.format(widget.historial.fum)
        : '';

    _gController.text = (widget.historial.g != null) ? widget.historial.g : '';
    _pController.text = (widget.historial.p != null) ? widget.historial.p : '';
    _cController.text = (widget.historial.c != null) ? widget.historial.c : '';
    _hvController.text =
        (widget.historial.hv != null) ? widget.historial.hv : '';
    _fppController.text =
        (widget.historial.fpp != null) ? widget.historial.fpp : '';

    _anticonceptivoController.text = (widget.historial.anticonceptivos != null)
        ? widget.historial.anticonceptivos
        : '';

    _notasController.text =
        (widget.historial.notas != null) ? widget.historial.notas : '';
  }

  @override
  void dispose() {
    _fumController.dispose();
    _furController.dispose();
    _sgController.dispose();
    _gController.dispose();
    _pController.dispose();
    _cController.dispose();
    _hvController.dispose();
    _fppController.dispose();
    _ucController.dispose();
    _menopausiaController.dispose();
    _anticonceptivoController.dispose();
    _vacunacionController.dispose();
    _notasController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final PreclinicaViewModel _preclinica = widget.preclinica;

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
              body: _historialForm(context)),
        ),
        onWillPop: () async => false);
  }

  SingleChildScrollView _historialForm(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          GFCard(
            elevation: 6.0,
            title: GFListTile(
                color: Colors.red,
                title: Text('Historial Gineco Obstetra',
                    style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
                icon: FaIcon(FontAwesomeIcons.user, color: Colors.white)),
            content: Form(
                key: _formkey,
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(child: _campoFum(context)),
                        Container(
                            margin: EdgeInsets.only(bottom: 25.0),
                            child: IconButton(
                                icon: Icon(
                                  Icons.delete,
                                  color: Theme.of(context).primaryColor,
                                ),
                                onPressed: () {
                                  _fumController.text = '';
                                  pickedFum = null;
                                  widget.historial.fum = null;
                                }))
                      ],
                    ),
                    _campoG(),
                    _campoP(),
                    _campoC(),
                    _campoHV(),
                    _campoFPP(),
                    _campoAnticonceptivo(),
                    _campoNotas(),
                    _crearBotones(context)
                  ],
                )),
          ),
        ],
      ),
    );
  }

  Widget _campoFum(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0),
      child: TextFormField(
        enableInteractiveSelection: false,
        controller: _fumController,
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
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
          selectDateMenarquia(context);
        },
      ),
    );
  }

  void selectDateMenarquia(BuildContext context) async {
    pickedFum = await showDatePicker(
        helpText: 'Seleccione fecha.',
        errorFormatText: 'Fecha invalida',
        fieldLabelText: 'Ingrese fecha',
        initialDatePickerMode: DatePickerMode.year,
        context: context,
        initialDate: new DateTime.now(),
        firstDate: new DateTime(1930),
        lastDate: new DateTime.now(),
        locale: Locale('es', 'ES'));

    if (pickedFum != null) {
      var format = DateFormat('dd/MM/yyyy');
      widget.historial.fum = pickedFum;
      _fumController.text = format.format(pickedFum);
    }
  }

  Widget _campoG() {
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0),
      child: TextFormField(
        controller: _gController,
        onSaved: (value) => widget.historial.g = value,
        keyboardType: TextInputType.text,
        decoration: inputsDecorations('G', Icons.insert_drive_file),
      ),
    );
  }

  Widget _campoP() {
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0),
      child: TextFormField(
        controller: _pController,
        onSaved: (value) => widget.historial.p = value,
        keyboardType: TextInputType.text,
        decoration: inputsDecorations('P', Icons.insert_drive_file),
      ),
    );
  }

  Widget _campoC() {
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0),
      child: TextFormField(
        controller: _cController,
        onSaved: (value) => widget.historial.c = value,
        keyboardType: TextInputType.text,
        decoration: inputsDecorations('C', Icons.insert_drive_file),
      ),
    );
  }

  Widget _campoHV() {
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0),
      child: TextFormField(
        controller: _hvController,
        onSaved: (value) => widget.historial.hv = value,
        keyboardType: TextInputType.text,
        decoration: inputsDecorations('HV', Icons.insert_drive_file),
      ),
    );
  }

  Widget _campoFPP() {
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0),
      child: TextFormField(
        controller: _fppController,
        onSaved: (value) => widget.historial.fpp = value,
        keyboardType: TextInputType.text,
        decoration: inputsDecorations('FPP', Icons.insert_drive_file),
      ),
    );
  }

  Widget _campoAnticonceptivo() {
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0),
      child: TextFormField(
        controller: _anticonceptivoController,
        onSaved: (value) => widget.historial.anticonceptivos = value,
        keyboardType: TextInputType.text,
        decoration:
            inputsDecorations('Anticonceptivos', Icons.insert_drive_file),
      ),
    );
  }

  Widget _campoNotas() {
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0),
      child: TextFormField(
        controller: _notasController,
        maxLines: 2,
        onSaved: (value) => widget.historial.notas = value,
        keyboardType: TextInputType.text,
        decoration: inputsDecorations('Notas Adicionales', Icons.note),
      ),
    );
  }

  Widget _crearBotones(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        RaisedButton.icon(
            color: Theme.of(context).primaryColor,
            onPressed: () => _guardar(context),
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
    if (_fumController.text.isEmpty &&
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
      mostrarFlushBar(context, Colors.black, 'Info',
          'El formulario no puede estar vacio', 3, Icons.info, Colors.white);
    } else {
      _formkey.currentState.save();
      await _pr.show();

      HistorialGinecoObstetra _historialGuardado;
      if (widget.historial.historialId == 0) {
        //guarda
        _historialGuardado =
            await _historialBloc.addHistorial(widget.historial);
      } else {
        // edita
        _historialGuardado =
            await _historialBloc.updateHistorial(widget.historial);
      }

      if (_historialGuardado != null) {
        await _pr.hide();
        mostrarFlushBar(context, Colors.green, 'Info', 'Datos Guardados', 2,
            Icons.info, Colors.black);
        widget.historial.historialId = _historialGuardado.historialId;
        setState(() {
          labelBoton = 'Editar';
        });
      } else {
        mostrarFlushBar(context, Colors.red, 'Info', 'Ha ocurrido un error', 2,
            Icons.info, Colors.white);
      }
    }
  }
}
