import 'package:appsam/src/models/examenFisicoGinecologico_model.dart';
import 'package:appsam/src/models/usuario_model.dart';
import 'package:appsam/src/utils/storage_util.dart';
import 'package:flutter/material.dart';

class CrearExamenGinecologicoPage extends StatefulWidget {
  static final String routeName = 'crear_examen_ginecologico';
  @override
  _CrearExamenGinecologicoPageState createState() =>
      _CrearExamenGinecologicoPageState();
}

class _CrearExamenGinecologicoPageState
    extends State<CrearExamenGinecologicoPage> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final ExamenFisicoGinecologico _examenGinecologico =
      new ExamenFisicoGinecologico();

  final UsuarioModel _usuario =
      usuarioModelFromJson(StorageUtil.getString('usuarioGlobal'));
  bool quieroEditar = true;
  String labelBoton = 'Guardar';

  @override
  void initState() {
    super.initState();
    StorageUtil.putString(
        'ultimaPagina', CrearExamenGinecologicoPage.routeName);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Consulta'),
      ),
      body: Container(),
    );
  }
}
