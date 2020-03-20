import 'package:appsam/src/blocs/asistentes_bloc/create_edit_asistentes.dart';
import 'package:appsam/src/blocs/asistentes_bloc/resetPassword_bloc.dart';
import 'package:appsam/src/models/usuario_model.dart';
import 'package:appsam/src/utils/storage_util.dart';
import 'package:appsam/src/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';

class ResetPasswordPage extends StatelessWidget {
  static final String routeName = 'reset-password';
  @override
  Widget build(BuildContext context) {
    StorageUtil.putString('ultimaPagina', ResetPasswordPage.routeName);
    final UsuarioModel _asistente = ModalRoute.of(context).settings.arguments;
    final _resetPasswordBloc = new ResetPasswordBloc();
    final blocService = new CrearEditarAsistentesBloc();
    return Scaffold(
      drawer: MenuWidget(),
      appBar: AppBar(
        title: Text('Resetear Contraseña'),
      ),
      body: Container(
        margin:
            EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0, bottom: 10.0),
        child: Card(
          elevation: 6.0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 15.0,
              ),
              _crearCampoPassword1(context, _resetPasswordBloc),
              SizedBox(
                height: 8.0,
              ),
              _crearRepetirPassword(context, _resetPasswordBloc),
              SizedBox(
                height: 8.0,
              ),
              _crearBoton(_resetPasswordBloc, blocService, _asistente)
            ],
          ),
        ),
      ),
    );
  }

  Widget _crearCampoPassword1(BuildContext context, ResetPasswordBloc bloc) {
    return StreamBuilder(
      stream: bloc.password,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: TextField(
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.lock_outline,
                  color: Colors.redAccent,
                ),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0)),
                labelText: 'Nueva contraseña',
                errorText: snapshot.error,
              ),
              onChanged: bloc.onPasswordChanged),
        );
      },
    );
  }

  Widget _crearRepetirPassword(BuildContext context, ResetPasswordBloc bloc) {
    return StreamBuilder(
      stream: bloc.confirmPassword,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: TextField(
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.lock_outline,
                  color: Colors.redAccent,
                ),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0)),
                labelText: 'Repetir Contraseña',
                errorText: snapshot.error,
              ),
              onChanged: bloc.onRetypePasswordChanged),
        );
      },
    );
  }

  Widget _crearBoton(ResetPasswordBloc bloc,
      CrearEditarAsistentesBloc blocService, UsuarioModel asistente) {
    return StreamBuilder(
      stream: bloc.registerValue,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return RaisedButton(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 80.0, vertical: 15.0),
            child: Text('Guardar'),
          ),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          elevation: 0.0,
          color: Colors.red,
          disabledTextColor: Colors.white,
          textColor: Colors.white,
          onPressed: (snapshot.hasData && snapshot.data == true)
              ? () {
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
                        padding: EdgeInsets.all(8.0),
                        child: CircularProgressIndicator()),
                    maxProgress: 100.0,
                    progressTextStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 13.0,
                        fontWeight: FontWeight.w400),
                    messageTextStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 19.0,
                        fontWeight: FontWeight.w600),
                  );
                  _pr.show();

                  var pass = bloc.confirmPassValue;
                  var modificadoPor = StorageUtil.getString('userName');
                  print(asistente.usuarioId);

                  blocService
                      .resetPassword(asistente.usuarioId, pass, modificadoPor)
                      .then((user) {
                    _pr.hide();
                    Navigator.pushReplacementNamed(context, 'asistente_detalle',
                        arguments: user);
                  });
                }
              : null,
        );
      },
    );
  }
}
