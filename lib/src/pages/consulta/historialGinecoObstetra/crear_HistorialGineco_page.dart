import 'package:flutter/material.dart';
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
    labelBoton = (widget.historial.historialId == 0) ? 'Guardar' : 'Editar';

    var format = DateFormat('dd/MM/yyyy');

    _menarquiaController.text = (widget.historial.menarquia != null)
        ? format.format(widget.historial.menarquia)
        : '';
    _furController.text = (widget.historial.fur != null)
        ? format.format(widget.historial.fur)
        : '';
    _menopausiaController.text = (widget.historial.fechaMenopausia != null)
        ? format.format(widget.historial.fechaMenopausia)
        : '';

    _sgController.text =
        (widget.historial.sg != null) ? widget.historial.sg : '';
    _gController.text = (widget.historial.g != null) ? widget.historial.g : '';
    _pController.text = (widget.historial.p != null) ? widget.historial.p : '';
    _cController.text = (widget.historial.c != null) ? widget.historial.c : '';
    _hvController.text =
        (widget.historial.hv != null) ? widget.historial.hv : '';
    _fppController.text =
        (widget.historial.fpp != null) ? widget.historial.fpp : '';
    _ucController.text =
        (widget.historial.uc != null) ? widget.historial.uc : '';
    _anticonceptivoController.text = (widget.historial.anticonceptivo != null)
        ? widget.historial.anticonceptivo
        : '';
    _vacunacionController.text = (widget.historial.vacunacion != null)
        ? widget.historial.vacunacion
        : '';
    _notasController.text =
        (widget.historial.notas != null) ? widget.historial.notas : '';
  }

  @override
  void dispose() {
    super.dispose();
    _menarquiaController.dispose();
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
  }

  @override
  Widget build(BuildContext context) {
    final PreclinicaViewModel _preclinica = widget.preclinica;

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
            body: _historialForm(context)),
        onWillPop: () async => false);
  }

  SingleChildScrollView _historialForm(BuildContext context) {
    return SingleChildScrollView(
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
                                onPressed: () {
                                  _menarquiaController.text = '';
                                  pickedMenarquia = null;
                                  widget.historial.menarquia = null;
                                }))
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
                                onPressed: () {
                                  _furController.text = '';
                                  pickedFur = null;
                                  widget.historial.fur = null;
                                }))
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
                                onPressed: () {
                                  _menopausiaController.text = '';
                                  pickedMenopausia = null;
                                  widget.historial.fechaMenopausia = null;
                                }))
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
    );
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
        lastDate: new DateTime.now(),
        locale: Locale('es', 'ES'));

    if (pickedMenarquia != null) {
      var format = DateFormat('dd/MM/yyyy');
      widget.historial.menarquia = pickedMenarquia;
      _menarquiaController.text = format.format(pickedMenarquia);
    }
  }

  Widget _campoFur(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0),
      child: TextFormField(
        enableInteractiveSelection: false,
        controller: _furController,
        decoration: inputsDecorations('Fur', Icons.calendar_today),
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
        lastDate: new DateTime.now(),
        locale: Locale('es', 'ES'));

    if (pickedFur != null) {
      var format = DateFormat('dd/MM/yyyy');
      widget.historial.fur = pickedFur;
      _furController.text = format.format(pickedFur);
    }
  }

  Widget _campoSG() {
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0),
      child: TextFormField(
        controller: _sgController,
        onSaved: (value) => widget.historial.sg = value,
        keyboardType: TextInputType.text,
        decoration: inputsDecorations('SG', Icons.insert_drive_file),
      ),
    );
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

  Widget _campoUC() {
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0),
      child: TextFormField(
        controller: _ucController,
        onSaved: (value) => widget.historial.uc = value,
        keyboardType: TextInputType.text,
        decoration: inputsDecorations('UC', Icons.insert_drive_file),
      ),
    );
  }

  Widget _campoFechaMenopausia() {
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0),
      child: TextFormField(
        enableInteractiveSelection: false,
        controller: _menopausiaController,
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
        lastDate: new DateTime.now(),
        locale: Locale('es', 'ES'));

    if (pickedMenopausia != null) {
      var format = DateFormat('dd/MM/yyyy');
      widget.historial.fechaMenopausia = pickedMenopausia;
      _menopausiaController.text = format.format(pickedMenopausia);
    }
  }

  Widget _campoAnticonceptivo() {
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0),
      child: TextFormField(
        controller: _anticonceptivoController,
        onSaved: (value) => widget.historial.anticonceptivo = value,
        keyboardType: TextInputType.text,
        decoration:
            inputsDecorations('Anticonceptivo', Icons.insert_drive_file),
      ),
    );
  }

  Widget _campoVacunacion() {
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0),
      child: TextFormField(
        controller: _vacunacionController,
        onSaved: (value) => widget.historial.vacunacion = value,
        keyboardType: TextInputType.text,
        decoration: inputsDecorations('Vacunacion', Icons.insert_drive_file),
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
