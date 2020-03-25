import 'dart:async';

import 'package:appsam/src/blocs/asistentes_bloc/create_edit_asistentes.dart';
import 'package:appsam/src/models/usuario_model.dart';
import 'package:appsam/src/utils/storage_util.dart';
import 'package:appsam/src/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:progress_dialog/progress_dialog.dart';

class AsistenteDetalle extends StatefulWidget {
  static final String routeName = 'asistente_detalle';
  @override
  _AsistenteDetalleState createState() => _AsistenteDetalleState();
}

class _AsistenteDetalleState extends State<AsistenteDetalle> {
  @override
  void initState() {
    super.initState();
    StorageUtil.putString('ultimaPagina', AsistenteDetalle.routeName);
  }

  @override
  Widget build(BuildContext context) {
    final UsuarioModel _usuario = ModalRoute.of(context).settings.arguments;
    final _screenSize = MediaQuery.of(context).size;
    final bloc = new CrearEditarAsistentesBloc();

    return Scaffold(
        appBar: AppBar(
          title: Text('${_usuario.nombres}'),
          actions: <Widget>[
            PopupMenuButton(
              elevation: 10.0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)),
              itemBuilder: (context) => [
                PopupMenuItem(
                  child: Text('Editar'),
                  value: 1,
                ),
                PopupMenuItem(
                    value: 2,
                    child: (_usuario.activo)
                        ? Text('Desactivar')
                        : Text('Activar')),
                PopupMenuItem(value: 3, child: Text('Resetear Contraseña')),
              ],
              onSelected: (value) {
                if (value == 1) {
                  Navigator.pushNamed(context, 'editar-asistente',
                      arguments: _usuario);
                } else if (value == 2) {
                  _desactivar(context, bloc, _usuario);
                } else if (value == 3) {
                  Navigator.pushReplacementNamed(context, 'reset-password',
                      arguments: _usuario);
                }
              },
            ),
          ],
        ),
        drawer: MenuWidget(),
        body: SingleChildScrollView(
          // physics: BouncingScrollPhysics(),
          child: Container(
            margin: EdgeInsets.only(top: 5.0),
            width: _screenSize.width,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(
                      left: _screenSize.width * 0.2,
                      right: _screenSize.width * 0.2,
                      top: 1.0,
                      bottom: 3.0),
                  child: Card(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0)),
                    child: Container(
                      padding: EdgeInsets.only(
                          left: 40.0, right: 40.0, top: 20.0, bottom: 20.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100.0),
                        child: FadeInImage(
                            width: 150,
                            height: 150,
                            placeholder: AssetImage('assets/jar-loading.gif'),
                            image: NetworkImage(_usuario.fotoUrl)),
                      ),
                    ),
                  ),
                ),
                _campoTexto(_usuario, Icons.email, context)
              ],
            ),
          ),
        ));
  }

  _desactivar(BuildContext context, CrearEditarAsistentesBloc bloc,
      UsuarioModel usuario) {
    final _pr = new ProgressDialog(
      context,
      type: ProgressDialogType.Normal,
      isDismissible: false,
      showLogs: false,
    );
    _pr.show();
    _pr.update(
      progress: 50.0,
      message: "Espere...",
      progressWidget: Container(
          padding: EdgeInsets.all(5.0), child: CircularProgressIndicator()),
      maxProgress: 100.0,
    );
    Timer(Duration(seconds: 2), () {
      setState(() {
        usuario.activo = !usuario.activo;
        bloc.updateUser(usuario);
      });
      _pr.hide();
    });
  }

  Widget _campoTexto(
      UsuarioModel usuario, IconData icon, BuildContext context) {
    final format = DateFormat.yMMMEd('es_Es');
    final _fechaNac = format.format(usuario.fechaNacimiento);
    // final _screenSize = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.only(top: 10.0, left: 25.0, right: 25.0, bottom: 10.0),
      child: Card(
        elevation: 6.0,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
        child: Column(
          children: <Widget>[
            ListTile(
              dense: true,
              leading: Icon(
                Icons.perm_identity,
                color: Colors.red,
                size: 22.0,
              ),
              title: Text(
                  '${usuario.nombres} ${usuario.primerApellido} ${usuario.segundoApellido}'),
              subtitle: Text('Nombre Completo'),
            ),
            ListTile(
              dense: true,
              leading: Icon(
                Icons.account_circle,
                color: Colors.red,
                size: 22.0,
              ),
              title: Text('${usuario.userName}'),
              subtitle: Text('Usuario'),
            ),
            ListTile(
              dense: true,
              leading:
                  Icon(Icons.chrome_reader_mode, color: Colors.red, size: 22.0),
              title: Text('${usuario.identificacion}'),
              subtitle: Text('Identificación'),
            ),
            ListTile(
              dense: true,
              leading: Icon(Icons.date_range, color: Colors.red, size: 22.0),
              title: Text('$_fechaNac'),
              subtitle: Text('Fecha de Nacimiento'),
            ),
            ListTile(
              dense: true,
              leading: Icon(Icons.face, color: Colors.red, size: 22.0),
              title: Text('${usuario.sexo}'),
              subtitle: Text('Sexo'),
            ),
            ListTile(
              dense: true,
              leading: FaIcon(FontAwesomeIcons.hashtag,
                  color: Colors.red, size: 22.0),
              title: Text('${usuario.edad}'),
              subtitle: Text('Edad'),
            ),
            ListTile(
              dense: true,
              leading: Icon(Icons.phone, color: Colors.red, size: 22.0),
              title: Text('${usuario.telefono1}'),
              subtitle: Text('Telefono'),
            ),
            ListTile(
              dense: true,
              leading: Icon(Icons.phone_iphone, color: Colors.red, size: 22.0),
              title: Text('${usuario.telefono2}'),
              subtitle: Text('Telefono Secundario'),
            ),
            ListTile(
              dense: true,
              leading: Icon(Icons.format_list_numbered,
                  color: Colors.red, size: 22.0),
              title: Text('${usuario.colegioNumero}'),
              subtitle: Text('Numero colegiación'),
            ),
            ListTile(
              dense: true,
              leading: Icon(Icons.email, color: Colors.red, size: 22.0),
              title: Text('${usuario.email}'),
              subtitle: Text('Email'),
            ),
            ListTile(
              dense: true,
              leading: Icon((usuario.activo) ? Icons.check_circle : Icons.close,
                  color: Colors.red, size: 22.0),
              title: (usuario.activo) ? Text('Activado') : Text('Desactivado'),
              subtitle: Text('Estado'),
            ),
            Padding(
              padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
              child: ListTile(
                dense: true,
                leading: Icon(Icons.note, color: Colors.red, size: 22.0),
                title: Text(
                  '${usuario.notas}',
                  textAlign: TextAlign.justify,
                ),
                subtitle: Text('Notas'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
