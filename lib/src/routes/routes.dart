import 'package:appsam/src/pages/consulta/consultaGeneral/crear_consultaGeneral_page.dart';
import 'package:appsam/src/pages/consulta/consulta_detalle_page.dart';
import 'package:appsam/src/pages/consulta/diagnosticos/crear_diagnosticos_page.dart';
import 'package:appsam/src/pages/consulta/examenGinecologico/crear_ExamenGinecologico.dart';
import 'package:appsam/src/pages/consulta/examenesIndicados/crear_ExamenIndicado_page.dart';

import 'package:appsam/src/pages/consulta/examenesIndicados/examenesIndicados_page.dart';
import 'package:appsam/src/pages/consulta/menuConsulta_page.dart';
import 'package:appsam/src/pages/consulta/notas/crear_notas_page.dart';
import 'package:appsam/src/pages/consulta/planTerapeutico/crear_PlanTerapeutico_page.dart';
import 'package:appsam/src/pages/consulta/planTerapeutico/planesTerapeuticos_page.dart';
import 'package:flutter/material.dart';
import 'package:appsam/src/pages/home_page.dart';

import 'package:appsam/src/blocs/theme_bloc.dart';
import 'package:appsam/src/pages/asistentes/asistentes_page.dart';
import 'package:appsam/src/pages/asistentes/crear_asistentes_page.dart';
import 'package:appsam/src/pages/asistentes/detalle_asistente.dart';
import 'package:appsam/src/pages/asistentes/editar_asistentes_page.dart';
import 'package:appsam/src/pages/asistentes/tab_resetpassword_page.dart';
import 'package:appsam/src/pages/consulta/antecedentesFamiliares/crear_antecedentes_page.dart';

import 'package:appsam/src/pages/consulta/farmacosUsoActual/crear_Farmacos_page.dart';
import 'package:appsam/src/pages/consulta/habitos/crear_habitos_page.dart';

import 'package:appsam/src/pages/consulta/preclinica/crear_preclinica_page.dart';
import 'package:appsam/src/pages/consulta/preclinica/edit_preclinica_page.dart';
import 'package:appsam/src/pages/consulta/preclinica/preclinica_detalle_page.dart';

import 'package:appsam/src/pages/consulta/preclinica/preclinica_page.dart';

import 'package:appsam/src/pages/login_page.dart';
import 'package:appsam/src/pages/my_profile_page.dart';
import 'package:appsam/src/pages/pacientes/crear_paciente_page.dart';
import 'package:appsam/src/pages/pacientes/edit_paciente_page.dart';

import 'package:appsam/src/pages/pacientes/paciente_detalle_page.dart';
import 'package:appsam/src/pages/pacientes/pacientes_page.dart';
import 'package:appsam/src/pages/resetmy_pass_page.dart';
import 'package:appsam/src/pages/settings_page.dart';

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
    EditarPacientePage.routeName: (BuildContext context) =>
        EditarPacientePage(),
    EditarPreclinicaPage.routeName: (BuildContext context) =>
        EditarPreclinicaPage(),
    CrearAntecedentesPage.routeName: (BuildContext context) =>
        CrearAntecedentesPage(),
    CrearHabitosPage.routeName: (BuildContext context) => CrearHabitosPage(),
    CrearFarmacosUsoActualPage.routeName: (BuildContext context) =>
        CrearFarmacosUsoActualPage(),
    CrearExamenGinecologicoPage.routeName: (BuildContext context) =>
        CrearExamenGinecologicoPage(),
    CrearDiagnosticosPage.routeName: (BuildContext context) =>
        CrearDiagnosticosPage(),
    CrearNotasPage.routeName: (BuildContext context) => CrearNotasPage(),
    ConsultaDetallePage.routeName: (BuildContext context) =>
        ConsultaDetallePage(),
    MenuConsultaPage.routeName: (BuildContext context) => MenuConsultaPage(),
    CrearConsultaGeneralPage.routeName: (BuildContext context) =>
        CrearConsultaGeneralPage(),
    ExamenesIndicadosPage.routeName: (BuildContext context) =>
        ExamenesIndicadosPage(),
    CrearExamenIndicadoPage.routeName: (BuildContext context) =>
        CrearExamenIndicadoPage(),
    PlanesTerapeuticosPage.routeName: (BuildContext context) =>
        PlanesTerapeuticosPage(),
    CrearPlanTerapeuticoPage.routeName: (BuildContext context) =>
        CrearPlanTerapeuticoPage()
  };
}
