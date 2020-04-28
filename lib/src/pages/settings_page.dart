import 'package:flutter/material.dart';

import 'package:appsam/src/blocs/asistentes_bloc/create_edit_asistentes.dart';
import 'package:appsam/src/blocs/provider.dart';
import 'package:appsam/src/blocs/theme_bloc.dart';
import 'package:appsam/src/models/usuario_model.dart';
import 'package:appsam/src/utils/storage_util.dart';
import 'package:appsam/src/widgets/drawer.dart';

class SettingsPage extends StatefulWidget {
  static final String routeName = 'settings';
  final ThemeBloc bloc;

  SettingsPage(this.bloc);
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool activado = StorageUtil.getBool('temaDark');

  @override
  void initState() {
    super.initState();
    StorageUtil.putString('ultimaPagina', SettingsPage.routeName);
  }

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.themeBloc(context);
    final blocAsistentes = Provider.crearEditarAsistentesBloc(context);
    return WillPopScope(
        child: Scaffold(
          drawer: MenuWidget(),
          appBar: AppBar(
            title: Text('Configuración'),
          ),
          body: _crearLista(context, bloc, blocAsistentes),
        ),
        onWillPop: () async => false);
  }

  Widget _crearLista(BuildContext context, ThemeBloc bloc,
      CrearEditarAsistentesBloc blocAsistentes) {
    final UsuarioModel _usuario =
        usuarioModelFromJson(StorageUtil.getString('usuarioGlobal'));
    if (_usuario != null) {
      return ListView(
        children: <Widget>[
          ListTile(
            title: Text('Mi perfil'),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () => Navigator.pushNamed(
              context,
              'my-profile',
            ),
          ),
          Divider(),
          ListTile(
            title: Text('Resetear mi contraseña'),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () => Navigator.pushNamed(context, 'reset-my-pass',
                arguments: _usuario.usuarioId),
          ),
          Divider(),
          // SwitchListTile(
          //     title: Text('Tema oscuro'),
          //     value: activado,
          //     onChanged: (value) {
          //       activado = value;
          //       setState(() {
          //         StorageUtil.putBool('temaDark', activado);
          //         widget.bloc.changeTheTheme(activado);
          //       });
          //     }),
        ],
      );
    } else {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
  }
}
