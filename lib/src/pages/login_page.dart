import 'package:appsam/src/models/planes_model.dart';
import 'package:appsam/src/models/user_model.dart';
import 'package:appsam/src/pages/forgot_password_page.dart';
import 'package:appsam/src/providers/auth_service.dart';
import 'package:appsam/src/providers/usuario_provider.dart';
import 'package:appsam/src/providers/webNotifications_service.dart';
import 'package:appsam/src/utils/storage_util.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decode_token/jwt_decode_token.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:appsam/src/utils/utils.dart';

// coments
class LoginPage extends StatefulWidget {
  static final String routeName = 'login';
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final authService = new AuthService();
  final usuarioService = new UsuarioProvider();
  bool verPass = true;
  bool logueando = false;

  String usuario;
  String password;

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
      child: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Image(
              image: AssetImage('assets/samlogo.png'),
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          _crearUsuario(),
          _crearPassword(),
          _crearBoton(size),
          SizedBox(
            height: 10.0,
          ),
          Container(
            child: Align(
              alignment: Alignment.centerRight,
              child: FlatButton(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onPressed: () =>
                    Navigator.pushReplacement(context, PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) {
                    return FadeTransition(
                      opacity: animation,
                      child: ForgotPasswordPage(),
                    );
                  },
                )),
                child: Text(
                  'Olvido su contraseña?',
                ),
              ),
            ),
          ),
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
          hintText: 'Contraseña',
          labelText: 'Contraseña',
        ),
      ),
    );
  }

  Widget _crearBoton(Size size) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Container(
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
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  color: Colors.white),
            )),
      ),
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
      authService.login(usuario, password).then((authResp) async {
        if (authResp.resultado.succeeded && authResp.token.isNotEmpty) {
          StorageUtil.putString('token', authResp.token);

          Map<String, dynamic> payload = decodeJwt(authResp.token);

          String userId = payload['nameid'];
          await usuarioService.getMyInfo(userId).then((userInfo) async {
            await _pr.hide();
            if (userInfo != null) {
              StorageUtil.putString(
                  'usuarioGlobal', userModelToJson(userInfo.usuario));
              StorageUtil.putString(
                  'planUsuario', planesModelToJson(userInfo.plan));
              StorageUtil.putInt(
                  'consultasAtendidas', userInfo.consultasAtendidas);

              WebNotificationService.instance.loadNotificaciones(userId);
              Navigator.pushReplacementNamed(context, 'home');
            }
          });
        } else if (!authResp.resultado.succeeded &&
            !authResp.resultado.isLockedOut) {
          await _pr.hide();
          _formKey.currentState.reset();

          final totalIntentos = 3 - authResp.intentos;
          mostrarFlushBar(
              context,
              Colors.black,
              'Info',
              'Usted tiene $totalIntentos intentos para ingresar',
              2,
              Icons.info,
              Colors.white);
        } else if (authResp.resultado.isLockedOut) {
          await _pr.hide();
          final actualTime = DateTime.now();
          final tiempo =
              actualTime.difference(authResp.horaDesbloqueo).inMinutes;
          mostrarFlushBar(
              context,
              Colors.black,
              'Info',
              'El usuario ha sido bloqueado pruebe de nuevo en ${tiempo.abs()} min.',
              2,
              Icons.info,
              Colors.white);
        } else {
          await _pr.hide();
          mostrarFlushBar(
              context,
              Colors.black,
              'Info',
              'A ocurrido un error ó el usuario no existe ó el email no se ha confirmado.',
              3,
              Icons.info,
              Colors.white);
        }
      }).catchError((e) async {
        await _pr.hide();
        print('EL ERROR PRRRO ${e.toString()}');
      });
      setState(() {
        logueando = false;
      });
    }
  }
}
