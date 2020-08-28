import 'package:appsam/src/models/user_model.dart';
import 'package:appsam/src/widgets/firebaseMessageWrapper.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:getflutter/getflutter.dart';
import 'package:progress_dialog/progress_dialog.dart';

import 'package:appsam/src/blocs/asistentes_bloc/create_edit_asistentes.dart';
import 'package:appsam/src/utils/storage_util.dart';
import 'package:appsam/src/utils/utils.dart';
import 'package:appsam/src/widgets/drawer.dart';

class ResetMyPasswordPage extends StatelessWidget {
  static final String routeName = 'reset-my-pass';
  @override
  Widget build(BuildContext context) {
    StorageUtil.putString('ultimaPagina', ResetMyPasswordPage.routeName);

    final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
    final blocService = new CrearEditarAsistentesBloc();
    final UserModel _usuario =
        userModelFromJson(StorageUtil.getString('usuarioGlobal'));
    TextEditingController _passwordController = new TextEditingController();
    TextEditingController _passwordConfirmController =
        new TextEditingController();

    return WillPopScope(
        child: FirebaseMessageWrapper(
          child: Scaffold(
              backgroundColor: colorFondoApp(),
              drawer: MenuWidget(),
              appBar: AppBar(
                title: Text('Cambiar mi contraseña prr'),
                actions: <Widget>[
                  IconButton(
                      icon: Icon(Icons.arrow_back_ios),
                      onPressed: () =>
                          Navigator.popAndPushNamed(context, 'settings'))
                ],
              ),
              body: SingleChildScrollView(
                  child: GFCard(
                elevation: 6.0,
                title: GFListTile(
                    color: Colors.red,
                    title: Text('',
                        style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                    icon: FaIcon(FontAwesomeIcons.lock, color: Colors.white)),
                content: Column(
                  children: <Widget>[
                    Form(
                      key: _formkey,
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            height: 15.0,
                          ),
                          _crearCampoPassword1(context, _passwordController),
                          SizedBox(
                            height: 8.0,
                          ),
                          _crearRepetirPassword(
                              context, _passwordConfirmController),
                          SizedBox(
                            height: 8.0,
                          ),
                          _crearBoton(
                              blocService,
                              context,
                              _usuario,
                              _passwordController,
                              _passwordConfirmController,
                              _formkey)
                        ],
                      ),
                    ),
                  ],
                ),
              ))),
        ),
        onWillPop: () async => false);
  }

  Widget _crearCampoPassword1(
      BuildContext context, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
      child: TextFormField(
        autovalidate: true,
        controller: controller,
        validator: validaTexto,
        decoration: inputsDecorations('Contraseña', Icons.lock),
      ),
    );
  }

  String validaTexto(String value) {
    if (value.length < 3) {
      return 'Campo obligatorio';
    } else {
      return null;
    }
  }

  Widget _crearRepetirPassword(
      BuildContext context, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
      child: TextFormField(
        autovalidate: true,
        controller: controller,
        validator: validaTexto,
        decoration: inputsDecorations('Repetir contraseña', Icons.lock),
      ),
    );
  }

  Widget _crearBoton(
      CrearEditarAsistentesBloc blocService,
      BuildContext context,
      UserModel usuario,
      TextEditingController passwordController,
      TextEditingController confirmPassController,
      GlobalKey<FormState> formKey) {
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
        onPressed: () async {
          if (formKey.currentState.validate()) {
            if (passwordController.text == confirmPassController.text) {
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
              await _pr.show();
              var pass = confirmPassController.text;
              var modificadoPor = usuario.userName;
              final user = await blocService.resetPassword(
                  usuario.id, pass, modificadoPor);
              if (user != null) {
                await _pr.hide();
                mostrarFlushBar(context, Colors.green, 'Info',
                    'Datos Guardados', 2, Icons.info, Colors.black);
                Future.delayed(Duration(seconds: 2)).then((_) {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      'login', (Route<dynamic> route) => false);
                });
              } else {
                mostrarFlushBar(context, Colors.red, 'Info',
                    'Ha ocurrido un error', 2, Icons.info, Colors.white);
              }
            } else {
              mostrarFlushBar(context, Colors.black, 'Info',
                  'Las contraseñas no coinciden.', 2, Icons.info, Colors.white);
            }
          } else {
            mostrarFlushBar(
                context,
                Colors.black,
                'Info',
                'Por favor rellene todos los campos',
                2,
                Icons.info,
                Colors.white);
          }
        });
  }
}
