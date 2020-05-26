import 'package:flutter/material.dart';
import 'dart:math';

import 'package:flushbar/flushbar.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

bool isNumeric(String s) {
  if (s.isEmpty) return false;

  final n = num.tryParse(s);

  return (n == null) ? false : true;
}

void mostrarAlerta(BuildContext context, String mensaje) {
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Información incorrecta'),
          content: Text(mensaje),
          actions: <Widget>[
            FlatButton(
              child: Text('Ok'),
              onPressed: () => Navigator.of(context).pop(),
            )
          ],
        );
      });
}

String validaNulo(String valor) {
  if (valor != null) {
    return valor;
  } else {
    return '';
  }
}

Widget loadingIndicator(BuildContext context) {
  return Center(
    child: SpinKitWave(
      color: Theme.of(context).primaryColor,
    ),
  );
}

void mostrarFlushBar(BuildContext context, Color color, String title,
    String mensaje, int segundos, IconData icon, Color iconColor) {
  Flushbar(
    isDismissible: false,
    borderRadius: 20.0,
    flushbarStyle: FlushbarStyle.FLOATING,
    flushbarPosition: FlushbarPosition.TOP,
    backgroundColor: color,
    margin: EdgeInsets.all(10.0),
    title: title,
    message: mensaje,
    duration: Duration(seconds: segundos),
    icon: Icon(
      icon,
      color: iconColor,
    ),
  )..show(context);
}

InputDecoration inputsDecorations(String label, IconData icon,
    {String helperTexto = '', String hintTexto = '', String counterTexto}) {
  return InputDecoration(
      filled: true,
      fillColor: Colors.white,
      prefixIcon: Icon(
        icon,
        color: Colors.redAccent,
      ),
      counterText: counterTexto,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
      labelText: label,
      helperText: helperTexto,
      hintText: hintTexto,
      isDense: true);
}

class EnviromentVariables {
  String getApiURL() {
    return 'https://samapiweb.azurewebsites.net';
    //return 'http://localhost:5001/';
  }
}

/*
 * @desc Function to generate password based on some criteria
 * @param bool _isWithLetters: password must contain letters
 * @param bool _isWithUppercase: password must contain uppercase letters
 * @param bool _isWithNumbers: password must contain numbers
 * @param bool _isWithSpecial: password must contain special chars
 * @param int _numberCharPassword: password length
 * @return string: new password
 */
String generatePassword(bool _isWithLetters, bool _isWithUppercase,
    bool _isWithNumbers, bool _isWithSpecial, double _numberCharPassword) {
  //Define the allowed chars to use in the password
  String _lowerCaseLetters = "abcdefghijklmnopqrstuvwxyz";
  String _upperCaseLetters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
  String _numbers = "0123456789";
  String _special = "@#=+!£\$%&?[](){}";

  //Create the empty string that will contain the allowed chars
  String _allowedChars = "";

  //Put chars on the allowed ones based on the input values
  _allowedChars += (_isWithLetters ? _lowerCaseLetters : '');
  _allowedChars += (_isWithUppercase ? _upperCaseLetters : '');
  _allowedChars += (_isWithNumbers ? _numbers : '');
  _allowedChars += (_isWithSpecial ? _special : '');

  int i = 0;
  String _result = "";

  //Create password
  while (i < _numberCharPassword.round()) {
    //Get random int
    int randomInt = Random.secure().nextInt(_allowedChars.length);
    //Get random char and append it to the password
    _result += _allowedChars[randomInt];
    i++;
  }

  return _result;
}

String generateUser(String nombres, String apellido1, String identificacion) {
  if (nombres.isEmpty || apellido1.isEmpty || identificacion.isEmpty) return '';
  final parteUno = nombres.substring(0, 3);
  final parteDos = apellido1.substring(0, 3);
  final parteTres = identificacion.substring(10, 13);
  return '$parteUno$parteDos$parteTres';
}

DateTime fechaNacToDatetime(String fecha) {
  if (fecha.length != 10) return DateTime.now();
  final dia = int.parse(fecha.substring(0, 2));
  final mes = int.parse(fecha.substring(3, 5));
  final anio = int.parse(fecha.substring(5, 9));
  final lafecha = new DateTime(anio, mes, dia);
  return lafecha;
}

void mostrarSnackbar(GlobalKey<ScaffoldState> key, String texto, int seconds) {
  key.currentState.showSnackBar(SnackBar(
    content: Text(texto),
    duration: Duration(seconds: seconds),
  ));
}
