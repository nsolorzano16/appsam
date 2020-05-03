import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';

import 'package:appsam/src/blocs/asistentes_bloc/create_edit_asistentes.dart';
import 'package:appsam/src/blocs/asistentes_bloc/resetPassword_bloc.dart';
import 'package:appsam/src/utils/storage_util.dart';
import 'package:appsam/src/widgets/drawer.dart';

class ResetMyPasswordPage extends StatelessWidget {
  static final String routeName = 'reset-my-pass';
  @override
  Widget build(BuildContext context) {
    StorageUtil.putString('ultimaPagina', ResetMyPasswordPage.routeName);
    final int _usuarioId = ModalRoute.of(context).settings.arguments;

    final blocService = new CrearEditarAsistentesBloc();

    return WillPopScope(
        child: Scaffold(
          drawer: MenuWidget(),
          appBar: AppBar(
            title: Text('Resetear Mi Contraseña'),
          ),
          body: Container(
            height: 250.0,
            margin: EdgeInsets.only(
                top: 10.0, left: 10.0, right: 10.0, bottom: 10.0),
            child: Card(
              elevation: 6.0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0)),
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 15.0,
                  ),
                  _crearCampoPassword1(context),
                  SizedBox(
                    height: 8.0,
                  ),
                  _crearRepetirPassword(context),
                  SizedBox(
                    height: 8.0,
                  ),
                  _crearBoton(context, blocService, _usuarioId)
                ],
              ),
            ),
          ),
        ),
        onWillPop: () async => false);
  }

  Widget _crearCampoPassword1(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: TextField(
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.lock_outline,
            color: Colors.redAccent,
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
          labelText: 'Nueva contraseña',
          errorText: '',
        ),
      ),
    );
  }

  Widget _crearRepetirPassword(
    BuildContext context,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: TextField(
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.lock_outline,
            color: Colors.redAccent,
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
          labelText: 'Repetir Contraseña',
          errorText: '',
        ),
      ),
    );
  }

  Widget _crearBoton(
      BuildContext context, CrearEditarAsistentesBloc blocService, int id) {
    return RaisedButton(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 80.0, vertical: 15.0),
        child: Text('Guardar'),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      elevation: 0.0,
      color: Colors.red,
      disabledTextColor: Colors.white,
      textColor: Colors.white,
      onPressed: () {
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

// TODO: arreglar aquii
        var pass = 'x mientras';
        var modificadoPor = StorageUtil.getString('userName');

        blocService.resetPassword(id, pass, modificadoPor).then((user) {
          _pr.hide();

          Navigator.pushReplacementNamed(context, 'login');
        });
      },
    );
  }
}
