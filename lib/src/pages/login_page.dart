import 'package:appsam/src/models/planes_model.dart';
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
  bool logueando = false;

  String usuario;
  String password;

  int _usuarioID;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      // fit: StackFit.expand,
      alignment: Alignment.center,
      children: <Widget>[
        _crearFondo(context),
        _fondoBlanco(context),
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

  Widget _fondoBlanco(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      width: size.width * 0.90,
      height: size.height * 0.8,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: _camposForm(context),
    );
  }

  Widget _camposForm(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Image(
              image: AssetImage('assets/samlogo.png'),
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(
            height: 25,
          ),
          _crearUsuario(),
          SizedBox(
            height: 10,
          ),
          _crearPassword(),
          SizedBox(
            height: 10,
          ),
          _crearBoton(size),
        ],
      ),
    );
  }

  Widget _crearUsuario() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
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
    return Padding(
      padding: const EdgeInsets.all(12.0),
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
          suffixIcon: IconButton(
              icon: Icon(
                (verPass) ? Icons.visibility : Icons.visibility_off,
                color: Colors.red,
              ),
              onPressed: () {
                setState(() {
                  verPass = !verPass;
                });
              }),
          isDense: true,
          hintText: 'Password',
          labelText: 'Password',
        ),
      ),
    );
  }

  Widget _crearBoton(Size size) {
    return Container(
      width: 250,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.red,
            Colors.redAccent,
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: FlatButton(
          onPressed: () => logueando ? null : _login(context),
          child: Text(
            'Login',
            style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.w400, color: Colors.white),
          )),
    );
  }

  _login(BuildContext context) async {
    if (_formKey.currentState.validate()) {
      setState(() {
        logueando = true;
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
        final PlanesModel plan = PlanesModel.fromJson(info['plan']);
        int consultasAtendidas = info['consultasAtendidas'];

        //imprimirJSON(usuario);
        StorageUtil.putString('usuarioGlobal', usuarioModelToJson(usuario));
        imprimirJSON(plan);
        StorageUtil.putString('planUsuario', planesModelToJson(plan));
        StorageUtil.putInt('consultasAtendidas', consultasAtendidas);
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
          logueando = false;
        });
        mostrarAlerta(context, info['mensaje']);
      }
    }
  }
}
