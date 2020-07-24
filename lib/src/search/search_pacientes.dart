import 'package:appsam/src/models/usuario_model.dart';
import 'package:appsam/src/pages/expediente/expediente_page.dart';
import 'package:appsam/src/search/search_delegate.dart';
import 'package:appsam/src/utils/storage_util.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:appsam/src/utils/utils.dart';
import 'package:appsam/src/blocs/provider.dart';
import 'package:appsam/src/models/paginados/pacientesPaginado_model.dart';

import '../providers/pacientes_service.dart';

class DataSearchPacientes extends SearchDelegate<String> {
  Future<PacientesPaginadoModel> pacientesFuture;
  PacientesService pacientesService = new PacientesService();

  UsuarioModel _usuario =
      usuarioModelFromJson(StorageUtil.getString('usuarioGlobal'));

  @override
  List<Widget> buildActions(BuildContext context) {
    // acciones de nuestro app bar
    return [
      IconButton(
          icon: Icon(
            Icons.delete,
            color: Colors.red,
          ),
          onPressed: () {
            query = '';
          }),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // icono a la izquierda del appbar
    return IconButton(
        icon: AnimatedIcon(
            icon: AnimatedIcons.menu_arrow, progress: transitionAnimation),
        onPressed: () {
          close(context, null);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    // crea los resultados que vamos a mostrar
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // son las sugerencias que aparecen cuando la persona escribe
    final bloc = Provider.pacientesBloc(context);

    if (query.isEmpty) return Container();
    if (query.length >= 13) {
      bloc.cargarPacientesPaginadoBusqueda(1, query);
    } else {
      return Container();
    }

    return StreamBuilder(
      stream: bloc.pacientesBusquedaStream,
      builder: (BuildContext context,
          AsyncSnapshot<List<PacientesViewModel>> snapshot) {
        if (snapshot.hasData) {
          if (!snapshot.hasData) return loadingIndicator(context);

          return ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (BuildContext context, int index) {
              return _item(context, snapshot.data[index]);
            },
          );
        } else {
          return loadingIndicator(context);
        }
      },
    );
  }

  // @override
  // ThemeData appBarTheme(BuildContext context) {
  //   assert(context != null);
  //   final ThemeData theme = Theme.of(context);
  //   assert(theme != null);

  //   return theme;
  // }

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
