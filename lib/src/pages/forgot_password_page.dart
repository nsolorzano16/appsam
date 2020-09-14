import 'package:appsam/src/models/reset_password_response_model.dart';

import 'package:appsam/src/pages/reset_password_page.dart';
import 'package:appsam/src/providers/auth_service.dart';
import 'package:appsam/src/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/fa_icon.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:getflutter/getflutter.dart';
import 'package:progress_dialog/progress_dialog.dart';

class ForgotPasswordPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    final AuthService _authService = AuthService();
    final TextEditingController _emailController = TextEditingController();

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pushReplacementNamed(context, 'login'),
          ),
          title: Text('Recuperar contraseña'),
        ),
        body: GFCard(
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
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                  child: TextFormField(
                    controller: _emailController,
                    autovalidate: true,
                    validator: validateEmail,
                    keyboardType: TextInputType.emailAddress,
                    decoration: inputsDecorations('Email', Icons.email),
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                _crearBotones(
                    context, _formKey, _authService, _emailController),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Ingrese email valido';
    else
      return null;
  }

  Widget _crearBotones(BuildContext context, GlobalKey<FormState> formKey,
      AuthService authService, TextEditingController emailController) {
    return Container(
      width: 150,
      child: RaisedButton.icon(
          color: Theme.of(context).primaryColor,
          onPressed: () =>
              _sendEmail(formKey, context, authService, emailController),
          textColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          icon: Icon(
            Icons.save,
            color: Colors.white,
          ),
          label: Text('Enviar')),
    );
  }

  void _sendEmail(GlobalKey<FormState> formKey, BuildContext context,
      AuthService authService, TextEditingController emailController) async {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
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
      final ResetPasswordResponseModel resp =
          await authService.resetPassword(emailController.text);

      await _pr.hide();
      if (resp != null) {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) {
              return FadeTransition(
                opacity: animation,
                child: ResetPasswordPage(
                    token: resp.tokenChangePassword, userId: resp.userId),
              );
            },
          ),
        );
      } else {
        mostrarFlushBar(
            context,
            Colors.black,
            'Info',
            'Ha ocurrido un error, el usuario no existe, ó esta inactivo.',
            2,
            Icons.info,
            Colors.white);
      }
    } else {
      mostrarFlushBar(context, Colors.black, 'Info',
          'El formulario no puede estar vacio', 3, Icons.info, Colors.white);
    }
  }
}
