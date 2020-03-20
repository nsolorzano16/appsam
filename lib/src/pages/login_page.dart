import 'package:appsam/src/blocs/asistentes_bloc/create_edit_asistentes.dart';
import 'package:appsam/src/blocs/provider.dart';
import 'package:appsam/src/models/usuario_model.dart';
import 'package:appsam/src/providers/usuario_provider.dart';
import 'package:appsam/src/utils/storage_util.dart';
import 'package:appsam/src/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';

import '../blocs/login_bloc.dart';

class LoginPage extends StatefulWidget {
  static final String routeName = 'login';
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final usuarioProvider = new UsuarioProvider();
  bool verPass = true;
  bool logueando = true;
  final txtControllerUsuario = TextEditingController();
  final txtControllerPass = TextEditingController();
  //final blocCreateEditAsistentes = new CrearEditarAsistentesBloc();
  @override
  Widget build(BuildContext context) {
    final bloc = Provider.loginBloc(context);
    final blocCreateEditAsistentes =
        Provider.crearEditarAsistentesBloc(context);

    return Scaffold(
        body: Stack(
      children: <Widget>[
        _crearFondo(context),
        _loginForm(context, bloc, blocCreateEditAsistentes)
      ],
    ));
  }

  Widget _crearFondo(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final fondoMorado = Container(
      height: size.height,
      width: double.infinity,
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: <Color>[
            Color.fromRGBO(0, 0, 77, 1.0),
            Color.fromRGBO(255, 0, 0, 1.0),
          ])),
    );
    final circulo = Container(
      width: 100.0,
      height: 100.0,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100.0),
          color: Color.fromRGBO(255, 255, 255, 0.05)),
    );
    return Stack(
      children: <Widget>[
        fondoMorado,
        Positioned(top: 90.0, left: 30.0, child: circulo),
        Positioned(top: -40.0, left: -30.0, child: circulo),
        Positioned(bottom: -50, right: -10, child: circulo),
        Positioned(bottom: 120, right: 20.0, child: circulo),
        Positioned(bottom: -50.0, left: -20.0, child: circulo),
      ],
    );
  }

  _loginForm(BuildContext context, LoginBloc bloc,
      CrearEditarAsistentesBloc asistentesBloc) {
    final size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          SafeArea(
              child: Container(
            height: size.height * 0.05,
          )),
          Container(
            padding: EdgeInsets.symmetric(vertical: 50.0),
            margin: EdgeInsets.symmetric(vertical: 50.0),
            width: size.width * 0.85,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50.0),
                border: Border.all(color: Colors.white),
                color: Colors.white),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 40.0, right: 40.0),
                  child: Image(
                    image: AssetImage('assets/samlogo.png'),
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(
                  height: 60.0,
                ),
                _crearUsuario(bloc),
                SizedBox(
                  height: 30.0,
                ),
                _crearPassword(bloc),
                SizedBox(
                  height: 30.0,
                ),
                _crearBoton(bloc, asistentesBloc)
              ],
            ),
          ),
          SizedBox(
            height: 100.0,
          )
        ],
      ),
    );
  }

  Widget _crearUsuario(LoginBloc bloc) {
    return StreamBuilder(
      stream: bloc.usuarioStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: TextField(
            controller: txtControllerUsuario,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              prefixIcon: Icon(
                Icons.account_circle,
                color: Colors.redAccent,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              labelText: 'Usuario',
              errorText: snapshot.error,
            ),
            onChanged: bloc.changeUsuario,
          ),
        );
      },
    );
  }

  Widget _crearPassword(LoginBloc bloc) {
    return StreamBuilder(
      stream: bloc.passwordStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: TextField(
            controller: txtControllerPass,
            obscureText: verPass,
            decoration: InputDecoration(
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
              prefixIcon: Icon(
                Icons.lock_outline,
                color: Colors.red,
              ),
              suffixIcon: GestureDetector(
                onTap: () {
                  setState(() {
                    verPass = !verPass;
                  });
                },
                child: Icon(
                  (verPass) ? Icons.visibility : Icons.visibility_off,
                  color: Colors.red,
                ),
              ),
              hintText: 'Password',
              labelText: 'Password',
              errorText: snapshot.error,
            ),
            onChanged: bloc.changePassword,
          ),
        );
      },
    );
  }

  Widget _crearBoton(LoginBloc bloc, CrearEditarAsistentesBloc asistentesBloc) {
    return StreamBuilder(
      stream: bloc.formValidStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return RaisedButton(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 80.0, vertical: 15.0),
              child: Text('Ingresar'),
            ),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            elevation: 0.0,
            color: Colors.red,
            disabledTextColor: Colors.white,
            textColor: Colors.white,
            onPressed: (snapshot.hasData && logueando)
                ? () => _login(bloc, context, asistentesBloc)
                : null);
      },
    );
  }

  _login(LoginBloc bloc, BuildContext context,
      CrearEditarAsistentesBloc asistentesBloc) async {
    setState(() {
      logueando = false;
    });
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
    Map info = await usuarioProvider.login(bloc.usuario, bloc.password);
    _pr.hide();
    setState(() {
      logueando = true;
    });
    if (info['ok']) {
      Navigator.pushReplacementNamed(context, 'home');
      final UsuarioModel usuario = UsuarioModel.fromJson(info['usuario']);

      StorageUtil.putString('usuarioGlobal', usuarioModelToJson(usuario));
      StorageUtil.putInt('usuarioId', usuario.usuarioId);
    } else {
      mostrarAlerta(context, info['mensaje']);
      txtControllerUsuario.text = '';

      txtControllerPass.text = '';
    }
  }
}
