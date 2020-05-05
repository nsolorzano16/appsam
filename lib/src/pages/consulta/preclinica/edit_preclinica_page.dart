import 'dart:async';
import 'package:appsam/src/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:getflutter/getflutter.dart';
import 'package:progress_dialog/progress_dialog.dart';

import 'package:appsam/src/blocs/consulta_bloc.dart';
import 'package:appsam/src/blocs/preclinica_bloc.dart';
import 'package:appsam/src/models/paginados/preclinica_paginadoVM.dart';
import 'package:appsam/src/models/usuario_model.dart';
import 'package:appsam/src/utils/storage_util.dart';
import 'package:appsam/src/utils/utils.dart';

class EditarPreclinicaPage extends StatefulWidget {
  static final String routeName = 'editar_preclinica';
  @override
  _EditarPreclinicaPageState createState() => _EditarPreclinicaPageState();
}

class _EditarPreclinicaPageState extends State<EditarPreclinicaPage> {
  PreclinicaBloc bloc = new PreclinicaBloc();
  ConsultaBloc blocConsulta = new ConsultaBloc();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final UsuarioModel _usuario =
      usuarioModelFromJson(StorageUtil.getString('usuarioGlobal'));

  @override
  void initState() {
    super.initState();
    StorageUtil.putString('ultimaPagina', EditarPreclinicaPage.routeName);
  }

  @override
  Widget build(BuildContext context) {
    final PreclinicaViewModel _preclinica =
        ModalRoute.of(context).settings.arguments;
    return WillPopScope(
        child: Scaffold(
            appBar: AppBar(
              title: Text('Editar Preclinica'),
              actions: <Widget>[
                IconButton(
                    icon: Icon(Icons.arrow_back_ios),
                    onPressed: () =>
                        Navigator.popAndPushNamed(context, 'preclinica'))
              ],
            ),
            drawer: MenuWidget(),
            body: Stack(
              children: <Widget>[_crearFormulario(_usuario, _preclinica)],
            )),
        onWillPop: () async => false);
  }

