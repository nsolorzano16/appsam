import 'package:appsam/src/blocs/habitos_bloc.dart';
import 'package:flutter/material.dart';
import 'package:appsam/src/blocs/asistentes_bloc.dart';
import 'package:appsam/src/blocs/asistentes_bloc/create_edit_asistentes.dart';
import 'package:appsam/src/blocs/asistentes_bloc/resetPassword_bloc.dart';
import 'package:appsam/src/blocs/consulta_bloc.dart';
import 'package:appsam/src/blocs/login_bloc.dart';
import 'package:appsam/src/blocs/pacientes_bloc/pacientes_bloc.dart';
import 'package:appsam/src/blocs/preclinica_bloc.dart';
import 'package:appsam/src/blocs/theme_bloc.dart';

class Provider extends InheritedWidget {
  final _loginBloc = new LoginBloc();
  final _asistentesBloc = new AsistentesBloc();
  final _crearEditarAsistentesBloc = new CrearEditarAsistentesBloc();
  final _resetPasswordBloc = new ResetPasswordBloc();
  final _pacientesBloc = new PacientesBloc();
  final _preclinicaBloc = new PreclinicaBloc();
  final blocTheme = new ThemeBloc();
  final _consultaBloc = new ConsultaBloc();
  final _habitosBloc = new HabitosBloc();

  static Provider _instancia;

  factory Provider({Key key, Widget child}) {
    if (_instancia == null) {
      _instancia = new Provider._internal(key: key, child: child);
    }

    return _instancia;
  }

  Provider._internal({Key key, Widget child}) : super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static LoginBloc loginBloc(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<Provider>()._loginBloc;
  }

  static AsistentesBloc asistentesBloc(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<Provider>()
        ._asistentesBloc;
  }

  static CrearEditarAsistentesBloc crearEditarAsistentesBloc(
      BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<Provider>()
        ._crearEditarAsistentesBloc;
  }

  static ResetPasswordBloc resetPasswordBloc(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<Provider>()
        ._resetPasswordBloc;
  }

  static ThemeBloc themeBloc(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<Provider>().blocTheme;
  }

  static PacientesBloc pacientesBloc(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<Provider>()
        ._pacientesBloc;
  }

  static PreclinicaBloc preclinicaBloc(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<Provider>()
        ._preclinicaBloc;
  }

  static ConsultaBloc consultaBloc(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<Provider>()._consultaBloc;
  }

  static HabitosBloc habitosBloc(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<Provider>()._habitosBloc;
  }
}
