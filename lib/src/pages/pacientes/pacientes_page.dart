import 'package:appsam/src/models/paginados/pacientesPaginado_model.dart';
import 'package:appsam/src/pages/expediente/expediente_page.dart';
import 'package:appsam/src/utils/utils.dart';
import 'package:appsam/src/widgets/firebaseMessageWrapper.dart';
import 'package:flutter/material.dart';

import 'package:appsam/src/blocs/pacientes_bloc/pacientes_bloc.dart';

import 'package:appsam/src/models/usuario_model.dart';
import 'package:appsam/src/utils/storage_util.dart';
import 'package:appsam/src/widgets/drawer.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PacientesPage extends StatefulWidget {
  static final String routeName = 'pacientes';
  @override
  _PacientesPageState createState() => _PacientesPageState();
}

class _PacientesPageState extends State<PacientesPage> {
  PacientesBlocBusqueda blocBusqueda = new PacientesBlocBusqueda();
  final UsuarioModel _usuario =
      usuarioModelFromJson(StorageUtil.getString('usuarioGlobal'));

  int totalPages = 0;
  int page = 1;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    StorageUtil.putString('ultimaPagina', PacientesPage.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: FirebaseMessageWrapper(
          child: Scaffold(
            backgroundColor: colorFondoApp(),
            drawer: MenuWidget(),
            appBar: AppBar(
              title: Text('Pacientes'),
            ),
            body: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0)),
                    elevation: 6.0,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        onChanged: (value) => blocBusqueda
                            .cargarPacientesPaginadoBusqueda(1, value),
                        maxLength: 13,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(13),
                          WhitelistingTextInputFormatter.digitsOnly
                        ],
                        //onChanged: bloc.onChangedText,
                        decoration: inputsDecorations('', Icons.search,
                            helperTexto:
                                'Identificación paciente, identificación madre, identificación padre.',
                            hintTexto: 'buscar'),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: AnimatedBuilder(
                    animation: blocBusqueda,
                    builder: (BuildContext context, Widget child) {
                      return (blocBusqueda.loading)
                          ? loadingIndicator(context)
                          : ListView.builder(
                              itemCount: blocBusqueda.pacientes.length,
                              itemBuilder: (BuildContext context, int index) {
                                return _item(
                                    context, blocBusqueda.pacientes[index]);
                              },
                            );
                    },
                  ),
                ),
              ],
            ),
            floatingActionButton: FloatingActionButton(
              backgroundColor: Theme.of(context).primaryColor,
              child: Icon(Icons.add),
              onPressed: () => _goToCrearPaciente(_usuario),
            ),
          ),
        ),
        onWillPop: () async => false);
  }

  void _goToCrearPaciente(UsuarioModel usuario) {
    Navigator.pushReplacementNamed(context, 'crear_paciente',
        arguments: usuario);
  }

  Widget _item(
    BuildContext context,
    PacientesViewModel paciente,
  ) {
    final size = MediaQuery.of(context).size;
    return Card(
      margin: EdgeInsets.all(10),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Column(
        children: <Widget>[
          ListTile(
            dense: true,
            leading: Container(
                padding: EdgeInsets.only(right: 5.0),
                decoration: BoxDecoration(
                    border: Border(
                        right: BorderSide(width: 1.0, color: Colors.black))),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30.0),
                  child: FadeInImage(
                      width: 40.0,
                      height: 40.0,
                      placeholder: AssetImage('assets/jar-loading.gif'),
                      image: NetworkImage(paciente.fotoUrl)),
                )),
            title: Text(
              '${paciente.nombres} ${paciente.primerApellido} ${paciente.segundoApellido}',
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text('Identificación: ${paciente.identificacion}'),
          ),
          Container(
            width: size.width * 0.9,
            child: Divider(
              thickness: 2,
            ),
          ),
          ListTile(
            title: Text('Detalle'),
            trailing: Icon(
              Icons.arrow_forward_ios,
              color: Theme.of(context).primaryColor,
            ),
            leading: FaIcon(
              FontAwesomeIcons.child,
              color: Theme.of(context).primaryColor,
            ),
            onTap: () => Navigator.pushReplacementNamed(
                context, 'paciente_detalle',
                arguments: paciente),
          ),
          ListTile(
            title: Text('Expediente'),
            trailing: Icon(
              Icons.arrow_forward_ios,
              color: Theme.of(context).primaryColor,
            ),
            leading: FaIcon(
              FontAwesomeIcons.solidFolderOpen,
              size: 20.0,
              color: Theme.of(context).primaryColor,
            ),
            onTap: () => (_usuario.rolId == 2)
                ? Navigator.of(context).pushReplacement(PageRouteBuilder(
                    transitionDuration: const Duration(milliseconds: 800),
                    pageBuilder: (_, animation, __) => FadeTransition(
                          opacity: animation,
                          child: ExpedientePage(
                              pacienteId: paciente.pacienteId,
                              doctorId: _usuario.usuarioId),
                        )))
                : mostrarFlushBar(
                    context,
                    Colors.lightGreen[700],
                    'Info',
                    'Usted no tiene acceso a este contenido',
                    2,
                    Icons.info,
                    Colors.white),
          ),
          ListTile(
            title: Text('Preclinica'),
            trailing: Icon(
              Icons.arrow_forward_ios,
              color: Theme.of(context).primaryColor,
            ),
            leading: FaIcon(
              FontAwesomeIcons.fileMedical,
              size: 20.0,
              color: Theme.of(context).primaryColor,
            ),
            onTap: () => (paciente.preclinicasPendientes == 0)
                ? Navigator.pushReplacementNamed(context, 'crear_preclinica',
                    arguments: paciente)
                : mostrarFlushBar(
                    context,
                    Colors.lightGreen[700],
                    'Info',
                    'Paciente con preclinicas pendientes',
                    2,
                    Icons.info,
                    Colors.white),
          ),
        ],
      ),
    );
  }
}
