import 'dart:io';
import 'package:appsam/src/utils/utils.dart';
import 'package:appsam/src/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:progress_dialog/progress_dialog.dart';

import 'package:appsam/src/blocs/asistentes_bloc/create_edit_asistentes.dart';
import 'package:appsam/src/blocs/provider.dart';
import 'package:appsam/src/models/usuario_model.dart';
import 'package:appsam/src/utils/storage_util.dart';

class MyProfilePage extends StatefulWidget {
  static final String routeName = 'my-profile';
  @override
  _MyProfilePageState createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {
  File foto;
  @override
  void initState() {
    super.initState();
    StorageUtil.putString('ultimaPagina', MyProfilePage.routeName);
  }

  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;
    final bloc = Provider.crearEditarAsistentesBloc(context);

    final UsuarioModel _usuario =
        usuarioModelFromJson(StorageUtil.getString('usuarioGlobal'));
    if (_usuario != null) {
      return WillPopScope(
          child: Scaffold(
              appBar: AppBar(
                title: Text('Mi Perfil'),
                actions: <Widget>[
                  IconButton(
                      icon: Icon(Icons.add_photo_alternate),
                      onPressed: () =>
                          _procesarImagen(ImageSource.gallery, _usuario, bloc)),
                  IconButton(
                      icon: Icon(Icons.add_a_photo),
                      onPressed: () =>
                          _procesarImagen(ImageSource.camera, _usuario, bloc)),
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
                                left: 40.0,
                                right: 40.0,
                                top: 10.0,
                                bottom: 10.0),
                            child: Padding(
                                padding: EdgeInsets.only(left: 2.0, top: 2.0),
                                child: Padding(
                                    padding: EdgeInsets.only(top: 5.0),
                                    child: Stack(
                                        fit: StackFit.loose,
                                        children: <Widget>[
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              _imageStorage(_usuario),
                                            ],
                                          ),
                                        ]))),
                          ),
                        ),
                      ),
                      _campoTexto(_usuario, Icons.email, context)
                    ],
                  ),
                ),
              )),
          onWillPop: () async => false);
    } else {
      return loadingIndicator(context);
    }
  }

  Widget _campoTexto(
      UsuarioModel usuario, IconData icon, BuildContext context) {
    final format = DateFormat.yMd('es_Es');
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
                color: Theme.of(context).primaryColor,
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
                color: Theme.of(context).primaryColor,
                size: 22.0,
              ),
              title: Text('${usuario.userName}'),
              subtitle: Text('Usuario'),
            ),
            ListTile(
              dense: true,
              leading: Icon(Icons.chrome_reader_mode,
                  color: Theme.of(context).primaryColor, size: 22.0),
              title: Text('${usuario.identificacion}'),
              subtitle: Text('Identificación'),
            ),
            ListTile(
              dense: true,
              leading: Icon(Icons.date_range,
                  color: Theme.of(context).primaryColor, size: 22.0),
              title: Text('$_fechaNac'),
              subtitle: Text('Fecha de Nacimiento'),
            ),
            ListTile(
              dense: true,
              leading: Icon(Icons.face,
                  color: Theme.of(context).primaryColor, size: 22.0),
              title: Text('${usuario.sexo}'),
              subtitle: Text('Sexo'),
            ),
            ListTile(
              dense: true,
              leading: Icon(Icons.phone,
                  color: Theme.of(context).primaryColor, size: 22.0),
              title: Text('${usuario.telefono1}'),
              subtitle: Text('Telefono'),
            ),
            ListTile(
              dense: true,
              leading: Icon(Icons.phone_iphone,
                  color: Theme.of(context).primaryColor, size: 22.0),
              title: Text('${usuario.telefono2}'),
              subtitle: Text('Telefono Secundario'),
            ),
            ListTile(
              dense: true,
              leading: Icon(Icons.format_list_numbered,
                  color: Theme.of(context).primaryColor, size: 22.0),
              title: Text('${usuario.colegioNumero}'),
              subtitle: Text('Numero colegiación'),
            ),
            ListTile(
              dense: true,
              leading: Icon(Icons.email,
                  color: Theme.of(context).primaryColor, size: 22.0),
              title: Text('${usuario.email}'),
              subtitle: Text('Email'),
            ),
            ListTile(
              dense: true,
              leading: Icon((usuario.activo) ? Icons.check_circle : Icons.close,
                  color: Theme.of(context).primaryColor, size: 22.0),
              title: (usuario.activo) ? Text('Activado') : Text('Desactivado'),
              subtitle: Text('Estado'),
            ),
            Padding(
              padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
              child: ListTile(
                dense: true,
                leading: Icon(Icons.note,
                    color: Theme.of(context).primaryColor, size: 22.0),
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

  // Widget _imageLocalDefault() {
  //   return Card(
  //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100.0)),
  //     child: Container(
  //       child: ClipRRect(
  //         borderRadius: BorderRadius.circular(100.0),
  //         child: FadeInImage(
  //             width: 150,
  //             height: 150,
  //             fit: BoxFit.cover,
  //             placeholder: AssetImage('assets/jar-loading.gif'),
  //             image: AssetImage(foto?.path ?? 'assets/no-image.png')),
  //       ),
  //     ),
  //   );

  //   // Ella no te ama 2:00 pm
  // }

  Widget _imageStorage(UsuarioModel _usuario) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100.0)),
      child: Container(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(100.0),
          child: FadeInImage(
              width: 150,
              height: 150,
              fit: BoxFit.cover,
              placeholder: AssetImage('assets/jar-loading.gif'),
              image: NetworkImage(_usuario.fotoUrl)),
        ),
      ),
    );
  }

  void _procesarImagen(ImageSource origen, UsuarioModel user,
      CrearEditarAsistentesBloc bloc) async {
    foto = await ImagePicker.pickImage(source: origen);
    if (foto != null) {
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
      _pr.show();
      final UsuarioModel usuario =
          await bloc.subirFotoApi(user.usuarioId, foto);
      setState(() {
        StorageUtil.putString('usuarioGlobal', usuarioModelToJson(usuario));
      });

      _pr.hide();
      foto = null;
    }
  }
}
