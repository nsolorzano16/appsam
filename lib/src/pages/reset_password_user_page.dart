import 'package:appsam/src/models/change_password_model.dart';
import 'package:appsam/src/providers/auth_service.dart';
import 'package:appsam/src/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:getflutter/getflutter.dart';
import 'package:progress_dialog/progress_dialog.dart';

class ResetPasswordUserPage extends StatefulWidget {
  final String token;
  final String userId;

  const ResetPasswordUserPage(
      {Key key, @required this.token, @required this.userId})
      : super(key: key);

  @override
  _ResetPasswordUserPageState createState() => _ResetPasswordUserPageState();
}

class _ResetPasswordUserPageState extends State<ResetPasswordUserPage> {
  String get userId => widget.userId;
  String get token => widget.token;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final AuthService _authService = AuthService();
  final TextEditingController _firstPassword = TextEditingController();
  final TextEditingController _secondPassword = TextEditingController();
  bool verPass = true;
  bool verConfirmPass = true;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () =>
                Navigator.pushReplacementNamed(context, 'settings'),
          ),
          title: Text('Resetear contraseña'),
        ),
        body: Container(
          child: GFCard(
            title: GFListTile(
              color: Colors.red,
              title: Text('',
                  style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white)),
              icon: FaIcon(FontAwesomeIcons.lock, color: Colors.white),
            ),
            content: Form(
              key: _formKey,
              child: Column(
                children: [
                  _password(),
                  _confirmPassword(),
                  SizedBox(
                    height: 10,
                  ),
                  _crearBoton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Padding _password() {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: TextFormField(
        obscureText: verPass,
        controller: _firstPassword,
        autovalidate: true,
        validator: validateField,
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

  Padding _confirmPassword() {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: TextFormField(
        obscureText: verConfirmPass,
        controller: _secondPassword,
        autovalidate: true,
        validator: validateField,
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
          prefixIcon: Icon(
            Icons.lock_outline,
            color: Colors.red,
          ),
          suffixIcon: IconButton(
              icon: Icon(
                (verConfirmPass) ? Icons.visibility : Icons.visibility_off,
                color: Colors.red,
              ),
              onPressed: () {
                setState(() {
                  verConfirmPass = !verConfirmPass;
                });
              }),
          isDense: true,
          hintText: 'Confirmar contraseña',
          labelText: 'Confirmar contraseña',
        ),
      ),
    );
  }

  Widget _crearBoton() {
    return RaisedButton.icon(
        color: Theme.of(context).primaryColor,
        onPressed: () => sendResetPassword(),
        textColor: Colors.white,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        icon: Icon(
          Icons.save,
          color: Colors.white,
        ),
        label: Text('Guardar'));
  }

  sendResetPassword() async {
    if (_formKey.currentState.validate()) {
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
      if (_firstPassword.text == _secondPassword.text) {
        await _pr.show();
        final model = ChangePasswordModel();
        model.userId = userId;
        model.token = token;
        model.password = _secondPassword.text;

        final bool resp = await _authService.changePassword(model);
        await _pr.hide();
        if (resp) {
          mostrarFlushBar(context, Colors.black, 'Info',
              'Se ha cambiado la contraseña.', 2, Icons.info, Colors.white);
          Future.delayed(const Duration(seconds: 2))
              .then((_) => Navigator.pushReplacementNamed(context, 'login'));
        } else {
          mostrarFlushBar(
              context,
              Colors.black,
              'Info',
              'No se ha podido cambiar la contraseña',
              3,
              Icons.info,
              Colors.white);
        }
      } else {
        mostrarFlushBar(context, Colors.red[400], 'Info',
            'Las contraseñas no coinciden', 3, Icons.info, Colors.white);
      }
    } else {
      mostrarFlushBar(context, Colors.black, 'Info',
          'El formulario no puede estar vacio', 3, Icons.info, Colors.white);
    }
  }

  String validateField(String value) {
    if (value.length < 6)
      return 'La contraseña tiene que tener mas de 6 carácteres';
    else
      return null;
  }
}
