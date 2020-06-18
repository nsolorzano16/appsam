import 'package:appsam/src/extensions/color_ext.dart';
import 'package:appsam/src/providers/calendarioFecha_service.dart';
import 'package:appsam/src/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:getflutter/getflutter.dart';
import 'package:intl/intl.dart';

import 'package:appsam/src/models/calendarioFecha_model.dart';
import 'package:appsam/src/models/usuario_model.dart';
import 'package:appsam/src/utils/storage_util.dart';
import 'package:appsam/src/widgets/drawer.dart';
import 'package:progress_dialog/progress_dialog.dart';

class CrearAgendaPage extends StatefulWidget {
  static final String routeName = 'crear_agenda';
  @override
  _CrearAgendaPageState createState() => _CrearAgendaPageState();
}

class _CrearAgendaPageState extends State<CrearAgendaPage> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  final UsuarioModel _usuario =
      usuarioModelFromJson(StorageUtil.getString('usuarioGlobal'));
  final CalendarioFechaModel _evento = new CalendarioFechaModel();
  final formatHora = DateFormat.Hm('es_Es');
  final formatFecha = DateFormat.MMMMEEEEd('es_Es');
  final _eventoService = new EventosService();

  TextEditingController _fechaInicioController = new TextEditingController();
  TextEditingController _fechaFinController = new TextEditingController();
  TextEditingController _notasController = new TextEditingController();

  Color pickerColor = HexColor.fromHex('#0000FF');
  Color currentColor = HexColor.fromHex('#0000FF');
  Color pickerColorSecond = HexColor.fromHex('#008000');
  Color currentColorSecond = HexColor.fromHex('#008000');

  @override
  void initState() {
    super.initState();
    if (_usuario.rolId == 2) _evento.doctorId = _usuario.usuarioId;
    if (_usuario.rolId == 3) _evento.doctorId = _usuario.asistenteId;
    _evento.activo = true;
    _evento.creadoPor = _usuario.userName;
    _evento.creadoFecha = DateTime.now();
    _evento.modificadoFecha = DateTime.now();
    _evento.modificadoPor = _usuario.userName;
    _evento.colorPrimario = pickerColor.toHex();
    _evento.colorSecundario = pickerColorSecond.toHex();
    _evento.todoElDia = true;
  }

  // ValueChanged<Color> callback
  void changeColor(Color color) {
    setState(() => pickerColor = color);
  }

  void changeColorSecond(Color color) {
    setState(() => pickerColorSecond = color);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        drawer: MenuWidget(),
        appBar: AppBar(
          title: Text('Agendar cita'),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.arrow_back_ios),
                onPressed: () =>
                    Navigator.pushReplacementNamed(context, 'agenda'))
          ],
        ),
        body: SingleChildScrollView(
          child: GFCard(
            title: GFListTile(
                color: Colors.red,
                title: Text('Cita',
                    style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
                icon: Icon(Icons.calendar_today, color: Colors.white)),
            elevation: 6.0,
            content: Form(
                key: _formkey,
                child: Column(
                  children: <Widget>[
                    _crearFechaInicio(context),
                    _espacio(),
                    _crearFechaFin(context),
                    _espacio(),
                    _crearNotas(),
                    _espacio(),
                    _crearColorPrimario(context),
                    _crearColorSecundario(context),
                    _crearBotones(context),
                  ],
                )),
          ),
        ),
      ),
      onWillPop: () async => false,
    );
  }

  GestureDetector _crearColorPrimario(BuildContext context) {
    return GestureDetector(
      child: Padding(
        padding: EdgeInsets.only(left: 8.8, right: 8.0),
        child: InputDecorator(
          decoration: inputsDecorations('Color primario', Icons.palette),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(5.0),
            child: Container(
              width: double.infinity,
              height: 15.0,
              color: pickerColor,
            ),
          ),
        ),
      ),
      onTap: () => _showColorPicker(context),
    );
  }

  GestureDetector _crearColorSecundario(BuildContext context) {
    return GestureDetector(
      child: Padding(
        padding: EdgeInsets.only(left: 8.8, right: 8.0),
        child: InputDecorator(
          decoration: inputsDecorations('Color secundario', Icons.palette),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(5.0),
            child: Container(
              width: double.infinity,
              height: 15.0,
              color: pickerColorSecond,
            ),
          ),
        ),
      ),
      onTap: () => _showSecondColorPicker(context),
    );
  }

  Widget _espacio() {
    return SizedBox(
      height: 10.0,
    );
  }

  String validaTexto(String value) {
    if (value.length < 3) {
      return 'Campo obligatorio';
    } else {
      return null;
    }
  }

  void _showColorPicker(BuildContext context) {
    showDialog(
        context: context,
        child: AlertDialog(
          title: const Text('Seleccione color'),
          content: SingleChildScrollView(
              child: BlockPicker(
            pickerColor: pickerColor,
            onColorChanged: changeColor,
          )),
          actions: <Widget>[
            FlatButton(
                onPressed: () {
                  setState(() {
                    currentColor = pickerColor;

                    _evento.colorPrimario = pickerColor.toHex();
                  });
                  Navigator.of(context).pop();
                },
                child: const Text('Ok'))
          ],
        ));
  }

  void _showSecondColorPicker(BuildContext context) {
    showDialog(
        context: context,
        child: AlertDialog(
          title: const Text('Seleccione color'),
          content: SingleChildScrollView(
              child: BlockPicker(
            pickerColor: pickerColorSecond,
            onColorChanged: changeColorSecond,
          )),
          actions: <Widget>[
            FlatButton(
                onPressed: () {
                  setState(() {
                    currentColorSecond = pickerColorSecond;
                    _evento.colorSecundario = pickerColorSecond.toHex();
                  });
                  Navigator.of(context).pop();
                },
                child: const Text('Ok'))
          ],
        ));
  }

  Widget _crearFechaInicio(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0),
      child: TextFormField(
        autovalidate: true,
        validator: validaTexto,
        enableInteractiveSelection: false,
        controller: _fechaInicioController,
        decoration: inputsDecorations('Fecha inicio', Icons.calendar_today),
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
          _selectDateInicio(context);
        },
      ),
    );
  }

  void _selectDateInicio(BuildContext context) {
    DatePicker.showDateTimePicker(context,
        minTime: DateTime(1930), maxTime: DateTime(2030), onConfirm: (date) {
      _evento.inicio = date;
      _fechaInicioController.text =
          '${formatHora.format(date)} - ${formatFecha.format(date)}';
      setState(() {});
    }, currentTime: DateTime.now(), locale: LocaleType.es);
  }

  Widget _crearFechaFin(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0),
      child: TextFormField(
        autovalidate: true,
        validator: validaTexto,
        enableInteractiveSelection: false,
        controller: _fechaFinController,
        decoration: inputsDecorations('Fecha fin', Icons.calendar_today),
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
          _selectDateFin(context);
        },
      ),
    );
  }

  void _selectDateFin(BuildContext context) {
    DatePicker.showDateTimePicker(context,
        minTime: DateTime(1930), maxTime: DateTime(2030), onConfirm: (date) {
      _evento.fin = date;
      _fechaFinController.text =
          '${formatHora.format(date)} - ${formatFecha.format(date)}';
      setState(() {});
    }, currentTime: DateTime.now(), locale: LocaleType.es);
  }

  Widget _crearNotas() {
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0),
      child: TextFormField(
        autovalidate: true,
        validator: validaTexto,
        controller: _notasController,
        onSaved: (value) => _evento.notas = value,
        maxLines: 3,
        keyboardType: TextInputType.text,
        decoration: inputsDecorations('Notas', Icons.note),
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
            label: Text('Guardar'))
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
    if (_fechaInicioController.text.isEmpty &&
        _fechaFinController.text.isEmpty &&
        _notasController.text.isEmpty) {
      mostrarFlushBar(context, Colors.black, 'Info',
          'El formulario no puede estar vacio', 3, Icons.info, Colors.white);
    }

    if (_formkey.currentState.validate()) {
      _formkey.currentState.save();
      _evento.fechaFiltro = _evento.inicio;
      await _pr.show();

      CalendarioFechaModel _eventoGuardado =
          await _eventoService.addEvento(_evento);

      if (_eventoGuardado != null) {
        await _pr.hide();
        mostrarFlushBar(context, Colors.green, 'Info', 'Datos Guardados', 2,
            Icons.info, Colors.black);
      } else {
        await _pr.hide();
        mostrarFlushBar(context, Colors.red, 'Info', 'Ha ocurrido un error', 2,
            Icons.info, Colors.white);
      }
      Future.delayed(Duration(seconds: 2)).then((_) {
        Navigator.pushReplacementNamed(context, 'agenda');
      });
    } else {
      mostrarFlushBar(context, Colors.black, 'Info', 'Rellene todos los campos',
          2, Icons.info, Colors.white);
    }
  }
}
