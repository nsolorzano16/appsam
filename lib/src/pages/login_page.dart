import 'package:appsam/src/providers/webNotifications_service.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';

import 'package:appsam/src/models/usuario_model.dart';
import 'package:appsam/src/providers/usuario_provider.dart';
import 'package:appsam/src/utils/storage_util.dart';
import 'package:appsam/src/utils/utils.dart';

// coments
class LoginPage extends StatefulWidget {
  static final String routeName = 'login';
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final usuarioProvider = new UsuarioProvider();
  bool verPass = true;
  bool logueando = true;

  String usuario;
  String password;

  int _usuarioID;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: <Widget>[_crearFondo(context), _loginForm(context)],
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

  _loginForm(BuildContext context) {
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
            child: Form(
              key: _formKey,
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
                  _crearUsuario(),
                  SizedBox(
                    height: 30.0,
                  ),
                  _crearPassword(),
                  SizedBox(
                    height: 30.0,
                  ),
                  _crearBoton()
                ],
              ),
            ),
          ),
          SizedBox(
            height: 100.0,
          )
        ],
      ),
    );
  }

  Widget _crearUsuario() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: TextFormField(
          onSaved: (value) => usuario = value,
          autovalidate: true,
          validator: validaTexto,
          keyboardType: TextInputType.text,
          decoration: inputsDecorations('Usuario', Icons.account_circle)),
    );
  }

  String validaTexto(String value) {
    if (value.length < 5) {
      return 'Campo obligatorio';
    } else {
      return null;
    }
  }

  Widget _crearPassword() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: TextFormField(
        onSaved: (value) => password = value,
        autovalidate: true,
        validator: validaTexto,
        obscureText: verPass,
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
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
          isDense: true,
          hintText: 'Password',
          labelText: 'Password',
        ),
      ),
    );
  }

  Widget _crearBoton() {
    return RaisedButton(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 80.0, vertical: 15.0),
          child: Text('Ingresar'),
        ),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        elevation: 0.0,
        color: Colors.red,
        disabledTextColor: Colors.white,
        textColor: Colors.white,
        onPressed: (logueando) ? () => _login(context) : null);
  }

  _login(BuildContext context) async {
    if (_formKey.currentState.validate()) {
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
      _formKey.currentState.save();
      await _pr.show();
      final info = await usuarioProvider.login(usuario, password);

      if (info['ok']) {
        await _pr.hide();
        final UsuarioModel usuario = UsuarioModel.fromJson(info['usuario']);
        StorageUtil.putString('usuarioGlobal', usuarioModelToJson(usuario));
        if (usuario.rolId == 2) {
          _usuarioID = usuario.usuarioId;
        } else if (usuario.rolId == 3) {
          _usuarioID = usuario.asistenteId;
        }
        WebNotificationService.instance.loadNotificaciones(_usuarioID);
        Navigator.pushReplacementNamed(context, 'home');
      } else {
        await _pr.hide();
        _formKey.currentState.reset();
        setState(() {
          logueando = true;
        });
        mostrarAlerta(context, info['mensaje']);
      }
    }
  }
}
