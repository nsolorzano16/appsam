import 'package:appsam/src/models/user_model.dart';
import 'package:appsam/src/pages/reset_password_user_page.dart';
import 'package:appsam/src/providers/auth_service.dart';
import 'package:appsam/src/utils/utils.dart';
import 'package:appsam/src/widgets/firebaseMessageWrapper.dart';
import 'package:flutter/material.dart';

import 'package:appsam/src/blocs/asistentes_bloc/create_edit_asistentes.dart';
import 'package:appsam/src/blocs/provider.dart';
import 'package:appsam/src/blocs/theme_bloc.dart';
import 'package:appsam/src/utils/storage_util.dart';
import 'package:appsam/src/widgets/drawer.dart';
import 'package:progress_dialog/progress_dialog.dart';

class SettingsPage extends StatefulWidget {
  static final String routeName = 'settings';
  final ThemeBloc bloc;

  SettingsPage(this.bloc);
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final AuthService _authService = AuthService();
  bool activado = StorageUtil.getBool('temaDark');
  final UserModel _usuario =
      userModelFromJson(StorageUtil.getString('usuarioGlobal'));
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
        child: FirebaseMessageWrapper(
          child: Scaffold(
            backgroundColor: colorFondoApp(),
            drawer: MenuWidget(),
            appBar: AppBar(
              title: Text('Configuración'),
            ),
            body: _crearLista(context, bloc, blocAsistentes),
          ),
        ),
        onWillPop: () async => false);
  }

  Widget _crearLista(BuildContext context, ThemeBloc bloc,
      CrearEditarAsistentesBloc blocAsistentes) {
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
            onTap: _sendEmail,
          ),
          Divider(),
        ],
      );
    } else {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
  }

  _sendEmail() async {
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
    final resp = await _authService.resetPassword(_usuario.email);
    await _pr.hide();
    if (resp != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ResetPasswordUserPage(
              token: resp.tokenChangePassword, userId: resp.userId),
        ),
      );
    }
  }
}
