import 'package:appsam/src/models/usuario_model.dart';
import 'package:appsam/src/pages/expediente/expediente_page.dart';
import 'package:appsam/src/utils/storage_util.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:appsam/src/utils/utils.dart';
import 'package:appsam/src/blocs/provider.dart';
import 'package:appsam/src/models/paginados/pacientesPaginado_model.dart';

import '../providers/pacientes_service.dart';

class DataSearchPacientes extends SearchDelegate {
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
    if (query.length >= 4) {
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

  Widget _item(
    BuildContext context,
    PacientesViewModel paciente,
  ) {
    return Card(
      elevation: 3.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      child: ListTile(
          dense: true,
          onTap: () {
            Navigator.pushReplacementNamed(context, 'paciente_detalle',
                arguments: paciente);
          },
          contentPadding: EdgeInsets.symmetric(
            horizontal: 10.0,
          ),
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
          title: Container(
            child: Text(
              '${paciente.nombres} ${paciente.primerApellido} ${paciente.segundoApellido}',
              overflow: TextOverflow.ellipsis,
            ),
          ),
          subtitle: Text('Identificación: ${paciente.identificacion}'),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              IconButton(
                  icon: FaIcon(
                    FontAwesomeIcons.solidFolderOpen,
                    size: 20.0,
                    color: Theme.of(context).primaryColor,
                  ),
                  onPressed: () => (_usuario.rolId == 2)
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
                          Colors.white)),
              IconButton(
                  icon: FaIcon(
                    FontAwesomeIcons.fileMedical,
                    size: 20.0,
                    color: Theme.of(context).primaryColor,
                  ),
                  onPressed: () => (paciente.preclinicasPendientes == 0)
                      ? Navigator.pushReplacementNamed(
                          context, 'crear_preclinica', arguments: paciente)
                      : mostrarFlushBar(
                          context,
                          Colors.lightGreen[700],
                          'Info',
                          'Paciente con preclinicas pendientes',
                          2,
                          Icons.info,
                          Colors.white))
            ],
          )),
    );
  }
}