  Widget _crearFormulario(
      UsuarioModel usuario, PreclinicaViewModel preclinica) {
    return SingleChildScrollView(
        child: Column(
      children: <Widget>[
        GFCard(
          title: GFListTile(
            avatar: ClipRRect(
              borderRadius: BorderRadius.circular(100.0),
              child: FadeInImage(
                  width: 100,
                  height: 100,
                  placeholder: AssetImage('assets/jar-loading.gif'),
                  image: NetworkImage(preclinica.fotoUrl)),
            ),
            title: Text(
                '${preclinica.nombres} ${preclinica.primerApellido} ${preclinica.segundoApellido}'),
            subTitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Identificación: ${preclinica.identificacion}'),
                Text('Edad: ${preclinica.edad}')
              ],
            ),
          ),
        ),
        GFCard(
          elevation: 6.0,
          boxFit: BoxFit.cover,
          title: GFListTile(
              color: Colors.red,
              title: Text('Preclinica',
                  style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white)),
              icon: FaIcon(FontAwesomeIcons.user, color: Colors.white)),
          content: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  _espacio(),
                  _crearPeso(preclinica),
                  _espacio(),
                  _crearAltura(preclinica),
                  _espacio(),
                  _crearTemperatura(preclinica),
                  _espacio(),
                  _crearFrecuenciaRespiratoria(preclinica),
                  _espacio(),
                  _crearRitmoCardiaco(preclinica),
                  _espacio(),
                  _crearPresionSistolica(preclinica),
                  _espacio(),
                  _crearPresionDiastolica(preclinica),
                  _espacio(),
                  _crearNotas(preclinica),
                  _crearBotones(preclinica)
                ],
              )),
        ),
      ],
    ));
  }

  Widget _espacio() {
    return SizedBox(
      height: 10.0,
    );
  }

  Widget _crearPeso(PreclinicaViewModel preclinica) {
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0),
      child: TextFormField(
        initialValue: preclinica.peso.toString(),
        autovalidate: true,
        validator: isNumeric,
        onSaved: (value) => preclinica.peso = double.parse(value),
        keyboardType: TextInputType.numberWithOptions(decimal: true),
        decoration: inputsDecorations('Peso', Icons.account_circle,
            hintTexto: 'Libras'),
      ),
    );
  }

  String isNumeric(String s) {
    if (s.isEmpty) return 'Campo obligatorio';

    final n = num.tryParse(s);

    return (n == null) ? 'Ingrese valores correctos' : null;
  }

  Widget _crearAltura(PreclinicaViewModel preclinica) {
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0),
      child: TextFormField(
        initialValue: preclinica.altura.toString(),
        autovalidate: true,
        validator: isNumeric,
        onSaved: (value) => preclinica.altura = double.parse(value),
        keyboardType: TextInputType.numberWithOptions(decimal: true),
        decoration: inputsDecorations('Altura', Icons.account_circle,
            hintTexto: 'Centimetros'),
      ),
    );
  }

  Widget _crearTemperatura(PreclinicaViewModel preclinica) {
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0),
      child: TextFormField(
        initialValue: preclinica.temperatura.toString(),
        autovalidate: true,
        validator: isNumeric,
        onSaved: (value) => preclinica.temperatura = double.parse(value),
        keyboardType: TextInputType.numberWithOptions(decimal: true),
        decoration: inputsDecorations('Temperatura', Icons.account_circle,
            hintTexto: 'Cº'),
      ),
    );
  }

  Widget _crearFrecuenciaRespiratoria(PreclinicaViewModel preclinica) {
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0),
      child: TextFormField(
        initialValue: preclinica.frecuenciaRespiratoria.toString(),
        autovalidate: true,
        validator: isNumeric,
        onSaved: (value) =>
            preclinica.frecuenciaRespiratoria = int.parse(value),
        keyboardType: TextInputType.number,
        decoration:
            inputsDecorations('Frecuencia Respiratoria', Icons.account_circle),
      ),
    );
  }

  Widget _crearRitmoCardiaco(PreclinicaViewModel preclinica) {
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0),
      child: TextFormField(
        initialValue: preclinica.ritmoCardiaco.toString(),
        autovalidate: true,
        validator: isNumeric,
        onSaved: (value) => preclinica.ritmoCardiaco = int.parse(value),
        keyboardType: TextInputType.number,
        decoration: inputsDecorations('Ritmo Cardiaco', Icons.account_circle),
      ),
    );
  }

  Widget _crearPresionSistolica(PreclinicaViewModel preclinica) {
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0),
      child: TextFormField(
        initialValue: preclinica.presionSistolica.toString(),
        autovalidate: true,
        validator: isNumeric,
        onSaved: (value) => preclinica.presionSistolica = int.parse(value),
        keyboardType: TextInputType.number,
        decoration:
            inputsDecorations('Presion Sistolica', Icons.account_circle),
      ),
    );
  }

  Widget _crearPresionDiastolica(PreclinicaViewModel preclinica) {
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0),
      child: TextFormField(
        initialValue: preclinica.presionDiastolica.toString(),
        autovalidate: true,
        validator: isNumeric,
        onSaved: (value) => preclinica.presionDiastolica = int.parse(value),
        keyboardType: TextInputType.number,
        decoration:
            inputsDecorations('Presion Diastolica', Icons.account_circle),
      ),
    );
  }

  Widget _crearNotas(PreclinicaViewModel preclinica) {
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0),
      child: TextFormField(
        initialValue: preclinica.notas,
        maxLines: 2,
        onSaved: (value) => preclinica.notas = value,
        keyboardType: TextInputType.text,
        decoration: inputsDecorations('Notas', Icons.note),
      ),
    );
  }

  Widget _crearBotones(PreclinicaViewModel _preclinica) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(left: 25.0, bottom: 10.0),
          child: RaisedButton.icon(
              elevation: 5.0,
              textColor: Colors.white,
              color: Colors.blueGrey,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)),
              onPressed: () => Navigator.popAndPushNamed(context, 'preclinica'),
              icon: Icon(Icons.clear),
              label: Text('Cancelar')),
        ),
        Padding(
            padding: EdgeInsets.only(right: 25.0, bottom: 10.0),
            child: RaisedButton.icon(
                elevation: 5.0,
                textColor: Colors.white,
                color: Theme.of(context).primaryColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0)),
                icon: Icon(Icons.save),
                label: Text('Guardar'),
                onPressed: () {
                  if (!_formKey.currentState.validate()) {
                    mostrarFlushBar(
                        context,
                        Colors.redAccent,
                        'Información',
                        'Rellene todos los campos',
                        2,
                        Icons.info,
                        Colors.black);
                  } else {
                    _formKey.currentState.save();

                    _guardaConsulta(_preclinica);
                    _formKey.currentState.reset();
                  }
                }))
      ],
    );
  }

  void _guardaConsulta(PreclinicaViewModel preclinica) async {
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
    preclinica.modificadoPor = _usuario.userName;
    preclinica.modificadoFecha = DateTime.now();
    _formKey.currentState.reset();
    final PreclinicaViewModel resp = await bloc.updatePreclinica(preclinica);

    await _pr.hide();
    if (resp != null) {
      mostrarFlushBar(context, Colors.green, 'Info',
          'Preclinica editada correctamente', 3, Icons.info, Colors.black);
      Timer(Duration(seconds: 3), () {
        Navigator.pushReplacementNamed(
          context,
          'preclinica',
        );
      });
    } else {
      mostrarFlushBar(context, Colors.red, 'Info', 'Ha ocurrido un error', 3,
          Icons.info, Colors.black);
    }
  }
}
