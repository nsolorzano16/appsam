import 'package:appsam/src/blocs/theme_bloc.dart';
import 'package:appsam/src/pages/asistentes/crear_asistentes_page.dart';
import 'package:appsam/src/pages/asistentes/editar_asistentes_page.dart';
import 'package:appsam/src/pages/asistentes/tab_resetpassword_page.dart';
import 'package:appsam/src/pages/asistentes_page.dart';
import 'package:appsam/src/pages/consulta/crear_preclinica_page.dart';
import 'package:appsam/src/pages/consulta/preclinica_detalle.dart';
import 'package:appsam/src/pages/consulta/preclinica_page.dart';
import 'package:appsam/src/pages/detalle_asistente.dart';
import 'package:appsam/src/pages/login_page.dart';
import 'package:appsam/src/pages/my_profile_page.dart';
import 'package:appsam/src/pages/pacientes/crear_paciente_page.dart';
import 'package:appsam/src/pages/pacientes/paciente_detalle_page.dart';
import 'package:appsam/src/pages/pacientes/pacientes_page.dart';
import 'package:appsam/src/pages/resetmy_pass_page.dart';
import 'package:appsam/src/pages/settings_page.dart';
import 'package:flutter/material.dart';

import '../pages/home_page.dart';

Map<String, WidgetBuilder> getApplicationRoutes(ThemeBloc bloc) {
  return <String, WidgetBuilder>{
    LoginPage.routeName: (context) => LoginPage(),
    HomePage.routeName: (BuildContext context) => HomePage(),
    AsistentesPage.routeName: (BuildContext context) => AsistentesPage(),
    AsistenteDetalle.routeName: (BuildContext context) => AsistenteDetalle(),
    CrearAsistentesPage.routeName: (BuildContext context) =>
        CrearAsistentesPage(),
    EditarAsistentesPage.routeName: (BuildContext context) =>
        EditarAsistentesPage(),
    ResetPasswordPage.routeName: (BuildContext context) => ResetPasswordPage(),
    SettingsPage.routeName: (BuildContext context) => SettingsPage(bloc),
    ResetMyPasswordPage.routeName: (BuildContext context) =>
        ResetMyPasswordPage(),
    MyProfilePage.routeName: (BuildContext context) => MyProfilePage(),
    PacientesPage.routeName: (BuildContext context) => PacientesPage(),
    PacienteDetalle.routeName: (BuildContext context) => PacienteDetalle(),
    CrearPacientePage.routeName: (BuildContext context) => CrearPacientePage(),
    PreclinicaPage.routeName: (BuildContext context) => PreclinicaPage(),
    PreclinicaDetallePage.routeName: (BuildContext context) =>
        PreclinicaDetallePage(),
    CrearPreclinicaPage.routeName: (BuildContext context) =>
        CrearPreclinicaPage(),
  };
}
